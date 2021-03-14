B = template
T = $(B).pdf
S = $(B).tex
L = latexmk -shell-escape

deafult: 2020

.PHONY: 2020
2020: $(S)
	$(L) -pdf $(B)

2019:
	PATH="/usr/local/texlive/2019/bin/x86_64-darwin/:$(PATH)" $(L) -pdf $(B)

xe: $(S)
	$(L) -pdfxe $(B)

lua: $(S)
	$(L) -pdflua $(B)

clean:
	$(L) -c $(B)

rc:
	Scripts/latex-clean-temp.sh
	
