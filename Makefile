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

.PHONY: bump0 bump1 bump2 bump3
bump1 bump2 bump3:
	$(eval BI='$(patsubst bump%,%,$@)')
	Scripts/bump.py -b $(BI)
	$(MAKE) bcmtp

.PHONY: bcmtp
bcmtp: build-phd-final-en commit rebase tag push

.PHONY: build-phd-final-en
build-phd-final-en: validate-config check-env check-build
	$(BUILD) $(SCHL) -t phd -s final -l en -p lua



#————————————————————————————————————————————————————————————————————————————
# Commit
COMMIT_MESSAGE ?= Version $(VERSION) - $(DATE). Auto-commit.
COMMIT_INCLUDE_UNTRACKED ?= no

.PHONY: commit commit-untracked
commit-untracked:
	make commit COMMIT_INCLUDE_UNTRACKED=yes

commit:
	@echo "📝 Starting commit process..."
	@printf "$(CYAN)VERSION=$(YELLOW)$(VERSION)$(CYAN) - DATE=$(YELLOW)$(DATE)$(RESET).\n"
	
# 1) Comprehensive pre-commit checks
	@echo "📋 Running pre-commit checks..."
	
# Git repository check
	@if ! git rev-parse --git-dir >& /dev/null; then \
		echo "❌ Error: Not in a git repository"; \
		exit 1; \
	fi
	
# Branch check
	$(eval CURRENT_BRANCH=$(shell git branch --show-current || echo "detached"))
	@if [ "$(CURRENT_BRANCH)" = "detached" ]; then \
		echo "❌ Error: Not on a branch (detached HEAD state)"; \
		exit 1; \
	else \
		echo "✅ On branch: $(CURRENT_BRANCH)"; \
	fi
	
# Modified files check
	@if [ -z "$$(git status --porcelain)" ]; then \
		echo "❌ Error: No modified files to commit"; \
		exit 1; \
	fi
	
# Show what will be committed
	@echo ""
	@echo "📋 Files to be committed:"
	@git status --short
	@echo ""
	
# Handle untracked files based on setting
	@if [ "$(COMMIT_INCLUDE_UNTRACKED)" = "yes" ]; then \
		echo "📋 Adding untracked files..."; \
		git add .; \
		echo "✅ Added all files (including untracked)"; \
	else \
		git add -u; \
		echo "✅ Staged modified files (excluding untracked)"; \
	fi
	
# 2) Create the commit
	@echo ""
	@echo "💾 Creating commit..."
	@if git commit -m "$(COMMIT_MESSAGE)"; then \
		echo "✅ Commit created successfully"; \
		COMMIT_HASH=$$(git rev-parse --short HEAD); \
		echo ""; \
		echo "📦 Commit Summary:"; \
		echo "   Hash:    $$COMMIT_HASH"; \
		echo "   Branch:  $(CURRENT_BRANCH)"; \
		echo "   Message: $(COMMIT_MESSAGE)"; \
		echo ""; \
		echo "📊 Files committed:"; \
		git show --stat --oneline $$COMMIT_HASH | tail -n +2; \
	else \
		echo "❌ Failed to create commit"; \
		echo "   This might be because there were no changes to commit after staging"; \
		exit 1; \
	fi
	
	@printf "\n🎉 Commit process completed successfully!\n\n"



#————————————————————————————————————————————————————————————————————————————
# REBASE -> if rebase fails, tries MERGE
MERGE_MESSAGE ?= Merged $(VERSION) - $(DATE).

.PHONY: rebase
rebase:
	@echo "🚀 Starting rebase process..."
	printf "$(CYAN)VERSION=$(YELLOW)$(1)$(CYAN) - DATE=$(YELLOW)$(2).$(RESET)\n"
	
# 1) Check if we are in branch develop
	@echo "📋 Checking current branch..."
	@if [ "$(shell git branch --show-current)" != "develop" ]; then \
		echo "❌ Error: You must be on the 'develop' branch to run this target"; \
		exit 1; \
	fi
	@echo "✅ Currently on 'develop' branch"
	
# 2) Check for pending/modified files
	@echo "📋 Checking for pending changes..."
	@if [ "$$(git status --porcelain | grep -Fv '??')" ]; then \
		echo "❌ Error: You have uncommitted changes. Please commit or stash them first."; \
		git status --short; \
		exit 1; \
	fi
	@echo "✅ No pending changes"
	
# 3) Checkout main and rebase
	@echo "🔄 Switching to main branch..."
	@git checkout main || { echo "❌ Failed to checkout main branch"; exit 1; }
	
	@echo "🔄 Rebasing main onto develop..."
	@if git rebase develop; then \
		echo "✅ Rebase completed successfully"; \
	else \
		echo "⚠️  Rebase encountered conflicts. Resolving automatically using develop version..."; \
		git rebase --abort 2>/dev/null || true; \
		git merge develop -X theirs -m "$$(MERGE_MESSAGE)" || { \
			echo "❌ Failed to merge with develop version"; \
			exit 1; \
		}; \
		echo "✅ Merge completed using develop version"; \
	fi
	
# 4) If no error, checkout develop
	@echo "🔄 Switching back to develop branch..."
	@git checkout develop || { echo "❌ Failed to checkout develop branch"; exit 1; }
	
	@echo "🎉 Rebase process completed successfully!"



.PHONY: tag 
tag:
	printf "\n"
	printf "$(RED)Tagging$(RESET)\n"
	printf "$(CYAN)VERSION=$(YELLOW)$(1)$(CYAN) - DATE=$(YELLOW)$(2).$(RESET)\n"

.PHONY: push
push:



#############################################################################
# MERGE-TAG-PUSH FUNCTION
#############################################################################

#————————————————————————————————————————————————————————————————————————————
.PHONY: mtp mtp2
mtp mtp2:
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
