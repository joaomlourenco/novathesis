SILENT = -silent
SYNCTEX = 1

B = template
F = -time -shell-escape -synctex=$(SYNCTEX) $(FLAGS)
T = $(B).pdf
S = $(B).tex
L = latexmk $(F)
V = open -a skim

AUXFILES=$(shell ls $(B)*.* | fgrep -v .tex | fgrep -v $(B).pdf | sed 's: :\\ :g' | sed 's:(:\\(:g' | sed 's:):\\):g')


default: pdf

$(T): $(S)
	make

.PHONY: pdf
pdf: $(S)
	$(L) -pdf $(SILENT) $(B)

.PHONY: xe lua
xe lua: $(S)
	$(L) -pdf$@ $(SILENT) $(B)

.PHONY: v view
v view: $(T)
	$(V) $(T)

.PHONY: verb verbose
verb verbose:
	$(L) -pdf $(B)

.PHONY: 2019 2020
2019 2020 2021:
	PATH="/usr/local/texlive/$@/bin/x86_64-darwin/:$(PATH)" $(L) $(X) $(SILENT) $(B)

.PHONY: clean
clean:
	@$(L) -c $(B)
	@rm -f $(AUXFILES)

gclean:
	git clean -fdx -e Scripts -e Fonts

.PHONY: rc
rc:
	Scripts/latex-clean-temp.sh

.PHONY: rcb
rcb:
	Scripts/latex-clean-temp.sh
	rm -rf `biber -cache`
	biber -cache

.PHONY: publish
publish:
	Scripts/publish.sh

.PHONY: bump1 bump2 bump3
bump1:
	Scripts/newversion.sh 1
	make publish

bump2:
	Scripts/newversion.sh 2
	make publish

bump3:
	Scripts/newversion.sh 3
	make publish
