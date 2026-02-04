#!/usr/bin/env python3
"""
-----------------------------------------------------------------------------
NOVATHESIS Build Assistant

Version 7.10.0 (2026-02-04)
Copyright (C) 2004-26 by João M. Lourenço <joao.lourenco@fct.unl.pt>
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
import atexit
import fcntl
import time
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from typing import Dict, Callable, List, Pattern, Optional

# --- CONSTANTS --------------------------------------------------------------
DEFAULT_LINE_COUNT = 4400
COVER_LINE_COUNT = 2400
PROGRESS_BAR_WIDTH = 37
CACHE_DIR = Path(".") / ".Build"
CACHE_FILE = CACHE_DIR / ".keep-dir.txt"
LINE_COUNT_CACHE = CACHE_DIR / ".keep-lines.txt"

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

# --- Output Helpers ---------------------------------------------------------
def print_error(msg: str) -> None:
    """Print error message in red."""
    print(f"{RED}✗ {msg}{RESET}")

def print_success(msg: str) -> None:
    """Print success message in green."""
    print(f"{GREEN}✓ {msg}{RESET}")

def print_info(msg: str) -> None:
    """Print info message in cyan."""
    print(f"{CYAN}ℹ {msg}{RESET}")

def print_warning(msg: str) -> None:
    """Print warning message in yellow."""
    print(f"{YELLOW}⚠ {msg}{RESET}")

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
        mode: Build mode (0: user, 1: demo, 2: cover)
        new_sdgs_list: SDG list
        force: Force school application
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
        # Escape special regex characters in the key (e.g., spine/layout -> spine\/layout)
        escaped_key = re.escape(key)
        
        # Match "key = <value>", where <value> is either "{...}" or unbraced up to ',' or '}'.
        key_re = re.compile(
            rf"({escaped_key}\s*=\s*)"
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
        print_error(f"File not found: {p}")
        print_warning(f"  Expected location: {p.absolute()}")
        return 0
    except UnicodeDecodeError:
        print_error(f"Could not decode {p} as UTF-8")
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
            print_error(f"Failed to write {p}: {e}")
    return changed

def _update_progress_bar(current_line: int, total_lines: int, bar_length: int = PROGRESS_BAR_WIDTH) -> None:
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
    sys.stdout.write(f'\r{BRIGHT_CYAN}📄 Progress: {BRIGHT_WHITE}|{bar}| {percentage:5.1f}% ({current_line}/{total_lines} lines){RESET}')
    sys.stdout.flush()

def get_highest_degree_from_conf(target_school: str, conf_filename: str = "schools.conf") -> Optional[str]:
    """
    Parses schools.conf to find the highest degree for a given school.
    Priority: phd > msc > bsc
    """
    priority = ["phd", "msc", "bsc"]
    conf_path = Path(".") / ".Build" / conf_filename
    
    if not conf_path.exists():
        print_error(f"Configuration file {conf_filename} not found.")
        return None

    with conf_path.open("r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            # Skip comments and empty lines
            if not line or line.startswith("#") or line.startswith("["):
                continue
            
            # Match school name and the degree list within brackets
            # Example: nova/fct [phd, msc] [en,pt]
            match = re.match(r"^([\w/-]+)\s+\[(.*?)\]", line)
            if match:
                school, degrees_str = match.groups()
                if school == target_school:
                    # Convert "[phd, msc]" to a list of strings
                    available_degrees = [d.strip() for d in degrees_str.split(",")]
                    # Return the first one that matches our priority list
                    for p in priority:
                        if p in available_degrees:
                            return p
    return None
    
# --- Symlink Helpers --------------------------------------------------------
def _copy_scripts_directory(src: Path, dst: Path) -> None:
    """
    Copy Scripts directory preserving symlinks and regular files.
    
    Args:
        src: Source path (file or directory)
        dst: Destination path
    """
    if src.is_symlink():
        # Preserve the original symlink
        link_target = src.readlink()
        try:
            if link_target.is_absolute():
                os.symlink(link_target, dst)
            else:
                # For relative symlinks, reconstruct proper relative path
                relative_target = os.path.relpath(
                    src.parent / link_target,
                    src.parent
                )
                os.symlink(relative_target, dst)
        except FileExistsError:
            pass
        except OSError as e:
            print_warning(f"Could not recreate symlink {src} → {dst}: {e}")
    else:
        # For regular files in Scripts, copy the actual content
        shutil.copy2(src, dst)

def _create_symlink_to_original(src: Path, dst: Path) -> None:
    """
    Create symlink from dst to src (absolute path).
    
    Args:
        src: Source file path
        dst: Destination symlink path
    """
    try:
        abs_src = os.path.abspath(src)
        os.symlink(abs_src, dst)
    except FileExistsError:
        pass
    except OSError as e:
        print_warning(f"Could not create symlink {src} → {dst}: {e}")
        # Fallback to copying on Windows or if symlinks fail
        try:
            shutil.copy2(src, dst)
            print_warning(f"  Fell back to file copy instead of symlink")
        except Exception as copy_err:
            print_error(f"  Copy fallback also failed: {copy_err}")

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
            print_warning(f"Source does not exist: {s}")
            return d
        
        target_path = Path(d)
        target_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Check if we're dealing with a file in the Scripts directory
        is_in_scripts = 'Scripts' in source_path.parts
        
        if is_in_scripts:
            _copy_scripts_directory(source_path, target_path)
        else:
            _create_symlink_to_original(source_path, target_path)
        
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
        print_warning(f"Source and dest are the same: '{src}'. No symlinking will be done.")
    else:
        shutil.copytree(
            src,
            dst,
            dirs_exist_ok=True,
            copy_function=_smart_copy,
            ignore=_combined_ignore
        )

def prepare_temp_workspace(project_root: Path, build_dir: Optional[str]) -> Path:
    """
    Create a temporary workspace with symlinks to project files.
    Args:
        project_root: Root directory of the NOVATHESIS project
        build_dir: Optional build directory path
    Returns:
        Path to the temporary workspace directory
    """
    if build_dir:
        tmpdir = Path(build_dir).resolve()
    else:
        tmpdir = Path(tempfile.mkdtemp(prefix="ntbuild-", dir="/tmp"))
    
    print_info(f"Temp workspace: {tmpdir}")
    
    # Ignore build artifacts and version control files
    ignore = shutil.ignore_patterns(
        "*.aux", "*.log", "*.toc", "*.out", "*.fls", "*.fdb_latexmk",
        "*.synctex*", "*.bbl", "*.blg",
        ".git", ".gitignore", ".DS_Store", "AUXDIR"
    )
    _copytree_symlinking(project_root, tmpdir, ignore=ignore)
    
    # Verify critical files exist
    template_file = tmpdir / "template.tex"
    makefile = tmpdir / "Makefile"
    if not template_file.exists():
        print_error(f"template.tex not found in temp workspace!")
        print_warning(f"  Expected at: {template_file}")
        if template_file.is_symlink():
            print_warning(f"  Symlink target: {template_file.readlink()}")
    else:
        print_success(f"template.tex found in temp workspace")
    
    if not makefile.exists():
        print_error(f"Makefile not found in temp workspace!")
    else:
        print_success(f"Makefile found in temp workspace")
    
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
                print_success(f"Restored symlink for {file_path.name}")
            except Exception as e:
                print_warning(f"Could not restore symlink for {file_path.name}: {e}")

# --- Cache Management -------------------------------------------------------
def store_keep_dir(temp_root: Path) -> None:
    """
    Store the path of the temp directory in a cache file.
    Args:
        temp_root: Path to the temporary directory to store
    """
    try:
        CACHE_DIR.mkdir(parents=True, exist_ok=True)
        CACHE_FILE.write_text(str(temp_root), encoding="utf-8")
        print_success(f"Stored temp directory path in cache: {temp_root}")
    except Exception as e:
        print_warning(f"Could not write to cache file: {e}")

def read_keep_dir() -> Optional[Path]:
    """
    Read the temp directory path from the cache file.
    Returns:
        Path to the temp directory if it exists and is valid, None otherwise
    """
    if not CACHE_FILE.exists():
        return None
    
    try:
        temp_path = Path(CACHE_FILE.read_text(encoding="utf-8").strip())
        if temp_path.exists():
            return temp_path
        else:
            print_warning(f"Cached temp directory does not exist: {temp_path}")
            return None
    except Exception as e:
        print_warning(f"Could not read or parse cache file: {e}")
        return None

def get_cached_line_count() -> int:
    """
    Get the cached line count from previous build.
    Returns:
        Cached line count or DEFAULT_LINE_COUNT if not available
    """
    try:
        if LINE_COUNT_CACHE.exists():
            return int(LINE_COUNT_CACHE.read_text())
    except (ValueError, OSError):
        pass
    return DEFAULT_LINE_COUNT

def store_line_count(count: int) -> None:
    """Store line count for future builds."""
    try:
        LINE_COUNT_CACHE.parent.mkdir(parents=True, exist_ok=True)
        LINE_COUNT_CACHE.write_text(str(count))
    except OSError:
        pass  # Non-critical, silently fail

# --- File Localization ------------------------------------------------------
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
    targets = [
        tmp_root / confdir / "1_novathesis.tex",
        tmp_root / confdir / "4_files.tex",
        tmp_root / confdir / "6_list_of.tex"
    ]
    
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
        
        # Now p is a real file in the temp tree – process it
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

# --- Biber Wrapper Creation -------------------------------------------------
def create_biber_wrapper(tmp_root: Path) -> Optional[Path]:
    """
    Create a wrapper script that serializes biber calls using file locking.
    
    Args:
        tmp_root: Temporary workspace directory
    
    Returns:
        Path to wrapper script, or None if biber not found
    """
    print_info("Intercepting 'biber'")
    
    # Locate real biber
    try:
        result = subprocess.run(
            ["which", "biber"],
            capture_output=True,
            text=True,
            check=True,
        )
        biber_path = result.stdout.strip()
        print(f"biber found: {biber_path}")
    except subprocess.CalledProcessError:
        print_warning("biber not found; no locking wrapper installed")
        return None
    
    lockfile_path = "/tmp/novathesis-biber.lock"
    wrapper_path = tmp_root / "biber"
    
    wrapper_code = f"""#!/usr/bin/env python3
import fcntl
import os
import subprocess
import sys

LOCKFILE = {lockfile_path!r}
REAL_BIBER = {biber_path!r}

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
    
    print_info(f"biber calls will be serialized using {lockfile_path}")
    
    # Register cleanup on exit
    atexit.register(lambda: wrapper_path.unlink(missing_ok=True))
    
    return wrapper_path

# --- Build Execution --------------------------------------------------------
def run_make_in_temp(
    tmp_root: Path,
    ltxprocessor: str,
    school_id: str,
    doctype: str,
    lang: str,
    outdir: Path,
    progress: int = 1,
    total_lines: int = DEFAULT_LINE_COUNT,
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
    # Create biber wrapper and update PATH
    wrapper_path = create_biber_wrapper(tmp_root)
    
    env = os.environ.copy()
    if wrapper_path:
        env["PATH"] = f"{tmp_root}{os.pathsep}{env.get('PATH', '')}"
    
    # Run make with appropriate output handling
    print_info(f"Running 'make {ltxprocessor}' in {tmp_root}")
    start_time = time.perf_counter()
    
    try:
        returncode = _execute_make(
            tmp_root, ltxprocessor, env, progress, total_lines
        )
        
        end_time = time.perf_counter()
        elapsed = end_time - start_time
        
        if returncode == 0:
            print(f"{CYAN}✅ 'make' succeeded in {RED}{elapsed:.2f}{CYAN} seconds{RESET}")
            return _handle_success(tmp_root, outdir, school_id, doctype, lang, keep_bdir, rename)
        else:
            print_error(f"'make' failed with exit code {returncode}")
            print_warning(f"Temp workspace kept for debugging: {tmp_root}")
            return returncode
            
    except subprocess.CalledProcessError as e:
        out = e.stdout if hasattr(e, "stdout") and isinstance(e.stdout, str) else ""
        print(out)
        print_error(f"'make' failed with exit code {e.returncode}")
        print_warning(f"Temp workspace kept for debugging: {tmp_root}")
        return e.returncode

def _execute_make(
    tmp_root: Path,
    ltxprocessor: str,
    env: dict,
    progress: int,
    total_lines: int
) -> int:
    """Execute make command with appropriate output handling."""
    if progress == 1:
        return _execute_with_progress_bar(tmp_root, ltxprocessor, env, total_lines)
    elif progress == 2:
        return _execute_with_realtime_output(tmp_root, ltxprocessor, env)
    else:
        return _execute_silent(tmp_root, ltxprocessor, env)

def _execute_with_progress_bar(
    tmp_root: Path,
    ltxprocessor: str,
    env: dict,
    total_lines: int
) -> int:
    """Execute with progress bar display."""
    print(f"{BRIGHT_CYAN}📊 Progress tracking enabled: expecting ~{total_lines} lines of output{RESET}")
    
    # Verify we can run make before starting
    if not (tmp_root / "Makefile").exists():
        print_error(f"Makefile not found in {tmp_root}")
        return 1
    
    if not (tmp_root / "template.tex").exists():
        print_error(f"template.tex not found in {tmp_root}")
        return 1
    
    proc = subprocess.Popen(
        ["make", ltxprocessor],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
        universal_newlines=True,
        cwd=tmp_root,
        env=env,
    )
    
    line_count = 0
    important_lines = []
    error_lines = []
    
    for line in proc.stdout:
        line_count += 1
        _update_progress_bar(line_count, total_lines)
        
        # Collect error lines
        if "error" in line.lower() or "!" in line[:5]:
            error_lines.append(line)
        
        # Collect important lines
        if (line.startswith("Run number") or
            line.startswith("Running") or
            line.startswith("Logging") or
            line.startswith("Latexmk:") or
            "error" in line.lower() or
            "warning" in line.lower()):
            important_lines.append(line)
        
        # Cache line count after 6 runs
        n = sum(s.startswith("Running") for s in important_lines)
        if n >= 6:
            store_line_count(line_count)
    
    returncode = proc.wait()
    
    # Clear progress bar
    sys.stdout.write("\r" + " " * 100 + "\r")
    sys.stdout.flush()
    
    # Print important lines
    for line in important_lines:
        print(line, end="")
    
    # If there were errors, print them prominently
    if returncode != 0 and error_lines:
        print(f"\n{RED}{'='*60}{RESET}")
        print(f"{RED}LaTeX ERRORS:{RESET}")
        print(f"{RED}{'='*60}{RESET}")
        for line in error_lines[-10:]:  # Show last 10 errors
            print(f"{YELLOW}{line}{RESET}", end="")
        print(f"{RED}{'='*60}{RESET}\n")
    
    return returncode

def _execute_with_realtime_output(
    tmp_root: Path,
    ltxprocessor: str,
    env: dict
) -> int:
    """Execute with real-time output."""
    print(f"{BRIGHT_CYAN}📺 Real-time output mode{RESET}")
    
    proc = subprocess.Popen(
        ["make", "verbose", ltxprocessor],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
        universal_newlines=True,
        cwd=tmp_root,
        env=env,
    )
    
    for line in proc.stdout:
        print(line, end="")
    
    return proc.wait()

def _execute_silent(tmp_root: Path, ltxprocessor: str, env: dict) -> int:
    """Execute in silent mode."""
    print(f"{BRIGHT_CYAN}🔇 Silent mode - showing only important messages{RESET}")
    
    proc = subprocess.run(
        ["make", ltxprocessor],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        cwd=tmp_root,
        env=env,
    )
    
    # Filter important lines
    for line in proc.stdout.splitlines():
        if (line.startswith("Run number") or
            line.startswith("Running") or
            line.startswith("Logging") or
            line.startswith("Latexmk:") or
            "error" in line.lower() or
            "warning" in line.lower()):
            print(line)
    
    return proc.returncode

def _handle_success(
    tmp_root: Path,
    outdir: Path,
    school_id: str,
    doctype: str,
    lang: str,
    keep_bdir: bool,
    rename: bool
) -> int:
    """Handle successful build by copying PDF to output directory."""
    src_pdf = tmp_root / "template.pdf"
    dest_pdf = outdir / (safe_outname(school_id, doctype, lang) if rename else "template.pdf")
    
    if not src_pdf.exists():
        print_error(f"'{src_pdf}' missing")
        return 1
    
    if src_pdf == dest_pdf:
        # Files are the same, no need to copy
        return 0
    
    outdir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src_pdf, dest_pdf)
    print_success(f"saved '{src_pdf.name}' to '{dest_pdf}'")
    
    # Clean up temp workspace if appropriate
    if "ntbuild-" in str(tmp_root) and not keep_bdir:
        shutil.rmtree(tmp_root)
        print_info(f"Temp workspace removed: {tmp_root}")
    else:
        print_warning(f"Preserving build directory: {tmp_root}")
    
    return 0

# --- Validation Helpers -----------------------------------------------------
def validate_school_id(school_id: str) -> str:
    """
    Validate and normalize school ID format.
    
    Args:
        school_id: School identifier (can use - or /)
    
    Returns:
        Normalized school ID with / separators
    
    Raises:
        SystemExit: If school ID format is invalid
    """
    # Normalize: accept '-', '.' or '/' as separators and normalize to '/'
    normalized = school_id.strip().replace("-", "/").replace(".", "/")
    # Collapse accidental repeated separators
    normalized = re.sub(r"/+", "/", normalized)
    
    if "/" not in normalized:
        print_error("School ID must contain '/' or '-'. Example: nova/fct or nova-fct")
        sys.exit(2)
    
    return normalized

def validate_language(lang: str) -> None:
    """
    Validate language code format.
    
    Args:
        lang: Language code to validate
    
    Raises:
        SystemExit: If language code is invalid
    """
    if not re.fullmatch(r"[a-z]{2,3}", lang):
        print_error("--lang must be a 2 or 3 letter code, e.g., en, pt, cat")
        sys.exit(2)

def validate_sdgs(sdgs: str) -> None:
    """
    Validate SDG list format.
    
    Args:
        sdgs: Comma-separated list of SDG numbers
    
    Raises:
        SystemExit: If SDG format is invalid
    """
    if not re.fullmatch(r"\d+(,\d+)*", sdgs):
        print_error("--sdgs must be comma-separated numbers, e.g., 1,2,3")
        sys.exit(2)

def validate_build_dir(build_dir: str, project_root: Path) -> None:
    """
    Validate that build directory is not ancestor of project root.
    
    Args:
        build_dir: Build directory path
        project_root: Project root path
    
    Raises:
        SystemExit: If build directory is invalid
    """
    build_path = Path(build_dir).resolve()
    current_path = project_root.resolve()
    
    # Check if build directory is current directory or current is within build
    if build_path == current_path or current_path.is_relative_to(build_path):
        print_error("Build directory cannot be current directory or its ancestor")
        sys.exit(1)

# --- Command Line Interface -------------------------------------------------
def parse_arguments() -> argparse.Namespace:
    """Parse and return command line arguments."""
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
        default=None,
        choices=["phd", "msc", "bsc"],
        help="Document type: 'phd', 'msc', 'bsc' (default: highest available in schools.conf)"
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
        help="Two/three-letter language code for document (default: en)"
    )
    ap.add_argument(
        "--sdgs",
        default="1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17",
        help="Comma-separated SDG numbers (default: 1,2,3,...,17)"
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
        help="Expected number of output lines for progress calculation (default: auto-detect)"
    )
    ap.add_argument(
        "-r", "--rename-pdf",
        action="store_true",
        default=False,
        help="Rename the PDF from 'template.pdf' to 'univ-school-type-lang.pdf' (default: False)"
    )
    ap.add_argument(
        "-m", "--mode",
        type=int,
        choices=[0, 1, 2],
        default=0,
        help="Build mode: 0 (user), 1 (demo), 2 (cover) (default: 0)"
    )
    ap.add_argument(
        "-bdir", "--build-dir",
        nargs="?",
        const="",
        default=None,
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
    ap.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be changed without actually building"
    )
    
    return ap.parse_args()

def setup_build_directory(args: argparse.Namespace, project_root: Path) -> tuple[Path, bool]:
    """
    Setup build directory based on arguments.
    
    Args:
        args: Parsed command line arguments
        project_root: Project root path
    
    Returns:
        Tuple of (build directory path, whether reusing existing temp dir)
    """
    reusing_temp_dir = False
    
    if args.build_dir is None:
        # No -bdir option: use current directory
        tmp_root = project_root
        print_info(f"Using current directory as build directory: {tmp_root}")
        args.keep_bdir = False
    
    elif args.build_dir == "-":
        # Use cached directory
        cached_temp_root = read_keep_dir()
        if cached_temp_root is None:
            print_warning("No cached temp directory found, creating new temp directory")
            tmp_root = prepare_temp_workspace(project_root, None)
            store_keep_dir(tmp_root)
            args.keep_bdir = True
            print_info("Created new temp directory and stored for future use")
        else:
            tmp_root = cached_temp_root
            reusing_temp_dir = True
            print_info(f"Using cached temp directory: {tmp_root}")
            args.keep_bdir = True
            print_info("Implicitly setting --keep-bdir for cached directory")
    
    elif args.build_dir == "":
        # Create temp directory
        tmp_root = prepare_temp_workspace(project_root, None)
        if args.keep_bdir:
            store_keep_dir(tmp_root)
    
    else:
        # Use specified directory
        validate_build_dir(args.build_dir, project_root)
        tmp_root = prepare_temp_workspace(project_root, args.build_dir)
        if args.keep_bdir:
            store_keep_dir(tmp_root)
    
    return tmp_root, reusing_temp_dir

def main() -> None:
    """Main entry point for the NOVATHESIS build assistant."""
    args = parse_arguments()
    
    # Map mode to descriptive names
    mode_names = {0: "user", 1: "demo", 2: "cover"}
    mode_name = mode_names[args.mode]
    demo = (args.mode == 1)
    cover_only = (args.mode == 2)
    
    # Demo mode forces final status
    if demo:
        args.docstatus = "final"
        print(f"{BRIGHT_CYAN}🎯 Demo mode: setting docstatus to 'final'{RESET}")
    
    # Determine expected line count
    if args.lines == -1:
        lines = get_cached_line_count()
    else:
        lines = args.lines
    
    # Adjust for cover-only mode
    if cover_only:
        lines = COVER_LINE_COUNT
        print(f"{BRIGHT_CYAN}📕 Cover mode: building cover-only version{RESET}")
    
    # Force -bdir for demo and cover modes if omitted
    if (demo or cover_only) and args.build_dir is None:
        args.build_dir = ""
        print(f"{BRIGHT_CYAN}🔧 Forcing temporary build directory for {mode_name} mode{RESET}")
    
    # Validate inputs
    school_id = validate_school_id(args.school_id)
    validate_language(args.lang)
    validate_sdgs(args.sdgs)

    # 1. Check if user provided a doctype via command line
    if args.doctype is not None:
        print_info(f"Using user-specified doctype: {args.doctype}")
    else:
        # 2. No argument given, try to auto-detect from schools.conf
        highest_degree = get_highest_degree_from_conf(school_id)
        if highest_degree:
            print_info(f"Auto-detected highest degree for {GREEN}{school_id}{RESET}: {GREEN}{highest_degree}{RESET}")
            args.doctype = highest_degree
        else:
            # 3. Fallback to 'phd' if school not found in config
            print_warning(f"School '{school_id}' not found in schools.conf. Falling back to default: phd")
            args.doctype = "phd"
    
    project_root = Path.cwd()
    
    # Validate configuration directory
    confdir_path = Path("0-Config")
    if not (project_root / confdir_path).exists():
        print_error("Configuration directory not found: 0-Config")
        sys.exit(1)
    
    # Setup build directory
    tmp_root, reusing_temp_dir = setup_build_directory(args, project_root)
    
    # Restore config symlinks if reusing temp dir in demo/cover mode
    if reusing_temp_dir and (demo or cover_only) and tmp_root != project_root:
        print(f"{BRIGHT_CYAN}🔧 Restoring config file symlinks for reuse in {mode_name} mode{RESET}")
        restore_config_symlinks(tmp_root, project_root, confdir_path)
    
    # Validate or create output directory
    outdir_path = Path(args.output_dir)
    if not outdir_path.exists():
        try:
            outdir_path.mkdir(parents=True, exist_ok=True)
            print_warning(f"Created output directory: {outdir_path}")
        except Exception as e:
            print_error(f"Could not create output directory {outdir_path}: {e}")
            sys.exit(1)
    
    # Build patterns for configuration changes
    patterns = {}
    if demo or cover_only or args.force_school:
        patterns = build_patterns(
            args.doctype, school_id, args.lang, args.mode,
            args.docstatus, args.sdgs, args.force_school
        )
        print(f"{BRIGHT_CYAN}🎯 {mode_name.capitalize()} mode: configuration files will be modified{RESET}")
    else:
        print(f"{BRIGHT_CYAN}👤 User mode: configuration files will not be modified{RESET}")
    
    # Dry run mode
    if args.dry_run:
        print(f"{BRIGHT_YELLOW}🔍 DRY RUN MODE - No actual build will be performed{RESET}")
        print(f"  School: {school_id}")
        print(f"  Document type: {args.doctype}")
        print(f"  Language: {args.lang}")
        print(f"  Status: {args.docstatus}")
        print(f"  Mode: {mode_name}")
        print(f"  Build directory: {tmp_root}")
        print(f"  Output directory: {outdir_path}")
        if patterns:
            print(f"  Files to modify: {', '.join(patterns.keys())}")
        sys.exit(0)
    
    # Localize and process configuration files
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
        school_id=school_id,
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