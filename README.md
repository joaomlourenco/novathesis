<!--
-----------------------------------------------------------------------------
NOVATHESIS — README.md

Version 8.0.2 (2026-08-07)
Copyright (C) 2004-26 by João M. Lourenço <joao.lourenco@fct.unl.pt>
-----------------------------------------------------------------------------
-->

<meta property="og:image" content="http://joaomlourenco.github.io/novathesis/novathesis-latex-logo-v5.svg" />

# NOVAthesis LaTeX Template

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
* [13\. Contributors](#13-contributors-thank-you)
* [14\. Say thank you!](#14-say-thank-you)

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

### 4.1.2. Download NOVAthesis

If your school is [listed below](#the-novathesis-repositories), download the tailored version for your school.

Otherwise, download the default/main repository (last in the list).


### How to download

- 📦 => Download ZIP archive;
- <img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" /> => Clone the git repository.


### The NOVAthesis repositories

<table>
<tr><th colspan="7">Universidade NOVA de Lisboa</th></tr>
<tr><th>FCT</th><th>FCT CBBI</th><th>FCT DI-ADC</th><th>ENSP</th><th>ITQB</th><th>FCSH</th><th>IMS(*)</th></tr>
<tr><td align="center">

| <img height="50" alt="nova-fct-phd" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/nova-fct-phd-en.jpg" /> &nbsp; <img height="50" alt="nova-fct-msc" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/nova-fct-msc-en.jpg" /> |
|:---------:|
| [📦](https://github.com/novathesis/nova-fct/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="19" alt="github-logo-25x25" src="https://github.com/user-attachments/assets/bdf7b017-aafc-4919-a382-1094b84dc2ff" />](https://github.com/novathesis/nova-fct.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc)|

 </td><td align="center">

| <img height="50" alt="nova-fct-cbbi" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/nova-fct-cbbi-msc-en.jpg" /> |
|:---------:|
| [📦](https://github.com/novathesis/nova-fct-cbbi/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/nova-fct-cbbi.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

 </td><td align="center">

| <img height="50" alt="nova-fct-di-adc" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/nova-fct-di-adc-bsc-en.jpg" /> |
|:---------:|
| [📦](https://github.com/novathesis/nova-fct-cbbi/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/nova-fct-cbbi.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

 </td><td align="center">
  
| <img height="50" alt="nova-ensp" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/nova-ensp-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/nova-ensp/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/nova-ensp.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td><td align="center">

| <img height="50" alt="nova-itqb" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/nova-itqb-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/nova-itqb/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/nova-itqb.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td><td align="center">

| <img height="50" alt="nova-itqb" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/nova-fcsh-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/nova-fcsh/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/nova-fcsh.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td><td align="center">

| <img height="50" alt="nova-ims" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/nova-ims-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/pdecampossouza/nova-ims-thesis-template-2025/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/pdecampossouza/nova-ims-thesis-template-2025) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td></tr>
</table>

(*) The [NOVA IMS template](https://github.com/pdecampossouza/nova-ims-thesis-template-2025) is an adaptation of the NOVAthesis template by Paulo de Campos Souza.  Please refer to the author's [project page in GitHub](https://github.com/pdecampossouza/nova-ims-thesis-template-2025) for support requests.


<table>
<tr><th colspan="4">Universidade de Lisboa</th><th>&nbsp;&nbsp;&nbsp;&nbsp;</th><th colspan="1">Universidade do Porto</th></tr>
<tr><th>FCUL</th><th>IST</th><th>ISEG</th><th>FMV</th><td></td><th>FCUP</th></tr>
<tr><td align="center">

| <img height="50" alt="ulisboa-fcul" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/ulisboa-fcul-msc-en.jpg" /> |
|:---------:|
| [📦](https://github.com/novathesis/ulisboa-fcul/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ulisboa-fcul.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td><td align="center">

| <img height="50" alt="ulisboa-ist" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/ulisboa-ist-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/ulisboa-ist/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ulisboa-ist.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td><td align="center">

| <img height="50" alt="ulisboa-iseg" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/ulisboa-iseg-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/ulisboa-iseg/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ulisboa-iseg.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td><td align="center">

| <img height="50" alt="ulisboa-fmv" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/ulisboa-fmv-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/ulisboa-fmv/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ulisboa-fmv.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td><td>
</td><td align="center">

| <img height="50" alt="uporto-fcup" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/uporto-fcup-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/uporto-fcup/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/uporto-fcup.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td></tr> 
</table>


<table>
<tr><th>Universidade do Minho</th><th>&nbsp;&nbsp;&nbsp;&nbsp;</th><th colspan="2">Universidade Lusófona</th></tr>
<tr><th>(all / todas)</th><th></th><th>DEISI</th><th>MGE</th></tr>
<tr><td align="center">

| <img height="50" alt="uminho" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/uminho-eeng-phd-en.jpg" />  &nbsp; <img height="50" alt="uminho" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/uminho-eeng-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/uminho/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/uminho.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td><td>
</td><td align="center">

| <img height="50" alt="ulht-deisi" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/ulht-deisi-phd-en.jpg" />  &nbsp; <img height="50" alt="ulht-deisi" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/ulht-deisi-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/ulht-deisi/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ulht-deisi.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td><td align="center">

| <img height="50" alt="ulht-mge" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/ulht-mge-phd-en.jpg" />  &nbsp; <img height="50" alt="ulht-mge" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/ulht-mge-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/ulht-mge/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ulht-mge.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td></tr> 
</table>


<table>
<tr><th>Inst. Politécnico Lisboa</th><th>&nbsp;&nbsp;&nbsp;&nbsp;</th><th>Inst. Politécnico Setúbal</th><th>&nbsp;&nbsp;&nbsp;&nbsp;</th><th>NOVAthesis</th></tr>
<tr><th>ISEL</th><th></th><th>ESTS</th><th></th><th>main repo</th></tr>
<tr><td align="center">

| <img height="50" alt="ipl-isel" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/ipl-isel-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/ipl-isel/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ipl-isel.git)  &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/ipl-isel-novathesis-v7-dot-10-dot-0/xmmydknrgknp)|

</td><td>
</td><td align="center">

| <img height="50" alt="ips-ests" src="https://raw.githubusercontent.com/joaomlourenco/novathesis/gh-pages/Showcase/Covers/JPG/ips-ests-msc-en.jpg" />  |
|:---------:|
| [📦](https://github.com/novathesis/ips-ests/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/novathesis/ips-ests.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td><td>
</td><td align="center">

| <img height="50" alt="novathesis" src="https://github.com/user-attachments/assets/9c19097a-a7b7-49ce-95ff-70694767b350" />  |
|:---------:|
| [📦](https://github.com/joaomlourenco/novathesis/archive/refs/heads/main.zip) &nbsp;&nbsp; [<img height="16" alt="github" src="https://github.com/user-attachments/assets/9fdc8eba-7bac-4a7e-a8de-cb04299a8095" />](https://github.com/joaomlourenco/novathesis.git) &nbsp;&nbsp; [<img height="19" alt="overleaf-logo-22x25" src="https://github.com/user-attachments/assets/810de5bc-6465-4f83-b343-65da3b798586" />](https://www.overleaf.com/latex/templates/novathesis-v7-dot-10-dot-0/jhqwhtcwbmqc) |

</td></tr> 
</table>

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
  - `make watch`: Rebuild automatically every time a file is saved.
  - `make log`: Show the LaTeX log file.
- **Cleaning:**
  - `make clean`: Remove build artifacts (keeps the PDF).
  - `make distclean`: Also remove the PDF and SyncTeX files.
- **Help:**
  - `make help`: Display a help message with all targets and variables.

The behavior can be adjusted with variables, e.g.:

```bash
make V=1                                  # verbose (raw LaTeX output)
make NT="doctype=msc,lang=pt"             # override any \ntsetup option
make view VIEWER="open -a Skim"           # choose the PDF viewer
```

The `NT` variable accepts any comma-separated list of `\ntsetup` options and takes precedence over `0-Config/1_novathesis.tex`, without editing any file. This is handy for testing another school, language, or document type.

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

NOVAthesis is available as an official Overleaf template.  Despite the regular updates, the version in Overleaf, although fully operational, may be slightly outdated.

1. Follow the instructions above and **download the ZIP**;
2. [Upload the ZIP to Overleaf](www.overleaf.com);
3. Set `template.tex` as the root document;
4. Compile;
5. Follow the steps above (*4.1.5. Configure & Recompile*) to customize your document.

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

- NOVA University Lisbon (FCT, FCSH, ITQB, ENSP)
- University of Lisbon (FCUL, FMV, ISEG, IST)
- University of Minho (EAAD, EC, ED, EEG, EENG, ELACH, EMED, EPSI, ESE, I3BS, ICS, IE)
- University of Porto (FCUP)
- ISCTE-IUL (ETA)
- Universidade Lusófona (DEISI, MGE)
- Instituto Politécnico de Lisboa (ISEL)
- Instituto Politécnico de Setúbal (ESTS)
- Escola Superior de Enfermagem do Porto

*(For the full list with cover examples, check the Wiki.)*

---

# 9. Showcase

Sample covers from the supported schools are available in the [Wiki's **Showcase** page](https://github.com/joaomlourenco/novathesis/wiki/showcase).

---

# 10. Disclaimer

This is **not** an official template from any school.  
Compliance has been ensured to the best extent possible using public documentation.

---

# 11. Deprecated Word Templates

The Word templates (unmaintained) can be found at  
<https://github.com/joaomlourenco/novathesis_word>

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

# 13. Contributors (thank you!)

<a href="https://github.com/joaomlourenco/novathesis/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=joaomlourenco/novathesis" />
</a>

Made with [contrib.rocks](https://contrib.rocks).


---

# 14. Say thank you!

1. **Star this repository** by clicking the (⭐️) at the top right of the [project's page](https://github.com/joaomlourenco/novathesis).
2. **Make a [small donation](https://paypal.me/novathesis)** (*pay me a beer!*)  
3. **Cite the NOVAthesis manual** in your thesis/dissertation (e.g., in the acknowledgments) with `\cite{novathesis-manual}` (the correct bibliographic reference will be added automatically).

<img src="https://github.com/user-attachments/assets/8434a462-3599-4d3c-a2fd-04995db03fe3" width="100" />

[![GitHub license](https://img.shields.io/badge/SAY%20THANKS-€5-orange.svg)](https://www.paypal.com/donate/?hosted_button_id=8WA8FRVMB78W8)

