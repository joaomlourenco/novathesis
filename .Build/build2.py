#!/usr/bin/env python3
import argparse
import re
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Dict, Callable, List

# --- Pattern builders -------------------------------------------------

def build_patterns(new_school_id: str) -> Dict[str, Dict[re.Pattern, Callable[[str], str]]]:
    """Return filename -> {compiled_pattern: transformer}."""
    # helper: uncomment & replace key=value inside \ntsetup{...}
    def _uncomment_replace(key: str, value: str) -> Callable[[str], str]:
        # keep leading spaces but drop a leading '%' (with optional spaces)
        key_re = re.compile(rf"({key}\s*=\s*)[^}},]+", re.IGNORECASE)
        def _transform(line: str) -> str:
            orig = line
            # strip leading comment (but keep indentation)
            line = re.sub(r"^(\s*)%+\s*", r"\1", line)
            line = key_re.sub(rf"\1{value}", line)
            return line if line != orig else orig
        return _transform

    file_1_patterns = {
        # %   \ntsetup{school=...}
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*school\s*=\s*[^}]+\}\s*.*$"): _uncomment_replace("school", new_school_id),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*docstatus\s*=\s*[^}]+\}\s*.*$"): _uncomment_replace("docstatus", "final"),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*spine/layout\s*=\s*[^}]+\}\s*.*$"): _uncomment_replace("spine/layout", "trim"),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*spine/width\s*=\s*[^}]+\}\s*.*$"): _uncomment_replace("spine/width", "2cm"),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*print/index\s*=\s*[^}]+\}\s*.*$"): _uncomment_replace("print/index", "true"),
        # exact abstractorder line → just uncomment
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*abstractorder=\{en,pt,uk,gr\}\}\s*.*$"):
            lambda line: re.sub(r"^(\s*)%+\s*", r"\1", line),
    }

    file_4_patterns = {
        re.compile(r"^\s*%?\s*\\ntaddfile\{abstract\}\[gr\]\{abstract-gr\}\s*.*$"):
            lambda line: re.sub(r"^(\s*)%+\s*", r"\1", line),
        re.compile(r"^\s*%?\s*\\ntaddfile\{abstract\}\[uk\]\{abstract-uk\}\s*.*$"):
            lambda line: re.sub(r"^(\s*)%+\s*", r"\1", line),
    }

    return {
        "1_novathesis.tex": file_1_patterns,
        "4_files.tex": file_4_patterns,
    }

# --- Core helpers -----------------------------------------------------

def backup_file(p: Path) -> Path:
    bak = p.with_suffix(p.suffix + ".bak")
    shutil.copy2(p, bak)
    print(f"📦 Backup created: {bak.name}")
    return bak

def process_file(p: Path, patterns: Dict[re.Pattern, Callable[[str], str]], dry_run: bool=False) -> int:
    lines = p.read_text(encoding="utf-8").splitlines()
    changed = 0
    out_lines: List[str] = []

    for line in lines:
        new_line = line
        for pat, action in patterns.items():
            if pat.match(new_line):
                transformed = action(new_line)
                if transformed != new_line:
                    new_line = transformed
                    changed += 1
                break
        out_lines.append(new_line)

    if not dry_run and changed > 0:
        p.write_text("\n".join(out_lines) + "\n", encoding="utf-8")

    print(f"{'🔎 (dry-run) ' if dry_run else ''}✅ {p.name}: {changed} line(s) modified.")
    return changed

def run_make(target: str) -> int:
    print(f"🛠️  Running `make {target}` ...")
    try:
        subprocess.run(["make", target], check=True)
        print("✅ `make` completed successfully.")
        return 0
    except subprocess.CalledProcessError as e:
        print("❌ `make` failed.")
        return e.returncode

# --- CLI --------------------------------------------------------------

def main() -> None:
    ap = argparse.ArgumentParser(
        description="Uncomment/normalize specific ntsetup lines and run make, then restore originals."
    )
    ap.add_argument("school_id", help="School ID like 'nova/fct' (must contain '/')")
    ap.add_argument("--confdir", default="0-Config", help="Directory with LaTeX config files (default: 0-Config)")
    ap.add_argument("--target", default="lua", help="Make target to run (default: lua)")
    ap.add_argument("--dry-run", action="store_true", help="Show what would change without writing files or running make")
    args = ap.parse_args()

    if "/" not in args.school_id:
        print("❌ Error: The school ID must contain '/'. Example: nova/fct")
        sys.exit(2)

    confdir = Path(args.confdir)
    files = [confdir / "1_novathesis.tex", confdir / "4_files.tex"]
    for f in files:
        if not f.exists():
            print(f"❌ Error: File not found: {f}")
            sys.exit(1)

    patterns_by_file = build_patterns(args.school_id)

    backups: List[Path] = []
    changes_total = 0

    try:
        if not args.dry_run:
            backups = [backup_file(f) for f in files]

        for f in files:
            patterns = patterns_by_file.get(f.name, {})
            changes_total += process_file(f, patterns, dry_run=args.dry_run)

        if args.dry_run:
            print("ℹ️  Dry-run: skipping make and restore.")
            return

        if changes_total > 0:
            rc = run_make(args.target)
            # Regardless of rc, we restore originals to leave the tree clean
        else:
            print("ℹ️  No changes detected — skipping `make`.")
    finally:
        if backups:
            for f in files:
                bak = f.with_suffix(f.suffix + ".bak")
                if bak.exists():
                    print(f"♻️  Restoring '{f.name}' from '{bak.name}'")
                    shutil.move(bak, f)
            print("✅ Files restored.")

if __name__ == "__main__":
    main()
