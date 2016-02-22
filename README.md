# unlthesis

The unlthesis LaTeX class is a thesis template initially designed for the PhD and MSc thesis at [FCT Universidade Nova de Lisboa (FCT-UNL)](http://www.fct.unl.pt), Portugal. The class provides utilities to easily set up the cover page, the front matter pages, the page headers, etc. with respect to the official guidelines of the FCT-UNL for writing PhD dissertations.

The template is easily customizable, including the support for other institutions as well. Currently the template supports out-of-thebox (at least): 17 Chapter Styles, 7 font sets, 4 schools.  If you customize this template for your institution or add new style files, please [let me knwow](http://docentes.fct.unl.pt/joao-lourenco) about the thorns in the process, so that I can work a bit to smooth them.  Thanks!

*This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.*


## Getting Started

### Download

Get the latest realease from the [releases page](https://github.com/joaomlourenco/unlthesis/releases)!

### Problems and Difficulties

Check the [wiki](https://github.com/joaomlourenco/unlthesis/wiki) and have some hope! :smile:

If you couldn't find what you were looking for, ask for help in:

* the [discussion forum](https://groups.google.com/forum/#!forum/unlthesis) at https://groups.google.com/forum/#!forum/unlthesis. 
* the [facebook page](https://www.facebook.com/groups/unlthesis/) at https://www.facebook.com/groups/unlthesis.

Those are the right places to ask for help!  *Please don't ask for help by email! We won't answer…*

### Suggestions and Recommendations

Please add them to the [wiki](https://github.com/joaomlourenco/unlthesis/wiki) and help other users!

**Did you find a bug?**  Please [open an issue](https://github.com/joaomlourenco/unlthesis/issues). Thanks!

## Disclaimer

These are not official templates for FCT-UNL, although they are fully compliant to the FCT and UNL formatting regulations.

The Word template is *frozen*.  The maintenance is very very limited.

All contributors, both sporadic and regular, are welcome. :) Please [contact me](http://docentes.fct.unl.pt/joao-lourenco) to join the team.

## Donations

If you think this template really helped you while writing your thesis, think about doing a [small donation](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KTPG2K2AHCRAW). I'll keep a list thanking to all the identified donors that identify themselves in the “*Add special instructions to the seller:*” box.

## Recent News

NOTE: see the file `changelog.txt` for the complete listing of changes.

*2016-02-22 — Version 3.1.2 — NOVA IMS improved*
+ Bugfix in \printaftercover

*2016-02-22 — Version 3.1.1 — NOVA IMS improved*
+ Added support for NOVA IMS (new PhD tempalte)
+ Added support for local (per school) "spine.clo" files. The main one is only used in no local version of the file is supplied.
+ Added support for "back cover" and "book spine" images in defaults.clo
+ Now using an altrnative "spine.clo" (thanks to Tomás Monteiro <monteiro.tomas@gmail.com>)
+ Minor fixes for NOVA IMS

*2016-01-07 — Version 3.1.0 — NOVA IMS*
+ Added support for NOVA IMS

*2015-12-07 — Version 3.0.13 — Less and less known bugs…*
+ Added link to Facebook page in the comments at top of unlthesis.cls and template.tex
+ New option 'printcommittee' (default=true) to inhibit printing the committee (when it should be printed)
+ Allow empty sets of committee members
+ Multiple fixes for font sets (thanks to Flávio Martins)
+ Fixed spacing in book spine
+ Removed package `textcomp`, which was clashing with font `kpfonts`, and it does not seem necessary.
+ Fixed a bug with glossaries hyperlinks
+ Fixed a font bug in IST chapter style

*2015-09-08 — Version 3.0.12 — Bug fixes in Listings*
+ Added the translation of "Listing #" to "Listagem #" for the Portuguese language in `fix-babel.clo` (thanks to Constantino Gomes for the fix).
+ Fixed a typo in `template.tex`.

*2015-09-07 — Version 3.0.10 — Multiple bug fixes*
+ `hyperref` option for `bibtex` exposed in `template.tex`.
+ Hyperlinks in citations were not working; now they are.
+ Fixed a bug that allowed chapters to start in even numbered pages.
+ Typo in word "dissertation" corrected in `strings-en.clo` (thanks to David Lopes and Rodrigo Carvalho).

*2015-08-27 — Version 3.0.9 — Covers are all right*
+ Fixed a bug with the background images for the covers in the document classes “mscplan”, “phdplan” and “phdprop”.

*2015-08-26 — Version 3.0.8 — French and Italian are here*
+ Added support for the Italian language (thanks to Paolo Romano <romano@inesc-id.pt>)
+ Added support for the French language (thanks to Sara Ferreira <sarasalomeferreira@gmail.com>)
