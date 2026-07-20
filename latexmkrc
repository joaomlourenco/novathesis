# NOVAthesis — latexmkrc
# Perl configuration file, auto-loaded by latexmk from the project root.

# ── Auxiliary directory ───────────────────────────────────────────────────────
# Honour the AUXDIR env var exported by the Makefile; fall back to ./AUXDIR.
# Note: AUXDIR deletion (make clean) also removes the minted cache inside it.
$aux_dir = $ENV{AUXDIR} // './AUXDIR';

# ── TEXINPUTS: expose NOVAthesis internal packages to kpathsea ───────────────
# Adding StyFiles and Strings as explicit directories means kpathsea finds
# internal .sty/.ldf files by bare name (e.g. \RequirePackage{options-ext}).
# Without this, kpathsea falls back to the \input@path recursive search which
# resolves files with a path prefix, causing "requested X but provides Y"
# warnings because the prefix mismatches the \ProvidesPackage declaration.
$ENV{TEXINPUTS} = './NOVAthesisFiles/StyFiles/:./NOVAthesisFiles/Strings/:'
                . ($ENV{TEXINPUTS} // '');

# ── Dependency tracking ───────────────────────────────────────────────────────
$recorder = 1;

# ── Default engine: LuaLaTeX (recommended for NOVAthesis) ────────────────────
# 1=pdflatex  4=lualatex  5=xelatex
$pdf_mode = 4;

# ── Bibliography: biblatex + biber ───────────────────────────────────────────
$bibtex_use = 2;  # run biber; also delete .bbl on latexmk -C

# ── Glossaries: glossaries-extra + bib2gls (record mode) ────────────────
# bib2gls reads the .aux and writes the .glstex; no makeindex/xindy, and no
# \write registers consumed by the class.
add_cus_dep('aux', 'glstex', 0, 'run_bib2gls');

sub run_bib2gls {
    my ($base, $dir) = fileparse($_[0]);
    $dir =~ s{/\z}{};
    $dir = '.' if $dir eq '';
    return system('bib2gls', '-q', '--group', '-d', $dir, $base);
}

push @generated_exts, 'glstex', 'glg';
$clean_ext .= ' %R.ist %R.xdy';
