# NOVAthesis — IntelliSense completion file (texlab / TeXstudio)
# Version 7.10.7 (2026-03-25)
# Copyright (C) 2004-26 João M. Lourenço <joao.lourenco@fct.unl.pt>
#
# CWL format:
#   \command[optional]{mandatory}   — one signature per line
#   (%<arg%>)                       — NOVAthesis-style parenthesised arg
#   %<placeholder%>                 — placeholder text shown in editors
# -----------------------------------------------------------------------

# ============================================================
# CLASS LOADING
# ============================================================
\documentclass[%<options%>]{novathesis}#n

# ============================================================
# MAIN SETUP
# ============================================================
\ntsetup{%<key=value,...%>}
\ntsetup[%<scope%>]{%<key=value,...%>}

# ============================================================
# DOCUMENT METADATA — TITLE
#   type : main | sub | cover | abstract | spine
#   lang : en pt de es fr it nl pl cz dk sk cat gr uk zhs zht
# ============================================================
\nttitle(%<type%>,%<lang%>){%<title%>}

# ============================================================
# DOCUMENT METADATA — INSTITUTION
# ============================================================
\ntdepartment(%<lang%>){%<name%>}
\ntdepartment*(%<lang%>){%<name%>}
\ntdegreename(%<lang%>){%<name%>}
\ntdegreename*(%<lang%>){%<name%>}
\ntspecialization(%<lang%>){%<name%>}
\ntspecialization*(%<lang%>){%<name%>}

# ============================================================
# DOCUMENT METADATA — SPONSORS
#   order : 1 2 3 ...
#   type  : text | logo
#   lang  : en pt ...
# ============================================================
\ntsponsors(%<order%>,%<type%>,%<lang%>){%<content%>}

# ============================================================
# DOCUMENT METADATA — AUTHOR
#   gender : m | f
# ============================================================
\ntauthorname(%<gender%>){%<full name%>}{%<short name%>}
\ntauthordegree(%<lang%>){%<degree%>}

# ============================================================
# DOCUMENT METADATA — DATES
#   type : submission | exam
#   date : YYYY-MM-DD  or  YYYY-MM  or  YYYY
# ============================================================
\ntdate(%<type%>){%<YYYY-MM-DD%>}
\SetDateISO(%<type%>){%<YYYY-MM-DD%>}
\PrintDateISO{%<YYYY-MM-DD%>}
\todayiso

# ============================================================
# DOCUMENT METADATA — PERSONS (advisers, committee)
#
#   class : adviser | committee
#
#   adviser roles  : a (adviser)  c / co (co-adviser)  t (tutor)
#   committee roles: c (chair)  r (rapporteur)  a (adviser)
#                    co (co-adviser)  m (member)  g (guest)
#   gender : m | f
# ============================================================
\ntaddperson{%<class%>}(%<role%>,%<gender%>){%<name, position, institution%>}

# ============================================================
# FILE REGISTRATION
#   \ntaddfile{class}[key]{filename}
#
#   class       key values (optional)
#   -----       -------------------
#   bib         —
#   abstract    en pt de es fr it nl pl cz dk sk cat gr uk zhs zht pt-ext
#   glossaries  glossary | acronym | symbols
#   chapter     optional doctype list, e.g. phd,msc
#   appendix    optional doctype list
#   annex       optional doctype list
#   cover       1 | 2 | N | spine
#   dedication  —
#   acknowledgements —
#   quote       —
#   statement   lang code
# ============================================================
\ntaddfile{%<class%>}{%<filename%>}
\ntaddfile{%<class%>}[%<key%>]{%<filename%>}
\ntaddfile{bib}{%<bibliography.bib%>}
\ntaddfile{abstract}[%<lang%>]{%<filename%>}
\ntaddfile{glossaries}[%<type%>]{%<filename%>}
\ntaddfile{chapter}{%<filename%>}
\ntaddfile{chapter}[%<doctype-list%>]{%<filename%>}
\ntaddfile{appendix}{%<filename%>}
\ntaddfile{appendix}[%<doctype-list%>]{%<filename%>}
\ntaddfile{annex}{%<filename%>}
\ntaddfile{annex}[%<doctype-list%>]{%<filename%>}
\ntaddfile{cover}[%<id%>]{%<filename%>}
\ntaddfile{dedication}{%<filename%>}
\ntaddfile{acknowledgements}{%<filename%>}
\ntaddfile{quote}{%<filename%>}
\ntaddfile{statement}[%<lang%>]{%<filename%>}

# ============================================================
# CUSTOM LIST OF …
#   \ntaddlistof[lang]{title}
# ============================================================
\ntaddlistof{%<title%>}
\ntaddlistof[%<lang%>]{%<title%>}

# ============================================================
# TEMPLATE.TEX HIGH-LEVEL PRINT CALLS
#   \ntprint{key}  — print a single named section
#   \ntprintlist{key}  — print a list of sections
# ============================================================
\ntprint{%<key%>}
\ntprintlist{%<key%>}

# ============================================================
# COVERS & SPINE
# ============================================================
\ntprintcovers
\ntprintcovers[%<cover-list%>]
\ntresetcovers
\ntresetonecover{%<cover-id%>}
\ntaddtocover{%<cover-ids%>}{%<content%>}
\ntaddtocover[%<scope%>]{%<cover-ids%>}{%<content%>}
\ntAddToCoverTikz(%<layer%>){%<cover-ids%>}{%<tikz-code%>}
\ntAddToCoverTikz<%<label%>>[%<tikz-options%>](%<layer%>)[%<more-opts%>]{%<cover-ids%>}{%<tikz-code%>}
\ntprintspine
\ntprintbackcover
\SpineSetup{%<width%>}{%<height%>}
\SpineSetup[%<options%>]{%<width%>}{%<height%>}

# ============================================================
# FRONT MATTER
# ============================================================
\ntthesisfrontmatter
\ntprintdedication
\ntprintquote
\ntprintacknowledgements
\ntprintstatement
\ntprintaidisclose
\ntprintsdgs
\ntprintcopyright
\ntprintabstracts
\ntprintalllistof

# ============================================================
# MAIN MATTER
# ============================================================
\ntthesismainmatter
\ntprintchapters

# ============================================================
# BACK MATTER
# ============================================================
\ntthesisbackmatter
\ntprintappendices
\annex
\ntprintannexes
\ntprintbibsingle
\ntprintbibsingle[%<options%>]
\ntprintbibseparate
\ntprintbibseparate[%<options%>]
\printcompactbib
\printcompactbib[%<options%>]
\ntprintindex
\ntindex{%<text%>}
\ntindex[%<sort-key%>]{%<text%>}

# ============================================================
# PERSON DISPLAY (adviser table, committee list)
#   \ntprintpersons{class}{roles}
# ============================================================
\ntprintpersons{%<class%>}{%<roles%>}
\GetPersonsAsList{%<class%>}{%<roles%>}
\GetPersonsAsList{%<class%>}{%<roles%>}[%<separator%>]
\TheAdvisersSignatures{%<name1%>}{%<name2%>}{%<name3%>}
\TheAdvisersSignatures[%<height%>]{%<name1%>}{%<name2%>}{%<name3%>}
\TheCandiadteSignature{%<name%>}{%<date%>}
\TheCandiadteSignature[%<height%>]{%<name%>}{%<date%>}
\StatementOneSignature{%<name%>}{%<title%>}{%<date%>}
\StatementOneSignature[%<height%>]{%<name%>}{%<title%>}{%<date%>}

# ============================================================
# QUOTE / EPIGRAPH HELPERS
# ============================================================
\begin{ntquoting}{%<text%>}
\begin{ntquoting}*{%<text%>}
\begin{ntquoting}[%<width%>][%<author%>][%<where%>][%<profession%>]{%<text%>}
\end{ntquoting}
\hugequote
\ntquotetext{%<text%>}
\ntquoteauthor{%<name%>}
\ntquotewhere{%<location%>}
\ntquoteprofession{%<profession%>}
\ntprintquote

# ============================================================
# CHAPTER HELPERS
# ============================================================
\ChapterNoTitle{%<label%>}
\ntfixspacing
\shiftbookmarks{%<content%>}
\shiftbookmarks[%<levels%>]{%<content%>}

# ============================================================
# LANGUAGE
# ============================================================
\ntselectlang{%<lang-code%>}
\MakeTitlecase{%<text%>}

# ============================================================
# CONDITIONALS
#   All follow: \ifXXX{true code}[false code]  or
#               \ifXXX{true code}{false code}
# ============================================================
\ifdocclass{%<class%>}{%<true%>}{%<false%>}
\ifphddoc{%<true%>}{%<false%>}
\ifmscdoc{%<true%>}{%<false%>}
\ifbscdoc{%<true%>}{%<false%>}
\ifplaindoc{%<true%>}{%<false%>}
\ifdocstatus{%<status%>}{%<true%>}{%<false%>}
\ifdocfinal{%<true%>}{%<false%>}
\ifdocprovisional{%<true%>}{%<false%>}
\ifdocworking{%<true%>}{%<false%>}
\ifdocunset{%<true%>}{%<false%>}
\ifcoverdefined{%<cover-id%>}{%<true%>}{%<false%>}
\ifcoverdefined[%<id%>]{%<true%>}{%<false%>}
\ifxeorlua{%<xe/lua code%>}{%<pdflatex code%>}

# ============================================================
# HOOKS (for school LDF files and advanced customization)
# ============================================================
\NTAddToHook{%<hook-name%>}{%<code%>}
\NTDeclareHook{%<hook-name%>}
\NTRunHook{%<hook-name%>}

# ============================================================
# UTILITY
# ============================================================
\NTengineName
\PrintProcessorName
\ValidateLtxProcessor{%<processor%>}{%<true%>}{%<false%>}
\ntcheckfonts
\IfFileExistsInDirsTF{%<dirs%>}{%<file%>}{%<true%>}{%<false%>}
\InputIfFileExistsInDirsTF{%<dirs%>}{%<file%>}{%<true%>}{%<false%>}
\IfBeginsWithAnyOf{%<text%>}{%<prefix-list%>}{%<true%>}{%<false%>}
\UniquifyList{%<list%>}
\UniquifyList{%<list%>}[%<output-var%>]
\datamatchtf{%<data%>}{%<name%>}(%<key%>){%<true%>}{%<false%>}
\datamatch{%<data%>}{%<name%>}(%<key%>)
\novathesis

# ============================================================
# DEBUG
# ============================================================
\debuggrid
\debuggrid[%<color%>]
