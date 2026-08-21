<!--
-----------------------------------------------------------------------------
novathesis — README.md

Version 8.2.0 (2026-08-21)
Copyright (C) 2004-26 by João M. Lourenço <joao.lourenco@fct.unl.pt>
-----------------------------------------------------------------------------
-->

<meta property="og:image" content="https://raw.githubusercontent.com/joaomlourenco/novathesis/main/novathesisFiles/Schools/other/novathesis/Images/red/insignia-red1.svg" />

# novathesis LaTeX Template

---

> ### ⚠️ Upgrading from 7.10.x or earlier? Read this first.
>
> **Version 8.0 changes where glossary entries live.** Acronyms, glossary terms and
> symbols moved from `.tex` files (`\newacronym`, `\newglossaryentry`, processed by
> `makeglossaries`) to `.bib` files processed by **`bib2gls`**.
>
> * Run **`make glsbib`** to convert your entry files, then **re-add any `sort` keys** —
>   the converter drops them, which silently reorders symbols and any entry whose name
>   is a command. The build still succeeds, so nothing warns you.
> * Delete `\glsaddall` if your document calls it.
> * **`bib2gls` needs a Java runtime.** Overleaf has one; check locally with
>   `bib2gls --version`.
>
> A registered `.tex` entry file now stops the build with an explanatory error, so you
> cannot miss the migration. Full procedure: the *Migrating from 7.10.x* appendix of
> the manual (`template.pdf`).
>
> **Why:** glossaries no longer consume any of pdfTeX's 16 write registers, so most
> documents no longer need the `morewrites` package — a full pdfLaTeX build of the
> manual went from **109 s to 36 s**.

<div align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/joaomlourenco/novathesis/main/novathesisFiles/Schools/other/novathesis/Images/red/insignia-red1.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/joaomlourenco/novathesis/main/novathesisFiles/Images/novathesis-insignia-outline.svg">
  <img src="https://raw.githubusercontent.com/joaomlourenco/novathesis/main/novathesisFiles/Images/novathesis-insignia-outline.svg" width="72" alt="novathesis insignia"/>
</picture>
<br/>
<img src="https://raw.githubusercontent.com/joaomlourenco/novathesis/main/novathesisFiles/Images/novathesis-text-on-white.svg" width="360" alt="novathesis"/>
<br><br>
<strong>A LaTeX template for MSc dissertations and PhD theses</strong><br>
Compliant covers, spines and formatting for 20+ Portuguese institutions.
<br><br>
<a href="https://novathesis.org"><strong>novathesis.org</strong></a> ·
<a href="https://novathesis.org/en/schools">Find your school</a> ·
<a href="https://novathesis.org/en/start">Get started</a> ·
<a href="https://novathesis.org/en/showcase">Showcase</a>	
</div>

---

This README covers the essentials for working directly in this repository. For everything else —
picking a pre-configured starter for your institution, a guided setup walkthrough, sample covers,
and full documentation — see the website.

[![GitHub forks](https://img.shields.io/github/forks/joaomlourenco/novathesis.svg?style=social&label=Fork)](https://github.com/joaomlourenco/novathesis)
[![GitHub stars](https://img.shields.io/github/stars/joaomlourenco/novathesis.svg?style=social&label=Star)](https://github.com/joaomlourenco/novathesis)
[![GitHub watchers](https://img.shields.io/github/watchers/joaomlourenco/novathesis.svg?style=social&label=Watch)](https://github.com/joaomlourenco/novathesis)
[![GitHub followers](https://img.shields.io/github/followers/joaomlourenco.svg?style=social&label=Follow)](https://github.com/joaomlourenco/novathesis)

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/joaomlourenco/novathesis/graphs/commit-activity)
[![made-with-latex](https://img.shields.io/badge/Made%20with-LaTeX-1f425f.svg?color=green)](https://www.latex-project.org/)
[![GitHub license](https://img.shields.io/badge/License-LaTeX%20v1.3c-green.svg)](https://www.latex-project.org/lppl/lppl-1-3c)

[![GitHub release](https://img.shields.io/github/release/joaomlourenco/novathesis.svg)](https://github.com/joaomlourenco/novathesis/releases/)
![GitHub Workflow Status (with branch)](https://img.shields.io/github/actions/workflow/status/joaomlourenco/novathesis/build-template.yml?branch=main)
[![GitHub commits](https://img.shields.io/github/commits-since/joaomlourenco/novathesis/2.0.0.svg)](https://github.com/joaomlourenco/novathesis/commit/)
![![Last commit](https://github.com/joaomlourenco/novathesis)](https://img.shields.io/github/last-commit/joaomlourenco/novathesis?color=blue)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21938603.svg)](https://doi.org/10.5281/zenodo.21938603)
[![GitHub license](https://img.shields.io/badge/SAY%20THANKS-€5-orange.svg)](https://www.paypal.com/donate/?hosted_button_id=8WA8FRVMB78W8)

---

# Table of Contents

* [1\. Overview](#1-overview)
* [2\. Key Features](#2-key-features)
* [3\. Who Is This For?](#3-who-is-this-for)
* [4\. Installation Options](#4-installation-options)
  * [4\.1\. Local LaTeX Installation](#41-local-latex-installation)
  * [4\.2\. Cloud Services (Overleaf)](#42-cloud-services-overleaf)
* [5\. Project Structure](#5-project-structure)
* [6\. Getting Help & Contributing](#6-getting-help--contributing)
* [7\. Supported Schools & Showcase](#7-supported-schools--showcase)
* [8\. Disclaimer](#8-disclaimer)
* [9\. Deprecated Word Templates](#9-deprecated-word-templates)
* [10\. Please give this repository a ⭐️](#10-please-give-this-repository-a-️%EF%B8%8F)
* [11\. Contributors](#11-contributors-thank-you)
* [12\. Say thank you! (and how to cite)](#12-say-thank-you-and-how-to-cite)

---

# 1. Overview

**nova**thesis is a complete LaTeX template for academic theses and dissertations. It provides:

- Ready‑to‑use cover pages compliant with each institution's rules
- A structured, extensible LaTeX codebase
- Automated bibliography management via **biblatex** + **biber**
- Professional typographic standards

The template is open‑source and actively maintained.

- Browse sample covers in the [showcase](https://novathesis.org/en/showcase.html)

---

# 2. Key Features

### ✔ Beginner‑Friendly

- Minimal setup
- Clear configuration files
- Works with any major LaTeX distribution

### ✔ Expert‑Ready

- Uses the powerful `memoir` class
- Supports extensive customization
- Well‑organized and modular

### ✔ School‑Compliant

- 25+ schools supported
- Automatic generation of covers, spine, and formatting rules

### ✔ Modern Tooling

- `latexmk` support
- `biber` for bibliographies
- `bib2gls` for glossaries, acronyms and symbols — ships with TeX Live, but **needs a Java runtime (JRE)**
  on your machine. Overleaf provides one; check a local install with `bib2gls --version`.
- Overleaf‑ready

---

# 3. Who Is This For?

- MSc and PhD students
- Supervisors preparing guidelines or templates
- Institutions wanting a high‑quality standard
- Anyone writing a large LaTeX document that needs structure

---

# 4. Installation Options

## 4.1. Local LaTeX Installation

This is the preferred option, especially for large projects.

### 4.1.1. Install LaTeX

- **Windows:** [TeX Live](www.tug.org) or [MikTeX](miktex.org)
- **macOS:** [MacTeX](www.tug.org/mactex/) or [MikTeX](miktex.org)
- **Linux:** [TeX Live](www.tug.org) or [MikTeX](miktex.org)

### 4.1.2. Download novathesis

Most institutions have a **pre-configured starter repository** — already set up with the
right cover, spine, and formatting rules for that school — kept automatically in sync with
this main repository.

**➡️ [Find your school on novathesis.org](https://novathesis.org/en/schools.html)** for the
full, up-to-date list (ZIP download, `git clone`, and Overleaf import links for each one).

If your institution isn't listed, clone this main repository instead and configure your
institution manually (see [§4.1.5](#415-configure--recompile)).

### 4.1.3. Compile

If you have `make` installed in your computer, simply run

```bash
make
```

otherwise run

```bash
latexmk -pdflua -shell-escape -file-line-error template
```

(the settings in the `latexmkrc` file at the project root are loaded automatically by `latexmk`).

> ⚠️ **Security note — `-shell-escape`.** The template compiles with shell‑escape **enabled**, because some features run external programs during the build: `minted` (source‑code highlighting) calls Pygments, and selecting a bundled proprietary font (e.g. Calibri, Arial) downloads it over the network. (Glossaries no longer require shell‑escape: since 8.0 they are built by `bib2gls`, which `latexmk` runs directly.) Shell‑escape means that **compiling a document can run commands on your computer with your user account's privileges** — there is no sandbox. In practice this is safe when you build the official template and your own content, but you should **only compile `.tex` files, school configurations, and font styles that you trust.** Treat a thesis project you received from someone else the same way you would treat any script before running it.

**Important:** The template uses **`biber`** by default, not `bibtex`.  However, `bibtex` can be also be used.

### 4.1.4. Makefile Targets

The `Makefile` is a thin wrapper around `latexmk` and provides several targets to simplify your workflow:

- **Compilation Engines:**
  - `make` or `make lua`: Build using `lualatex` (recommended default).
  - `make pdf`: Build using `pdflatex`.
  - `make xe`: Build using `xelatex`.
- **Viewing & Logs:**
  - `make v` or `make view`: Build the PDF and open it in your default viewer.
  - `make watch`: Rebuild automatically every time a file is saved (LuaLaTeX).
  - `make watch-pdf` / `make watch-xe`: Same, with pdfLaTeX / XeLaTeX.
  - `make log`: Show the LaTeX log file.
- **Cleaning:**
  - `make clean`: Remove build artifacts (keeps the PDF and `AUXDIR/matrix/`).
  - `make distclean`: Also remove the PDF and SyncTeX files.
- **Help:**
  - `make help`: Display a help message with all targets and variables.
  - `make help-dev`: Maintainer-only targets (`school`, `matrix`, `zip`, version bumps, …) — not shipped in releases, only available from a git checkout.

The behavior can be adjusted with variables, e.g.:

```bash
make V=1                                  # verbose (raw LaTeX output)
make NT="doctype=msc,lang=pt"             # override any \ntsetup option
make view VIEWER="open -a Skim"           # choose the PDF viewer
make BATCH=1                              # never stop at errors (good for CI)
make TL=2024                              # build against a specific TeX Live release
```

The `NT` variable accepts any comma-separated list of `\ntsetup` options and takes precedence over `0-Config/1_novathesis.tex`, without editing any file. This is handy for testing another school, language, or document type. Other variables (`FILE`, `FASTWRITES`, `PAGER`, `FLAGS`) are documented in the header comment of the `Makefile` itself.

### 4.1.5. Configure & Recompile

**Carefully edit** the files inside the `0-Config/` directory to set your document metadata, e.g.:

- Document type;
- School;
- Language(s) used;
- Cover metadata;
- Bibliography settings;
- …

---

## 4.2. Cloud Services (Overleaf)

**nova**thesis is available as an official Overleaf template.  Despite the regular updates, the version in Overleaf, although fully operational, may be slightly outdated.

1. Find your school on **[novathesis.org](https://novathesis.org/en/schools.html)** and click 📦 to open its starter repository directly in Overleaf (this uploads the ZIP archive and sets `template.tex` as the root document automatically);
2. Compile;
3. Follow the steps above (*4.1.5. Configure & Recompile*) to customize your document.

**Warning:** You will need a paid Overleaf account. The template will not compile under Overleaf Free Plan, which has a 20‑second compilation limit.

---

# 5. Project Structure

```
template.tex            # Document main file (do not change this file)
0-Config/               # Document configuration and customization
  ├── 0_memoir.tex      #   low level customization (for advanced users only)
  ├── 1_novathesis.tex  #   main document customization file
  ├── 2_biblatex.tex    #   bibliography customization
  ├── 3_cover.tex       #   cover contents/metadata
  ├── 4_files.tex       #   files to include in the document
  ├── 5_packages.tex    #   user customization (packages and commands)
  ├── 6_list_of.tex     #   ordering for the lists (for advanced users only)
  ├── 7-aidisclose.tex  #   AI usage disclosure statement
  └── 9_*.tex           #   School‑specific configs
1-FrontMatter/          # Abstract, Dedicatory, …
2-MainMatter/           # Document main content (main chapters)
3-BackMatter/           # Appendices and Annexes
4-Bibliography/         # Bibliography database (your .bib files)
5-Figures/              # All the figures used in the document
```

Each configuration file has a single, well‑defined purpose to keep the project modular.

---

# 6. Getting Help & Contributing

Full documentation, along with support and contributing guides, now live on
**[novathesis.org](https://novathesis.org)**:

- 📖 **[Docs](https://novathesis.org/en/docs.html)** — configuration options, school-specific notes
- 🆘 **[Support](https://novathesis.org/en/support.html)** — where to ask usage questions vs. report bugs
- 🤝 **[Contributing](https://novathesis.org/en/contributing.html)** — adding a school, fixing a formatting
  rule, improving the docs, translating

Quick links that stay on GitHub:

- Usage questions → [GitHub Discussions](https://github.com/joaomlourenco/novathesis/discussions)
- Bug reports & feature requests → [GitHub Issues](https://github.com/joaomlourenco/novathesis/issues)

> **Please don’t contact the author directly.** Support is community‑based.

---

# 7. Supported Schools & Showcase

**[novathesis.org](https://novathesis.org)** hosts the up-to-date, browsable versions of both:

- 🏫 **[Find your school](https://novathesis.org/en/schools.html)** — the full list of 25+
  supported institutions, each with a ready-to-use starter repository
- 🖼️ **[Showcase](https://novathesis.org/en/showcase.html)** — sample covers, spines, and
  chapters for every supported school

---

# 8. Disclaimer

This is **not** an official template from any school.  
Compliance has been ensured to the best extent possible using public documentation.

---

# 9. Deprecated Word Templates

The Word templates (unmaintained) can be found at  
<https://github.com/joaomlourenco/novathesis_word>

--------

# 10. Please give this repository a ⭐️

<!--
<picture>
  <source
    media="(prefers-color-scheme: dark)"
    srcset="
      https://star-history.dera.page/svg?repos=joaomlourenco/novathesis&type=Date&theme=dark
    "
  />
  <source
    media="(prefers-color-scheme: light)"
    srcset="
      https://star-history.dera.page/svg?repos=joaomlourenco/novathesis&type=Date
    "
  />
  <img
    width="500"
    alt="Star History Chart"
    src="https://star-history.dera.page/svg?repos=joaomlourenco/novathesis&type=Date"
  />
</picture>
-->

<picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/chart?repos=joaomlourenco/novathesis%2Cjoaomlourenco/novathesis_word&type=date&theme=dark&legend=top-left&sealed_token=KiAdxo7wrX5R__JpXkk-v3LKV14s5YrCRjGkdMCgJEWBV1KxiPXIY8TUMXMx1_AHz8ivYGooM2Wb7tR4M4-EwNfQvMZWccO6fnAv8gA2wk72JCe5i6ewyA" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/chart?repos=joaomlourenco/novathesis%2Cjoaomlourenco/novathesis_word&type=date&legend=top-left&sealed_token=KiAdxo7wrX5R__JpXkk-v3LKV14s5YrCRjGkdMCgJEWBV1KxiPXIY8TUMXMx1_AHz8ivYGooM2Wb7tR4M4-EwNfQvMZWccO6fnAv8gA2wk72JCe5i6ewyA" />
   <img width="450" alt="Star History Chart" src="https://api.star-history.com/chart?repos=joaomlourenco/novathesis%2Cjoaomlourenco/novathesis_word&type=date&legend=top-left&sealed_token=KiAdxo7wrX5R__JpXkk-v3LKV14s5YrCRjGkdMCgJEWBV1KxiPXIY8TUMXMx1_AHz8ivYGooM2Wb7tR4M4-EwNfQvMZWccO6fnAv8gA2wk72JCe5i6ewyA" />
</picture>


---

# 11. Contributors (thank you!)

<a href="https://github.com/joaomlourenco/novathesis/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=joaomlourenco/novathesis" />
</a>

Made with [contrib.rocks](https://contrib.rocks).


---

# 12. Say thank you! (and how to cite)

<table>
<tr>
<td valign="top">

1. **Star this repository** by clicking the (⭐️) at the top right of the [project's page](https://github.com/joaomlourenco/novathesis).
2. **Make a [small donation](https://paypal.me/novathesis)** (*pay me a beer!*)
3. **Cite novathesis** — see below.

</td>
<td align="center" valign="middle">

<img src="https://github.com/user-attachments/assets/8434a462-3599-4d3c-a2fd-04995db03fe3" width="100"/><br/>
[![GitHub license](https://img.shields.io/badge/SAY%20THANKS-€5-orange.svg)](https://www.paypal.com/donate/?hosted_button_id=8WA8FRVMB78W8)

</td>
</tr>
</table>

### How to cite

novathesis is archived on Zenodo with a DOI: **[10.5281/zenodo.21938603](https://doi.org/10.5281/zenodo.21938603)**. This is the *concept* DOI, so it is version-independent and always resolves to the latest release.

**If you write your thesis with the template, you need do nothing:** the reference is added to your bibliography automatically. Turn it off with `\ntsetup{cite/template=false}` if you prefer.

To cite it explicitly in the text, use `\cite{novathesis-manual}` — the bibliographic entry is supplied by the template, so there is no BibTeX to copy.

Anywhere else, use:

```bibtex
@Manual{novathesis-manual,
  title        = {{novathesis}: A {LaTeX} Template for Academic Theses and Dissertations},
  author       = {João M. Lourenço},
  organization = {NOVA University Lisbon},
  year         = {2026},
  doi          = {10.5281/zenodo.21938603},
}
```

> J. M. Lourenço. *novathesis: A LaTeX Template for Academic Theses and Dissertations.* NOVA University Lisbon, 2026. doi: 10.5281/zenodo.21938603

GitHub's **“Cite this repository”** button (right-hand sidebar) generates the same reference in BibTeX or APA, from [`CITATION.cff`](CITATION.cff).

