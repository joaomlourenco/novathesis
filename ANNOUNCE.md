# Announcing NOVAthesis v8.0.1

We are happy to announce the release of **NOVAthesis v8.0.1**, a release focused on speed, on a simpler build system, and on documentation you can trust.

This is a **major** release: glossaries changed their underlying technology, and existing documents need a short, guided migration.

## Highlights of v8.0.1

### Much faster builds ⚡

Glossaries used to consume 4 of the 16 write registers available in pdfTeX. That forced the template to load the `morewrites` package, which made every pdfLaTeX pass roughly **9 times slower**. Glossaries are now processed by **`bib2gls`**, which uses **no** write registers at all.

The result: a full pdfLaTeX build of the manual went from **109 seconds to 36 seconds**. Glossaries also no longer require `-shell-escape`.

As a result, `morewrites` is **no longer loaded by default**. The rare register-heavy document that overshoots the 16-file limit can bring it back with `FASTWRITES=0` (or `\def\ntmorewrites{}` before `\documentclass`); it is a no-op under LuaLaTeX.

### ⚠️ Breaking change: glossaries now use `.bib` files

Acronyms, glossary terms and symbols are now defined in **`.bib` files** processed by **`bib2gls`**, instead of `.tex` files processed by `makeglossaries`.

To migrate:

1. Run **`make glsbib`** to convert your `1-FrontMatter/*.tex` entry files to `.bib`.
2. **Re-add any `sort` keys.** The conversion tool silently drops them. `make glsbib` counts them and warns you per file.
3. Convert symbol entries from `@entry` to `@symbol`.
4. Delete `\glsaddall` if your document calls it. It has no `bib2gls` equivalent.
5. Delete the old `.tex` entry files once the output looks right.

You cannot miss this migration by accident: a registered `.tex` entry file now **stops the build** with an error that names the cause and the fix. The full procedure is in the *Migrating from 7.10.x* appendix of the manual.

**New requirement:** `bib2gls` is a Java program. It ships with TeX Live but needs a **JRE**. Overleaf provides one. Check your local installation with `bib2gls --version`.

### Build any variant from the command line

Any `\ntsetup` option can now be set at build time, without editing a single configuration file.

```bash
make NT="doctype=msc,school=uminho/ec,lang=pt"
```

This is the easiest way to try another school, language, or document type, and to keep several variants of the same document.

### A simpler build system

The build system was rebuilt from scratch around `latexmk`. The `Makefile` is now a thin wrapper, all LaTeX knowledge lives in `latexmkrc`, and the maintainer tooling moved to a separate `Makefile.dev` that is not shipped with the template.

```bash
make            # build with LuaLaTeX
make watch      # rebuild on every save
make view       # build and open the PDF
make help       # all targets and variables
```

Useful variables: `V=1` (verbose), `BATCH=1` (for CI), `TL=2024` (pick a TeX Live release), `FILE=<root>`.

### Documentation you can trust

The whole manual and the comments in `0-Config/` were audited against the code. Several options were documented with wrong names or wrong defaults, and one documented command did not exist at all. Those are fixed, and four previously undocumented options are now described. See the release notes for the detailed list.

---

## How to Update

If you are starting a new thesis, download the latest version from our [GitHub repository](https://github.com/joaomlourenco/novathesis) or clone the branch for your school.

If you are updating an existing document, read the **Breaking change** section above and the *Migrating from 7.10.x* appendix of the manual. `RELEASE_NOTES.md` has the complete list of changes.

---

**Thank you to all contributors who helped make this release possible!**
Your feedback, bug reports, and code contributions keep this project alive and thriving.

Happy writing! 📝
