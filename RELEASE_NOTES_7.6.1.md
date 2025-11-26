## 🚀 NOVAthesis Template Release Notes for v7.6.1

This release focuses heavily on **Sustainable Development Goals (SDG)** integration, **build process improvements**, **font style updates**, and various **code cleanup/refactoring** across the template files.

---

### ✨ New Features and Enhancements

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

### ⚠️ Breaking Changes and Removals

* **Removal of NOVA/IMS SDG Icons:** The old SDG icon files previously located in `NOVAthesisFiles/Schools/nova/ims/Images/` have been **removed** in favor of the new, standardized, global set of SDG icons.
* **Removal of NOVA/IMS Defaults File:** The specific school defaults file `0-Config/9_nova_ims.tex` has been **deleted**.
* **Removed Redundant String File:** The localized string file `NOVAthesisFiles/Strings/strings-es2.ldf` has been **deleted**.
* **NOVA/IMS Defaults Refactor:** The general `nova-ims-defaults.ldf` file has been removed, and related configurations have been consolidated/updated in specialized IMS files (`nova-ims-csig-defaults.ldf`, `nova-ims-gt-defaults.ldf`).

---
