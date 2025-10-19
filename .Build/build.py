#!/usr/bin/env python3

import argparse
import time
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Dict, Callable, List

# --- Colors -------------------------------------------------
RESET = "\033[0m"

# Regular text colors
BLACK   = "\033[30m"
RED     = "\033[31m"
GREEN   = "\033[32m"
YELLOW  = "\033[33m"
BLUE    = "\033[34m"
MAGENTA = "\033[35m"
CYAN    = "\033[36m"
WHITE   = "\033[37m"

# Bright text colors
BRIGHT_BLACK   = "\033[90m"
BRIGHT_RED     = "\033[91m"
BRIGHT_GREEN   = "\033[92m"
BRIGHT_YELLOW  = "\033[93m"
BRIGHT_BLUE    = "\033[94m"
BRIGHT_MAGENTA = "\033[95m"
BRIGHT_CYAN    = "\033[96m"
BRIGHT_WHITE   = "\033[97m"

# --- Pattern builders -------------------------------------------------

def build_patterns(new_doc_type: str, new_school_id: str, new_lang_code: str, cover_only: bool) -> dict[str, dict[re.Pattern, Callable[[str], str]]]:
    """Return filename -> {compiled_pattern: transformer}."""
    # helper: uncomment & replace key=value inside \ntsetup{...}
    def _uncomment_replace(key: str, value: str):
        # Escape key in case it contains regex metacharacters like '/'
        key_re = re.compile(rf"({re.escape(key)}\s*=\s*)[^}},]+", re.IGNORECASE)

        def _transform(line: str) -> str:
            orig = line
            # Uncomment while preserving indentation
            line = re.sub(r"^(\s*)%+\s*", r"\1", line)
            # Use a callable to avoid '\1' + digit turning into '\12'
            line = key_re.sub(lambda m: m.group(1) + value, line)
            return line if line != orig else orig

        return _transform

    file_1_patterns = {
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*doctype\s*=\s*[^}]+\}\s*.*$"): 
            _uncomment_replace("doctype", new_doc_type),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*school\s*=\s*[^}]+\}\s*.*$"): 
            _uncomment_replace("school", new_school_id),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*lang\s*=\s*[^}]+\}\s*.*$"): 
            _uncomment_replace("lang", new_lang_code),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*docstatus\s*=\s*[^}]+\}\s*.*$"): 
            _uncomment_replace("docstatus", "final"),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*spine/layout\s*=\s*[^}]+\}\s*.*$"): 
            _uncomment_replace("spine/layout", "trim"),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*spine/width\s*=\s*[^}]+\}\s*.*$"): 
            _uncomment_replace("spine/width", "2cm"),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*print/index\s*=\s*[^}]+\}\s*.*$"): 
            _uncomment_replace("print/index", "true"),
        re.compile(r"^\s*%?\s*\\ntsetup\{\s*abstractorder=\{en,pt,uk,gr\}\}\s*.*$"):
            lambda line: re.sub(r"^(\s*)%+\s*", r"\1", line),
    }
    
    result = {
        "1_novathesis.tex": file_1_patterns,
    }
    
    if cover_only:
        # In the cover_only branch
        file_1_patterns |= {
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*print/copyright\s*=\s*[^}]+\}\s*.*$"): 
                _uncomment_replace("print/copyright", "false"),
        }
        file_4_patterns = {
            re.compile(r"^\s*\\ntaddfile.*$"):
                lambda line: re.sub(r"^(\s*\\ntaddfile.*)", r"% \1", line),
        }
        file_6_patterns = {
            # Match any line that does NOT start with optional spaces followed by '%'
            re.compile(r"^(?!\s*%).*$"):
                # Prepend '% ' to those lines
                lambda line: re.sub(r"^(?!\s*%)(.*)$", r"% \1", line),
        }
        result |= {
            "4_files.tex": file_4_patterns,
            "6_list_of.tex": file_6_patterns,
        }
    else:
        # conver and contents
        file_4_patterns = {
            re.compile(r"^\s*%?\s*\\ntaddfile\{abstract\}\[gr\]\{abstract-gr\}\s*.*$"):
                lambda line: re.sub(r"^(\s*)%+\s*", r"\1", line),
            re.compile(r"^\s*%?\s*\\ntaddfile\{abstract\}\[uk\]\{abstract-uk\}\s*.*$"):
                lambda line: re.sub(r"^(\s*)%+\s*", r"\1", line),
        }
        result |= {
            "4_files.tex": file_4_patterns,
        }
    return result

# --- Core helpers -----------------------------------------------------

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
        print(f"{YELLOW}✅ modified {p.name} {changed} lines{RESET}")
    return changed

def _print_filtered(stream_text: str) -> None:
    for line in stream_text.splitlines():
        if line.startswith("Run number") or line.startswith("Running") or line.startswith("Logging"):
            print(line)

# --- New: temp mirror & build ----------------------------------------

def _copytree_symlinking(src: Path, dst: Path, ignore=None) -> None:
    """
    Replicate directory tree from src to dst, creating symlinks for files.
    """
    def _symlink_copy(s: str, d: str, *, follow_symlinks=True):
        Path(d).parent.mkdir(parents=True, exist_ok=True)
        try:
            os.symlink(s, d)
        except FileExistsError:
            pass
        return d

    shutil.copytree(
        src,
        dst,
        dirs_exist_ok=True,
        copy_function=_symlink_copy,
        ignore=ignore
    )

def prepare_temp_workspace(project_root: Path) -> Path:
    tmpdir = Path(tempfile.mkdtemp(prefix="ntbuild-", dir="/tmp"))
    print(f"{CYAN}🧪 Temp workspace: {tmpdir}{RESET}")

    ignore = shutil.ignore_patterns(
        "*.aux", "*.log", "*.toc", "*.out", "*.fls", "*.fdb_latexmk",
        "*.synctex*", "*.bbl", "*.blg",
        ".git", ".gitignore", ".DS_Store", "AUXDIR"
    )
    _copytree_symlinking(project_root, tmpdir, ignore=ignore)
    return tmpdir

def localize_and_process_files(tmp_root: Path, confdir: Path, patterns: dict[str, Dict[re.Pattern, Callable[[str], str]]], dry_run: bool) -> bool:
    """
    In the TEMP tree: for each target file
      - if it's a symlink, make a local copy, remove the symlink, rename local copy to original name
      - process the local file with regex transforms
    Returns True if any file had changes.
    """
    changed_any = False
    # Paths in the temp tree
    targets = [tmp_root / confdir / "1_novathesis.tex", tmp_root / confdir / "4_files.tex", tmp_root / confdir / "6_list_of.tex"]

    for p in targets:
        if not p.exists():
            continue

        # If it's a symlink, replace it with a local copy
        if p.is_symlink():
            resolved = p.resolve()
            tmp_local = p.with_suffix(p.suffix + ".localcopy")
            # Create a real file copy side-by-side
            shutil.copy2(resolved, tmp_local)
            # Remove the symlink and move the local copy into place
            p.unlink()
            tmp_local.rename(p)
            print(f"{YELLOW}🔗→📄 localized '{p.name}' (replaced symlink with real file){RESET}")

        # Now p is a real file in the temp tree — process it
        changed = process_file(p, patterns.get(p.name, {}), dry_run=dry_run)
        changed_any = changed_any or (changed > 0)

    return changed_any

def safe_outname(school: str, doctype: str, lang: str) -> str:
    """Return a safe output filename for the given parameters."""
    school_safe = school.replace("/", "-").replace(" ", "_")
    doctype_safe = doctype.replace(" ", "_")
    lang_safe = lang.replace(" ", "_")
    return f"{school_safe}-{doctype_safe}-{lang_safe}.pdf"

def run_make_in_temp(tmp_root: Path, ltxprocessor: str, school_id: str, doctype: str, lang: str, outdir: Path) -> int:
    print(f"{CYAN}📦 Running 'make {ltxprocessor}' in {tmp_root}{RESET}")
    start_time = time.perf_counter()
    try:
        proc = subprocess.run(
            ["make", ltxprocessor],
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            cwd=tmp_root
        )
        end_time = time.perf_counter()
        elapsed = end_time - start_time
        # _print_filtered(proc.stdout)
        print(f"{CYAN}✅ 'make' succeeded in {RED}{elapsed:.2f}{YELLOW} seconds{RESET}")

        # Success → copy template.pdf to "{school-doctype-lang}.pdf"
        src_pdf = tmp_root / "template.pdf"
        dest_pdf = outdir / safe_outname(school_id, doctype, lang)
        if src_pdf.exists():
            outdir.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src_pdf, dest_pdf)
            print(f"{YELLOW}✅ saved '{src_pdf.name}' to '{dest_pdf}'{RESET}")
            shutil.rmtree(tmp_root)
            print(f"{CYAN}🧪 Temp workspace removed: {tmp_root}{RESET}")
        else:
            print(f"{ref}❌ '{src_pdf}' missing{RESET}")
        return 0
    except subprocess.CalledProcessError as e:
        out = e.stdout if hasattr(e, "stdout") and isinstance(e.stdout, str) else ""
        print(out)
        print("❌ 'make' failed")
        print(f"{RED}🧪 Temp workspace kept: {tmp_root}{RESET}")
        return e.returncode

# --- CLI --------------------------------------------------------------

def main() -> None:
    ap = argparse.ArgumentParser(
        description="Replicate project to /tmp (symlinks), localize & edit config files there, build, then copy PDF to output directory."
    )

    ap.add_argument(
        "school_id",
        help="School ID like 'nova/fct' or 'nova/fct/cbbi' (must contain '/')"
    )

    ap.add_argument(
        "--confdir",
        default="0-Config",
        help="Directory with LaTeX config files (default: 0-Config)"
    )

    ap.add_argument(
        "-p", "--processor",
        default="lua",
        help="Select the LaTeX 'processor' (default: lua)"
    )

    ap.add_argument(
        "-n", "--dry-run",
        action="store_true",
        help="Show what would change without writing files or running make"
    )

    ap.add_argument(
        "-l", "--lang",
        default="en",
        help="Two-letter language code to set in \\ntsetup{lang=...} (default: en)"
    )

    ap.add_argument(
        "-d", "--doctype",
        default="msc",
        help="The document type, usually 'phd' or 'msc', and sometimes 'bsc' (default: msc)"
    )

    ap.add_argument(
        "-c", "--cover-only",
        action="store_true",
        default=False,
        help="Builds an empty document, just with the covers (deafult: False)"
    )
    
    ap.add_argument(
        "-b", "--build-directory",
        default=None,
        help="Directory where to build the project (default: /tmp/ntbuild-…)"
    )
    
    ap.add_argument(
        "-o", "--output-directory",
        default=".",
        help="Directory to receive the resulting PDF (default: project root)"
    )

    args = ap.parse_args()

    if "/" not in args.school_id:
        print("❌ Error: The school ID must contain '/'. Example: nova/fct")
        sys.exit(2)

    # (Left as-is from your original, though it checks school_id format while the error message mentions --lang)
    if not re.fullmatch(r"(?!/)(?:[^/\s]+(?:/[^/\s]+)*)", args.school_id):
        print("❌ Error: --lang must be a two-letter code, e.g., en, pt, uk, gr")
        sys.exit(2)

    project_root = Path.cwd()
    tmp_root = prepare_temp_workspace(project_root) if not args.build_directory else Path(args.build_directory)

    # Build regex patterns using CLI args
    patterns = build_patterns(args.doctype, args.school_id, args.lang, args.cover_only)

    # Localize & process the target files inside the TEMP tree
    changed_any = localize_and_process_files(
        tmp_root=tmp_root,
        confdir=Path(args.confdir),
        patterns=patterns,
        dry_run=args.dry_run
    )

    if args.dry_run:
        print("ℹ️  Dry-run: skipping make.")
        return

    if changed_any:
        outdir = (project_root / args.output_directory).resolve()
        rc = run_make_in_temp(
            tmp_root=tmp_root,
            ltxprocessor=args.processor,
            school_id=args.school_id,
            doctype=args.doctype,
            lang=args.lang,
            outdir=outdir
        )
        if rc != 0:
            sys.exit(rc)
    else:
        print("ℹ️  No changes detected — still building in temp (in case previous artifacts differ).")
        outdir = (project_root / args.output_directory).resolve()
        rc = run_make_in_temp(
            tmp_root=tmp_root,
            ltxprocessor=args.processor,
            school_id=args.school_id,
            doctype=args.doctype,
            lang=args.lang,
            outdir=outdir
        )
        if rc != 0:
            sys.exit(rc)

if __name__ == "__main__":
    main()
