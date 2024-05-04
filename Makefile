#############################################################################
# CUSTOMIZATION AREA HERE
#############################################################################
# If you want to force the name of the main file, uncomment the following command
# MF:="YOUR_MAIN_TEX_FILE" # without the ".tex" extension

# Define V to the ommand to the name of your PDF viewer
V:=open -a skim



#############################################################################
# DO NOT TOUCH BELOW THIS POINT
#############################################################################

# If a file "tempalte.tex" is found, use it as the main file
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
SILENT:=-interaction=batchmode #-silent
SYNCTEX:=1
B:=$(MF)
T:=$(MF).pdf
S:=$(MF).tex

L:=latexmk $(F)
F:=-time -shell-escape -synctex=$(SYNCTEX) -output-format=pdf -file-line-error $(FLAGS)

# target and files to be incldued in "make zip"
ZIPFILES:=NOVAthesisFiles Bibliography Config Chapters LICENSE Makefile novathesis.cls README.md .gitignore template.tex
ZIPTARGET:=$(B)-$(VERSION)@$(DATE).zip

# extract version and date of the template
VERSION=$(shell head -1 NOVAthesisFiles/nt-version.sty | sed -e 's/.*{//' -e 's/\(.*\)./\1/')
DATE:=$(shell tail -1 NOVAthesisFiles/nt-version.sty | sed -e 's/.*{//' -e 's/\(.*\)./\1/' | tr '\n' '@'m| sed -e 's/\(.*\)./\1/')

# aux files
AUXFILES:=$(shell ls $(B)*.* | fgrep -v .tex | fgrep -v .pdf | sed 's: :\\ :g' | sed 's:(:\\(:g' | sed 's:):\\):g')

# schools requiring XeLaTeX or LuaLaTeX (incompatible with pdfLaTeX)
LUA="other/esep uminho/ea uminho/ec uminho/ed uminho/ee uminho/eeg uminho/elach uminho/em uminho/ep uminho/ese uminho/ics uminho/ie uminho/i3b"

# Extract school being built
SCHL=$(shell grep -v "^%" Config/1_novathesis.tex | grep "ntsetup{school=" | cut -d "=" -f 2 | cut -d "}" -f 1)
ifeq ($(SCHL),)
	SCHL=nova/fct
endif


.PHONY: default
default:
#	@$(shell if test -f Scripts/toc_readme.sh; then git status | fgrep README.md && (Scripts/toc_readme.sh; git add README.md; git commit -m 'Updated README.md'; fi))
	@echo SCHL=$(SCHL)
ifeq ($(findstring $(SCHL),$(LUA)),)
	make pdf
else
	make xe
endif


#############################################################################
# Main targets:  
# pdf/xe/lua		build with Tex-Live
# tl pdf/xe/lua	build with Tex-Live
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
	$(L) -pdf$(patsubst pdf%,%,$@) $(SILENT) $(B)
	@$(call times)

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
	@$(call times)

#————————————————————————————————————————————————————————————————————————————
.PHONY: zip
zip:
	rm -f "$(ZIPTARGET)"
	zip --exclude .github --exclude .git -r "$(ZIPTARGET)" $(ZIPFILES)


#————————————————————————————————————————————————————————————————————————————
.PHONY: clean
clean:
	@$(L) -c $(B)
	@rm -f $(AUXFILES) "*(1)*"
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
ifneq (, $(shell ls Scripts/publish.sh))	
	Scripts/publish.sh
endif

#————————————————————————————————————————————————————————————————————————————
.PHONY: bump1 bump2 bump3
bump1 bump2 bump3:
ifneq (, $(shell ls Scripts/newversion.sh))
	Scripts/newversion.sh $(subst bump,,$@)
	@$(call mtp)
endif



#————————————————————————————————————————————————————————————————————————————
.PHONY: time
time:
	@$(call times)

#############################################################################
# FUNCTIONS
#############################################################################
#————————————————————————————————————————————————————————————————————————————
ifneq (, $(findstring jml,${USER}))
define times
	@printf "TIMES FROM THE LAST EXECUTION\n"
	@declare TIMES="$(shell grep -e 'l3benchmark. + TOC'  *.log | cut -d ' ' -f 4)";\
	declare PHASES="$(shell fgrep TIME *.log | cut -d ' ' -f 2-3 | cut -d '=' -f 1 | tr ' ' '_')";\
	declare -a TM=($${TIMES});\
	declare -a PH=($${PHASES});\
	for i in `seq 0 $$(($${#TM[@]}-1))`; do\
	      printf "%20s = %6.2f\n" "$${PH[$$i]}" "$${TM[$$i]}";\
	done
endef
endif

# merge, tag and push
define mtp
	make clean
	git cam "Version $(VERSION)."
	git checkout main
	git pull
	git merge -m "Merge branch 'develop'" develop
	git tag -a "v$(VERSION)" -m "Version $(VERSION)."
	git push --all
	git push --tags
	git checkout develop
endef
