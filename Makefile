# --- Configuration ---
# Default compiler if none is specified
ENGINE ?= lualatex
LATEXMK_FLAG = -time

# Detect if texfot is installed to filter verbose output
TEXFOT := $(shell command -v texfot 2>/dev/null)

# --- Flag Setup ---
COMMON_FLAGS = -file-line-error -shell-escape -synctex=1 -recorder -output-directory=AUXDIR

# --- Root File Detection ---
ifeq ($(FILE),)
    TARGET_FILES := $(shell grep -lF "\\documentclass" *.tex 2>/dev/null)
    NUM_FILES    := $(words $(TARGET_FILES))
    ifneq ($(NUM_FILES),1)
        $(error Found $(NUM_FILES) .tex file(s) with \documentclass — set FILE=<name> explicitly)
    endif
    BASEFILE := $(basename $(TARGET_FILES))
else
    BASEFILE := $(basename $(FILE))
endif

# --- Public Targets & Short Aliases ---

.PHONY: all mkl mkll mkp mkpp lualatex latexmk-lua pdflatex latexmk-pdf clean

# Default target when you just type 'make'
all: mkll

# Short & Full aliases for LuaLaTeX
mkl: lualatex
lualatex: ENGINE = lualatex
lualatex: build

# Short & Full aliases for Latexmk + LuaLaTeX
mkll: latexmk-lua
latexmk-lua: ENGINE = latexmk
latexmk-lua: LATEXMK_FLAG += -pdflua
latexmk-lua: build

# Short & Full aliases for PDFLaTeX
mkp: pdflatex
pdflatex: ENGINE = pdflatex
pdflatex: build

# Short & Full aliases for Latexmk + PDFLaTeX
mkpp: latexmk-pdf
latexmk-pdf: ENGINE = latexmk
latexmk-pdf: LATEXMK_FLAG += -pdf
latexmk-pdf: build

# --- Core Build Logic ---
build:
	@mkdir -p AUXDIR
	@echo "Running: $(TEXFOT) $(ENGINE) $(LATEXMK_FLAG) $(COMMON_FLAGS) $(BASEFILE)"
	@$(TEXFOT) $(ENGINE) $(LATEXMK_FLAG) $(COMMON_FLAGS) $(BASEFILE).tex
	@cp -f AUXDIR/$(BASEFILE).pdf       $(BASEFILE).pdf       2>/dev/null || true
	@cp -f AUXDIR/$(BASEFILE).synctex.gz $(BASEFILE).synctex.gz 2>/dev/null || true

# --- Clean Target ---
clean:
	@echo "Cleaning up AUXDIR..."
	@rm -rf AUXDIR
	@rm -f $(BASEFILE).pdf $(BASEFILE).synctex.gz
