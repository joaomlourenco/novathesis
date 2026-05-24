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

# ── Glossaries: glossaries-extra + makeglossaries ────────────────────────────
add_cus_dep('glo', 'gls', 0, 'run_makeglossaries');
add_cus_dep('acn', 'acr', 0, 'run_makeglossaries');
add_cus_dep('slo', 'sls', 0, 'run_makeglossaries');
add_cus_dep('cho', 'chs', 0, 'run_makeglossaries');

sub run_makeglossaries {
    my ($base, $dir) = fileparse($_[0]);
    if ($^O =~ /MSWin/) {
        return system 'makeglossaries', '-q', '-d', $dir, $base;
    } else {
        return system "makeglossaries -q -d '$dir' '$base'";
    }
}

push @generated_exts, 'glo', 'gls', 'glg';
push @generated_exts, 'acn', 'acr', 'alg';
push @generated_exts, 'slo', 'sls', 'slg';
push @generated_exts, 'cho', 'chs', 'chg';
$clean_ext .= ' %R.ist %R.xdy';
