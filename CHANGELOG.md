# novathesis Template Changelog (v1.0.0 - v8.3.0)

This document summarizes the changes and improvements made to the **nova**thesis template from version **1.0.0** to the current version **8.3.0**.

---

## v8.3.0 — Stork: Flying International (2026-08-29)

### What's new
*   **New school: Humboldt-Universität zu Berlin** (`other/huberlin`) — cover, logo and accent colour modeled on the official title-page sample, supporting every doctype/language the template already knows. Select it with `\ntsetup{school=other/huberlin}`. Its cover is also the only one that prints the author's date/place of birth, via the new `\SetAuthorBirthDate*`/`\SetAuthorBirthPlace*` commands (both are no-ops on every other school).
*   **`\ntsetup{print/appendixname=true}`** prefixes "Appendix"/"Annex" to the chapter number in appendix/annex chapter headings, not just in the PDF bookmarks (which already showed it). Each bundled chapter style places the label wherever its own layout wants it — e.g. before the vertical bar in `bar`, on its own line above the number in `ist`/`vz34` — so the option looks native to whichever style is active rather than just being tacked on.
*   **`\ntsetup{listof/skip={...}}`** turns off individual "list of ..." entries (figures, tables, algorithms, listings, or any custom one) without commenting out their `\ntaddlistof` line in `0-Config/6_list_of.tex`. `glossaries` is accepted too, as a friendlier spelling of `\ntsetup{print/glossaries=false}`.
*   **Chapter styles showcase**, a demo chapter (`3-BackMatter/app-chapter-styles-showcase.tex`, commented out by default in `0-Config/4_files.tex`) that cycles through every bundled chapter style and every standard memoir chapter style, one short chapter each, so they can be compared side by side before picking one with `style/chapter`.
*   **`\AddValidDegree{key}{doctypes}` / `\ValidateDegree{u}{s}{d}`**, a `\AddValidProcessor`/`\ValidateLtxProcessor`-shaped pair of macros for school `.clo` files: a school (or one of its programme-specific sub-schools, like `nova/fct/cbbi` or `nova/fct/di-adc`) can now declare which doctypes it actually offers, and picking a doctype it doesn't errors clearly instead of silently producing a mismatched cover. `phd` also covers `phdplan`/`phdprop`, `msc` also covers `mscplan` (proposal/plan phases of the same degree, not separate programmes needing their own declaration), and `plain` is never restricted anywhere. Wired up for every school with a real per-doctype restriction in `.Build/schools.conf` (32 `.clo` files); schools with no declared restriction remain unrestricted, as before.

### What was fixed
*   **The `school` comment block in `0-Config/1_novathesis.tex` was stale**: `ulisboa/ff` (renamed to `ulisboa/fful` in v8.2.0) was never updated there, and several `nova/fct` colour variants (`blue`, `brown`, `green`, `plain`, `red`) and the bare `nova/itqb` id were missing entirely.

## v8.2.0 — Hummingbird: Travelling Light (2026-08-21)

### What's new
*   **New school: ULisboa FFUL** (Faculdade de Farmácia da Universidade de Lisboa) — cover, spine, statement pages and the `modality` choice (`dissertation`, `report`, `project`), with its own citation style. Contributed by **Afonso Nóbrega** ([nobrega8](https://github.com/nobrega8)); select it with `\ntsetup{school=ulisboa/fful}`.
*   **`make SIZE=10` caps the final PDF** at a given number of megabytes, for submission systems that enforce a limit. After the build, Ghostscript binary-searches the highest raster-image resolution that still fits; text, fonts and vector graphics are untouched, and the pre-shrink build is kept as `<file>.pdf.orig`. Requires Ghostscript on `PATH`.
*   **The shipped example PDF is now the manual itself** (`novathesis-manual.pdf`), rather than one school's compiled cover — what you get is the documentation you actually want to read.

### What was improved
*   **`make matrix` ends with a summary:** how many variants built, how many failed, and each failure with its first TeX error, so a long regression run states its own result instead of leaving you to count PDFs against logs.
*   **The release version comes from `nt-version.sty`** instead of `git describe`, so an archive built outside a git checkout still reports the right version.
*   **README rewritten** around the project website: a description and quick links in the header, and the per-school tables trimmed now that [novathesis.org](https://novathesis.org) carries them.
*   **The insignia matches the brand accent** (`#D94329`); two insignia files previously disagreed with each other.
*   **The rebrand is complete.** The all-caps `NOVATHESIS` in every source file's header banner is now lowercase, finishing what v8.1.0 started.

### What was fixed
*   **`\hbar` (and other AMS symbols) broke under pdfLaTeX with `style/font=times`.** `mathptmx` redefines `\hbar`, and `amssymb` — pulled in for `\checkmark` whenever the math font does not provide one — was loaded after it, leaving a self-referential macro that errored at first use. `amssymb` now loads first. Only the pdfLaTeX engine was affected; the Xe/LuaLaTeX branch loads `newtxmath`, which defines `\checkmark`.
*   **FFUL's school id is `ulisboa/fful` throughout.** It was briefly `ulisboa/ff`; the directory, the defaults file and every internal reference now agree, so the class no longer fails with *"Missing file … ulisboa-fful-defaults.clo"*. The old id was never part of a tagged release.
*   uminho: the I3Bs school name read *"Research Institute 13Bs"* — digit one instead of the letter I.
*   The class error message *"Cann not load the font"* is now *"Cannot load the font"*.

---

## v8.1.0 — Peacock: New Plumage (2026-08-19)

The release that renamed the template to **nova**thesis and moved the class off
its last external dependency.

### ⚠️ Breaking: `NOVAthesisFiles` is now `novathesisFiles`

The support directory was renamed to lower case. macOS and Windows will not
notice, but **Linux, Overleaf and CI are case-sensitive**: any local
customization, script or `.gitignore` rule that spells the old name stops
resolving. Search your project for `NOVAthesisFiles` and lower-case the `NOVA`.

### What's new
*   **The template is now written **nova**thesis** — a wordmark with `nova` in
    semibold and `thesis` in light, shipped as insignia and text SVGs that need
    no font. `\novathesis` renders the logo under LuaLaTeX/XeLaTeX and the
    wordmark otherwise.
*   **A real Colophon page** in the back matter, replacing the old mini-colophon:
    multilingual, with the template logo, the full citation, the font in use, the
    PDF/A status and a build id, gated on `docstatus`.
*   **Citing the template is now the default and the only path.** The reference
    goes into the document's own bibliography, `CITATION.cff` makes GitHub render
    a *Cite this repository* button, the entry has a DOI, and the build tells you
    at the end that the reference was added. The old hidden white 0.01pt citation
    is gone, as is the opt-out toggle.
*   **SDG icons download on demand**, chosen by the language code, instead of
    shipping with the template.
*   **Jost** joins the font styles.
*   **Glossaries** gained optional per-type group headings and title overrides.
*   **uminho** gained a declaration of AI usage.

### What was improved
*   **The external `options` package is gone**, replaced by an internal `l3keys`
    engine. Every registry — persons, files, list-of, print order, languages, the
    private docclass and folder keys — was migrated across, then `options-ext.sty`
    and the dead code behind it were deleted. `\ntsetup` is unchanged; this is
    one fewer dependency and one fewer source of surprises.
*   **Font pretty-names live with the fonts.** Each `FontStyles/*.sty` now
    registers its own display name instead of a central 21-way lookup table.
*   **Spine boxes auto-scale** to fill the space available.
*   **latexmk rebuild triggers for `bib2gls`** are correct, so glossaries no
    longer go stale between runs.
*   The maintainer's variant build script prints in colour.

### What was fixed
*   The shipped custom-glossary-type example was broken, and works again.
*   The Back Cover bookmark sat at the wrong level in the PDF outline.
*   Back Matter's bookmark no longer collapses under `\part`.
*   uminho: the I3Bs school name read "Research Institute 13Bs" — digit one
    instead of the letter I.
*   The README's star-history chart pointed at a dead endpoint.

---

## v8.0.0 — Swallow: Migration Season (2026-07-30)

A release focused on **build speed**, a **simpler build system**, and **documentation you can trust**.

### ⚠️ Breaking change: glossaries now use `bib2gls`

Acronyms, glossary terms and symbols are now defined in **`.bib` files** processed by **`bib2gls`**, instead of `.tex` files processed by `makeglossaries`. Existing documents must be migrated:

1.  Run **`make glsbib`** to convert `1-FrontMatter/*.tex` entry files to `.bib`.
2.  **Re-add any `sort` keys** — `convertgls2bib` silently drops them, and without them symbols (and any entry whose name is a command) come out in the wrong order. `make glsbib` counts them and warns you per file.
3.  Convert symbol entries from `@entry` to `@symbol`.
4.  Delete `\glsaddall` if your document calls it; it has no `bib2gls` equivalent.
5.  Delete the old `.tex` entry files once the output looks right.

A leftover `.tex` entry file now **stops the build** with an error naming the cause and the fix, so the migration cannot be missed silently. Full procedure: the *Migrating from 7.10.x* appendix of the manual. **New requirement:** `bib2gls` needs a **JRE** (it ships with TeX Live; Overleaf provides one; check locally with `bib2gls --version`).

### What's new
*   **Command-line overrides:** set any `\ntsetup` option at build time with `make NT="doctype=msc,lang=pt"`, without editing a configuration file.
*   **Rebuilt build system:** the `Makefile` is now a thin wrapper over `latexmk` (all LaTeX settings live in `latexmkrc`); maintainer tooling — per-school and full-matrix builds, timestamped output, parallel jobs — moved to `Makefile.dev` + `.Build/nt-variant.sh`.
*   **`make glsbib`:** one-off helper to migrate 7.10.x glossary `.tex` entry files to `.bib`.
*   **Build System appendix** added to the manual.

### What was improved
*   **Much faster pdfLaTeX/XeLaTeX builds.** Glossaries no longer consume any of pdfTeX's 16 write registers, so the `morewrites` package (which made each pass ~9× slower) is **no longer loaded by default**. A full pdfLaTeX build of the manual dropped from **109 s to 36 s**, and glossaries no longer need `-shell-escape`. A register-heavy document that overshoots the limit can restore `morewrites` with `FASTWRITES=0` (or `\def\ntmorewrites{}` before `\documentclass`); no-op under LuaLaTeX.
*   **Symbols glossary created on demand** — it only costs a write register when a symbols file is actually registered.
*   **Bibliography location lists** use `bib2gls`'s native `loc-prefix` for the `p.`/`pp.` distinction.
*   **Faster, smarter matrix builds** (maintainer regression tooling). Variants of a group now share a *warm* auxiliary directory within each sequential unit, reusing `.aux`/`.bbl`/`.glstex` and rebuilding in far fewer passes (`WARM=0` restores cold builds). Parallel units (`JOBS>1`) each run under their own jobname, so per-jobname caches (`minted`'s `_minted-<jobname>`, …) can't collide across concurrent builds. And units are dispatched **longest-first** from measured build times cached in `.Build/.matrix-costs.tsv`, front-loading the heavy schools to shrink the parallel long tail — no `schools.conf` hand-tuning. Each variant's glossaries are still verified (no dropped entries, correct sort order) rather than trusting the exit code.
*   **Dropped the unused `ifplatform` package**: it shell-escaped `uname` into `\jobname.w18` on every build (a needless cost) and raced under parallel matrix jobs sharing one working directory. Nothing in the template used its result.
*   **Documentation accuracy pass:** the manual and `0-Config` comments were corrected against the code — e.g. the real option names `color/glossaries/gls` and `spine/layout`, the correct `tocintoc` default (`true`), removal of the nonexistent `\ntlatesetup` and the retired `nova/ims` identifiers — and `print/otherlists`, `print/glossaries`, `abstract/title` and `abstract/title/align` are now documented.
*   **Hardening:** the font downloader validates its inputs and quotes its shell arguments; CI pins `actions/checkout` and `texlive-action` to commit SHAs, no longer compiles `main` on PRs, and gained Dependabot.

### What was fixed
*   The `mainmatter/pre` hook fired twice.
*   `\ntprintfrontpage` did not respect `print/frontpage`.
*   The SDG heading now falls back to English for languages without a translation.
*   PDF bookmarks now handle bracketless `\ntindex` entries correctly.
*   Name lists built by `\FormatNamesAsList` (advisers, committee) no longer break or mis-expand their separators — fixes the stacked-name covers used by uminho and ISEL-MEB.
*   uminho: the copyright page no longer errors when no Creative Commons modifier is set (it now defaults to `by-nc-sa`).
*   Silenced an l3regex *"invalid end-point for range"* warning from the font-name check (an unescaped `-` in a character class).

---

## v7.10.0 (2026-01-27)

### Features
*   **Chinese Language Support:** Added full support for Chinese abstracts in both Simplified (`zhs`) and Traditional (`zht`) scripts.
*   **ISEL Support:** Added comprehensive support for **IPL/ISEL** (Instituto Superior de Engenharia de Lisboa), including custom styles, cover layouts, and integrity statements.
*   **NOVA FCSH Automation:** Automated the integrity statement generation and updated configuration for NOVA FCSH.
*   **Institutional Assets:** Added institutional logos and wireframe assets for IPL/ISEL.

### Refactoring & Fixes
*   **Date Handling:** Overhauled date handling logic, standardizing on `\PrintDateISO` across school templates.
*   **Statement Processing:** Refactored statement generation (integrity, copyright) for better consistency.
*   **Abstracts:** Optimized CJK font loading and refactored abstract skipping logic.

---

## v7.9.x (January 2026)

### Features
*   **Glossaries:** Enhanced glossary support with customizable layouts (`0-Config/6_list_of.tex`) and improved setup.
*   **ULisboa/FMV:** Added support for the Faculty of Veterinary Medicine (FMV).
*   **Dynamic Signatures:** Implemented dynamic signature generation for statement pages.
*   **Contributors:** Added a contributors section to the README.

### Refactoring
*   **AI Disclosure:** Major overhaul of the AI disclosure functionality, now using the upstream `aidisclose` package (loaded with `autobib=false`) and modernizing the taxonomy.
*   **Data Storage (`memstore`):** Migrated internal data storage (departments, etc.) to a new `memstore` package for better reliability.
*   **File Structure:** Relocated style files to a dedicated `StyFiles` directory and standardized directory macros.
*   **Language Handling:** Simplified language list generation and improved `babel` compatibility.

---

## v7.8.x (December 2025)

### Features
*   **AI Disclosure Integration:** Introduced the `aidisclose` package for formal AI usage declarations in theses.
*   **Stocksize Overhaul:** Completely rewrote `stocksize.sty` using `expl3` for robust page geometry handling.
*   **Geometry Package:** Transitioned page layout definitions to use the `geometry` package instead of `memoir` custom methods.

---

## v7.7.x (December 2025)

### Features
*   **New Spine Design:** Implemented a new spine design for most schools (excluding ISEL).
*   **New School Support:**
    *   ULisboa/FCUL (Faculty of Sciences)
    *   ULisboa/IST (Instituto Superior Técnico)
    *   ULisboa/ISEG (Lisbon School of Economics and Management)
*   **NOVA FCT Covers:** Improved default cover values and background colors.

---

## v7.6.x (November 2025)

### Features
*   **SDG Support:** Added full support for **Sustainable Development Goals (SDG)** icons (English and Portuguese), with options for inverted/mono styles.
*   **New Languages:** Added support for Danish (`dk`), Catalan (`cat`), Czech (`cz`), Slovak (`sk`), Polish (`pl`), Dutch (`nl`), and others.
*   **Font Styles:** Added support for `palatino`, `palatino-gyre-pagella`, and `palatino-linotype`.

### Refactoring
*   **School Defaults:** Standardized school configurations into `*-defaults.ldf` files.
*   **Build System:** Significant improvements to build scripts (`build.py`, `Makefile`) for better automation.

---

## v7.5.x (November 2025)

### Features
*   **Compact Layout:** Introduced a `compact` class option to reduce vertical spacing for shorter documents.
*   **Font Loading:** Added auto-download capabilities for fonts when using LuaLaTeX.
*   **Metadata:** Improved PDF metadata handling (title, author, keywords).

### Fixes
*   **Captions:** improved spacing and consistency for table and figure captions.
*   **Accessibility:** Better screen-reader compatibility and language tagging in PDFs.

---

## v7.4.x (October-November 2025)

### Features
*   **Build System:** "Much improved" build scripts and Makefile with new targets.
*   **INESC TEC:** Updated logos to vectorial format.

### Fixes
*   **School Fixes:** Corrections for NOVA/IMS (statements, dates), IPS/ESTS (margins), and ULisboa/FCUL.

---

## v7.3.x (January - June 2025)

### Features
*   **Ukrainian Support:** Added support for the Ukrainian language.
*   **NOVA FCSH:** Added support for partnerships.
*   **Bibliography:** Updated link preference order (DOI -> eprint -> URL).

---

## v7.2.x (January 2025)

### Features
*   **NOVA FCT:**
    *   Added support for the **DI-ADC** (Doctoral Program in Computer Science) document type.
    *   Added support for **Colored Covers** (Red/Brown) for specific courses.
    *   Added support for Master in Computational Biology & Bioinformatics.
*   **Fonts:** Added support for the `futura` font.
*   **Auxiliary Directory:** Makefile now uses an `AUXDIR` for temporary files to keep the root clean.

---

## v7.2.1 (October 2024)

### Features
*   **NOVA FCT:**
    *   Added support for the **DI-ADC** (Doctoral Program in Computer Science) document type.
    *   Added support for **Colored Covers** (Red/Brown) for specific courses.
*   **Maintenance:**
    *   Fixed `mtp` target in Makefile.
    *   Removed backup `nova-ims-defaults`.
    *   Minor fixes in NOVA-IMS templates.
    *   Fixed bug in ULisboa/FMV for phdcover with specialization.
    *   Work in progress for NOVA-ITQB with `b5paper`.

---

## v7.1.x (2023 - 2024)

### Features & Improvements
*   **School Support:**
    *   Added support for **ULisboa/ISEG**.
    *   Added support for **ULisboa/FCUL**.
    *   Added support for **NOVA/ITQB**.
    *   Added support for **NOVA/FCSH** partnerships.
    *   Added support for **ULHT-MGE** and **ULHT-DEISI**.
    *   Added support for **IPL/ISEL** (initial support).
    *   Added support for **UMinho** (University of Minho) schools.
    *   Added support for **NOVA/IMS** (Master in Computational Biology & Bioinformatics, etc.).
    *   Added support for **Erasmus Mundus MSc on Geospacial Technologies**.
*   **Spine:**
    *   Implemented a new spine design for most schools.
    *   Added support for user-defined book spine with `\ntaddfile{cover}[spine]{filename}`.
    *   Added support for multiple logos in the spine.
*   **Covers:**
    *   Re-engineered cover drawing mechanisms.
    *   Added support for colored covers and specific document types.
    *   Improved cover layout for various schools (NOVA FCT, IST, FMV, etc.).
    *   Added support for second cover (front page) separate from the main cover.
*   **Formatting & Layout:**
    *   Implemented `compact` class option.
    *   Added support for `b5paper` and `a3` pages (via `newpdflayout`).
    *   Improved support for `widows-and-orphans`.
    *   Standardized date handling to ISO format (`YYYY-MM-DD`).
    *   Improved "list of persons" (advisers, committee) layout options (list, 1-column, 2-columns).
*   **Build System:**
    *   Significant improvements to `Makefile` and build scripts (`build.py`).
    *   Added support for `latexmk` with various engines (`pdflatex`, `xelatex`, `lualatex`).
    *   Added `clean` and `dist` targets.
*   **Languages:**
    *   Added support for Ukrainian (`uk`).
    *   Added support for Greek (`gr`).
    *   Improved support for Portuguese (`pt`), English (`en`), French (`fr`), Italian (`it`), Spanish (`es`), and German (`de`).
*   **Bibliography:**
    *   Transitioned to `biblatex` by default (deprecating `bibtex` in some contexts).
    *   Added support for multiple bibliographies.
    *   Updated citation styles (APA-like).
*   **Glossaries:**
    *   Enhanced glossary support with `glossaries-extra` and `xindy`.
    *   Added `xltabular` based glossary styles.
*   **Fonts:**
    *   Added support for `newtx` and `newpx` font sets.
    *   Added support for `erewhon`, `kieranhealy`, `scholax`, `kpfonts`, `libertine`, `palatino`, `cm-unicode`, etc.
    *   Added font loading helpers for `xelatex` and `lualatex`.

### Refactoring
*   **Core Logic:**
    *   Major refactoring of `novathesis.cls` to use `expl3` (LaTeX3) features.
    *   Replaced `assocarray` with `memory2` package for internal data storage.
    *   Standardized option handling and configuration loading.
    *   Moved school-specific configurations to `*-defaults.ldf` files.
*   **File Structure:**
    *   Restructured directories (`0-Config`, `1-FrontMatter`, `novathesisFiles`, etc.).
    *   Moved style files to `StyFiles`.
    *   Cleaned up and standardized file naming conventions.

---

## v6.x (2020 - 2022)

### Features
*   **School Support:**
    *   Added/Improved support for **NOVA/IMS**, **NOVA/FCSH**, **NOVA/ENSP**, **ULisboa/IST**, **ULisboa/FC**, **IPS/ESTS**, **IPL/ISEL**, **ESEP**.
*   **Cover System:**
    *   Major rewrite of the cover printing logic.
    *   Added support for "track message" on covers.
    *   Introduced `debugcover` option.
*   **Options:**
    *   Replaced the old option system with `xkeyval` and later with custom key-value handling.
    *   Added `docstatus` option (working, provisional, final).
    *   Added `printfrontmatter` option.
*   **LaTeX Engines:**
    *   Added full support for **XeLaTeX** and **LuaLaTeX**.

---

## v5.x (2020 - 2021)

### Features
*   **Engines:**
    *   Added support for **XeLaTeX** and **LuaLaTeX**.
*   **Refactoring:**
    *   Replaced the options system with a command `\ntsetup{...}`.
    *   Improved file loading and hook system.
*   **Visuals:**
    *   New logo for **nova**thesis.
    *   Updated school logos to vector formats where possible.

---

## v4.x (2014 - 2020)

### Features
*   **Renaming:** Template renamed from `unlthesis` to `novathesis` (v4.0.0, 2017).
*   **Bibliography:**
    *   Support for APA-like citations.
*   **Layout:**
    *   Shift from `book` class to `memoir` class foundation (v3.0.0, 2014).
*   **Workflow:**
    *   Migrated from Google Code to GitHub (2014).
    *   Added MS Word templates (later removed/moved).

---

## v3.x (2014 - 2016)

### Features
*   **Core:**
    *   Major rewrite of the class file.
    *   Adoption of `memoir` class.
    *   Support for multiple schools (multi-institution support).
*   **Languages:**
    *   Better multilingual support (pt, en, fr, it).
*   **Structure:**
    *   Support for Acronyms and Glossaries.

---

## v2.x & v1.x (2010 - 2012)

### Early History
*   **Origins:** Initial import as `thesisdifctunl` on Google Code (2010).
*   **Features:**
    *   Support for FCT/UNL layout.
    *   Biblatex support.
    *   Partial bibliographies.
    *   Support for multiple advisers.
*   **Evolution:**
    *   Renamed directories (User -> Chapters).
    *   Added examples.
    *   Switched to `utf8` encoding default.
