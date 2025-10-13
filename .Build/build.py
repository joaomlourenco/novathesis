#!/usr/bin/env python3
import re
import shutil
import sys
import subprocess
from pathlib import Path

CONFDIR="0-Config"

# --- Global map of filename → pattern set ---
PATTERN_MAP = {
    # Original rules for 1_novathesis.tex
    "1_novathesis.tex": lambda new_school_id: {
        # Replace any doctype=... with doctype=phd and uncomment
        # r"%?\s*\\ntsetup\{doctype=[^}]+\}.*": lambda line: re.sub(
        #     r"^%?\s*", "", re.sub(r"doctype=[^}]+", "doctype=phd", line)
        # ),
        # Replace any school=... with school=ARGUMENT and uncomment
        r"%?\s*\\ntsetup\{school=[^}]+\}.*": lambda line: re.sub(
            r"^%?\s*", "", re.sub(r"school=[^}]+", f"school={new_school_id}", line)
        ),
        # Replace any docstatus=... with docstatus=final and uncomment
        r"%?\s*\\ntsetup\{docstatus=[^}]+\}.*": lambda line: re.sub(
            r"^%?\s*", "", re.sub(r"docstatus=[^}]+", "docstatus=final", line)
        ),
        # Replace any spine/layout=... with spine/layout=trim and uncomment
        r"%?\s*\\ntsetup\{spine/layout=[^}]+\}.*": lambda line: re.sub(
            r"^%?\s*", "", re.sub(r"spine/layout=[^}]+", "spine/layout=trim", line)
        ),
        # Replace any spine/width=... with spine/width=2cm and uncomment
        r"%?\s*\\ntsetup\{spine/width=[^}]+\}.*": lambda line: re.sub(
            r"^%?\s*", "", re.sub(r"spine/width=[^}]+", "spine/width=2cm", line)
        ),
        # Replace any print/index=... with print/index=true and uncomment
        r"%?\s*\\ntsetup\{print/index=[^}]+\}.*": lambda line: re.sub(
            r"^%?\s*", "", re.sub(r"print/index=[^}]+", "print/index=true", line)
        ),
        # Uncomment abstractorder={en,pt,uk,gr}
        r"%?\s*\\ntsetup\{abstractorder=\{en,pt,uk,gr\}\}.*": lambda line: re.sub(r"^%?\s*", "", line),
    },
    "4_files.tex": lambda _new_school_id: {
        # Uncomment: % \ntaddfile{abstract}[gr]{abstract-gr}
        r"%?\s*\\ntaddfile\{abstract\}\[gr\]\{abstract-gr\}.*": lambda line: re.sub(r"^%?\s*", "", line),
        # Uncomment: % \ntaddfile{abstract}[uk]{abstract-uk}
        r"%?\s*\\ntaddfile\{abstract\}\[uk\]\{abstract-uk\}.*": lambda line: re.sub(r"^%?\s*", "", line),
    },
}


def prepare_file(filepath_str: str) -> Path:
    """
    Ensure the given file exists and create a backup copy.
    Returns a Path object to the validated file.
    """
    filepath_str = CONFDIR + "/" + filepath_str
    filepath = Path(filepath_str)
    if not filepath.exists():
        print(f"❌ Error: File '{filepath}' not found.")
        sys.exit(1)

    backup_path = filepath.with_suffix(filepath.suffix + ".bak")
    shutil.copy(filepath, backup_path)
    print(f"📦 Backup created: {backup_path.name}")
    return filepath


def process_file(filepath: Path, new_school_id: str) -> int:
    """
    Reads, updates, and writes back the LaTeX file.
    Returns the number of modified lines.
    """
    filename = filepath.name
    if filename not in PATTERN_MAP:
        print(f"⚠️  No pattern set defined for '{filename}'. No changes made.")
        return 0

    patterns = PATTERN_MAP[filename](new_school_id)

    lines = filepath.read_text(encoding="utf-8").splitlines()
    new_lines = []
    changes = 0

    for line in lines:
        for pattern, action in patterns.items():
            if re.match(pattern, line):
                line = action(line)
                changes += 1
                break
        new_lines.append(line)

    filepath.write_text("\n".join(new_lines), encoding="utf-8")
    print(f"✅ Updated '{filename}' — {changes} lines modified.")
    return changes


def run_make_and_revert(filepaths: list[Path]) -> None:
    """
    Runs `make` and then reverts the file from .bak copy.
    """
    print("🛠️  Running `make`lua ...")
    try:
        subprocess.run(["make", "lua"], check=True)
        print("✅ `make` completed successfully.")
    except subprocess.CalledProcessError:
        print("❌ `make` failed. The file will still be reverted.")
    
    for p in filepaths:
        backup_path = p.with_suffix(p.suffix + ".bak")
        print(f"♻️  Reverting changes in '{p}' from backup file '{backup_path}'")
        shutil.move(backup_path, p)
        print(f"✅ Reverted '{p.name}' to original state.")
        # print(f"♻️  Reverting changes in '{p.name}' using git checkout...")
        # try:
        #     subprocess.run(["git", "checkout", "--", str(p)], check=True)
        #     print(f"✅ Reverted '{p.name}' to original state.")
        # except subprocess.CalledProcessError:
        #     print("⚠️  Warning: Failed to revert file via git. Please check manually.")


def main():
    if len(sys.argv) != 2:
        print("Usage: python uncomment_ntsetup.py <new_school_id>")
        sys.exit(1)

    # get school name
    new_school_id = sys.argv[1]

    # --- Enforce that the school ID contains a "/" ---
    if "/" not in new_school_id:
        print("❌ Error: The school ID must contain at least one '/'. Example: nova/fct")
        sys.exit(1)

    # Process 1_novathesis.tex
    filepath1 = prepare_file("1_novathesis.tex")
    changes1 = process_file(filepath1, new_school_id)

    # Process 4_files.tex
    filepath4 = prepare_file("4_files.tex")
    changes4 = process_file(filepath4, new_school_id)

    # Only call make + revert if something was changed
    if changes1 + changes4 >= 0:
        run_make_and_revert([filepath1, filepath4])
    else:
        print("ℹ️  No changes detected — skipping `make` and revert.")

if __name__ == "__main__":
    main()
