* unlthesis *
===============

The unlthesis LaTeX class is a PhD thesis template for the [FCT Universidade Nova de Lisboa (FCT-UNL)](http://www.fct.unl.pt), Portugal. The class provides utilities to easily set up the cover page, the front matter pages, the page headers, etc. with respect to the official guidelines of the FCT-UNL for writing PhD dissertations.

The template is easily costumizable for other institutions as well.  If you costumize this template for your institution, please [let me knwow](http://docentes.fct.unl.pt/joao-lourenco) about the hardest costumization tasks do that I can work a bit on them.  Thanks.

*This work is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/4.0/.*


Quick Guide
-----------

+ **DOWNLOAD???**  Get the latest realease from the [releases page](https://github.com/joaomlourenco/unlthesis/releases)!
+ **Sguggestions and/or recommendations?** Please add them to the [wiki](https://github.com/joaomlourenco/unlthesis/wiki) and help other users!
+ **Problems?** Check the [wiki](https://github.com/joaomlourenco/unlthesis/wiki) and have some hope! :)
+ **Still with problems?**  Ask for help in the [discussion forum](https://groups.google.com/forum/#!forum/unlthesis) at https://groups.google.com/forum/#!forum/unlthesis. That is the right place to ask for help!  *Please don't send me an email! with problems/questions*
+ **Did you find a bug?**  Please [open an issue](https://github.com/joaomlourenco/unlthesis/issues). Thanks!
+ [See below](#news) for the most recent [news](#news).


Disclaimer
----------

These are not official templates for FCT-UNL, although they are fully compliant to the FCT and UNL formatting regulations.

The Word template is *frozen*.  The maintenance is very very limited.

All contributors, both sporadic and regular, are welcome. :) Please [contact me](http://docentes.fct.unl.pt/joao-lourenco) to join the team.


News
----
*2015-07-31 — Version 3.0.5 — Smaller is better*
+ Now 'hyperref' is the last package to be loaded (as recommended in the package documentation).
+ Moved extra documentation to the [unlthesis-extras repository](https://github.com/joaomlourenco/unlthesis-extras)

*2015-07-30 — Version 3.0.4*
+ More bug fixes on cover designs

*2015-07-29 — Version 3.0.3*
+ Folder “Examples” as a showcase of thesis for different schools and with different chapter styles
+ More bug fixes

*2015-07-28 — Version 3.0.2*
+ Added support for FCSH-UNL (together with FCT-UNL and IST-UL, see the
README files in the corresponding folders)
+ New option: *otherlistsat=front|back* to print the other lists
(figures, tables, etc) after the TOC or just before the appendixes
+ New option: *aftercover=false|ture* to (not) include the aftercover
file (even if exists)
+ New Option: *media=screen|paper* to specify the target medias (they
may use different page layouts)

*2015-07-28 — Version 3.0.0*
+ Major internal changes, but mainly not visible to the template user.
Now the template includes "folder-based" support for new schools
(forward compatible with new folders to be added).
+ Created a flexible system to design the thesis cover and its
contents, to facilitate the support of other schools/institutions.
+ General cleanup of the code. Removed dependencies from a few packages
(geometry, tabu, memoir, ...)

*2015-07-20 — Lots of styles*
+ Added a new institution: ul/ist
+ Added lots of styles: bianchi bluebox brotherton dash default elegant(*) ell ger hansen jenor lyhne madsen pedersen veelo vz14 vz34 vz43

*2015-07-15 — Towards multiple schools and multiple styles*
+ Renamed document types 'prepmsc'->'mscplan', 'prepphd'->'phdplan', 'propphd'->'phdprop'
+ Split the “unlthesis.cls” file into subfiles with specific contents and moved them to the 'unl-thesis' folder
+ Added support for multiple schools
	- Added option “school” (defaults to “fctunl”, no more are available now)
	- Moved the FCT-UNL support configuration file to the appropriate folder
	- Renamed the “Logo” folder “Images” and moved it inside the “fctunl” configuration folder
+ Added support for multiple book styles
	- Added option “style” (defaults to “elegant”, but others are available)
+ Added the new options to the “template.tex” file
+ Added example for subfigures in chapter 3


*2015-07-01 — Better multilingual support.*
+ Fixed some translations to Portuguese in Babel.
+ Fixed declaration of copyright in Portuguese to follow the new spelling rules.
+ Better multilingual support (more language related things moved to "langsupport.tex" file file).
+ Renamed PhD thesis plan from "prepphd" to "phdplan".

*2015-02-23 — BSc reporting as well.*
+ Improved support for BSc report.
+ Included a MSc like cover but with round corners.

*2015-01-23 — Cover looks nicer.*
+ Fixed a (minor) bug in the cover typesetting.
+ Example with sugfigures is working now!

*2014-11-19 — Appendixes are fine.*
+ Fixed a bug with the numbering of the appendices.

*2014-10-16 — All documents are fine.*
+ Fixed a bug in the frontpage text in some classes of documents (prepmsc, prepphd, propphd).

*2014-09-26 — Headers are back.*
+ Fixed some annoying bugs. The most visible was the absence of headers in text pages.

*2014-08-12 — Even better support for multilingual documents.*
+ Fixed a bug in the multilingual support (the language paramenter was being ignored).

*2014-08-12 — Better support for multilingual documents.*
+ New file “langsupport.tex” with configuration for support of multiples languages
+ Added a flexible interface based in the macro "\addlisttofrontmatter{…}" to manage the different types of lists in the frontmatter (LOF, LOT, etc)
+ Extensive changes to "unlthesis.cls" to: i) use the info from file "langsupport.tex"; and ii) make internal use of lists to do repetitive processing.
+ The support for "glossaries" is not hardcoded into the class file anymore, now it is loaded in the template file and an alternative package may be used instead.

*2014-08-08 — Autoformating for the advisers.*
+ The template requires 3 pieces of info on the adviser(s): name, position and institution. Now if these 3 items will be printed in a single line if possible, otherwise splito into two or three lines as necessary.

*2014-08-03 — Major rewrite of the code that prints the cover page.*
+ The option “spine” with no assigned value means “spine=true”
+ New file “cover strings.tex” with definition of strings in both Portuguese and English (translation to English is still incomplete)
+ Macro “\frontpage” in now “\coverpage”
+ Removed dependency from “ctable” package
+ Removed limits in the number of advisers or jury members (the page layout will impose some limits) by using “lists” and “iterators” over the lists.

*2014-08-01 — Support printing the book spine (“lonbada” in Portuguese).*
+ Added a new option “spine=(true | false)” for printing (not printing) the book spine.
+ This option require “\shortauthor” to be defined for printing the spine.
+ Added examples of *thin*, *medium* and *thick* book spines.
+ Added a new chapter (chapter 4) with “lore ipsum” for trying out with larger documents.
+ Fix of alighment of the (big) Chapter number with the text at the right margin.

*2014-07-01 — Support for list of acronyms (glossary).*
+ Added support for a list of acronyms (glossary).
+ There are separate files for each type (acronyms.tex) and (glossary.tex) and examples of usage in Chapter 1.  Although, both acronyms and glossary entries will be printed in the same (sorted) list.
+ Now the template will still work if the non-mandatory files (dedicatory, quote, acknowledgments) are absent.

*2014-07-01 — New major revision.*
+ Now the base class is “memoir”, which is much more flexible and configurable than “book”.
+ Added support for the “bwl-FU” bibliography style, i.e., “author (year)”.  If more than two authors, replace with just one and add “et al”.
+ Support for the “linkscolor=color” option
+ Support for sending options to the memoir base class with “memoir={list_of_options}”
+ Added support for the “draft” option in the memoir option list. If present, replaces the “YEAR, MONTH” by “Draft: TODAY’S_DATE”
+ Proper configuration of the “palatino” font
+ Removed many classes whose functionalities are now provided by the memoir base class
+ No more need of subfigure (direct support by memoir).

*2014-07-01 — A new version of the template is out.*
+ THe name of the clas in now "unlthesis" and is based in the book memoir class.  
+ Part of the class was rewritten to add support for other referencing types (e.g., numbers unsorted, numbers sorted, alpha, apa-like, etc)

*2014-07-01 — The repository moved out form GoogleCode to GitHub.*

*2014-02-18 — A [discussion forum](https://groups.google.com/forum/#!forum/thesisdifctunl) for users of this template is available at https://groups.google.com/forum/#!forum/thesisdifctunl. 
+ Please register… ask for help/support there and give help/support to your peers.*

*2011-02-27 — The LaTeX template is now fully compliant to the FCT and UNL formatting regulations.*

*2011-02-27 — There is a MS Word DOC version of the template, also fully compliant to the FCT and UNL formatting regulations.*

*2011-11-19 — New version (v 2.1) is now available in downloads section.*
+ Most visible improvement is the smart support for multiple advisers and co-advisers (maximum 9). Sensitive to gender and number. 
+ Now a second (separate) archive provides a basic version of the MSc and PhD templates in MS Word DOC format.

*2011-11-10 — New version (v 2.0) is now available in downloads section.*
+ Most visible improvement is the support for multiple advisers and co-advisers (maximum 9).

*2011-10-23 — New version available in downloads section.*
+ This is a major revision to include the new requirements of FCT/UNL concerning the thesis layout (including a major redesign of the cover page).

*2011-01-19 — New version available in downloads section.*
+ Includes some minor bug fixes and support for input encodings: UTF8 (default) and Latin1.

*2011-02-12 — New version available in downloads section.*
