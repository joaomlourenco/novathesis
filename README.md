# novathesis

The NOVAthesis LaTeX class is a thesis template initially designed for the PhD and MSc thesis at [FCT Universidade NOVA de Lisboa (FCT-NOVA)](http://www.fct.nova.pt), Portugal. The class provides utilities to easily set up the cover page, the front matter pages, the page headers, etc. with respect to the official guidelines of the FCT-NOVA for writing PhD dissertations.

The template is easily customizable, including the support for other institutions as well. Currently the template supports out-of-thebox (at least): 17 Chapter Styles, 7 font sets, 4 schools.  If you customize this template for your institution or add new style files, please [let me knwow](http://docentes.fct.unl.pt/joao-lourenco) about the thorns in the process, so that I can work a bit to smooth them.  Thanks!

*This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.*


## Getting Started

### Download

Get the latest realease from the [releases page](https://github.com/joaomlourenco/novathesis/releases)!

### Problems and Difficulties

Check the [wiki](https://github.com/joaomlourenco/novathesis/wiki) and have some hope! :smile:

If you couldn't find what you were looking for, ask for help in:

* the [discussion forum](https://groups.google.com/forum/#!forum/novathesis) at https://groups.google.com/forum/#!forum/novathesis. 
* the [facebook page](https://www.facebook.com/groups/novathesis/) (PT or EN) at https://www.facebook.com/groups/novathesis.
* the [google group](https://groups.google.com/forum/#!forum/novathesis) (EN only please) at https://groups.google.com/forum/#!forum/novathesis.
* You may also give a look at the new [NOVA thesis blog](https://novathesis.blogspot.pt) at https://novathesis.blogspot.pt.

Those are the right places to learn about LaTeX and ask for help!  *Please don't ask for help by email! We won't answer…*

### Suggestions and Recommendations

Please add them to the [wiki](https://github.com/joaomlourenco/novathesis/wiki) and help other users!

**Did you find a bug?**  Please [open an issue](https://github.com/joaomlourenco/novathesis/issues). Thanks!

## Donations

If you think this template really helped you while writing your thesis, think about doing a [small donation](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KTPG2K2AHCRAW). I'll keep a list thanking to all the identified donors that identify themselves in the “*Add special instructions to the seller:*” box.

## Disclaimer

These are not official templates for FCT-NOVA, although they are fully compliant to the FCT and NOVA formatting regulations.

The Word template is *frozen*.  The maintenance is very very limited.

All contributors, both sporadic and regular, are welcome. :) Please [contact me](http://docentes.fct.unl.pt/joao-lourenco) to join the team.

## Recent News

NOTE: see the file `changelog.txt` for the complete listing of changes.

*2017-07-26 — Version 4.1.2 — CD spine for FCT-NOVA
+ Now both spines in the CD inlay are filled out. One has the "date, author and logo" and the other has the "date, title and logo".

*2017-07-15 — Version 4.1.1 — Bugfixes in book spine for FCT-NOVA

*2017-07-10 — Version 4.1.0 — CD cover support
+ Added support for school specific CD cover and inlay
+ Added support for default CD cover and inlay (if no school specific definition)
+ Added support for FCT (MSc and PhD) specific CD covers

*2017-01-30 — Version 4.0.1 — Support for APA-like citations and bibliography

*2017-01-14 — Version 4.0.0 — Template renamed to NOVA thesis (novathesis)

*2016-11-07 — Version 3.2.0 — Support for both Appendixes and Annexes*
+ Added support for both Appendixes and Annexes.

*2016-09-17 — Version 3.1.4 — Support for FC-UL*
+ Added support for FC-UL.

*2016-02-22 — Version 3.1.3 — Book spine is ok*
+ Bug fix in \printaftercover
+ Bug fix in cover of NOVA IMS
+ Bug fix in book spine of NOVA IMS

*2016-02-22 — Version 3.1.2 — NOVA IMS improved*
+ Bugfix in \printaftercover

*2016-02-22 — Version 3.1.1 — NOVA IMS improved*
+ Added support for NOVA IMS (new PhD template)
+ Added support for local (per school) "spine.clo" files. The main one is only used in no local version of the file is supplied.
+ Added support for "back cover" and "book spine" images in defaults.clo
+ Now using an altrnative "spine.clo" (thanks to Tomás Monteiro <monteiro.tomas@gmail.com>)
+ Minor fixes for NOVA IMS

*2016-01-07 — Version 3.1.0 — NOVA IMS*
+ Added support for NOVA IMS

*2015-12-07 — Version 3.0.13 — Less and less known bugs…*
+ Added link to Facebook page in the comments at top of novathesis.cls and template.tex
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
