#----------------------------------------------------------------------------
# NOVATHESIS — Makefile
#----------------------------------------------------------------------------
#
# Version 1.1.1 (1999-12-12)
# Copyright (C) 2004-25 by João M. Lourenço <joao.lourenco@fct.unl.pt>


#----------------------------------------------------------------------------
# CUSTOMIZATION AREA HERE

# Define V command to the name of your PDF viewer
V:=open -a skim


#############################################################################
# DO NOT TOUCH BELOW THIS POINT
#############################################################################

#————————————————————————————————————————————————————————————————————————————
# Prevents the “each line is a new shell” pitfall and simplifies variable flow
.ONESHELL:
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
# LUA cache file
CACHE=.nopdflatex

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
VERSION_FILE=NOVAthesisFiles/nt-version.sty

ORIGVERSION:=$(shell awk -F'[{}]' '/\\novathesisversion/ {print $$4; exit}' '$(VERSION_FILE)')
ORIGDATE:=$(shell awk   -F'[{}]' '/\\novathesisdate/    {print $$4; exit}' '$(VERSION_FILE)')

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
LUA=$(shell cat $(CACHE))
default: validate-config check-env check-build
	$(BUILD) $(SCHL)

#————————————————————————————————————————————————————————————————————————————
# The main targets
# e.g. '$(MAKE) lua'
.PHONY: pdf xe lua
pdf xe lua: validate-config check-env $(CACHE) $(LTXFILE) $(LTXCLS)
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
	$(V) $(PDFFILE)

#————————————————————————————————————————————————————————————————————————————
# Build the PDF
$(PDFFILE): $(LTXFILE)
	$(MAKE) default

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
help:
	@printf "$(CYAN)NOVAthesis Makefile Help$(RESET)\n"
	@printf "$(CYAN)========================$(RESET)\n"
	@printf "$(CYAN)Main targets:$(RESET)\n"
	@printf "$(CYAN)  pdf, xe, lua    - Build with different engines$(RESET)\n"
	@printf "$(CYAN)  view/v          - Build and view PDF$(RESET)\n"
	@printf "$(CYAN)  clean           - Remove build artifacts$(RESET)\n"
	@printf "$(CYAN)  zip             - Create distribution package$(RESET)\n"
	@printf "$(CYAN)  bump1/2/3       - Bump version numbers$(RESET)\n"
	@printf "\n"
	@printf "$(CYAN)Advanced:$(RESET)\n"
	@printf "$(CYAN)  tl/mik TARGET   - Use specific TeX distribution$(RESET)\n"
	@printf "$(CYAN)  YEAR TARGET     - Use specific TeX Live version$(RESET)\n"
	@printf "$(CYAN)  verb/btch/itrt  - Verbose/Batch/Interactive mode$(RESET)\n"
	
#————————————————————————————————————————————————————————————————————————————
# Debug
.PHONY: dry-run debug-vars
dry-run:
	@printf "$(CYAN)Would build with: SCHOOL=$(SCHL), MODE=$(MODE)$(RESET)\n"
	@printf "$(CYAN)Main file: $(BASENAME).tex$(RESET)\n"
	@printf "$(CYAN)Compiler: $(LTXMK) $(LTXFLAGS)$(RESET)\n"

debug-vars:
	@printf "$(CYAN)SCHOOL: $(SCHL)$(RESET)\n"
	@printf "$(CYAN)VERSION: $(ORIGVERSION)$(RESET)\n"
	@printf "$(CYAN)MAIN FILE: $(BASENAME)$(RESET)\n"
	@printf "$(CYAN)TEX VERSIONS: $(TEXVERSIONS)$(RESET)\n"
	@printf "$(CYAN)LUA SCHOOLS: $(shell cat .nopdflatex 2>/dev/null || $(MAGENTA)'not computed'$(RESET))$(RESET)\n"

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
VERSION=$(shell awk -F'[{}]' '/\\novathesisversion/ {print $$4; exit}' '$(VERSION_FILE)')
DATE=$(shell awk   -F'[{}]' '/\\novathesisdate/    {print $$4; exit}' '$(VERSION_FILE)')
ZIPFILES:=NOVAthesisFiles [0-5]-* LICENSE Makefile README.md Scripts novathesis.cls template.pdf template.tex .gitignore
ZIPTARGET=$(BASENAME)-$(VERSION)@$(DATE).zip

#————————————————————————————————————————————————————————————————————————————
.PHONY: zip
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
AUXFILES := $(filter-out $(GOODFILES),$(wildcard $(BASENAME).*)) $(CACHE)

#————————————————————————————————————————————————————————————————————————————
.PHONY: clean
clean:
	@ $(LTXMK) -c $(BASENAME)
	@ rm -f $(AUXFILES) "*(1)*"
	@ rm -rf $(AUXDIR) _minted*
	@ find . -name .DS_Store | xargs rm -rf

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


#############################################################################
# Bump up the template version
#	bump1 -> increase major version number
#	bump2 -> increase mid version number
#	bump3 -> increase minor version number
#############################################################################

#————————————————————————————————————————————————————————————————————————————
# File containing version info
VERSION_FILE = NOVAthesisFiles/nt-version.sty

.PHONY: bump1 bump2 bump3
bump1 bump2 bump3:
	@ BI='$(patsubst bump%,%,$@)'; \
	OLDVERSION='$(ORIGVERSION)'; \
	OLDDATE='$(ORIGDATE)'; \
	[ -n "$$OLDVERSION" ] || { printf "$(RED)ERROR: parse version$(RESET)\n" >&2; exit 1; }; \
	NEWVERSION=$$(awk -v bi="$$BI" -v ver="$$OLDVERSION" 'BEGIN{ \
	  n=split(ver,a,"."); if(bi<1||bi>n){print ver; exit} \
	  a[bi]++; for(i=bi+1;i<=n;i++) a[i]=0; \
	  for(i=1;i<=n;i++){ printf "%s",a[i]; if(i<n)printf "." } }'); \
	NEWDATE=$$(date +%F); \
	@ printf "\n"; \
	printf "$(CYAN)Bumping: $(YELLOW)$$BI$(RESET)\n"; \
	printf "$(CYAN)Version: $(YELLOW)$$OLDVERSION -> $$NEWVERSION$(RESET)\n"; \
	printf "$(CYAN)   Date: $(YELLOW)$$OLDDATE    -> $$NEWDATE$(RESET)\n"; echo; \
	cp '$(VERSION_FILE)' '$(VERSION_FILE).bak'; \
	awk -v newver="$$NEWVERSION" -v newdate="$$NEWDATE" ' \
	  /\\novathesisversion/ { sub(/\{[^}]*\}$$/, "{" newver "}"); } \
	  /\\novathesisdate/    { sub(/\{[^}]*\}$$/, "{" newdate "}"); } \
	  { print }' '$(VERSION_FILE).bak' > '$(VERSION_FILE)'; \
	rm -f '$(VERSION_FILE).bak'; \
	printf "$(CYAN)Updated $(YELLOW)$(VERSION_FILE)$(RESET)\n"; \
	printf "\n"; \
	printf "$(CYAN)New content:$(RESET)\n$(GREEN)"; \
	grep -E 'novathesis(version|date)' $(VERSION_FILE) || true; \
	printf "$(RESET)\n"; \
	rm -f $(VERSION_FILE).bak; \
	$(MAKE) mtp



#############################################################################
# Find out which templates cannot be compiled with 'pdflatex'
# i.e., that must be compiled with 'lualatex' or 'xelatex'
#############################################################################

#————————————————————————————————————————————————————————————————————————————
.PHONY: nopdflatex
NOPDFALLCMD=$(shell $(GREP) -rl "is not compatible with pdfLaTeX" NOVAthesisFiles/FontStyles | cut -d / -f 3 | cut -d . -f 1 | $(GREP) -ril -f - NOVAthesisFiles/Schools | $(GREP) .ldf | sed -e "s,.*/,," -e "s,-defaults.ldf,," | tr - /)
# Keep only the words that do NOT contain a slash
NOPDFUNIVSCMD=$(foreach word,$(NOPDFALL),$(if $(findstring /,$(word)),,$(word)))
NOPDFSCHOOLSCMD=$(foreach word,$(NOPDFALL),$(if $(findstring /,$(word)),$(word),))
NOPDFSCHLSFROMUNIV=$(NOPDFSCHOOLS) $(foreach univ,$(NOPDFUNIVS),$(shell find NOVAthesisFiles/Schools/$(univ) -type d -mindepth 1 -maxdepth 1 | grep -v '/Images' | cut -d / -f 3-4))

nopdflatex:
	$(eval NOPDFALL:=$(NOPDFALLCMD))
	$(eval NOPDFUNIVS:=$(NOPDFUNIVSCMD))
	$(eval NOPDFSCHOOLS:=$(NOPDFSCHOOLSCMD))
	$(eval NOPDFSCHLSFROMU:=$(NOPDFSCHLSFROMUNIV))
	@ echo $(NOPDFSCHLSFROMUNIV) > .nopdflatex
	
# Add a real dependency for the cache file
.nopdflatex: $(shell find NOVAthesisFiles -name "*.sty" -o -name "*.ldf")
	$(MAKE) --no-print-directory nopdflatex

#############################################################################
# MERGE-TAG-PUSH FUNCTION
#############################################################################

#————————————————————————————————————————————————————————————————————————————
.PHONY: mtp mtp2
mtp mtp2:
	$(eval VERSION := $(shell awk -F'[{}]' '/\\novathesisversion/ {print $$4; exit}' $(VERSION_FILE)))
	$(eval DATE    := $(shell awk -F'[{}]' '/\\novathesisdate/    {print $$4; exit}' $(VERSION_FILE)))
	@ $(call _$@,$(VERSION),$(DATE))

#————————————————————————————————————————————————————————————————————————————
# commit, build, merge, tag and push
define _mtp
	printf "$(CYAN)VERSION=$(YELLOW)$(1)$(CYAN) - DATE=$(YELLOW)$(2).$(RESET)\n"
	git commit --all --message "Version $(1) - $(2)." || true
	$(MAKE) clean
	.Build/build.py nova/fct --no-rename
	git commit --all --message "Version $(1) - $(2)." || true
	git checkout main
	git pull
	git merge --strategy-option theirs -m "Merge branch 'develop'" develop
	git tag -f -a "v$(1)" -m "Version $(1) - $(2)."
	git push -f --all
	git push -f --tags
	git checkout develop
endef

#————————————————————————————————————————————————————————————————————————————
# commit, NO BUILD, merge, tag and push
define _mtp2
	printf "$(CYAN)VERSION=$(YELLOW)$(1)$(CYAN) - DATE=$(YELLOW)$(2).$(RESET)\n"
	git commit --all --message "Version $(1) - $(2)." || true
	$(MAKE) clean
	git commit --all --message "Version $(1) - $(2)." || true
	git checkout main
	git pull
	git merge --strategy-option theirs -m "Merge branch 'develop'" develop
	git tag -f -a "v$(1)" -m "Version $(1) - $(2)."
	git push -f --all
	git push -f --tags
	git checkout develop
endef
