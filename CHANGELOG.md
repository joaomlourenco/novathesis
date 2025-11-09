# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [7.5.0] - 2025-11-09
### Added
- compact class option: add `compact` to enable tighter vertical spacing in lists, captions, and paragraph spacing.
- Extended font-loading helper macros to simplify font configuration for XeLaTeX and LuaLaTeX.

### Changed
- Improved caption and float behavior, including consistent caption spacing and better handling in minipage and two-column contexts.
- Smarter defaults for PDF metadata and bookmarks; improved PDF accessibility and language metadata.
- Better TOC handling respecting tocdepth across frontmatter and appendices.

### Fixed
- Fixed appendix numbering regression affecting users using appendix helpers and custom labels.
- Fixed footnotes inside captions breaking layout in some engines.
- Fixed ordering issues in glossary and index generation on certain LaTeX engines.

### Documentation
- Updated user manual and migration guide with examples for migrating from 7.4.1 and using the new `compact` option.
