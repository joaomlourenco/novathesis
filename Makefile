B = template
F = -shell-escape -synctex=1
T = $(B).pdf
S = $(B).tex
L = latexmk $(F)
V = open -a skim

default: pdf

$(T): $(S)
	make

.PHONY: pdf
pdf: $(S)
	$(L) -pdf -silent $(B)

.PHONY: verb verbose
verb verbose:
	$(L) -pdf $(B)

.PHONY: 2019
2019:
	PATH="/usr/local/texlive/2019/bin/x86_64-darwin/:$(PATH)" $(L) -pdf -silent $(B)

.PHONY: xe
xe: $(S)
	$(L) -pdfxe -silent $(B)

.PHONY: lua
lua: $(S)
	$(L) -pdflua -silent $(B)

.PHONY: v
.PHONY: view
v view: $(T)
	$(V) $(T)

.PHONY: clean
clean:
	$(L) -c $(B)

.PHONY: rc
rc:
	Scripts/latex-clean-temp.sh


.PHONY: rcb
rcb:
	Scripts/latex-clean-temp.sh
	rm -rf `biber -cache`
	biber -cache

