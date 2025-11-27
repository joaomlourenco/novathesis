## NOVAthesis Template Release Notes for v7.6.1

This release focuses heavily on **Sustainable Development Goals (SDG)** integration, **build process improvements**, **font style updates**, and various **code cleanup/refactoring** across the template files.

---

Release date: 2025-11-26  
Compared to: 7.5.0

---

### New Features and Enhancements

* **Full SDG Icon Integration:** Added all **17 English and Portuguese SDG icons** as PDF files (`NOVAthesisFiles/Images/sdg-en/` and `sdg-pt/`) to fully support the SDG setup options.
* **SDG Configuration Options:** Introduced new configuration options for SDG printing in `0-Config/1_novathesis.tex`:
  * `\ntsetup{print/sdgs/list={...}}`
  * `\ntsetup{print/sdgs/type=...}` (e.g., `inverted`, `normal`, `mono`)
  * Options for `size`, `hspace`, and `vspace` for fine-grained control.
* **New Font Styles:** Added explicit support for several new font options in `NOVAthesisFiles/FontStyles/`:
  * `palatino-gyre-pagella.ldf`
  * `palatino-linitype.ldf`
  * `palatino.ldf`
* **New Language Strings:** Added comprehensive string localization files for:
  * Catalan (`strings-ca.ldf`)
  * Czech (`strings-cz.ldf`)
  * Danish (`strings-dk.ldf`)
  * Dutch (`strings-nl.ldf`)
  * Polish (`strings-pl.ldf`)
  * Slovak (`strings-sk.ldf`)
* **FCSH Defaults:** Added the default configuration file for NOVA FCSH (`NOVAthesisFiles/Schools/nova/fcsh/nova-fcsh-defaults.ldf`).

---

### 🛠️ Improvements and Refactoring

* **Build Script Overhaul:** Significant updates and additions across various build scripts in the `.Build/` directory, including new/updated files for `build.py`, `commit.sh`, `need_lualatex.sh`, `nt-safe-update.sh`, `push-force.sh`, `push-header.sh`, `push.sh`, `rebase.sh`, `tag-delete.sh`, `tag-push.sh`, and `tag.sh`.
* **General FCT/FCT-NOVA Naming Standardization:** Standardized the references from the older **FCT-NOVA** to the modern **NOVA FCT** across files like `0-Config/3_cover.tex` and various school-specific defaults (`nova-fct-defaults.ldf`, `nova-fct-cbbi-defaults.ldf`, etc.).
* **Font Style File Updates:** Updated existing font style files (`calibri.ldf`, `kieranhealy.ldf`, `newpx.ldf`, `newsgott.ldf`) for improved stability and compatibility.
* **Configuration Cleanup:** Refactoring and minor updates in several config files (`0-Config/1_novathesis.tex`, `0-Config/3_cover.tex`, `0-Config/6_list_of.tex`) and main matter files (`2-MainMatter/chapter1.tex`, `chapter2.tex`, etc.).
* **String Localization Consolidation:** Updated and cleaned up numerous existing string localization files (e.g., `strings-de.ldf`, `strings-en.ldf`, `strings-pt.ldf`) to align with the new features and strings.

---

### Breaking Changes and Removals

* **Removal of NOVA/IMS SDG Icons:** The old SDG icon files previously located in `NOVAthesisFiles/Schools/nova/ims/Images/` have been **removed** in favor of the new, standardized, global set of SDG icons.
* **Removal of NOVA/IMS Defaults File:** The specific school defaults file `0-Config/9_nova_ims.tex` has been **deleted**.
* **Removed Redundant String File:** The localized string file `NOVAthesisFiles/Strings/strings-es2.ldf` has been **deleted**.
* **NOVA/IMS Defaults Refactor:** The general `nova-ims-defaults.ldf` file has been removed, and related configurations have been consolidated/updated in specialized IMS files (`nova-ims-csig-defaults.ldf`, `nova-ims-gt-defaults.ldf`).

---

## novathesis 7.5.0 — Release notes

Release date: 2025-11-09  
Compared to: 7.4.1

### Overview

Version 7.5.0 is a minor release focused on quality-of-life improvements, additional customization options, documentation updates, and a number of bug fixes. No major breaking API changes are expected for most users migrating from 7.4.1, but please read the "Upgrade notes" section before upgrading if you rely on heavy customizations or overrides.

### Highlights

- New: compact layout option to reduce vertical spacing for shorter theses and reports.
- New: extended font-loading helpers and better Unicode handling for XeLaTeX/LuaLaTeX.
- Improved: improved table and figure caption spacing and caption formatting consistency.
- Improved: smarter defaults for hyperref metadata and PDF accessibility (bookmarks &amp; language).
- Fixed: a set of issues with appendix numbering, TOC depth handling, and conflicting package options.
- Docs: updated user manual and migration guide from 7.4.x with examples.

### What's new (details)

#### New features

- compact class option: add `compact` to the document class options to enable tighter vertical spacing in common environments (lists, captions, paragraph spacing). Useful for short theses, project reports, or when seeking a denser layout.
- Extended font helpers: convenience macros to more easily configure system fonts with XeLaTeX and LuaLaTeX and fallbacks for common missing glyphs.
- Improved PDF metadata handling: the template now sets more complete PDF metadata (title/author/keywords) by default and exposes simple options for customization.

#### Improvements

- Caption and float behavior: consistent spacing and styling for captions in tables and figures, including better behavior when floats appear inside two-column or minipage contexts.
- TOC and bookmarks: table of contents handling now respects specified tocdepth across frontmatter and appendices, and PDF bookmarks generation is more reliable.
- Build robustness: detection and advisories for Biber/BibTeX usage depending on user bibliography configuration; clearer error messages when bibliography backend mismatch is detected.
- Accessibility: language and metadata improvements for better screen-reader compatibility.

#### Bug fixes

- Fixed appendix numbering regression that could appear for users who enabled both `appendix` helpers and certain custom labels.
- Fixed an issue where footnotes inside captions could sometimes break layout.
- Fixed corner cases with custom titlepage overrides that prevented proper page numbering in frontmatter.
- Fixed glossary/order-of-entries and indexing ordering issues in certain LaTeX engines.

#### Documentation

- Updated the user manual with step-by-step examples for migrating from 7.4.1 and switching between LaTeX engines.
- Added example showing `compact` usage and recommended font setups for XeLaTeX/LuaLaTeX.
- Added troubleshooting section for common upgrade issues (bib backend, engine selection, local overrides).

### Upgrade notes

- Most users can upgrade by replacing the class and templates and recompiling their document. Run a full clean build (remove auxiliary files) and regenerate bibliography and index files:
  - latexmk -C (to clean)
  - latexmk -pdf (or use your existing build flow)
  - if you use biber: run biber; if bibtex: run bibtex — check your configuration.
- If you have local custom .sty or template overrides, scan them for references to internal macros which you might have overridden in 7.4.1; a small number of internal helper macro names were clarified and may require minor renaming in overrides. If you hit a break, consult the migration guide section in the manual.
- If you rely on exact spacing, please test with the `compact` option off by default; enable it intentionally when you want tighter layout.

### Compatibility

- Backwards compatible for standard usages migrating from 7.4.1.
- No required external package updates are mandated, though updating your TeX distribution (TeX Live / MiKTeX) to a reasonably recent version is recommended to avoid engine/package incompatibilities.

### Credits &amp; contributors

Thanks to community contributors and testers who reported issues and provided patches. See the changelog for a full list of contributors.

### Changelog (summary)

- Added: compact layout option
- Added: font-loading helper macros for XeLaTeX/LuaLaTeX
- Improved: caption and TOC handling, PDF metadata
- Fixed: appendix numbering, footnotes-in-captions, glossary order
- Docs: updated manual and migration guide

### Release summary (short for GitHub release)

novathesis 7.5.0 — quality-of-life improvements, new compact layout option, better XeLaTeX/LuaLaTeX font helpers, caption/TOC fixes, and updated documentation. See the full release notes for upgrade instructions and breaking-change guidance.

Would you like me to:

- produce a ready-to-copy GitHub Release body,
- open a PR with the updated CHANGELOG and release notes file,
- or tailor the notes to call out specific commits or PRs (if you provide the list or let me fetch them)?
