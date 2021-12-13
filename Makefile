SILENT = -silent

B = template
F = -time -shell-escape -synctex=1 $(FLAGS)
T = $(B).pdf
S = $(B).tex
L = latexmk $(F)
V = open -a skim

AUXFILES=$(shell ls $(B)*.* *.fls | fgrep -v .tex | fgrep -v $(B).pdf | sed 's: :\\ :g' | sed 's:(:\\(:g' | sed 's:):\\):g')


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

.PHONY: rc
rc:
	Scripts/latex-clean-temp.sh

.PHONY: rcb
rcb:
	Scripts/latex-clean-temp.sh
	rm -rf `biber -cache`
	biber -cache

school:
	Scripts/validate-schools.sh $S
