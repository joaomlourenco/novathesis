# novathesis — latexmkrc
# Perl configuration file, auto-loaded by latexmk from the project root.

# ── Auxiliary directory ───────────────────────────────────────────────────────
# Honour the AUXDIR env var exported by the Makefile; fall back to ./AUXDIR.
# Note: AUXDIR deletion (make clean) also removes the minted cache inside it.
$aux_dir = $ENV{AUXDIR} // './AUXDIR';

# ── TEXINPUTS: expose novathesis internal packages to kpathsea ───────────────
# Adding StyFiles and Strings as explicit directories means kpathsea finds
# internal .sty/.ldf files by bare name (e.g. \RequirePackage{options-ext}).
# Without this, kpathsea falls back to the \input@path recursive search which
# resolves files with a path prefix, causing "requested X but provides Y"
# warnings because the prefix mismatches the \ProvidesPackage declaration.
$ENV{TEXINPUTS} = './novathesisFiles/StyFiles/:./novathesisFiles/Strings/:'
                . ($ENV{TEXINPUTS} // '');

# ── Dependency tracking ───────────────────────────────────────────────────────
$recorder = 1;

# ── Default engine: LuaLaTeX (recommended for novathesis) ────────────────────
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
    my $ret = system('bib2gls', '-q', '--group', '-d', $dir, $base);
    return $ret if $ret;

    # bib2gls runs as an external process, outside latexmk's -recorder
    # tracking, so latexmk has no idea it read e.g. 1-FrontMatter/acronyms.bib
    # -- without this, editing a .bib source doesn't retrigger a rebuild,
    # since the 'aux -> glstex' dependency above only reruns bib2gls when the
    # .aux itself changes. Parsing bib2gls's own .glg log for "Reading ..."
    # lines and registering them via rdb_ensure_file is the fix documented in
    # latexmk's bundled example_rcfiles/bib2gls_latexmkrc.
    my $glg = "$_[0].glg";
    if (open(my $glg_fh, '<', $glg)) {
        rdb_add_generated($glg);
        while (<$glg_fh>) {
            s/\s*$//;
            if (/^Reading\s+(.+)$/) { rdb_ensure_file($rule, $1); }
            if (/^Writing\s+(.+)$/) { rdb_add_generated($1); }
        }
        close $glg_fh;
    }
    else {
        warn "run_bib2gls: cannot read log file '$glg': $!\n";
    }
    return $ret;
}

# Deliberately NOT listing 'glstex' here (only 'glg'): @generated_exts tells
# latexmk "a diff in this file, since the last run, is expected noise from
# regeneration, not a signal that something needs rebuilding" -- exactly
# backwards from what we want for .glstex, whose content changing (because
# bib2gls picked up an edited .bib entry) is precisely the signal that
# lualatex needs to rerun to pick up the new text. Cleanup is unaffected:
# `make clean` blanket-wipes AUXDIR's contents regardless of this list.
push @generated_exts, 'glg';
$clean_ext .= ' %R.ist %R.xdy %R.glstex %R-*.glstex';
