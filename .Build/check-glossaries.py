#!/usr/bin/env python3
"""Verify the glossaries of a built NOVAthesis document.

A build can succeed, produce the right page count, and still be wrong: with
bib2gls the 'selection' resource option decides which entries are included, so
a mistake there silently drops entries instead of leaving a visible '??'.  Both
regressions seen during the bib2gls migration -- an entry vanishing, and an
entry sorting to the wrong place -- were invisible to exit codes and page
counts.  This script closes that gap.

Checks, per \\GlsXtrLoadResources recorded in the .aux:

  1. every resource produced a .glstex with at least one entry;
  2. for selection={all}, the entries in the .glstex are exactly the entries
     in the source .bib files -- nothing dropped, nothing conjured;
  3. entries appear in non-decreasing sort-key order.

Check 3 deliberately does not try to reproduce bib2gls's ICU collation.  It
compares accent-stripped casefolded keys, and skips entries whose sort key
cannot be predicted (no explicit 'sort' and a name containing TeX markup),
so it flags real reordering without failing on locale subtleties.

Usage: check-glossaries.py <auxdir> <jobname> <root>
Exit status is 0 if every check passes, 1 otherwise.
"""

import re
import sys
import unicodedata
from pathlib import Path

RESOURCE_RE = re.compile(r"\\glsxtr@resource\{(.*)\}\{([^{}]*)\}\s*$")
OPT_RE = re.compile(r"(\w[\w-]*)=\{(.*?)\}\s*,", re.DOTALL)
GLSTEX_ENTRY_RE = re.compile(r"\\bibglsnew[a-z]*\{([^}]*)\}")
BIB_ENTRY_RE = re.compile(r"^@(\w+)\s*\{\s*([^,\s]+)\s*,", re.MULTILINE)


def sort_key(text):
    """Accent-stripped, casefolded key for order comparison."""
    decomposed = unicodedata.normalize("NFKD", text)
    return "".join(c for c in decomposed if not unicodedata.combining(c)).casefold()


def parse_bib(path):
    """Return {label: sort key or None} for one .bib file."""
    text = path.read_text(encoding="utf-8", errors="replace")
    entries = {}
    positions = [(m.start(), m.group(2)) for m in BIB_ENTRY_RE.finditer(text)]
    for index, (start, label) in enumerate(positions):
        end = positions[index + 1][0] if index + 1 < len(positions) else len(text)
        body = text[start:end]
        explicit = re.search(r"\bsort\s*=\s*\{(.*?)\}", body, re.DOTALL)
        if explicit:
            entries[label] = explicit.group(1).strip()
            continue
        name = re.search(r"\bname\s*=\s*\{(.*?)\}", body, re.DOTALL)
        # No explicit sort and a name carrying TeX markup: bib2gls interprets
        # it, and we will not guess.  None means "skip in the order check".
        if name and "\\" not in name.group(1):
            entries[label] = name.group(1).strip()
        elif name:
            entries[label] = None
        else:
            entries[label] = label
    return entries


def parse_resources(aux_path):
    """Return [(options dict, glstex basename)] from the .aux."""
    resources = []
    for line in aux_path.read_text(encoding="utf-8", errors="replace").splitlines():
        match = RESOURCE_RE.match(line.strip())
        if not match:
            continue
        raw, basename = match.group(1), match.group(2)
        opts = {k: v for k, v in OPT_RE.findall(raw if raw.rstrip().endswith(",") else raw + ",")}
        resources.append((opts, basename))
    return resources


def main():
    if len(sys.argv) != 4:
        sys.exit(__doc__)
    auxdir, job, root = Path(sys.argv[1]), sys.argv[2], Path(sys.argv[3])

    aux_path = auxdir / f"{job}.aux"
    if not aux_path.exists():
        print(f"    glossary check: no {aux_path}, skipped")
        return 0

    resources = parse_resources(aux_path)
    if not resources:
        print("    glossary check: no bib2gls resources recorded, skipped")
        return 0

    problems = []
    for opts, basename in resources:
        glstex = auxdir / f"{basename}.glstex"
        if not glstex.exists():
            problems.append(f"{basename}.glstex was never written")
            continue

        found = GLSTEX_ENTRY_RE.findall(
            glstex.read_text(encoding="utf-8", errors="replace"))
        if not found:
            problems.append(f"{basename}.glstex defines no entries")
            continue

        expected = {}
        for src in (s.strip() for s in opts.get("src", "").split(",") if s.strip()):
            bib = root / f"{src}.bib"
            if not bib.exists():
                problems.append(f"source {src}.bib not found")
                continue
            expected.update(parse_bib(bib))

        # 2. selection={all} must include every source entry, and only those.
        if opts.get("selection", "").strip() == "all" and expected:
            missing = sorted(set(expected) - set(found))
            extra = sorted(set(found) - set(expected))
            if missing:
                problems.append(
                    f"{basename}: {len(missing)} entry/entries dropped despite "
                    f"selection=all: {', '.join(missing)}")
            if extra:
                problems.append(
                    f"{basename}: unexpected entries: {', '.join(extra)}")

        # 3. sort-key order.
        checkable = [(label, expected[label]) for label in found
                     if expected.get(label)]
        for (prev_label, prev_key), (label, key) in zip(checkable, checkable[1:]):
            if sort_key(key) < sort_key(prev_key):
                problems.append(
                    f"{basename}: '{label}' (sort={key}) appears after "
                    f"'{prev_label}' (sort={prev_key}) -- list is out of order")
                break

    if problems:
        for problem in problems:
            print(f"    glossary check FAILED: {problem}")
        return 1

    total = sum(len(GLSTEX_ENTRY_RE.findall(
        (auxdir / f"{b}.glstex").read_text(encoding="utf-8", errors="replace")))
        for _, b in resources if (auxdir / f"{b}.glstex").exists())
    print(f"    glossary check ok ({total} entries across "
          f"{len(resources)} resource(s))")
    return 0


if __name__ == "__main__":
    sys.exit(main())
