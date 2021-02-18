B = template
T = $(B).pdf
S = $(B).tex
L = latexmk

PDFLATEX_SUFFIX = ""
XELATEX_SUFFIX = "xe"
LUALATEX_SUFFIX = "lua"

deafult: pdf

.PHONY: pdf
pdf: $(S)
	$(L) -pdf $(B)

xe: $(S)
	$(L) -pdfxe $(B)

lua: $(S)
	$(L) -pdflua $(B)

clean:
	$(L) -c $(B)

rc:
	Scripts/latex-clean-temp.sh
	