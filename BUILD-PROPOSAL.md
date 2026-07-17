# NOVAthesis Build System, a fresh start

Proposal, 2026-07-13. Replaces `Makefile`, `Makefile-OLD` and most of `.Build/`.

**Status (2026-07-14): implemented.** The §8 command-line override (`\ntoverride`
in `nt-setup.sty`) was built first and removed the need for temp workspaces
entirely, so `nt-variant.sh` builds variants in place with per-variant aux
dirs under `AUXDIR/variants/`. Delivered: `Makefile`, `Makefile.dev`,
`.Build/nt-variant.sh`, `.Build/shims/biber`, updated CI workflow.
`Makefile-OLD`, `build.py` and the git scripts remain untouched for the
transition period.

## 1. What the current system actually does

Inventory of functionality across the three mechanisms:

| Functionality | Where it lives today | Audience |
|---|---|---|
| Auto-detect root .tex file | both Makefiles | user |
| Build with lua/pdf/xe engines | both Makefiles + latexmkrc | user |
| AUXDIR output dir, copy PDF back | Makefile + latexmkrc | user |
| Biber, glossaries, TEXINPUTS | latexmkrc | user |
| View PDF, open log | Makefile-OLD | user |
| Verbose / batch / interactive modes | Makefile-OLD | user |
| Select TeX Live year or MikTeX | Makefile-OLD | user |
| clean / bclean / gclean | Makefile-OLD | user |
| Build any school/doctype/lang variant | build.py (1237 lines) | maintainer |
| Temp workspace + config patching | build.py | maintainer |
| Progress bar, line-count cache, biber lock | build.py | maintainer |
| schools.conf lookup (highest degree, engine) | build.py | maintainer |
| Detect schools that need LuaLaTeX | need_lualatex.sh | maintainer |
| zip release archive | Makefile-OLD | maintainer |
| Version bump | Makefile-OLD + Scripts/bump.py | maintainer |
| commit / rebase / tag / push automation | 9 shell scripts in .Build | maintainer |
| CI build | .github calls build.py | maintainer |

Two structural problems:

1. **Two audiences in one system.** Roughly 70% of the machinery serves the
   template maintainer, but it ships with (and confuses) every student who
   just wants `make`.
2. **A circular dependency.** `Makefile → build.py → make lua → latexmk`.
   Each layer re-implements part of the others (engine choice, output dirs,
   progress reporting). latexmk already solves most of it.

## 2. Design principles

- **latexmk is the build engine.** All LaTeX knowledge (engines, biber,
  glossaries, aux dir, clean lists) stays in `latexmkrc`, where it already is.
  Makefiles never call `lualatex` directly.
- **One thin Makefile for users.** No recursion, no pseudo-target tricks
  (`make verbose lua`), no shell script dependencies. Behavior switches are
  plain variables: `make lua V=1`, `make TL=2024`.
- **Maintainer tooling is separate and optional.** A `Makefile.dev` loaded
  with `-include Makefile.dev` (absent from release zips, so users never see
  those targets). It may call one small script.
- **Git automation is dropped.** commit/rebase/tag/push are done with git
  directly. This removes 9 scripts and ~80 Makefile lines.

## 3. Proposed layout

```
Makefile           ~100 lines   user targets, ships in the template
Makefile.dev       ~80 lines    maintainer targets, git-only, excluded from zip
latexmkrc          unchanged    the real build brain
.Build/nt-variant.sh  ~150 lines  builds one school/doctype/lang variant
```

Total: about 330 lines replacing about 2,300.

## 4. Makefile (user-facing)

```
make               build with LuaLaTeX (recommended default)
make lua|pdf|xe    choose engine (latexmk -pdflua / -pdf / -pdfxe)
make view          build then open the PDF        (VIEWER=... to override)
make watch         latexmk -pvc, rebuild on save
make log           open the main .log file        (EDITOR=... to override)
make clean         latexmk -C, remove AUXDIR and generated files
make help          annotated target list
```

Variables instead of mode pseudo-targets:

```
FILE=mythesis      root file override (else auto-detect \documentclass, error if not exactly 1)
V=1                verbose (real-time LaTeX output; default is quiet via -silent/texfot)
BATCH=1            -interaction=batchmode for CI
TL=2024            prepend /usr/local/texlive/2024/bin/* to PATH for this run
FLAGS=...          extra latexmk flags, passed through
```

Kept from today: root-file auto-detection, AUXDIR, PDF + synctex copied back
to the project root, texfot filtering when available.

Dropped: `mik` target (use `PATH=... make`), `tl` (redundant), separate
`lualatex`/`pdflatex`-without-latexmk targets (latexmk with `V=1` covers the
debugging use case), `bclean` (rarely needed; document the biber command in
help), `check-env`/`check-build` ceremony (a missing latexmk already fails
with a clear message).

## 5. Makefile.dev (maintainer)

```
make school SCHOOL=nova/fct [TYPE=msc] [LANG=pt] [STATUS=final] [COVER=1]
                   build one variant via .Build/nt-variant.sh
make matrix        build every school/doctype/lang in schools.conf
                   (sequential by default; JOBS=4 for parallel)
make covers        cover-only pages for the showcase (wraps make-covers logic)
make needlua       regenerate the list of LuaLaTeX-only schools
make zip           release archive novathesis-<version>@<date>.zip
make bump1|2|3     Scripts/bump.py, unchanged
make gclean        git clean -fx with the usual excludes
```

Release flow becomes explicit git, e.g.
`make bump3 && git commit -am "..." && git tag v$(V) && git push --follow-tags`.
If that proves tedious a single `make release` target can chain them, still
without helper scripts.

## 6. .Build/nt-variant.sh (replaces build.py)

One job: build the template for a school/doctype/lang combination without
touching the working copy. About 150 lines of bash:

1. Create a temp dir; populate with `git archive HEAD | tar -x` if in a git
   checkout, else `rsync -a` with excludes. (Replaces 200+ lines of
   symlink-tree logic; symlinks caused the biber and "restore symlinks"
   complications.)
2. Patch `0-Config/1_novathesis.tex` with `sed`: school, doctype, lang,
   docstatus; `COVER=1` comments out `\ntaddfile` and `list_of` lines.
   (Replaces the 400-line regex/pattern engine.)
3. Look up defaults in `schools.conf`: highest degree, required engine.
4. Run `make <engine> BATCH=1` in the temp dir (plain make, no recursion back
   into the maintainer layer).
5. On success copy the PDF out as `univ-school-type-lang.pdf`; on failure
   keep the temp dir and print its path.

Deliberately dropped from build.py, with reasons:

- **Progress bar + line-count cache** (~250 lines): `V=1` for real-time
  output, quiet otherwise. latexmk's `-time` gives timing.
- **Cached/reusable temp dirs** (`-bdir -`, `.keep-dir`): re-creating a temp
  dir costs about a second with `git archive`.
- **Generated biber lock wrapper**: the lock itself stays (concurrent biber
  runs do fail sporadically), but it becomes a small committed shim,
  `.Build/shims/biber` (~10 lines, `flock` based), instead of Python code
  generated from a string. It is off by default and enabled automatically
  whenever builds run concurrently (`JOBS>1` in `make matrix`) by prepending
  `.Build/shims` to `PATH`; `BIBER_LOCK=1` forces it on for external
  regression scripts. Likely root cause worth testing separately: TeX Live's
  biber is a PAR-packed binary that self-extracts into a shared per-user
  cache (`biber --cache`), and two processes racing on that extraction can
  fail. Two cheap mitigations: run `biber --version` once to pre-warm the
  cache before spawning parallel jobs, and/or give each variant its own
  cache via `PAR_GLOBAL_TEMP=$tmpdir/.biber-cache`, which removes the shared
  state entirely and lets biber run truly in parallel.
- **--sdgs, --index, --force-school**: niche flags; a plain `sed` before
  calling the script covers them when needed. Can be re-added later if missed.
- **Dry-run mode**: `bash -x` or reading the 20-line patch function is enough.

## 7. Migration and CI

- `.github/workflows/build-template.yml` changes from
  `python .Build/build.py nova/fct --build-dir=AUXDIR --progress=2` to
  `make school SCHOOL=nova/fct` (or just `make BATCH=1` to test the shipped
  user path, which is arguably what CI should test).
- Release zip includes `Makefile` and `latexmkrc`, excludes `Makefile.dev`
  and `.Build/`.
- `Makefile-OLD`, `build.py` and the git scripts are deleted after a
  transition period (they stay in git history anyway).

## 8. Possible follow-up (not part of this proposal)

The temp-workspace/sed machinery exists only because school, doctype and lang
live inside a tracked file. If `novathesis.cls` accepted overrides from the
command line, e.g.

```
latexmk -usepretex='\def\ntoverride{school=nova/fct,doctype=msc,lang=pt}' ...
```

with `\ntsetup` honoring `\ntoverride` when defined, then `nt-variant.sh`
shrinks to about 20 lines and no files are ever patched. Worth considering
for a future template version.
