 #----------------------------------------------------------------------------
# NOVATHESIS — Makefile
#----------------------------------------------------------------------------
#
# Version 7.10.0 (2026-02-04)
# Copyright (C) 2004-26 by João M. Lourenço <joao.lourenco@fct.unl.pt>


#----------------------------------------------------------------------------
# CUSTOMIZATION AREA HERE

# Use bash and not sh
SHELL := /bin/bash

# Define V command to the name of your PDF viewer
PDFVIEWER ?= open -a skim

# Define the text Editor
EDITOR ?= mate

#############################################################################
# DO NOT TOUCH BELOW THIS POINT
#############################################################################

#————————————————————————————————————————————————————————————————————————————
# Prevents the “each line is a new shell” pitfall and simplifies variable flow
SHELL := /bin/sh
.SHELLFLAGS := -eu -c -o pipefail
#————————————————————————————————————————————————————————————————————————————
# Define commans
GREP := grep -F

#————————————————————————————————————————————————————————————————————————————
# Automatically discover the main file:
# 	1) the first file containing "\documentclass"
#	2) ; if none found, raises an error
LTXFILE := $(firstword $(shell $(GREP) -F -l -m1 '\documentclass' -- *.tex 2>/dev/null))
ifeq ($(LTXFILE),)
$(error No .tex file found with "\documentclass")
endif
BASENAME := $(patsubst %.tex,%,$(LTXFILE))
PDFFILE := $(BASENAME).pdf
LTXCLS := novathesis.cls

#————————————————————————————————————————————————————————————————————————————
# Possible compilation modes
MODEITRT :=
MODENSTP := -interaction=nonstopmode
MODEBTCH := -interaction=batchmode
ifeq ($(MODE),)
MODE := $(MODENSTP)
endif


#————————————————————————————————————————————————————————————————————————————
# Cache files
NEEDLUALATEX=.needlualatex
KEEPDIR=.keep-dir

#————————————————————————————————————————————————————————————————————————————
# AUXDIR to avoid cluttering workspace
ifndef AUXDIR
AUXDIR:=./AUXDIR
export AUX_DIR=$(AUXDIR)
endif

#————————————————————————————————————————————————————————————————————————————
# latexmk and its flags
LTXMK:=latexmk
LTXFLAGS=-time -f -file-line-error -shell-escape -synctex=1 -auxdir=$(AUXDIR) $(MODE) $(FLAGS)
BUILD:=.Build/build.py

#————————————————————————————————————————————————————————————————————————————
# extract version and date of the template
VERSION_FILE=NOVAthesisFiles/StyFiles/nt-version.sty

VERSION		= $(shell awk -F'[{}]' '/\\novathesisversion/ {print $$4; exit}' '$(VERSION_FILE)')
DATE		= $(shell awk -F'[{}]' '/\\novathesisdate/    {print $$4; exit}' '$(VERSION_FILE)')
ORIGVERSION := $(VERSION)
ORIGDATE	:= $(DATE)

#————————————————————————————————————————————————————————————————————————————
# Find out which versions of TeX live are available (works for macos)
TEXVERSIONS:=$(shell ls /usr/local/texlive/ | $(GREP) -v texmf-local)

#————————————————————————————————————————————————————————————————————————————
# Extract school being built
SCHL := $(shell sed -n '/^[[:space:]]*%/d; s/.*ntsetup{school=\([^}]*\)}.*/\1/p' 0-Config/1_novathesis.tex | head -1)
SCHL := $(if $(SCHL),$(SCHL),nova/fct)



#############################################################################
# Main targets:
# pdf/xe/lua		build with Tex-Live
# tl pdf/xe/lua		build with Tex-Live
# mik pdf/xe/lua	build with MikTeX
# year pdf/xe/lua	build with Tex-Live release for <year> (if available, otherwise defaults release)
# v/view			build with pdfLaTeX
# zip				build a ZIP archive with the source files
# help              print help message
#############################################################################

#————————————————————————————————————————————————————————————————————————————
# Automatically use the right latex compiler and compile
.PHONY: default
default: validate-config check-env check-build
	$(BUILD) $(SCHL) ${BFLAGS}

#————————————————————————————————————————————————————————————————————————————
# The main targets
# e.g. '$(MAKE) lua'
.PHONY: pdf xe lua
pdf xe lua: validate-config check-env $(NEEDLUALATEX) $(LTXFILE) $(LTXCLS)
	$(LTXMK) -pdf$(patsubst pdf%,%,$@) $(LTXFLAGS) $(BASENAME)

#————————————————————————————————————————————————————————————————————————————
# Btach mode
.PHONY: verbose verb vv
verbose verb vv:
	$(MAKE) $(filter-out $@,$(MAKECMDGOALS)) MODE=$(MODENSTP) PROGRESS=$(PROGRESSVERB)

#————————————————————————————————————————————————————————————————————————————
# Btach mode
.PHONY: batch btch bt
batch btch bt:
	$(MAKE) $(filter-out $@,$(MAKECMDGOALS)) MODE=$(MODEBTCH) PROGRESS=

#————————————————————————————————————————————————————————————————————————————
# Interactive mode
.PHONY: interactive itrtv itrt it
interactive itrtv itrt it:
	$(MAKE) $(filter-out $@,$(MAKECMDGOALS)) MODE="$(MODEITRT)" PROGRESS=

#————————————————————————————————————————————————————————————————————————————
# Use TeX-Live and excute next target
# e.g. '$(MAKE) tl lua'
.PHONY: tl
tl:
	@ hash -r
	$(MAKE) $(filter-out $@,$(MAKECMDGOALS))

#————————————————————————————————————————————————————————————————————————————
# Use MikTeX and excute next target
# e.g. '$(MAKE) mik lua'
.PHONY: mik
mik:
	@ hash -r
	PATH="$(HOME)/bin:$(PATH)" $(MAKE) $(filter-out $@,$(MAKECMDGOALS))

#————————————————————————————————————————————————————————————————————————————
# Use a specific TeX-Live release and excute next target
# e.g. '$(MAKE) 2024 lua'
.PHONY: $(TEXVERSIONS)
$(TEXVERSIONS):
	@ hash -r
	$(eval TEXBIN := $(firstword $(wildcard /usr/local/texlive/$@/bin/*-darwin/)))
ifeq ($(TEXBIN),)
	@ printf "$(RED)TeX Live $@ not found; using default on PATH$(RESET)\n"
	$(MAKE) $(filter-out $@,$(MAKECMDGOALS))
else
	PATH="$(TEXBIN):$(PATH)" $(MAKE) $(filter-out $@,$(MAKECMDGOALS))
endif

#————————————————————————————————————————————————————————————————————————————
# Build and display the PDF
.PHONY: v view
v view: $(PDFFILE)
	$(PDFVIEWER) $(PDFFILE)

#————————————————————————————————————————————————————————————————————————————
# Display the log file
.PHONY: log
log:
	$(EDITOR) $$(find . -name "$(BASENAME).log" -print0 | xargs -0)

#————————————————————————————————————————————————————————————————————————————
# Build the PDF
$(PDFFILE): $(LTXFILE)
	$(MAKE) default $(BF)

#————————————————————————————————————————————————————————————————————————————
# Add fail-safe for critical commands
.PHONY: check-env check-build
check-env:
	@command -v $(LTXMK) >/dev/null 2>&1 || { printf "$(RED)Error: $(LTXMK) not found$(RESET)\n"; exit 1; }

check-build:
	@command -v $(BUILD) -h >/dev/null 2>&1 || { printf "$(RED)Error: $(BUILD) not found$(RESET)\n"; exit 1; }

#————————————————————————————————————————————————————————————————————————————
.PHONY: validate-config
validate-config:
	@if [ -z "$(SCHL)" ]; then \
		printf "$(RED)Error: School configuration not found in 0-Config/1_novathesis.tex$(RESET)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)Building for school: $(YELLOW)$(SCHL)$(RESET)\n"


#############################################################################
# HELP & DDEBUG
#############################################################################

#————————————————————————————————————————————————————————————————————————————
# Help
.PHONY: help
.ONESHELL:
help:
	@printf "$(CYAN)NOVAthesis Makefile Help$(RESET)\n"
	@printf "$(CYAN)========================$(RESET)\n"
	@printf "$(CYAN)Main targets:$(RESET)\n"
	@printf "$(CYAN)  pdf, xe, lua    - Build with different engines$(RESET)\n"
	@printf "$(CYAN)  view/v          - Build and view PDF$(RESET)\n"
	@printf "$(CYAN)  clean           - Remove build artifacts$(RESET)\n"
	@printf "$(CYAN)  zip             - Create distribution package$(RESET)\n"
	@printf "$(CYAN)  bump0/1/2/3     - Bump version numbers$(RESET)\n"
	@printf "\n"
	@printf "$(CYAN)Advanced:$(RESET)\n"
	@printf "$(CYAN)  tl/mik TARGET   - Use specific TeX distribution$(RESET)\n"
	@printf "$(CYAN)  YEAR TARGET     - Use specific TeX Live version$(RESET)\n"
	@printf "$(CYAN)  verb/btch/itrt  - Verbose/Batch/Interactive mode$(RESET)\n"
	
#————————————————————————————————————————————————————————————————————————————
# Debug
.PHONY: dry-run debug-vars
.ONESHELL:
dry-run:
	@printf "$(CYAN)Would build with: SCHOOL=$(SCHL), MODE=$(MODE)$(RESET)\n"
	@printf "$(CYAN)Main file: $(BASENAME).tex$(RESET)\n"
	@printf "$(CYAN)Compiler: $(LTXMK) $(LTXFLAGS)$(RESET)\n"

.ONESHELL:
debug-vars:
	@printf "$(CYAN)SCHOOL: $(SCHL)$(RESET)\n"
	@printf "$(CYAN)VERSION: $(ORIGVERSION)$(RESET)\n"
	@printf "$(CYAN)MAIN FILE: $(BASENAME)$(RESET)\n"
	@printf "$(CYAN)TEX VERSIONS: $(TEXVERSIONS)$(RESET)\n"
	@printf "$(CYAN)LUA SCHOOLS: $(shell cat $(NEEDLUALATEX) 2>/dev/null || $(MAGENTA)'not computed'$(RESET))$(RESET)\n"

#————————————————————————————————————————————————————————————————————————————
# Color definitions
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
MAGENTA := \033[0;35m
CYAN := \033[0;36m
WHITE := \033[0;37m
BOLD := \033[1m
RESET := \033[0m



#############################################################################
# Create a ZIP file (no .git and similar folder)
#############################################################################

#————————————————————————————————————————————————————————————————————————————
# target and files to be incldued in "$(MAKE) zip"
ZIPFILES:=NOVAthesisFiles [0-5]-* LICENSE Makefile README.md Scripts novathesis.cls template.pdf template.tex .gitignore
ZIPTARGET=$(BASENAME)-$(VERSION)@$(DATE).zip

#————————————————————————————————————————————————————————————————————————————
.PHONY: zip
.ONESHELL:
zip: clean
	@ printf "$(YELLOW)Creating archive: $(ZIPTARGET)$(RESET)\n"
	@ rm -f "$(ZIPTARGET)"
	@ zip $(ZIPTARGET) -r -q $(ZIPFILES)  -x 'Scripts/*'
	@ printf "$(YELLOW)Archive created: $(ZIPTARGET) ($(shell stat -f%$(RESET)z "$(ZIPTARGET)" 2>/dev/null || stat -c%s "$(ZIPTARGET)" ) bytes)\n"


#############################################################################
# Cleaning targets
#	clean -> standard clean
#	bclean -> also cleans biber cache
#	gclean -> uses git clean (removes all untracked files)
#############################################################################

#————————————————————————————————————————————————————————————————————————————
# aux files
# AUXFILES:=$(shell ls $(BASENAME)*.* | $(GREP) -v .tex | $(GREP) -v .pdf | sed 's: :\\ :g' | sed 's:(:\\(:g' | sed 's:):\\):g')

GOODFILES := LICENSE Makefile %.cls %.md .gitignore %.tex %.pdf
AUXFILES := $(filter-out $(GOODFILES),$(wildcard $(BASENAME).*)) $(NEEDLUALATEX)

#————————————————————————————————————————————————————————————————————————————
.PHONY: clean
.ONESHELL:
clean:
	@ $(LTXMK) -c $(BASENAME)
	@ rm -f $(AUXFILES) "*(1)*" $(NEEDLUALATEX) $(KEEPDIR)
	@ rm -rf $(AUXDIR) _minted*
	@ find . -name .DS_Store | xargs rm -rf
	@ find . -maxdepth 1 -type f -name 'novathesis*' ! -name '*.pdf' ! -name '*.tex' ! -name '*.cls' -delete
	@ rm -rf $(wildcard /tmp/novathesis) $(wildcard /tmp/ntbuild-*)&

#————————————————————————————————————————————————————————————————————————————
.PHONY: bclean
bclean:
	@ rm -rf `biber -cache`
	@ biber -cache
	@ $(MAKE) clean

#————————————————————————————————————————————————————————————————————————————
.PHONY: gclean
gclean:
	@ git clean -fx -e Scripts -e Fonts
	@ rm -rf $(wildcard /tmp/ntbuild-*)&


#############################################################################
# Bump up the template version
#	bump0 -> do not increase version number
#	bump1 -> increase major version number
#	bump2 -> increase mid version number
#	bump3 -> increase minor version number
#############################################################################

#————————————————————————————————————————————————————————————————————————————
# File containing version info
.PHONY: bump0 bump1 bump2 bump3
bump0 bump1 bump2 bump3:
ifneq ($@,bump0)
	$(eval BI='$(patsubst bump%,%,$@)')
	@ Scripts/bump.py -b $(BI)
endif
	$(MAKE) bcrtp

.PHONY: bcrtp bcrp bcp crp cp rp crtp rtp tp 
bcrtp: build-phd-en crtp

bcrp: build-phd-en crp

bcp: build-phd-en commit push

bcp-f: build-phd-en commit push-force

crp: commit rebase push

rp: rebase push

crp-f: commit rebase push-force

cp: commit push

cp-f: commit push-force

crtp: commit rtp

rtp: rebase tp

tp: tag push

custom:
	@ $(eval SCHL=$(shell printf "%s" "$(notdir $(CURDIR))" | sed -e 's,-,/,; s,-,/,'))
	@ sed -i '' -E 's|[[:space:]]*%?[[:space:]]*(\\ntsetup\{school=)[^}]*}|\1'$(SCHL)'\}|' 0-Config/1_novathesis.tex
	@ make bcp SCHL="$(SCHL)" BFLAGS="-f"

#############################################################################
# BUILD
#############################################################################


# 1. Define Defaults
DFL_SCHL := nova.fct
DFL_TYP  := phd
DFL_LNG  := en

# 2. Define Extraction Function
# Note: Regex changed to "^[[:space:]]*" to strictly match start of line + spaces
# This ignores lines starting with %
GET_TEX_VAR = sed -n 's/^[[:space:]]*\\ntsetup{$(1)=\([^}]*\).*/\1/p' 0-Config/1_novathesis.tex

# 3. Logic: Try to get from file; if empty, use Default
# We store the raw extraction in a temporary variable (_) to check if it exists

# Handle SCHL (Needs special tr handling only if extracted)
_FILE_SCHL := $(shell $(call GET_TEX_VAR,school))
SCHL := $(if $(_FILE_SCHL),$(shell echo $(_FILE_SCHL) | tr '/-' '..'),$(DFL_SCHL))

# Handle TYP
_FILE_TYP := $(shell $(call GET_TEX_VAR,doctype))
TYP := $(or $(_FILE_TYP),$(DFL_TYP))

# Handle LNG
_FILE_LNG := $(shell $(call GET_TEX_VAR,lang))
LNG := $(or $(_FILE_LNG),$(DFL_LNG))

# 4. Define Build Rules
.PHONY: build
# Default build uses the variables calculated above
build: build-$(SCHL)-$(TYP)-$(LNG)

# Pattern rule to parse arguments from the target name
build-%: 
	$(eval PATTERN := $(subst .o,,$*))
	$(eval PARTS := $(subst -, ,$(PATTERN)))
	$(eval WORD_COUNT := $(words $(PARTS)))
	@SCHL="$(SCHL)"; \
	TYP="$(TYP)"; \
	LNG="$(LNG)"; \
	\
	if [ "$(WORD_COUNT)" = "3" ]; then \
		SCHL=$(word 1,$(PARTS)); \
		TYP=$(word 2,$(PARTS)); \
		LNG=$(word 3,$(PARTS)); \
	elif [ "$(WORD_COUNT)" = "2" ]; then \
		TYP=$(word 1,$(PARTS)); \
		LNG=$(word 2,$(PARTS)); \
	elif [ "$(WORD_COUNT)" = "1" ]; then \
		LNG=$(word 1,$(PARTS)); \
	else \
		echo "Error: Invalid format '$*'. Expected 1-3 arguments."; \
		exit 1; \
	fi; \
	\
	FINAL_SCHL=$$(echo $$SCHL | sed 's/\./\//; s/\./\//; s/\./-/g'); \
	\
	echo "$(BUILD) $$FINAL_SCHL --doctype $$TYP --lang $$LNG --rename-pdf --mode 1 --docstatus final -o $(PWD) $(BFLAGS)"; \
	$(BUILD) $$FINAL_SCHL --doctype $$TYP --lang $$LNG --rename-pdf --mode 1 --docstatus final -o $(PWD) $(BFLAGS)



#############################################################################
# COMMIT / PUSH
#############################################################################
COMMIT_MESSAGE ?= Version $(VERSION) - $(DATE). $(CM)
COMMIT_INCLUDE_UNTRACKED ?= no

.PHONY: commit commit-untracked push push-force
commit push push-force:
	@ VERSION="$(VERSION)" \
	DATE="$(DATE)" \
	COMMIT_MESSAGE="$(COMMIT_MESSAGE)" \
	COMMIT_INCLUDE_UNTRACKED="$(COMMIT_INCLUDE_UNTRACKED)" \
	.Build/$@.sh

commit-untracked:
	make commit COMMIT_INCLUDE_UNTRACKED=yes

#————————————————————————————————————————————————————————————————————————————
# Helper to show remote status
PUSH_REMOTE ?= origin
.PHONY: push-status
push-status:
	@echo "📋 Remote status for all branches:"
	@git remote show $(PUSH_REMOTE) | grep -E "(HEAD branch|Local branch|pushes to|local out of date)" || true


#############################################################################
# REBASE -> if rebase fails, tries MERGE
#############################################################################
MERGE_MESSAGE ?= Merged $(VERSION) - $(DATE).
#————————————————————————————————————————————————————————————————————————————
.PHONY: rebase
rebase:
	@MERGE_MESSAGE="$(MERGE_MESSAGE)" \
	VERSION="$(VERSION)" \
	DATE="$(DATE)" \
	.Build/rebase.sh



#############################################################################
# TAG
#############################################################################
TAG_VERSION ?= $(VERSION)
TAG_DATE ?= $(DATE)
TAG_MESSAGE ?= Version $(TAG_VERSION) - $(TAG_DATE).

.PHONY: tag tag-push tag-delete tag-dry-run tag-show tag-list
tag tag-push tag-delete tag-dry-run tag-show:
	@VERSION="$(VERSION)" \
	DATE="$(DATE)" \
	TAG_VERSION="$(TAG_VERSION)" \
	TAG_DATE="$(TAG_DATE)" \
	TAG_MESSAGE="$(TAG_MESSAGE)" \
	.Build/$@.sh

tag-list:
	@echo "📋 Recent tags:"
	@git tag -l --sort=-version:refname "v*" | head -10


	
	




#############################################################################
# UPDATE
#############################################################################
CDIR    = $(shell basename $$(pwd))
update:
	@ .Build/nt-safe-update.sh $(CDIR)

#############################################################################
# Find out which templates cannot be compiled with 'pdflatex'
# i.e., that must be compiled with 'lualatex' or 'xelatex'
#############################################################################

#————————————————————————————————————————————————————————————————————————————
.PHONY: needlua needlualatex
needlua needlualatex:
	@ .Build/need_lualatex.sh

# Add a real dependency for the cache file
$(NEEDLUALATEX): $(shell find NOVAthesisFiles -name "*.sty" -o -name "*.ldf")
	$(MAKE) --no-print-directory needlualatex
