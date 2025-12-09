#!/usr/bin/env python3
"""
-----------------------------------------------------------------------------
NOVATHESIS Build Assistant

Version 7.8.0 (2025-12-09)
Copyright (C) 2004-25 by João M. Lourenço <joao.lourenco@fct.unl.pt>
-----------------------------------------------------------------------------

This script automates the process of building NOVATHESIS documents by:
1. Creating a temporary workspace with symlinks to the original project files
2. Localizing and modifying configuration files for specific school, document type, and language
3. Running the LaTeX build process in the temporary workspace
4. Copying the resulting PDF to an output directory
The script handles both cover-only builds and full document builds with appropriate
configuration adjustments.
"""
import argparse
import fcntl
import time
import os
import re
import shutil
import subprocess
import sys
import tempfile
import atexit
from pathlib import Path
from typing import Dict, Callable, List, Pattern

# --- ANSI Color Codes for Terminal Output ------------------------------------
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

# --- Pattern Builders -------------------------------------------------------
def build_patterns(new_doc_type: str, new_school_id: str, new_lang_code: str, 
                   mode: int, new_doc_status: str, new_sdgs_list: str, force: bool
                  ) -> dict[str, dict[Pattern, Callable[[str], str]]]:
    """
    Build regex patterns and transformation functions for configuration file processing.
    Args:
        new_doc_type: Document type (e.g., 'phd', 'msc', 'bsc')
        new_school_id: School identifier (e.g., 'nova/fct')
        new_lang_code: Language code (e.g., 'en', 'pt', 'uk', 'gr')
        new_doc_status: Document status (e.g., 'working', 'provisional', 'final', 'keep')
        demo: Whether to build demo version with all abstracts
    Returns:
        Dictionary mapping filenames to pattern-transformer dictionaries
    """
    def _uncomment_replace(key: str, value: str):
        """
        Create a transformer function that uncomments and replaces key-value pairs in \ntsetup{}.

        Works for:
            \ntsetup{key=value}
            \ntsetup{key={value}}

        If the original value is braced ({...}), the replacement will also be braced.
        """
        # Match "key = <value>", where <value> is either "{...}" or unbraced up to ',' or '}'.
        key_re = re.compile(
            rf"({re.escape(key)}\s*=\s*)"
            r"(\{[^}]*\}|[^,}]+)",
            re.IGNORECASE,
        )

        def _transform(line: str) -> str:
            orig = line
            # Uncomment while preserving indentation
            line = re.sub(r"^(\s*)%+\s*", r"\1", line)

            def repl(m: re.Match) -> str:
                prefix = m.group(1)
                old_val = m.group(2).strip()
                new_val = value.strip()

                # If the original value was braced, keep braces in the replacement
                if old_val.startswith("{") and old_val.endswith("}"):
                    new_val = new_val.strip("{}").strip()
                    return f"{prefix}{{{new_val}}}"
                else:
                    return f"{prefix}{new_val}"

            line = key_re.sub(repl, line)
            return line if line != orig else orig

        return _transform

    # Patterns for 1_novathesis.tex - core document configuration
    result = {}
    if force:
        file_1_patterns = {
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*school\s*=\s*[^}]+\}\s*.*$"):
                _uncomment_replace("school", new_school_id),
        }
        result |= {
            "1_novathesis.tex": file_1_patterns,
        }
    if new_doc_status != "keep":
        file_1_patterns = {
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*doctype\s*=\s*[^}]+\}\s*.*$"):
                _uncomment_replace("doctype", new_doc_type),
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*school\s*=\s*[^}]+\}\s*.*$"):
                _uncomment_replace("school", new_school_id),
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*lang\s*=\s*[^}]+\}\s*.*$"):
                _uncomment_replace("lang", new_lang_code),
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*spine/layout\s*=\s*[^}]+\}\s*.*$"):
                _uncomment_replace("spine/layout", "trim"),
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*spine/width\s*=\s*[^}]+\}\s*.*$"):
                _uncomment_replace("spine/width", "2cm"),
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*print/index\s*=\s*[^}]+\}\s*.*$"):
                _uncomment_replace("print/index", "true"),
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*docstatus\s*=\s*\{?[^}]+\}\s*.*$"):
                _uncomment_replace("docstatus", new_doc_status),
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*print/sdgs/list\s*=\s*\{?[^}]+\}\s*.*$"):
                _uncomment_replace("print/sdgs/list", new_sdgs_list),
            # re.compile(r"^\s*%?\s*\\ntsetup\{\s*abstractorder=\{en,pt,uk,gr\}\}\s*.*$"):
            #     lambda line: re.sub(r"^(\s*)%+\s*", r"\1", line),
        }
        result |= {
            "1_novathesis.tex": file_1_patterns,
        }

    if mode == 2: 
        # Cover only, remove contents
        file_1_patterns |= {
            re.compile(r"^\s*%?\s*\\ntsetup\{\s*print/copyright\s*=\s*[^}]+\}\s*.*$"):
                _uncomment_replace("print/copyright", "false"),
        }
        file_4_patterns = {
            re.compile(r"^\s*\\ntaddfile.*$"):
                lambda line: re.sub(r"^(\s*\\ntaddfile.*)", r"% \1", line),
        }
        file_6_patterns = {
            re.compile(r"^(?!\s*%).*$"):
                lambda line: re.sub(r"^(?!\s*%)(.*)$", r"% \1", line),
        }
        result |= {
            "4_files.tex": file_4_patterns,
            "6_list_of.tex": file_6_patterns,
        }
    else:
        if mode == 1:
            file_4_patterns = {
                re.compile(r"^\s*%?\s*\\ntaddfile\{abstract\}\[gr\]\{abstract-gr\}\s*.*$"):
                    lambda line: re.sub(r"^(\s*)%+\s*", r"\1", line),
                re.compile(r"^\s*%?\s*\\ntaddfile\{abstract\}\[uk\]\{abstract-uk\}\s*.*$"):
                    lambda line: re.sub(r"^(\s*)%+\s*", r"\1", line),
            }
            # result |= {
            #     "4_files.tex": file_4_patterns,
            # }
    return result

# --- Core Processing Functions ----------------------------------------------
def process_file(p: Path, patterns: Dict[re.Pattern, Callable[[str], str]]) -> int:
    """
    Process a file by applying pattern transformations.
    Args:
        p: Path to the file to process
        patterns: Dictionary of regex patterns and their transformation functions
    Returns:
        Number of lines that were changed
    """
    try:
        lines = p.read_text(encoding="utf-8").splitlines()
    except FileNotFoundError:
        print(f"{RED}❌ File not found: {p}{RESET}")
        return 0
    except UnicodeDecodeError:
        print(f"{RED}❌ Could not decode {p} as UTF-8{RESET}")
        return 0
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
    if changed > 0:
        try:
            p.write_text("\n".join(out_lines) + "\n", encoding="utf-8")
            print(f"{YELLOW}✅ modified {p.name} {changed} lines{RESET}")
        except Exception as e:
            print(f"{RED}❌ Failed to write {p}: {e}{RESET}")
    return changed
def _update_progress_bar(current_line: int, total_lines: int, bar_length: int = 37) -> None:
    """
    Update and display a progress bar based on the current line count.
    Args:
        current_line: Current line number being processed
        total_lines: Total expected lines for completion
        bar_length: Visual length of the progress bar in characters
    """
    progress = min(current_line / total_lines, 1.0)
    filled_length = int(bar_length * progress)
    bar = '█' * filled_length + '░' * (bar_length - filled_length)
    percentage = progress * 100
    # Use carriage return to overwrite the same line
    sys.stdout.write(f'\r{BRIGHT_CYAN}🔄 Progress: {BRIGHT_WHITE}|{bar}| {percentage:5.1f}% ({current_line}/{total_lines} lines){RESET}')
    sys.stdout.flush()
    
# --- Temporary Workspace Management -----------------------------------------
def _copytree_symlinking(src: Path, dst: Path, ignore=None) -> None:
    """
    Replicate directory tree from src to dst, creating symlinks for files.
    - The 'Scripts' directory is copied with all its contents preserved as-is,
      including existing symlinks.
    - Regular files in other directories are symlinked to their original locations.
    Args:
        src: Source directory path
        dst: Destination directory path
        ignore: Pattern for files to ignore (passed to shutil.copytree)
    """
    def _smart_copy(s: str, d: str, *, follow_symlinks=True):
        """Copy function that handles Scripts directory differently."""
        source_path = Path(s)
        if not source_path.exists():
            print(f"{YELLOW}⚠️  Source does not exist: {s}{RESET}")
            return d
        target_path = Path(d)
        target_path.parent.mkdir(parents=True, exist_ok=True)
        # Check if we're dealing with a file in the Scripts directory
        is_in_scripts = 'Scripts' in source_path.parts
        if is_in_scripts:
            # For Scripts directory: preserve existing symlinks as-is, copy regular files
            if source_path.is_symlink():
                # Preserve the original symlink
                link_target = source_path.readlink()
                try:
                    # Create a new symlink pointing to the same target
                    if link_target.is_absolute():
                        os.symlink(link_target, d)
                    else:
                        # For relative symlinks, we need to reconstruct the proper relative path
                        # from the new location in the temp directory
                        relative_target = os.path.relpath(
                            source_path.parent / link_target,
                            source_path.parent
                        )
                        os.symlink(relative_target, d)
                except FileExistsError:
                    pass
                except OSError as e:
                    print(f"{YELLOW}⚠️  Could not recreate symlink {s} → {d}: {e}{RESET}")
            else:
                # For regular files in Scripts, copy the actual content
                shutil.copy2(s, d)
        else:
            # For non-Scripts files: create symlinks to original files
            try:
                abs_s = os.path.abspath(s)
                os.symlink(abs_s, d)
            except FileExistsError:
                pass
            except OSError as e:
                print(f"{YELLOW}⚠️  Could not create symlink {s} → {d}: {e}{RESET}")
        return d
    # Original ignore patterns (build artifacts, etc.)
    original_ignore = ignore
    def _combined_ignore(path, names):
        """Combine original ignore patterns with our custom logic."""
        ignored = set()
        # Apply original ignore patterns if provided
        if original_ignore:
            ignored.update(original_ignore(path, names))
        return ignored
    if src == dst:
        print(f"{YELLOW}⚠️  Source and dest are the same: '{src}'.  No symlinking will be done.{RESET}")
    else:
        shutil.copytree(
            src,
            dst,
            dirs_exist_ok=True,
            copy_function=_smart_copy,
            ignore=_combined_ignore
        )

def prepare_temp_workspace(project_root: Path, build_dir: str) -> Path:
    """
    Create a temporary workspace with symlinks to project files.
    Args:
        project_root: Root directory of the NOVATHESIS project
    Returns:
        Path to the temporary workspace directory
    """
    if build_dir:
        tmpdir = Path(build_dir).resolve()
    else:
        tmpdir = Path(tempfile.mkdtemp(prefix="ntbuild-", dir="/tmp"))
    print(f"{CYAN}🧪 Temp workspace: {tmpdir}{RESET}")
    # Ignore build artifacts and version control files
    ignore = shutil.ignore_patterns(
        "*.aux", "*.log", "*.toc", "*.out", "*.fls", "*.fdb_latexmk",
        "*.synctex*", "*.bbl", "*.blg",
        ".git", ".gitignore", ".DS_Store", "AUXDIR"
    )
    _copytree_symlinking(project_root, tmpdir, ignore=ignore)
    return tmpdir

def restore_config_symlinks(tmp_root: Path, project_root: Path, confdir: Path) -> None:
    """
    Restore symlinks for configuration files that were customized (are real files and not symlinks).
    This is needed when reusing a temp-root folder in demo or cover modes.
    Args:
        tmp_root: Temporary workspace directory
        project_root: Original project root directory
        confdir: Configuration directory name
    """
    config_dir = tmp_root / confdir
    if not config_dir.exists():
        return
    
    # Get all files in the configuration directory
    for file_path in config_dir.iterdir():
        # Skip directories, only process files
        if not file_path.is_file():
            continue
            
        original_file = project_root / confdir / file_path.name
        
        # Only process if the file exists and is a real file (not a symlink)
        # and the original file exists in the project
        if (file_path.exists() and 
            file_path.is_file() and 
            not file_path.is_symlink() and
            original_file.exists()):
            try:
                # Remove the real file and create a symlink to the original
                file_path.unlink()
                file_path.symlink_to(original_file)
                print(f"{GREEN}🔗 Restored symlink for {file_path.name}{RESET}")
            except Exception as e:
                print(f"{YELLOW}⚠️  Could not restore symlink for {file_path.name}: {e}{RESET}")

def store_keep_dir(temp_root: Path) -> None:
    """
    Store the path of the temp directory in a cache file ".keep-dir".
    Args:
        temp_root: Path to the temporary directory to store
    """
    cache_file = Path(".keep-dir")
    try:
        cache_file.write_text(str(temp_root), encoding="utf-8")
        print(f"{GREEN}💾 Stored temp directory path in {cache_file}: {temp_root}{RESET}")
    except Exception as e:
        print(f"{YELLOW}⚠️  Could not write to {cache_file}: {e}{RESET}")

def read_keep_dir() -> Path | None:
    """
    Read the temp directory path from the ".keep-dir" cache file.
    Returns:
        Path to the temp directory if it exists and is valid, None otherwise
    """
    cache_file = Path(".keep-dir")
    if not cache_file.exists():
        return None
    
    try:
        temp_path = Path(cache_file.read_text(encoding="utf-8").strip())
        if temp_path.exists():
            return temp_path
        else:
            print(f"{YELLOW}⚠️  Cached temp directory does not exist: {temp_path}{RESET}")
            return None
    except Exception as e:
        print(f"{YELLOW}⚠️  Could not read or parse {cache_file}: {e}{RESET}")
        return None

def localize_and_process_files(tmp_root: Path, confdir: Path, patterns: dict[str, Dict[re.Pattern, Callable[[str], str]]]) -> bool:
    """
    Localize configuration files in temp workspace and apply transformations.
    Args:
        tmp_root: Root of temporary workspace
        confdir: Configuration directory name
        patterns: Pattern transformers for different files
    Returns:
        True if any files were modified, False otherwise
    """
    changed_any = False
    # Target configuration files to process
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
        changed = process_file(p, patterns.get(p.name, {}))
        changed_any = changed_any or (changed > 0)
    return changed_any
    
def safe_outname(school: str, doctype: str, lang: str) -> str:
    """
    Generate a safe filename for the output PDF.
    Args:
        school: School identifier
        doctype: Document type
        lang: Language code
    Returns:
        Safe filename string
    """
    school_safe = school.replace("/", "-").replace(" ", "_")
    doctype_safe = doctype.replace(" ", "_")
    lang_safe = lang.replace(" ", "_")
    return f"{school_safe}-{doctype_safe}-{lang_safe}.pdf"


class Cleanup:
     file = None
def remove_file():
    if Cleanup.file and os.path.exists(Cleanup.file):
        os.remove(Cleanup.file)


def run_make_in_temp(
    tmp_root: Path,
    ltxprocessor: str,
    school_id: str,
    doctype: str,
    lang: str,
    outdir: Path,
    progress: int = 1,
    total_lines: int = 4400,
    keep_bdir: bool = False,
    rename: bool = False,
) -> int:
    """
    Run make command in temporary workspace and handle output.
    Args:
        tmp_root:     Temporary workspace directory
        ltxprocessor: LaTeX processor to use (e.g., 'lua', 'pdf')
        school_id:    School identifier
        doctype:      Document type
        lang:         Language code
        outdir:       Output directory for final PDF
        progress:     Progress display mode (0: silent, 1: progress bar, 2: real-time output)
        total_lines:  Total expected lines of output for progress calculation
        keep_bdir:    Whether to keep the building dir
        rename:       Whether to rename the final PDF to 'univ-school-type-lang.pdf'
    Returns:
        Exit code from make process (0 for success)
    """

    print(f"{CYAN}📦 Intercepting 'biber'")

    # Track the wrapper so we can ALWAYS remove it (success, failure, Ctrl-C, etc.)
    wrapper_path: Path | None = None

    # ------------------------------------------------------------------
    # 1) Locate real biber
    # ------------------------------------------------------------------
    try:
        result = subprocess.run(
            ["which", "biber"],
            capture_output=True,
            text=True,
            check=True,
        )
        BIBER = result.stdout.strip()
        print(f"biber found: {BIBER}")
    except subprocess.CalledProcessError:
        BIBER = None
        print("biber not found")

    # ------------------------------------------------------------------
    # 2) Prepare environment and biber locking wrapper
    # ------------------------------------------------------------------
    env = os.environ.copy()

    if BIBER:
        lockfile_path = "/tmp/novathesis-biber.lock"
        wrapper_path = tmp_root / "biber"  # this will shadow the real 'biber'
        Cleanup.file = wrapper_path

        wrapper_code = f"""#!/usr/bin/env python3
import fcntl
import os
import subprocess
import sys

LOCKFILE = {lockfile_path!r}
REAL_BIBER = {BIBER!r}

def main():
    # Open (and create if needed) a lock file shared by all processes
    with open(LOCKFILE, "w") as lf:
        # Acquire exclusive lock (blocks until available)
        fcntl.flock(lf, fcntl.LOCK_EX)
        try:
            # Forward all arguments to the real biber
            rc = subprocess.call([REAL_BIBER] + sys.argv[1:])
        finally:
            # Explicit unlock (also happens automatically on close)
            fcntl.flock(lf, fcntl.LOCK_UN)
    sys.exit(rc)

if __name__ == "__main__":
    main()
"""

        wrapper_path.write_text(wrapper_code)
        wrapper_path.chmod(0o755)

        # Prepend tmp_root to PATH so our wrapper is found first
        env["PATH"] = f"{tmp_root}{os.pathsep}{env.get('PATH', '')}"
        print(f"{CYAN}🔒 biber calls will be serialized using {lockfile_path}{RESET}")
    else:
        print(f"{YELLOW}⚠️ biber not found; no locking wrapper installed{RESET}")

    # ------------------------------------------------------------------
    # 3) Run make (with env including our PATH override)
    #    and ALWAYS remove the wrapper on exit (finally)
    # ------------------------------------------------------------------
    try:
        print(f"{CYAN}📦 Running 'make {ltxprocessor}' in {tmp_root}{RESET}")
        start_time = time.perf_counter()
        try:
            if progress == 1:
                # Run with progress bar
                print(
                    f"{BRIGHT_CYAN}📊 Progress tracking enabled: "
                    f"expecting ~{total_lines} lines of output{RESET}"
                )
                proc = subprocess.Popen(
                    ["make", ltxprocessor],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    bufsize=1,  # Line buffered
                    universal_newlines=True,
                    cwd=tmp_root,
                    env=env,
                )
                line_count = 0
                important_lines = []

                # Read output line by line and update progress
                for line in proc.stdout:
                    line_count += 1
                    # Update progress bar
                    _update_progress_bar(line_count, total_lines)
                    # Collect important lines for display
                    if (
                        line.startswith("Run number")
                        or line.startswith("Running")
                        or line.startswith("Logging")
                        or line.startswith("Latexmk:")
                        or "error" in line.lower()
                        or "warning" in line.lower()
                    ):
                        important_lines.append(line)
                    n = sum(s.startswith("Running") for s in important_lines)
                    if n >= 6:
                        Path('.Build/.n_lines.txt').write_text(str(line_count))
                        

                # Wait for process to complete and get return code
                returncode = proc.wait()

                # Clear the progress bar line
                sys.stdout.write("\r" + " " * 100 + "\r")
                sys.stdout.flush()

                # Print collected important lines
                for line in important_lines:
                    print(line, end="")

            elif progress == 2:
                # Real-time output mode - print everything as it comes
                print(f"{BRIGHT_CYAN}📝 Real-time output mode{RESET}")
                proc = subprocess.Popen(
                    ["make", "verbose", ltxprocessor],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    bufsize=1,  # Line buffered
                    universal_newlines=True,
                    cwd=tmp_root,
                    env=env,
                )
                # Print output in real-time
                for line in proc.stdout:
                    print(line, end="")
                returncode = proc.wait()

            else:  # progress == 0 (silent mode)
                # Silent mode - only show errors and important messages
                print(
                    f"{BRIGHT_CYAN}🔇 Silent mode - showing only important messages{RESET}"
                )
                proc = subprocess.run(
                    ["make", ltxprocessor],
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                    text=True,
                    cwd=tmp_root,
                    env=env,
                )
                returncode = proc.returncode

                # Filter and print important lines
                for line in proc.stdout.splitlines():
                    if (
                        line.startswith("Run number")
                        or line.startswith("Running")
                        or line.startswith("Logging")
                        or line.startswith("Latexmk:")
                        or "error" in line.lower()
                        or "warning" in line.lower()
                    ):
                        print(line)

            end_time = time.perf_counter()
            elapsed = end_time - start_time

            if returncode == 0:
                print(
                    f"{CYAN}✅ 'make' succeeded in {RED}{elapsed:.2f}{CYAN} seconds{RESET}"
                )
                # Success → copy template.pdf to "{university-school-doctype-lang}.pdf"
                src_pdf = tmp_root / "template.pdf"
                if rename:
                    dest_pdf = outdir / safe_outname(school_id, doctype, lang)
                else:
                    dest_pdf = outdir / "template.pdf"

                if src_pdf != dest_pdf:
                    if src_pdf.exists():
                        outdir.mkdir(parents=True, exist_ok=True)
                        shutil.copy2(src_pdf, dest_pdf)
                        print(
                            f"{GREEN}✅ saved '{src_pdf.name}' to '{dest_pdf}'{RESET}"
                        )
                        # Only remove temp workspace if we created it temporarily
                        if "ntbuild-" in str(tmp_root) and not keep_bdir:
                            shutil.rmtree(tmp_root)
                            print(
                                f"{CYAN}🧪 Temp workspace removed: {tmp_root}{RESET}"
                            )
                        else:
                            print(
                                f"{YELLOW}📁 Preserving build directory: "
                                f"{tmp_root}{RESET}"
                            )
                    else:
                        print(f"{RED}❌ '{src_pdf}' missing{RESET}")
                    return 0
            else:
                print(f"{RED}❌ 'make' failed with exit code {returncode}{RESET}")
                print(
                    f"{YELLOW}🧪 Temp workspace kept for debugging: {tmp_root}{RESET}"
                )
                return returncode

        except subprocess.CalledProcessError as e:
            out = (
                e.stdout
                if hasattr(e, "stdout") and isinstance(e.stdout, str)
                else ""
            )
            print(out)
            print(f"{RED}❌ 'make' failed with exit code {e.returncode}{RESET}")
            print(
                f"{YELLOW}🧪 Temp workspace kept for debugging: {tmp_root}{RESET}"
            )
            return e.returncode

    finally:
        # ------------------------------------------------------------------
        # 4) ALWAYS remove the temporary 'biber' wrapper if it was created
        # ------------------------------------------------------------------
        if wrapper_path is not None:
            try:
                if wrapper_path.exists():
                    wrapper_path.unlink()
                    print(
                        f"{CYAN}🧹 Removed temporary biber wrapper: {wrapper_path}{RESET}"
                    )
            except Exception as e:
                # Best-effort cleanup; do not mask the original error/return code
                print(
                    f"{YELLOW}⚠️ Could not remove temporary biber wrapper "
                    f"{wrapper_path}: {e}{RESET}"
                )

# --- Command Line Interface -------------------------------------------------
def main() -> None:
    """Main entry point for the NOVATHESIS build assistant."""
    ap = argparse.ArgumentParser(
        description="NOVATHESIS Build Assistant: Replicate project to temporary workspace, "
                   "localize & edit config files, build, and copy PDF to output directory."
    )
    # Required arguments
    ap.add_argument(
        "school_id",
        help="School ID in format 'faculty/school' (e.g., 'nova/fct', 'nova/fct/cbbi')"
    )
    # Optional arguments
    ap.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose output for debugging"
    )
    ap.add_argument(
        "-f", "--force-school",
        action="store_true",
        help="Force applying the school to Config file"
    )
    ap.add_argument(
        "-t", "--doctype",
        default="phd",
        choices=["phd", "msc", "bsc"],
        help="Document type: 'phd', 'msc', 'bsc' (default: msc)"
    )
    ap.add_argument(
        "-s", "--docstatus",
        default="keep",
        choices=["working", "provisional", "final", "keep"],
        help="Document status: 'working', 'provisional', 'final', or 'keep' to leave unchanged (default: keep)"
    )
    ap.add_argument(
        "-l", "--lang",
        default="en",
        help="Two-letter language code for document (default: en)"
    )
    ap.add_argument(
        "--sdgs",
        default="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17",
        help="Two-letter language code for document (default: en)"
    )
    ap.add_argument(
        "-p", "--processor",
        default="lua",
        help="LaTeX processor to use with make (default: lua)"
    )
    ap.add_argument(
        "-k", "--keep-bdir",
        action="store_true",
        default=False,
        help="Keep build directory even in case of success (only relevant when using -bdir)"
    )
    # Progress argument as integer with three modes
    ap.add_argument(
        "--progress",
        type=int,
        choices=[0, 1, 2],
        default=1,
        help="Output mode: 0 (silent), 1 (progress bar), 2 (real-time output) (default: 1)"
    )
    ap.add_argument(
        "--lines",
        type=int,
        default=-1,
        help="Expected number of output lines for progress calculation (default: 4400)"
    )
    ap.add_argument(
        "-r", "--rename-pdf",
        action="store_true",
        default=False,
        help="Rename the PDF from 'template.pdf' to 'univ-school-type-lang.pdf' (default: False)"
    )
    # Mode selection - replaces user/demo/cover modes
    ap.add_argument(
        "-m", "--mode",
        type=int,
        choices=[0, 1, 2],
        default=0,
        help="Build mode: 0 (user), 1 (demo), 2 (cover) (default: 0)"
    )
    # Build directory with optional argument
    ap.add_argument(
        "-bdir", "--build-dir",
        nargs="?",
        const="",  # Empty string means create temp directory
        default=None,  # None means use current directory
        help="Build directory: if not present, use current directory; "
             "if present with no argument, create temp directory; "
             "if present with argument, use specified directory; "
             "if '-', use cached directory from .keep-dir file"
    )
    ap.add_argument(
        "-o", "--output-dir",
        default=".",
        help="Output directory for generated PDF (default: current directory)"
    )
    args = ap.parse_args()
    
    # Map mode to demo and cover_only flags
    demo = (args.mode == 1)
    cover_only = (args.mode == 2)
    
    # If demo mode is active, override status to "final"
    if demo:
        args.docstatus = "final"
        print(f"{BRIGHT_CYAN}🎯 Demo mode: setting docstatus to 'final'{RESET}")

    # Adjust expected lines
    lines = args.lines
    cache_file=".Build/.n_lines.txt"
    if lines == -1:
        lines = int(Path(cache_file).read_text()) if Path(cache_file).exists() else 3500
    
    # Adjust expected lines for cover-only mode
    if cover_only:
        lines = 2400
        print(f"{BRIGHT_CYAN}📔 Cover mode: building cover-only version{RESET}")
    
    # Force -bdir for demo and cover modes if -bdir was omitted
    if (demo or cover_only) and args.build_dir is None:
        args.build_dir = ""
        print(f"{BRIGHT_CYAN}🔧 Forcing temporary build directory for {'demo' if demo else 'cover'} mode{RESET}")
    
    # Validate school_id format
    def _normalize_school(s: str) -> str:
        # If it already contains a "/", return unchanged
        if "/" in s:
            return s
    
        # Replace at most two "-" with "/"
        parts = s.split("-", 2)  # allows at most 3 parts → at most 2 replacements
        return "/".join(parts)
    
    schl = _normalize_school(args.school_id)
    if "/" not in schl:
        print("❌ Error: The school ID must contain '/'. Example: nova/fct")
        sys.exit(2)
    
    # Validate language code format
    if not re.fullmatch(r"[a-z]{2}", args.lang): 
        print("❌ Error: --lang must be a two-letter code, e.g., en, pt, uk, gr")
        sys.exit(2)
    
    project_root = Path.cwd()
    
    # Handle build directory logic
    reusing_temp_dir = False
    if args.build_dir is None:
        # No -bdir option: use current directory (no copy, no symlinks)
        tmp_root = project_root
        print(f"{CYAN}📁 Using current directory as build directory: {tmp_root}{RESET}")
        # In this mode, we don't want to keep the build directory since it's the project root
        args.keep_bdir = False
    elif args.build_dir == "-":
        # Special case: -bdir - means use cached directory from .keep-dir file
        cached_temp_root = read_keep_dir()
        if cached_temp_root is None:
            # If .keep-dir doesn't exist or is invalid, proceed as if -bdir was given with no argument
            print(f"{YELLOW}⚠️  No cached temp directory found, creating new temp directory{RESET}")
            tmp_root = prepare_temp_workspace(project_root, None)
            # Store the new temp directory and assume --keep-bdir for future executions
            store_keep_dir(tmp_root)
            args.keep_bdir = True
            print(f"{BRIGHT_CYAN}🔧 Created new temp directory and stored for future use{RESET}")
        else:
            # Use the cached temp directory
            tmp_root = cached_temp_root
            reusing_temp_dir = True
            print(f"{CYAN}📁 Using cached temp directory: {tmp_root}{RESET}")
            # Implicitly set --keep-bdir when using cached directory
            args.keep_bdir = True
            print(f"{BRIGHT_CYAN}🔧 Implicitly setting --keep-bdir for cached directory{RESET}")
            
            # When reusing temp directory in demo or cover mode, restore symlinks for config files
            if (demo or cover_only) and tmp_root != project_root:
                print(f"{BRIGHT_CYAN}🔧 Restoring config file symlinks for reuse in {'demo' if demo else 'cover'} mode{RESET}")
                restore_config_symlinks(tmp_root, project_root, Path("0-Config"))
    elif args.build_dir == "":
        # -bdir with no argument: create temp directory (with symlinks)
        tmp_root = prepare_temp_workspace(project_root, None)
        # Store the temp directory path if keep_bdir is set
        if args.keep_bdir:
            store_keep_dir(tmp_root)
    else:
        # -bdir with argument: use specified directory (with symlinks)
        build_path = Path(args.build_dir).resolve()
        current_path = project_root.resolve()
        
        # Check if build directory is current directory or its direct ancestor
        if build_path == current_path.is_relative_to(build_path):
            print(f"{RED}❌ Build directory cannot be ancestor of current directoy {RESET}")
            sys.exit(1)
        
        tmp_root = prepare_temp_workspace(project_root, args.build_dir)
        # Store the temp directory path if keep_bdir is set
        if args.keep_bdir:
            store_keep_dir(tmp_root)
    
    # Validate configuration directory exists
    confdir_path = Path("0-Config")  # Fixed default as per requirements
    if not (project_root / confdir_path).exists():
        print(f"{RED}❌ Configuration directory not found: 0-Config{RESET}")
        sys.exit(1)
    
    # Validate or create output directory
    outdir_path = Path(args.output_dir)
    if not outdir_path.exists():
        try:
            outdir_path.mkdir(parents=True, exist_ok=True)
            print(f"{YELLOW}📁 Created output directory: {outdir_path}{RESET}")
        except Exception as e:
            print(f"{RED}❌ Could not create output directory {outdir_path}: {e}{RESET}")
            sys.exit(1)
    
    # Build regex patterns for demo and cover modes
    patterns = {}
    if demo or cover_only or args.force_school:
        patterns = build_patterns(args.doctype, schl, args.lang, args.mode, 
                                  args.docstatus, args.sdgs, args.force_school)
        match args.mode:
            case 0: mode_name = "user"
            case 1: mode_name = "demo"
            case 2: mode_name = "cover"
        print(f"{BRIGHT_CYAN}🎯 {mode_name.capitalize()} mode: configuration files will be modified{RESET}")
    else:
        print(f"{BRIGHT_CYAN}👤 User mode: configuration files will not be modified{RESET}")
    
    # Localize & process the target files inside the build tree
    changed_any = localize_and_process_files(
        tmp_root=tmp_root,
        confdir=confdir_path,
        patterns=patterns
    )
    
    # Run the build process
    outdir = (project_root / args.output_dir).resolve()
    rc = run_make_in_temp(
        tmp_root=tmp_root,
        ltxprocessor=args.processor,
        school_id=schl,
        doctype=args.doctype,
        lang=args.lang,
        outdir=outdir,
        progress=args.progress,
        total_lines=lines,
        keep_bdir=args.keep_bdir,
        rename=args.rename_pdf
    )
    
    if rc != 0:
        sys.exit(rc)

if __name__ == "__main__":
    main()