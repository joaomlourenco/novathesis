#############################################################################
# CUSTOMIZATION AREA HERE
#############################################################################
# If you want to force the name of the main file, uncomment the following command
# MF:="YOUR_MAIN_TEX_FILE" # without the ".tex" extension

# Define V command to the name of your PDF viewer
V:=open -a skim



#############################################################################
# DO NOT TOUCH BELOW THIS POINT
#############################################################################

# If a file "tempalte.tex" is found, usennn it as the main file
# otherwise, use the first (alphabetically) .tex file found as the main file
ifeq ($(MF),)
TEX:=$(patsubst %.tex,%,$(wildcard *.tex))
MF:=$(findstring template,$(TEX)})
ifeq ($(MF),)
MF:=$(word 1,$(TEX))
endif
endif

# Find out which versions of TeX live are available (works for macos)
TEXVERSIONS=$(shell ls /usr/local/texlive/ | fgrep -v texmf-local)

# Customize latex compilation
B:=$(MF)
T:=$(MF).pdf
S:=$(MF).tex

ifndef AUXDIR
AUXDIR:=./AUXDIR
export AUX_DIR=$(AUXDIR)
endif

MK:=latexmk $(MKF)
MKF:=-time -interaction=batchmode -shell-escape -synctex=1 -file-line-error -f -auxdir=$(AUXDIR) $(FLAGS)

CT=cluttex $(CTF)
CFT:=

# target and files to be incldued in "make zip"
ZIPFILES:=NOVAthesisFiles Bibliography Config Chapters LICENSE Makefile novathesis.cls README.md .gitignore template.tex
ZIPTARGET=$(B)-$(VERSION)@$(DATE).zip

# extract version and date of the template
VERSION=$(shell head -1 NOVAthesisFiles/nt-version.sty | sed -e 's/.*{//' -e 's/\(.*\)./\1/')
DATE:=$(shell tail -1 NOVAthesisFiles/nt-version.sty | sed -e 's/.*{//' -e 's/\(.*\)./\1/' | tr '\n' '@'m| sed -e 's/\(.*\)./\1/')

# aux files
AUXFILES:=$(shell ls $(B)*.* | fgrep -v .tex | fgrep -v .pdf | sed 's: :\\ :g' | sed 's:(:\\(:g' | sed 's:):\\):g')

# schools requiring XeLaTeX or LuaLaTeX (incompatible with pdfLaTeX)
LUA="uminho/eaad uminho/ec uminho/ed uminho/eeg uminho/eeng uminho/elach uminho/emed uminho/epsi uminho/ese uminho/i3bs uminho/ics uminho/ie other/esep"

# Extract school being built
SCHL=$(shell grep -v "^%" Config/1_novathesis.tex | grep "ntsetup{school=" | cut -d "=" -f 2 | cut -d "}" -f 1)
ifeq ($(SCHL),)
	SCHL=nova/fct
endif


.PHONY: default
default:
	@echo SCHL=$(SCHL)
ifeq ($(findstring $(SCHL),$(LUA)),)
	make pdf
else
	make xe
endif

.PHONY: ct mk
ct mk:
ifeq ($@,ct)
	@echo Using cluttex
else
ifeq ($@,mk)
	@echo Using latexmk
endif
endif
	make CTMK=$@ $(filter-out $@,$(MAKECMDGOALS))

#############################################################################
# Main targets:
# pdf/xe/lua		build with Tex-Live
# tl pdf/xe/lua		build with Tex-Live
# mik pdf/xe/lua	build with MikTeX
# year pdf/xe/lua	build with Tex-Live release for <year> (if available, otherwise defaults release)
# v/view			build with pdfLaTeX
# zip				build a ZIP archive with the source files
#############################################################################

#————————————————————————————————————————————————————————————————————————————
# TeX-Live
.PHONY: tl
tl:
	hash -r
	make $(filter-out $@,$(MAKECMDGOALS))

#————————————————————————————————————————————————————————————————————————————
# MikTeX
.PHONY: mik
mik:
	hash -r
	PATH="$(HOME)/bin:$(PATH)" make $(filter-out $@,$(MAKECMDGOALS))

#————————————————————————————————————————————————————————————————————————————
# TL Release (e.g., 2022)
.PHONY: $(TEXVERSIONS)
$(TEXVERSIONS):
	hash -r
	PATH="$(wildcard /usr/local/texlive/$@/bin/*-darwin/):$(PATH)" make $(filter-out $@,$(MAKECMDGOALS))

#————————————————————————————————————————————————————————————————————————————
.PHONY: pdf xe lua
pdf xe lua: $(S)
ifeq ($(CTMK),ct)	
	$(CT) -e pdf$(patsubst pdf%,%,$@)latex $(CTF) $(B)
else
	$(MK) -pdf$(patsubst pdf%,%,$@) $(MKF) $(B)
endif
	@ eval "$$printtimes"

#————————————————————————————————————————————————————————————————————————————
.PHONY: v view
v view: $(T)
	$(V) $(T)

#————————————————————————————————————————————————————————————————————————————
$(T): $(S)
	make default

#————————————————————————————————————————————————————————————————————————————
.PHONY: vv verb verbose
vv verb verbose:
	$(L) -pdf $(B)
	@ eval "$$printtimes"


#————————————————————————————————————————————————————————————————————————————
.PHONY: zip
zip:
	rm -f "$(ZIPTARGET)"
	zip --exclude .github --exclude .git -r "$(ZIPTARGET)" $(ZIPFILES)


#————————————————————————————————————————————————————————————————————————————
.PHONY: clean
clean:
	@$(MK) -c $(B)
	@rm -f $(AUXFILES) "*(1)*"
	@rm -rf $(AUXDIR)
	@find . -name .DS_Store -o -name '_minted*' | xargs rm -rf

#————————————————————————————————————————————————————————————————————————————
.PHONY: gclean
gclean:
	git clean -fdx -e Scripts -e Fonts

#————————————————————————————————————————————————————————————————————————————
.PHONY: bclean
bclean:
	rm -rf `biber -cache`
	biber -cache
	make clean

#————————————————————————————————————————————————————————————————————————————
.PHONY: publish
publish:
ifneq (, $(wildcard Scripts/publish.sh))
	Scripts/publish.sh
endif

#————————————————————————————————————————————————————————————————————————————
.PHONY: bump1 bump2 bump3
bump1 bump2 bump3:
ifneq (, $(wildcard Scripts/newversion.sh))
	Scripts/newversion.sh $(subst bump,,$@)
	@$(call mtp)
endif



#————————————————————————————————————————————————————————————————————————————
.PHONY: mtp
mtp:
	@$(call mtp)



#————————————————————————————————————————————————————————————————————————————
.PHONY: time

time times:
	@ eval "$$printtimes"

#############################################################################
# FUNCTIONS
#############################################################################
#————————————————————————————————————————————————————————————————————————————
define _printtimes
printf "TIMES FROM THE LAST EXECUTION\n"
TIMES="$(grep -e 'l3benchmark. + TOC'  ${AUX_DIR}/*.log | cut -d ' ' -f 4 | xargs)"
PHASES="$(fgrep TIME ${AUX_DIR}/*.log | cut -d ' ' -f 2-3 | cut -d '=' -f 1 | tr ' ' '_' | xargs)"
declare -a TM=($TIMES)
declare -a PH=($PHASES)
for i in `seq 0 $((${#TM[@]}-1))`; do
	printf "%20s = %6.2f\n" "${PH[$i]}" "${TM[$i]}"
done
endef

ifneq (, $(findstring jml,${USER}))
export printtimes = $(value _printtimes)
else
export printtimes = $(shell true)
endif

# merge, tag and push
define mtp
	VERSION=$(shell head -1 NOVAthesisFiles/nt-version.sty | sed -e 's/.*{//' -e 's/\(.*\)./\1/')
	DATE=$(shell tail -1 NOVAthesisFiles/nt-version.sty | sed -e 's/.*{//' -e 's/\(.*\)./\1/' | tr '\n' '@'m| sed -e 's/\(.*\)./\1/')
	make clean
	echo "VERSION IS $(VERSION)"
	git commit --all --message "Version $(VERSION)." || true
	git checkout main
	git reset template.pdf
	git pull
	git merge -m "Merge branch 'develop'" develop
	git tag -f -a "v$(VERSION)" -m "Version $(VERSION)."
	git push --all
	git push -f --tags
	git checkout develop
endef


run:
	@ eval "$$script"
