#-----------------------------------------------------------------------------
# NOVAthesis — Makefile
# Version 8.0.0 (2026-07-27)
#
# The build engine is latexmk; all LaTeX-specific behavior (engine defaults,
# biber, glossaries, clean lists) lives in ./latexmkrc.
#
# Targets:
#   make               build with LuaLaTeX (recommended)
#   make lua|pdf|xe    build with a specific engine
#   make view | v      build, then open the PDF
#   make watch         rebuild automatically on every change (LuaLaTeX)
#   make watch-pdf|watch-xe   like watch, with pdfLaTeX / XeLaTeX
#   make glsbib        convert 7.10.x glossary .tex entry files to .bib
#                      (one-off migration step; see the manual)
#   make log           show the build log
#   make clean         remove build artifacts (keeps the PDF and AUXDIR/matrix/)
#   make distclean     clean + remove PDF and synctex files
#   make help          show this help
#   make help-dev      maintainer targets (school, matrix, zip; git checkout only)
#
# Variables:
#   FILE=name          root .tex file (default: auto-detect \documentclass)
#   NT="k=v,..."       \ntsetup overrides, e.g. NT="doctype=msc,lang=pt"
#   V=1                verbose: raw LaTeX output
#   BATCH=1            batch mode (never stops at errors) — good for CI
#   FASTWRITES=0       load morewrites (default is 1 = skip it). Only needed
#                      for a pdf/xe document that overshoots the 16 write
#                      streams ("No room for a new \write"); no-op for LuaLaTeX
#   TL=2024            use /usr/local/texlive/2024 for this run
#   VIEWER=...         PDF viewer for 'make view'
#   PAGER=...          pager for 'make log' (default: less)
#   FLAGS=...          extra latexmk flags, passed through
#-----------------------------------------------------------------------------

# --- Root file detection -----------------------------------------------------
ifeq ($(FILE),)
  ROOTS := $(shell grep -lF '\documentclass' *.tex 2>/dev/null)
  ifneq ($(words $(ROOTS)),1)
    $(error Found $(words $(ROOTS)) file(s) with \documentclass ($(ROOTS)); use FILE=<name>)
  endif
  BASE := $(basename $(ROOTS))
else
  BASE := $(basename $(FILE))
endif

AUXDIR := AUXDIR
export AUXDIR                       # also read by latexmkrc

# --- TeX Live release selection (TL=2024) ------------------------------------
ifneq ($(TL),)
  TLBIN := $(firstword $(wildcard /usr/local/texlive/$(TL)/bin/*))
  ifeq ($(TLBIN),)
    $(error TeX Live $(TL) not found under /usr/local/texlive)
  endif
  export PATH := $(TLBIN):$(PATH)
endif

# --- Commands and flags -------------------------------------------------------
LATEXMK  := latexmk
LMKFLAGS := -time -file-line-error -shell-escape -synctex=1 \
            -output-directory=$(AUXDIR)

ifeq ($(BATCH),1)
  LMKFLAGS += -interaction=batchmode
else
  LMKFLAGS += -interaction=nonstopmode
endif

# Code injected before \documentclass: \ntsetup overrides (see nt-setup.sty,
# \ntoverride) and the write-register switch (see nt-packages.sty).
# NOTE: concatenated without spaces — texfot re-splits the command line on
# whitespace, which would break a quoted -pretex argument containing spaces.
# morewrites is skipped by default; FASTWRITES=0 re-enables it.
FASTWRITES ?= 1
PRETEX :=
ifneq ($(NT),)
  PRETEX := $(PRETEX)\def\ntoverride{$(NT)}
endif
ifneq ($(FASTWRITES),1)
  PRETEX := $(PRETEX)\def\ntmorewrites{}
endif
ifneq ($(PRETEX),)
  LMKFLAGS += -usepretex -pretex='$(PRETEX)'
endif

LMKFLAGS += $(FLAGS)

# Filter LaTeX chatter with texfot when available (disabled by V=1)
TEXFOT := $(shell command -v texfot 2>/dev/null)
ifeq ($(V),1)
  RUN :=
else
  RUN := $(TEXFOT)
endif

# --- Build targets ------------------------------------------------------------
.PHONY: all lua pdf xe build
all: lua
lua: ENG := -pdflua
pdf: ENG := -pdf
xe:  ENG := -pdfxe
lua pdf xe: build

build:
	@mkdir -p $(AUXDIR)
	$(RUN) $(LATEXMK) $(ENG) $(LMKFLAGS) $(BASE).tex
	@cp -f $(AUXDIR)/$(BASE).pdf . 2>/dev/null || true
	@cp -f $(AUXDIR)/$(BASE).synctex.gz . 2>/dev/null || true

# --- Convenience targets --------------------------------------------------------
ifeq ($(shell uname),Darwin)
  VIEWER ?= open
else
  VIEWER ?= xdg-open
endif

.PHONY: v view watch watch-lua watch-pdf watch-xe log
v view: lua
	$(VIEWER) "$(BASE).pdf"

# Continuous preview (latexmk -pvc).  The engine follows the target, like
# the build targets above; plain 'watch' defaults to LuaLaTeX.
watch watch-lua: ENG := -pdflua
watch-pdf:       ENG := -pdf
watch-xe:        ENG := -pdfxe
watch watch-lua watch-pdf watch-xe:
	$(LATEXMK) $(ENG) -pvc $(LMKFLAGS) $(BASE).tex

PAGER ?= less
log:
	@$(PAGER) "$(AUXDIR)/$(BASE).log"

# --- Glossary migration (7.10.x .tex entries -> .bib) ---------------------------
GLSDIR ?= 1-FrontMatter

.PHONY: glsbib
glsbib:
	@command -v convertgls2bib >/dev/null 2>&1 || { \
	  echo "ERROR: convertgls2bib not found — it ships with bib2gls (TeX Live)."; exit 1; }
	@found=0; \
	for f in $(GLSDIR)/*.tex; do \
	  [ -e "$$f" ] || continue; \
	  grep -qE '\\newglossaryentry|\\newacronym' "$$f" || continue; \
	  found=1; b="$${f%.tex}.bib"; \
	  if [ -e "$$b" ]; then echo "  skip  $$f  ($$b already exists)"; continue; fi; \
	  echo "  convert  $$f  ->  $$b"; \
	  convertgls2bib --texenc UTF-8 --bibenc UTF-8 "$$f" "$$b" >/dev/null || exit 1; \
	  n=`grep -cE 'sort *=' "$$f" || true`; \
	  if [ "$$n" -gt 0 ]; then \
	    echo "     WARNING: $$f had $$n sort key(s). convertgls2bib DROPS them;"; \
	    echo "              re-add them in $$b or those entries will mis-sort."; \
	  fi; \
	done; \
	if [ "$$found" = 0 ]; then echo "No glossary .tex files found in $(GLSDIR)/"; fi

# --- Cleaning -------------------------------------------------------------------
.PHONY: clean distclean
clean:
	-@$(LATEXMK) -C -output-directory=$(AUXDIR) $(BASE).tex >/dev/null 2>&1
	rm -rf _minted*
	@find "$(AUXDIR)" -mindepth 1 -maxdepth 1 ! -name matrix -exec rm -rf {} + 2>/dev/null || true
	@find . -name .DS_Store -delete 2>/dev/null || true

distclean: clean
	rm -f "$(BASE).pdf" "$(BASE).synctex.gz"

# --- Help -------------------------------------------------------------------------
.PHONY: help
help:
	@awk '/^#---/{n++; next} n==1 && /^#/{sub(/^# ?/,""); print}' Makefile

# --- Maintainer targets (not shipped in releases) -----------------------------------
-include Makefile.dev
