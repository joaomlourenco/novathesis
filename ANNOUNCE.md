# Announcing NOVAthesis v7.10.0

We are thrilled to announce the release of **NOVAthesis v7.10.0**, continuing our mission to provide a robust, modern, and flexible LaTeX template for academic theses and dissertations across multiple Portuguese institutions.

This release brings significant new language support, expands our institutional coverage, and refines the core automation that makes NOVAthesis easy to use.

## 🚀 Highlights of v7.10.0

### 🇨🇳 Chinese Language Support
We have introduced full support for Chinese abstracts, covering both **Simplified (`zhs`)** and **Traditional (`zht`)** scripts. This includes optimized CJK font loading and refactored logic to handle these scripts seamlessly alongside European languages.

### 🏛 New School Support: IPL/ISEL
Comprehensive support for **IPL/ISEL (Instituto Superior de Engenharia de Lisboa)** is now available. This includes:
- Custom cover layouts and styles.
- Institutional logos and wireframe assets.
- Integrated integrity statements compliant with ISEL regulations.

### 🤖 Automation & Refactoring
- **NOVA FCSH:** The integrity statement generation is now fully automated, simplifying the workflow for students.
- **Date Handling:** We've overhauled the date handling logic across all templates to standardize on `\PrintDateISO`, ensuring consistent date formatting everywhere.
- **Statement Processing:** A unified refactoring of how statements (integrity, copyright) are generated improves maintainability and consistency.

---

## ✨ Recent Major Features (v7.x Series)

In case you missed them, here are some of the game-changing features introduced in recent updates:

### 🧠 AI Disclosure Statements (v7.8+)
In response to the growing use of AI tools in academia, we introduced the **`aidisclose`** package. This feature allows students to formally and transparently declare the use of AI tools in their work, adhering to evolving academic integrity standards.

### 🌍 Sustainable Development Goals (SDG) (v7.6+)
You can now easily tag your thesis with **Sustainable Development Goals (SDG)** icons. The template supports the full set of 17 icons in English and Portuguese, with flexible styling options (standard, inverted, mono) to match your document's aesthetic.

### 📄 Enhanced Page Layouts (v7.8+)
We completely rewrote the page geometry handling (migrating from `memoir` custom methods to the standard `geometry` package and a new `stocksize` package). This ensures more robust and predictable page layouts, including support for `compact` options and better handling of varied paper sizes (`b5paper`, `a3` inserts).

### 🏫 Expanding Institutional Support
The NOVAthesis family continues to grow! Recent versions have added or significantly improved support for:
- **ULisboa:** FMV (Veterinary Medicine), FCUL (Sciences), IST (Técnico), ISEG (Economics & Management).
- **NOVA:** ITQB, ENSP, FCSH partnerships.
- **UMinho:** Comprehensive support for various schools.

### 🛠 Better Build Tools
Our build system (`Makefile` and scripts) has seen massive improvements, offering smoother compilation workflows with `latexmk`, better font loading (especially for LuaLaTeX), and smarter handling of metadata and bibliography backends (`biblatex`/`biber`).

---

## 📦 How to Update

If you are starting a new thesis, simply download the latest version from our [GitHub repository](https://github.com/joaomlourenco/novathesis) or clone the specific branch for your school.

If you are updating an existing document, please check the `RELEASE_NOTES.md` for specific migration guides, especially if you have customized your configuration files.

---

**Thank you to all contributors who helped make this release possible!**
Your feedback, bug reports, and code contributions keep this project alive and thriving.

Happy writing! 📝
