# NOVAthesis — latexmk configuration
#
# Adds the NOVAthesis internal style-files directory to TEXINPUTS so that
# \RequirePackage{options-ext} (and similar internal packages) are found by
# their short name rather than resolved to the full ./NOVAthesisFiles/StyFiles/
# path prefix.  Without this, LaTeX emits cosmetic "You have requested package
# X but the package provides X" warnings for the five NOVAthesis-internal
# packages loaded from nt-packages.sty.
$ENV{TEXINPUTS} = './NOVAthesisFiles/StyFiles:' . ($ENV{TEXINPUTS} // '');
