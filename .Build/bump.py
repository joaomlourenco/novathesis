#!/usr/bin/env python3
# update_headers.py — NOVATHESIS Version Updater (with colors and optional -b)

from __future__ import annotations

import argparse
import os
import stat
import re
import sys
from dataclasses import dataclass
from datetime import date
from pathlib import Path
from typing import List, Tuple, Optional

# ---------- Coloring ----------
class Color:
    RESET  = "\033[0m"
    BOLD   = "\033[1m"
    CYAN   = "\033[36m"
    YELLOW = "\033[33m"
    GREEN  = "\033[32m"
    RED    = "\033[31m"

def supports_color() -> bool:
    return sys.stdout.isatty()

USE_COLOR = supports_color()

def paint(text: str, color: str) -> str:
    if not USE_COLOR:
        return text
    return f"{color}{text}{Color.RESET}"

def after_colon(label: str, value: str, color: str = Color.YELLOW) -> str:
    """Format 'Label: value' with the value colored."""
    return f"{label}: {paint(value, color)}"

# ---------- Files/Paths ----------
ROOT = Path(".")
VERSION_FILE = ROOT / "novathesisFiles" / "StyFiles" / "nt-version.sty"

_STYFILES_DIR = ROOT / "novathesisFiles" / "StyFiles"
_STYFILES = sorted(
    list(_STYFILES_DIR.glob("*.sty")) + list(_STYFILES_DIR.glob("*.tex"))
)

TARGET_FILES = [
    ROOT / "Makefile",
    ROOT / "Makefile.dev",
    ROOT / "README.md",
    ROOT / "LLM.md",
    ROOT / "novathesis.cls",
    ROOT / "template.tex",
    ROOT / ".Build" / "nt-variant.sh",
    ROOT / "AGENTS.md",
    ROOT / ".github" / "copilot-instructions.md",
    ROOT / "CITATION.cff",
] + _STYFILES \
  + sorted((ROOT / "2-MainMatter").glob("*.tex")) \
  + sorted((ROOT / "3-BackMatter").glob("*.tex"))

# ---------- Regex Patterns ----------
VER_LINE = re.compile(
    r'^(?P<prefix>[ \t#%]*)'
    r'(?P<label>Version[ \t]+)'
    r'(?P<ver>(?:V\.V\.V|[0-9]+(?:\.[0-9]+)*))'
    r'[ \t]*\('
    r'(?P<date>(?:YYYY-MM-DD|YYY-MM-DD|[0-9]{4}-[0-9]{2}-[0-9]{2}))'
    r'\)'
    r'(?P<suffix>.*)',   # preserve any trailing content on the line
    re.MULTILINE,
)

CR_LINE = re.compile(
    r'^(?P<prefix>[ \t#%]*)'
    r'Copyright[ \t]*\([cC]\)[ \t]*'
    r'(?P<start>\d{4})-(?P<end>\d{2}|BB)'
    r'(?P<trail>[ \t]+by[ \t]+João[ \t]+M\.\s+Lourenço[ \t]*<joao\.lourenco@fct\.unl\.pt>)',
    re.MULTILINE,
)

PROVIDES = re.compile(
    r'(\\ProvidesClass\{novathesis\}\[.*Version\s+)' # Group 1: Prefix up to "Version "
    r'(?:V\.V\.V|[0-9]+(?:\.[0-9]+)*)\s*\('           # Version and open paren
    r'(?:YYYY-MM-DD|YYY-MM-DD|[0-9]{4}-[0-9]{2}-[0-9]{2})\)' # Date and close paren
    r'(.*\])'                                         # Group 2: Suffix (e.g. " template class file]")
)

# CITATION.cff's "version" and "date-released" YAML fields. Specific enough
# (quoted values, exact field names) that it never false-matches anything in
# the other target files, so it can just be added to the generic scan below.
CFF_VERSION_LINE = re.compile(
    r'^(?P<prefix>version:\s*")'
    r'(?:[0-9]+(?:\.[0-9]+)*)'
    r'(?P<suffix>")',
    re.MULTILINE,
)

CFF_DATE_LINE = re.compile(
    r'^(?P<prefix>date-released:\s*")'
    r'(?:[0-9]{4}-[0-9]{2}-[0-9]{2})'
    r'(?P<suffix>")',
    re.MULTILINE,
)

# ---------- Data ----------
@dataclass
class Change:
    line_no: int
    old: str
    new: str
    kind: str       # 'version', 'copyright', 'provides'
    style: str      # '#', '%', 'plain', 'provides'

# ---------- Logic ----------
def extract_version_and_date(path: Path) -> Tuple[str, str]:
    txt = path.read_text(encoding="utf-8")
    vm = re.search(r'\\newcommand\*\{\\novathesisversion\}\{([0-9]+(?:\.[0-9]+)*)\}', txt)
    dm = re.search(r'\\newcommand\*\{\\novathesisdate\}\{([0-9]{4}-[0-9]{2}-[0-9]{2})\}', txt)
    if not vm or not dm:
        raise SystemExit(f"ERROR: Could not parse VERSION/DATE from {path}")
    return vm.group(1), dm.group(1)

def bump_version(ver: str, pos: int) -> str:
    parts = [int(x) for x in ver.split('.')]
    if pos < 1 or pos > len(parts):
        return ver
    idx = len(parts) - pos
    parts[idx] += 1
    for i in range(idx + 1, len(parts)):
        parts[i] = 0
    return '.'.join(str(x) for x in parts)

def style_from_prefix(prefix: str, kind: str) -> str:
    if kind == 'provides':
        return 'provides'
    prefix = prefix.lstrip()
    if prefix.startswith('#'):
        return '#'
    if prefix.startswith('%'):
        return '%'
    return 'plain'

def process_file(content: str, version: str, date_str: str, newyy: str) -> Tuple[str, List[Change]]:
    lines = content.splitlines(keepends=False)
    changes: List[Change] = []

    # Version lines
    for i, line in enumerate(lines):
        m = VER_LINE.match(line)
        if not m:
            continue
        new_line = f"{m.group('prefix')}{m.group('label')}{version} ({date_str}){m.group('suffix')}"
        if new_line != line:
            changes.append(Change(
                line_no=i+1, old=line, new=new_line,
                kind='version', style=style_from_prefix(m.group('prefix'), 'version')
            ))
            lines[i] = new_line

    # Copyright lines
    for i, line in enumerate(lines):
        m = CR_LINE.match(line)
        if not m:
            continue
        new_line = (
            f"{m.group('prefix')}Copyright (C) "
            f"{m.group('start')}-{newyy}{m.group('trail')}"
        )
        if new_line != line:
            changes.append(Change(
                line_no=i+1, old=line, new=new_line,
                kind='copyright', style=style_from_prefix(m.group('prefix'), 'copyright')
            ))
            lines[i] = new_line

    # \ProvidesClass lines
    for i, line in enumerate(lines):
        pm = PROVIDES.search(line)
        if not pm:
            continue
        new_line = f"{pm.group(1)}{version} ({date_str}){pm.group(2)}"
        if new_line != line:
            changes.append(Change(
                line_no=i+1, old=line, new=new_line,
                kind='provides', style='provides'
            ))
            lines[i] = new_line

    # CITATION.cff: version: "X.Y.Z"
    for i, line in enumerate(lines):
        m = CFF_VERSION_LINE.match(line)
        if not m:
            continue
        new_line = f"{m.group('prefix')}{version}{m.group('suffix')}"
        if new_line != line:
            changes.append(Change(
                line_no=i+1, old=line, new=new_line,
                kind='cff', style='cff'
            ))
            lines[i] = new_line

    # CITATION.cff: date-released: "YYYY-MM-DD"
    for i, line in enumerate(lines):
        m = CFF_DATE_LINE.match(line)
        if not m:
            continue
        new_line = f"{m.group('prefix')}{date_str}{m.group('suffix')}"
        if new_line != line:
            changes.append(Change(
                line_no=i+1, old=line, new=new_line,
                kind='cff', style='cff'
            ))
            lines[i] = new_line

    return "\n".join(lines) + ("\n" if content.endswith("\n") else ""), changes

def update_nt_version_sty(old_ver: str, old_date: str, new_ver: str, new_date: str, dry_run: bool) -> None:
    text = VERSION_FILE.read_text(encoding="utf-8")
    new_text = re.sub(
        r'(\\newcommand\*\{\\novathesisversion\}\{)([0-9]+(?:\.[0-9]+)*)(\})',
        rf'\g<1>{new_ver}\3',
        text
    )
    new_text = re.sub(
        r'(\\newcommand\*\{\\novathesisdate\}\{)([0-9]{4}-[0-9]{2}-[0-9]{2})(\})',
        rf'\g<1>{new_date}\3',
        new_text
    )

    print("📦 Bumping nt-version.sty:")
    print(f"   • {after_colon('Version', f'{old_ver} → {new_ver}')}")
    print(f"   • {after_colon('Date',    f'{old_date} → {new_date}')}")
    if dry_run:
        print(paint("   🚧 DRY RUN: nt-version.sty would be updated", Color.CYAN))
    else:
        tmp = VERSION_FILE.with_suffix(VERSION_FILE.suffix + ".tmp___")
        tmp.write_text(new_text, encoding="utf-8")
        os.replace(tmp, VERSION_FILE)
        print(paint("   ✅ Updated nt-version.sty", Color.GREEN))

# ---------- CLI ----------
def main() -> None:
    ap = argparse.ArgumentParser(description="NOVATHESIS Version Updater")
    ap.add_argument("-n", "--dry-run", action="store_true", help="Preview changes without modifying files")
    # -b optional with optional argument → const=3, nargs='?', default=None
    ap.add_argument(
        "-b", "--bump",
        nargs="?", const=3, type=int, choices=[0, 1, 2, 3],
        help="Optionally bump version component (0=no bump, 1=patch, 2=minor, 3=major). If present without value, defaults to 3."
    )
    args = ap.parse_args()

    if not VERSION_FILE.exists():
        raise SystemExit(f"ERROR: {VERSION_FILE} not found.")

    # Read current version/date
    cur_version, cur_date = extract_version_and_date(VERSION_FILE)
    bump_value: Optional[int] = args.bump

    # Determine version/date to use
    if bump_value is not None:
        new_version = bump_version(cur_version, bump_value)
        new_date = date.today().isoformat()
    else:
        new_version, new_date = cur_version, cur_date

    # Header
    print("NOVATHESIS Version Updater")
    if args.dry_run:
        print(paint("🚧 DRY RUN MODE - No files will be modified", Color.CYAN))
    print("=" * 50)
    print(after_colon("📦 Current Version", cur_version))
    print(after_colon("📅 Current Date", cur_date))
    if bump_value is not None:
        print(after_colon("🧩 Bump component", str(bump_value)))
        print(after_colon("➡️  New Version", new_version))
        print(after_colon("➡️  New Date", new_date))

    # Update nt-version.sty if bumping
    if bump_value is not None:
        update_nt_version_sty(cur_version, cur_date, new_version, new_date, args.dry_run)

    # Values to propagate
    version = new_version
    date_str = new_date
    newyy = date_str[2:4]  # last two digits of year

    total_would_update = 0
    total_updated = 0

    for fpath in TARGET_FILES:
        print(f"🔍 Processing {fpath.name}...")
        if not fpath.exists():
            print(paint(f"   ⚠️  Missing file: {fpath.name}", Color.RED))
            continue

        original = fpath.read_text(encoding="utf-8")
        updated, changes = process_file(original, version, date_str, newyy)

        if not changes:
            print(f"   ℹ️  {paint(f'No patterns found in {fpath.name}', Color.CYAN)}")
            continue

        print("   📄 Matched lines:")
        for ch in changes:
            print(f"        {paint(f'{ch.line_no}: {ch.old}', Color.CYAN)}")
            print(f"        {paint(f'{ch.line_no}→ {ch.new}', Color.YELLOW)}")

        kinds = {c.kind for c in changes}
        styles = {c.style for c in changes if c.style in ('#', '%', 'plain')}
        bullets: List[str] = []
        if '#' in styles:
            bullets.append("Updated Markdown comment block (# style)")
        if '%' in styles:
            bullets.append("Updated TeX comment block (%% style)")
        if 'plain' in styles:
            bullets.append("Updated plain header line")
        if 'provides' in {c.style for c in changes}:
            bullets.append("Updated \\ProvidesClass header")
        if 'version' in kinds:
            bullets.append("Updated version/date")
        if 'copyright' in kinds:
            bullets.append("Updated copyright year")
        if 'cff' in kinds:
            bullets.append("Updated CITATION.cff version/date-released")

        if args.dry_run:
            total_would_update += 1
            print(paint(f"   ✅ Would update {fpath.name}:", Color.GREEN))
            for b in bullets:
                print(f"      • {b}")
        else:
            # Create temporary file for atomic write
            tmp = fpath.with_suffix(fpath.suffix + ".tmp___")
            # Preserve original file permissions
            st = os.stat(fpath)
            orig_mode = stat.S_IMODE(st.st_mode)
            # Write the temp file
            tmp.write_text(updated, encoding="utf-8")
            # Apply original permissions before atomic replacement
            os.chmod(tmp, orig_mode)
            # Atomic swap
            os.replace(tmp, fpath)
            total_updated += 1
            print(paint(f"   ✅ Updated {fpath.name}:", Color.GREEN))
            for b in bullets:
                print(f"      • {b}")
        
    print("=" * 50)
    if args.dry_run:
        print(paint(f"🚧 DRY RUN: Would update {total_would_update} file(s)", Color.CYAN))
    else:
        print(paint(f"✅ Updated {total_updated} file(s)", Color.GREEN))

if __name__ == "__main__":
    main()
