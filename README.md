* unlthesis *
===============

A LaTeX template for MSc and PhD dissertations from Universidade Nova de Lisboa
-------------------------------------------------------------------------------

**DOWNLOAD???**  Get the latest realease from the [releases page](https://github.com/joaomlourenco/unlthesis/releases)!

**Sguggestions and/or recommendations?** Please add them to the [wiki](https://github.com/joaomlourenco/unlthesis/wiki) and help other users!

**Problems?** Check the [wiki](https://github.com/joaomlourenco/unlthesis/wiki) and have some hope! :)

**Still with problems?**  *Please don't send me an email!*  Please ask for help in the [discussion forum](https://groups.google.com/forum/#!forum/thesisdifctunl) at https://groups.google.com/forum/#!forum/thesisdifctunl. That is the right place to ask for help!

Do you think **you found a bug**, please [open an issue](https://github.com/joaomlourenco/unlthesis/issues). Thanks!

[See below](#news) the most recent [news](#news).

About
-----

This template was intially developed as working basis for the students from the MSc and PhD programs at [DI-FCT-UNL](http://www.di.fct.unl.pt) (1) writing their thesis in LaTex (then I added a Word template as well).

The LaTeX template is highly configurable and foolows the thesis formatting rules for FCT-UNL, and can easily be used by students from other degrees with minor costumization. With a litle more of tweeking it is also possible to adapt the LaTeX template to other institutions as well.

There is a folder with the Word template that is... well... is a Word document... with all associated the good and bad things. ;)

-- (1) Departamento de Informática (CS Department) of Faculdade de Ciências e Tecnologia of Universidade Nova de Lisboa (http://www.di.fct.unl.pt).


Disclaimer
----------

These are not official templates for FCT-UNL, although they are fully compliant to the FCT and UNL formatting regulations.

All contributors, both sporadic and regular, are welcome. :) Please contact "joao.lourenco@nospamplease.fct.unl.pt" (remove the "nospamplease.") to join the team.


News
----
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
