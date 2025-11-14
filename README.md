<!--
-----------------------------------------------------------------------------
NOVATHESIS — README.md

Version 7.5.5 (2025-11-14)
Copyright (C) 2004-25 by João M. Lourenço <joao.lourenco@fct.unl.pt>
-----------------------------------------------------------------------------
-->

<meta property="og:image" content="http://joaomlourenco.github.io/novathesis/novathesis-latex-logo-v5.svg" />

# NOVAthesis LaTeX Template

---

<div>
<img/ src="http://joaomlourenco.github.io/novathesis/novathesis-latex-logo-v5.jpg" width="400"/>
Say thanks! ➡️ <img/ src="https://github.com/user-attachments/assets/8434a462-3599-4d3c-a2fd-04995db03fe3" width="100"/>
</div>

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

[![GitHub license](https://img.shields.io/badge/SAY%20THANKS-€5-orange.svg)](https://www.paypal.com/donate/?hosted_button_id=8WA8FRVMB78W8)
--------

---

# Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Who Is This For?](#who-is-this-for)
- [Installation Options](#installation-options)
  - [Local LaTeX Installation](#local-latex-installation)
  - [Cloud Services (Overleaf)](#cloud-services-overleaf)
- [Project Structure](#project-structure)
- [Getting Help](#getting-help)
- [Contributing](#contributing)
- [Supported Schools](#supported-schools)
- [Showcase](#showcase)
- [Disclaimer](#disclaimer)
- [Deprecated Word Templates](#deprecated-word-templates)
- [Please give this repository a ⭐️](#please-give-this-repository-a-%EF%B8%8F)

---

# Overview

**NOVAthesis** is a complete LaTeX template for academic theses and dissertations. It provides:

- Ready‑to‑use cover pages compliant with each institution's rules
- A structured, extensible LaTeX codebase
- Automated bibliography management via **biblatex** + **biber**
- Professional typographic standards

The template is open‑source and actively maintained.

---

# Key Features

### ✔ Beginner‑Friendly

- Minimal setup
- Clear configuration files
- Works with any major LaTeX distribution

### ✔ Expert‑Ready

- Uses the powerful `memoir` class
- Supports extensive customization
- Well‑organized and modular

### ✔ School‑Compliant

- 20+ schools supported
- Automatic generation of covers, spine, and formatting rules

### ✔ Modern Tooling

- `latexmk` support
- `biber` for bibliographies
- Overleaf‑ready

---

# Who Is This For?

- MSc and PhD students
- Supervisors preparing guidelines or templates
- Institutions wanting a high‑quality standard
- Anyone writing a large LaTeX document that needs structure

---

# Installation Options

## Local LaTeX Installation

This is the preferred option, especially for large projects.

### 1. Install LaTeX

- **Windows:** [TeX Live](www.tug.org) or [MikTeX](miktex.org)
- **macOS:** [MacTeX](www.tug.org/mactex/) or [MikTeX](miktex.org)
- **Linux:** [TeX Live](www.tug.org) or [MikTeX](miktex.org)

### 2. Download NOVAthesis

```bash
git clone --depth=1 https://github.com/joaomlourenco/novathesis.git
```

Or [download the latest ZIP release](https://github.com/joaomlourenco/novathesis/archive/refs/heads/main.zip).

### 3. Compile

```bash
latexmk -shell-escape -file-line-error -luapdf template
```

**Important:** The template uses **`biber`** by default, not `bibtex`.  However, `bibtex` can be also be used.

### 4. Configure

Edit the files inside the `0-Config/` directory to set your document metadata, e.g.:

- Document type;
- School;
- Language(s) used;
- Cover metadata;
- Bibliography settings;
- …

---

## Cloud Services (Overleaf)

NOVAthesis is available as an official Overleaf template.  Despite the regular updates, the version in Overleaf, although fully operational, may be slightly outdated.

1. [Download the ZIP](https://github.com/joaomlourenco/novathesis/archive/refs/heads/main.zip);
2. [Upload it to Overleaf](www.overleaf.com);
3. Set `template.tex` as the root document;
4. Compile;
5. Follow the steps above (4. Configure) to customize you document.

**Warning:** You will need a paid Overleaf account. The template will not compile under Overleaf Free Plan, which has a 20‑second compilation limit.

---

# Project Structure

```
template.tex            # Document main file (do not change this file)
0-Config/               # Document configuration and customization
  ├── 0_memoir.tex      #   low level customization (for advanced users only)
  ├── 1_novathesis.tex  #   main document customization file
  ├── 2_biblatex.tex    #   biliography customization
  ├── 3_cover.tex       #   cover contents/metadata
  ├── 4_files.tex       #   files to include in the document
  ├── 5_packages.tex    #   user customization (pckages and commands)
  ├── 6_list_of.tex     #   ordering for the lists (for advanced users only)
  └── 9_*.tex           #   School‑specific configs
1-FrontMatter/          # Abstract, Dedicatory, …
2-MainMatter/           # Document main content (main chapters)
3-BackMatter/           # Appendices and Annexes
4-Bibliography          # Bibliography databse (your .bib files)
5-Figures/              # All the figures uaed in the document
```

Each configuration file has a single, well‑defined purpose to keep the project modular.

---

# Getting Help

### 📘 Documentation

- Complete wiki: https://github.com/joaomlourenco/novathesis/wiki

### 💬 Community Support

- GitHub Discussions: https://github.com/joaomlourenco/novathesis/discussions
- Reddit: [r/novathesis](https://www.reddit.com/r/novathesis/)

> **Please don’t contact the author directly.** Support is community‑based.

---

# Contributing

Contributions are welcome:

- Bug reports → [GitHub Issues](https://github.com/joaomlourenco/novathesis/issues)
- New features → [Issues](https://github.com/joaomlourenco/novathesis/issues) or PRs
- Suggestions → [Wiki](https://github.com/joaomlourenco/novathesis/wiki) or [Discussions](https://github.com/joaomlourenco/novathesis/discussions)
- School support → [Issues](https://github.com/joaomlourenco/novathesis/issues) + cover specification

---

# Supported Schools

A large and growing list including:

- NOVA University Lisbon (FCT, IMS, FCSH, ITQB, ENSP)
- University of Lisbon (ISEG, IST, FC, FMV)
- University of Minho (EAD, EC, ED, EEG, EENG, ELACH, EMED, EPSI, ESE, I3BS, ICS, IE)
- Universidade Lusófona
- Instituto Politécnico de Lisboa (ISEL)
- Instituto Politécnico de Setúbal (ESTS)
- Escola Superior de Enfermagem do Porto

*(For the full list with cover examples, check the Wiki.)*

---

# Showcase

Sample covers from the supported schools are available in the Wiki's **Showcase** page.

---

# Disclaimer

This is **not** an official template from any school.  
Compliance has been ensured to the best extent possible using public documentation.

---

# Deprecated Word Templates

The Word templates (unmaintained) can be found in  
[https://github.com/joaomlourenco/novathesis_word]()

--------

# Please give this repository a ⭐️

<picture>
  <source
    media="(prefers-color-scheme: dark)"
    srcset="
      https://api.star-history.com/svg?repos=joaomlourenco/novathesis&type=Date&theme=dark
    "
  />
  <source
    media="(prefers-color-scheme: light)"
    srcset="
      https://api.star-history.com/svg?repos=joaomlourenco/novathesis&type=Date
    "
  />
  <img
    width="500"
    alt="Star History Chart"
    src="https://api.star-history.com/svg?repos=joaomlourenco/novathesis&type=Date"
  />
</picture>

**If you choose to use this project, please:**

1. **Give it a star** by clicking the (⭐️) at the top right of the [project's page](https://github.com/joaomlourenco/novathesis).
2. **Make a [small donation](https://paypal.me/novathesis)** (*pay me a beer!*)
3. **Cite the NOVAthesis manual** in your thesis/dissertation (e.g., in the acknowledgments) with `\cite{novathesis-manual}` (the correct bibliographic reference will be added automatically).

--------
