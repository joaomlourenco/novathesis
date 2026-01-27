# NOVAthesis Template Release Notes (v1.0.0 - v7.10.0)

This document summarizes the changes and improvements made to the NOVAthesis template from version **1.0.0** to the current version **7.10.0**.

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
*   **AI Disclosure:** Major overhaul of the AI disclosure functionality, renaming the package to `aidisclose2` and modernizing the taxonomy.
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
*   **Font Styles:** Added support for `palatino`, `palatino-gyre-pagella`, and `palatino-linitype`.

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
    *   Restructured directories (`0-Config`, `1-FrontMatter`, `NOVAthesisFiles`, etc.).
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
    *   New logo for NOVAthesis.
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
