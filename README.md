<!--
-----------------------------------------------------------------------------
NOVATHESIS — README.md

Version 7.10.0 (2026-01-26)
Copyright (C) 2004-26 by João M. Lourenço <joao.lourenco@fct.unl.pt>
-----------------------------------------------------------------------------
-->

<meta property="og:image" content="http://joaomlourenco.github.io/novathesis/novathesis-latex-logo-v5.svg" />

# NOVAthesis LaTeX Template

---

<div>
<img/ src="http://joaomlourenco.github.io/novathesis/novathesis-latex-logo-v5.jpg" width="400"/>
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

---

# Table of Contents

* [1\. Overview](#1-overview)
* [2\. Key Features](#2-key-features)
* [3\. Who Is This For?](#3-who-is-this-for)
* [4\. Installation Options](#4-installation-options)
  * [4\.1\. Local LaTeX Installation](#41-local-latex-installation)
  * [4\.2\. Cloud Services (Overleaf)](#42-cloud-services-overleaf)
* [5\. Project Structure](#5-project-structure)
* [6\. Getting Help](#6-getting-help)
* [7\. Contributing](#7-contributing)
* [8\. Supported Schools](#8-supported-schools)
* [9\. Showcase](#9-showcase)
* [10\. Disclaimer](#10-disclaimer)
* [11\. Deprecated Word Templates](#11-deprecated-word-templates)
* [12\. Please give this repository a ⭐️](#12-please-give-this-repository-a-️%EF%B8%8F)

---

# 1. Overview

**NOVAthesis** is a complete LaTeX template for academic theses and dissertations. It provides:

- Ready‑to‑use cover pages compliant with each institution's rules
- A structured, extensible LaTeX codebase
- Automated bibliography management via **biblatex** + **biber**
- Professional typographic standards

The template is open‑source and actively maintained.

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

- 20+ schools supported
- Automatic generation of covers, spine, and formatting rules

### ✔ Modern Tooling

- `latexmk` support
- `biber` for bibliographies
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

### 4.1.2. Download NOVAthesis

If listed, download the tailored version for your school.

Otherwise, download the default/main repository.


### How to download

- 📦 => Download ZIP archive;
- <img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" /> => Clone the git repository.


### The NOVAthesis repositories

<table>
<tr><th colspan="6">Universidade NOVA de Lisboa</th></tr>
<tr><th>FCT</th><th>FCT CBBI</th><th>FCT DI-ADC</th><th>ENSP</th><th>ITQB</th></tr>
<tr><td align="center">

| <img height="50" alt="nova-fct-phd" src="https://github.com/user-attachments/assets/efcbc6b0-175f-43e4-866a-126ab7889ab8" /> &nbsp; <img height="50" alt="nova-fct-msc" src="https://github.com/user-attachments/assets/4b153d74-e4ec-4445-b16d-0a7fcea38d35" /> |
|:---------:|
| [📦](https://github.com/novathesis/nova-fct/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/nova-fct.git) |

 </td><td align="center">

| <img height="50" alt="nova-fct-cbbi" src="https://github.com/user-attachments/assets/d983e7d1-fd8c-4ced-86b6-9f0792228ecb" /> |
|:---------:|
| [📦](https://github.com/novathesis/nova-fct-cbbi/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/nova-fct-cbbi.git) |

 </td><td align="center">

| <img height="50" alt="nova-fct-di-adc" src="https://github.com/user-attachments/assets/d5dd4150-3f7b-45d4-878b-4d5ffc246e76" /> |
|:---------:|
| [📦](https://github.com/novathesis/nova-fct-cbbi/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/nova-fct-cbbi.git) |

 </td><td align="center">
  
| <img height="50" alt="nova-ensp" src="https://github.com/user-attachments/assets/148cb148-b4e8-4fd4-a914-5f53a50d7134" />  |
|:---------:|
| [📦](https://github.com/novathesis/nova-ensp/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/nova-ensp.git) |

</td><td align="center">

| <img height="50" alt="nova-itqb" src="https://github.com/user-attachments/assets/dd2cebb4-afdc-45f2-afa2-4b4c3d62033a" />  |
|:---------:|
| [📦](https://github.com/novathesis/nova-itqb/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/nova-itqb.git) |

</td></tr>
</table>


<table>
<tr><th colspan="3">Universidade de Lisboa</th><th colspan="1">Universidade do Porto</th><th colspan="1">Universidade do Minho</th></tr>
<tr><th>FCUL</th><th>IST</th><th>ISEG</th><th>FCUL</th><th>(all / todas)</th></tr>
<tr><td align="center">

| <img height="50" alt="ulisboa-fcul" src="https://github.com/user-attachments/assets/07930d8c-69fa-466f-8523-a0fd419b15a7" /> |
|:---------:|
| [📦](https://github.com/novathesis/ulisboa-fcul/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ulisboa-fcul.git) |

</td><td align="center">

| <img height="50" alt="ulisboa-ist" src="https://github.com/user-attachments/assets/fa9e1eb7-4b7c-4587-aa6e-ba23d8287ac1" />  |
|:---------:|
| [📦](https://github.com/novathesis/ulisboa-ist/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ulisboa-ist.git) |

</td><td align="center">

| <img height="50" alt="ulisboa-iseg" src="https://github.com/user-attachments/assets/594e1a5b-5e3c-4db0-94f1-d23e8e27bc20" />  |
|:---------:|
| [📦](https://github.com/novathesis/ulisboa-iseg/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ulisboa-iseg.git) |

</td><td align="center">

| <img height="50" alt="uporto-fcul" src="https://github.com/user-attachments/assets/11788b92-e608-4e25-8bf1-5aa98b11efc7" />  |
|:---------:|
| [📦](https://github.com/novathesis/uporto-fcul/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/uporto-fcul.git) |

</td><td align="center">

| <img height="50" alt="uminho" alt="uminho-phd" src="https://github.com/user-attachments/assets/b08da764-ba7a-4cde-b4f9-df17e87ff035" />  &nbsp; <img height="50" alt="uminho" alt="uminho-phd" src="https://github.com/user-attachments/assets/12f8d058-a74a-4426-bcfb-d637826b653f" />  |
|:---------:|
| [📦](https://github.com/novathesis/uminho/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/uminho.git) |

</td></tr> 
</table>

<table>
<tr><th>NOVAthesis</th></tr>
<tr><th>main repo</th></tr>
<tr><td align="center">

| <img height="50" alt="novathesis" src="https://github.com/user-attachments/assets/9c19097a-a7b7-49ce-95ff-70694767b350" />  |
|:---------:|
| [📦](https://github.com/joaomlourenco/novathesis/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/joaomlourenco/novathesis.git) |

</td></tr> </table>

### 4.1.3. Compile

If you have `make` installed in your computer, simply run

```bash
make
```

otherwise run

```bash
latexmk -shell-escape -file-line-error -luapdf template
```

**Important:** The template uses **`biber`** by default, not `bibtex`.  However, `bibtex` can be also be used.

### 4.1.4. Configure & Recompile

**Carefully edit** the files inside the `0-Config/` directory to set your document metadata, e.g.:

- Document type;
- School;
- Language(s) used;
- Cover metadata;
- Bibliography settings;
- …

---

## 4.2. Cloud Services (Overleaf)

NOVAthesis is available as an official Overleaf template.  Despite the regular updates, the version in Overleaf, although fully operational, may be slightly outdated.

1. Follow the instructions above and **download the ZIP**;
2. [Upload the ZIP to Overleaf](www.overleaf.com);
3. Set `template.tex` as the root document;
4. Compile;
5. Follow the steps above (*4.1.4. Configure & Recompile*) to customize you document.

**Warning:** You will need a paid Overleaf account. The template will not compile under Overleaf Free Plan, which has a 20‑second compilation limit.

---

# 5. Project Structure

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

# 6. Getting Help

### Documentation

- Complete wiki: https://github.com/joaomlourenco/novathesis/wiki

### Community Support

- GitHub Discussions: https://github.com/joaomlourenco/novathesis/discussions
- Reddit: [r/novathesis](https://www.reddit.com/r/novathesis/)

> **Please don’t contact the author directly.** Support is community‑based.

---

# 7. Contributing

Contributions are welcome:

- Bug reports → [GitHub Issues](https://github.com/joaomlourenco/novathesis/issues)
- New features → [Issues](https://github.com/joaomlourenco/novathesis/issues) or PRs
- Suggestions → [Wiki](https://github.com/joaomlourenco/novathesis/wiki) or [Discussions](https://github.com/joaomlourenco/novathesis/discussions)
- School support → [Issues](https://github.com/joaomlourenco/novathesis/issues) + cover specification

---

# 8. Supported Schools

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

# 9. Showcase

Sample covers from the supported schools are available in the Wiki's **Showcase** page.

---

# 10. Disclaimer

This is **not** an official template from any school.  
Compliance has been ensured to the best extent possible using public documentation.

---

# 11. Deprecated Word Templates

The Word templates (unmaintained) can be found in  
[https://github.com/joaomlourenco/novathesis_word]()

--------

# 12. Please give this repository a ⭐️

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

---

# 12. Contributers (thank you!)

<a href="https://github.com/joaomlourenco/novathesis/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=joaomlourenco/novathesis" />
</a>

Made with [contrib.rocks](https://contrib.rocks).


---

# 13. Say thank you!

1. **Star this repository** by clicking the (⭐️) at the top right of the [project's page](https://github.com/joaomlourenco/novathesis).
2. **Make a [small donation](https://paypal.me/novathesis)** (*pay me a beer!*)  
3. **Cite the NOVAthesis manual** in your thesis/dissertation (e.g., in the acknowledgments) with `\cite{novathesis-manual}` (the correct bibliographic reference will be added automatically).

<img src="https://github.com/user-attachments/assets/8434a462-3599-4d3c-a2fd-04995db03fe3" width="100" />

[![GitHub license](https://img.shields.io/badge/SAY%20THANKS-€5-orange.svg)](https://www.paypal.com/donate/?hosted_button_id=8WA8FRVMB78W8)
