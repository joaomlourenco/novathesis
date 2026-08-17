#!/usr/bin/env python3
"""Check that every localized string store has the entries each language needs.

novathesis's translated UI strings live behind the `memstore` key-value system
(novathesisFiles/StyFiles/memstore.sty): novathesisFiles/Strings/strings-declare.tex
declares a store per name (\\NewMemStore{X}), and each
novathesisFiles/Strings/strings-<lang>.ldf then supplies \\Set<X>(<key>)={...}
entries for that store. Missing a *specific key* that memstore looks up at
build time is a hard, non-expandable "unknown key" error ("Compilation
cannot proceed"), not a silent typo -- worth catching before someone builds
a thesis in a language nobody has exercised in a while.

Scope: only the "global" stores declared in strings-declare.tex are checked
against every strings-<lang>.ldf file. School-specific memstores (declared in
novathesisFiles/Schools/**/*.clo, e.g. uminho's \\NewMemStore{OfStr}) are
intentionally out of scope -- those are only ever used in the one or two
languages that particular school supports, so "must exist in every language"
does not apply to them.

Two of the sixteen languages -- zhs/zht (Simplified/Traditional Chinese) --
are deliberately partial: novathesis does not translate the whole template
into Chinese, only enough to typeset a Chinese-language ABSTRACT alongside a
thesis whose main matter is in another language (see \\@ntprintabstract in
nt-render-matter.sty). Tracing every store actually used on that code path
shows only two are required with no fallback:
    - KeywordsString (the "Keywords:" label under an abstract)
    - BkmString      (the "Abstract" chapter-heading bookmark text)
A third store, SdgString, is also referenced there, but nt-render-matter.sty's
\\ntprintsdgs already guards that lookup with \\IfMemVoidTF and falls back to
the English heading when the abstract's language lacks one -- by design, per
its own comment. So PARTIAL_LANGUAGES below lists only the two truly-required
stores; treat it as a live cross-reference to \\@ntprintabstract /
\\printabstracttitle / \\keywords in nt-render-matter.sty, not a number to
tune by trial and error. If that code ever starts using another store
per-abstract-language without a void-guard, add it here too.

Usage: check-strings.py [repo-root]      (default: current directory)
Exit status is 0 if every check passes, 1 otherwise.
"""

import re
import sys
from pathlib import Path

PARTIAL_LANGUAGES = {
    "zhs": {"KeywordsString", "BkmString"},
    "zht": {"KeywordsString", "BkmString"},
}

STORE_RE = re.compile(r'\\NewMemStore\{([^}]+)\}')
SETTER_RE = re.compile(r'^\s*\\Set([A-Z][A-Za-z]*)[*(]')


def strip_comment(line):
    """Remove a trailing TeX comment (an unescaped %) from one line."""
    out = []
    escaped = False
    for ch in line:
        if ch == '%' and not escaped:
            break
        out.append(ch)
        escaped = (ch == '\\') and not escaped
    return ''.join(out)


def parse_declared_stores(declare_file):
    """Return (ordered unique store names, duplicate names) from strings-declare.tex."""
    seen = []
    duplicates = []
    with open(declare_file, encoding="utf-8") as f:
        for line in f:
            m = STORE_RE.search(strip_comment(line))
            if not m:
                continue
            name = m.group(1)
            (duplicates if name in seen else seen).append(name)
    return seen, duplicates


def parse_setter_stores(lang_file):
    """Return the set of store names with >=1 \\Set<Name> entry in this file."""
    stores = set()
    with open(lang_file, encoding="utf-8") as f:
        for line in f:
            m = SETTER_RE.match(strip_comment(line))
            if m:
                stores.add(m.group(1))
    return stores


def check_strings(repo_root):
    """Run the check and print a report. Return True if everything is complete."""
    strings_dir = repo_root / "novathesisFiles" / "Strings"
    declare_file = strings_dir / "strings-declare.tex"
    color = sys.stdout.isatty()

    def c(code, text):
        return f"\033[{code}m{text}\033[0m" if color else text

    if not declare_file.exists():
        print(f"check-strings: cannot find {declare_file}")
        return False

    declared_stores, duplicates = parse_declared_stores(declare_file)
    for name in duplicates:
        print(c(93, f"warning: \\NewMemStore{{{name}}} is declared more than "
                     f"once in {declare_file.name}; treating as one store"))

    if not declared_stores:
        print(c(93, f"warning: no \\NewMemStore declarations found in {declare_file}"))
        return True

    lang_files = sorted(strings_dir.glob("strings-*.ldf"))
    if not lang_files:
        print(c(93, f"warning: no strings-*.ldf files found in {strings_dir}"))
        return True

    print(f"\n{c(1, 'String Key Completeness Check')}")
    print(c(96, f"Declared stores ({len(declared_stores)}): "
                f"{', '.join(declared_stores)}") + "\n")

    gaps = []  # (store, lang)
    for lang_file in lang_files:
        lang = lang_file.stem.replace("strings-", "")
        present = parse_setter_stores(lang_file)
        required = PARTIAL_LANGUAGES.get(lang, set(declared_stores))
        missing = [s for s in declared_stores if s in required and s not in present]

        if missing:
            gaps.extend((s, lang) for s in missing)
            print(f"  {c(93, f'[{lang}]')} missing: {c(91, ', '.join(missing))}")
        elif lang in PARTIAL_LANGUAGES:
            print(f"  {c(92, f'[{lang}]')} partial support (abstract-only): "
                  f"{len(required)}/{len(required)} required store(s) present")
        else:
            print(f"  {c(92, f'[{lang}]')} all {len(declared_stores)} stores present")

    print()
    if gaps:
        n_langs = len({lang for _, lang in gaps})
        print(c('1;91', f"Found {len(gaps)} gap(s) across {n_langs} language(s)."))
        return False

    print(c('1;92', "All string stores are complete."))
    return True


def main(argv):
    if len(argv) > 2:
        print(__doc__)
        return 2
    repo_root = Path(argv[1]).resolve() if len(argv) == 2 else Path.cwd()
    return 0 if check_strings(repo_root) else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
