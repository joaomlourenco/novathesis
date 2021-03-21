B = template
F = -shell-escape
T = $(B).pdf
S = $(B).tex
L = latexmk $(F)
V = open -a skim

default: 2020

$(T): $(S)
	make

.PHONY: 2020
2020: $(S)
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
	
