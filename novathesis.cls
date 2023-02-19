%!TEX root=template.tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% novathesis.cls
%% NOVA thesis document class
%%
%% This work is licensed under the
%% The LaTeX project public license (LPPL), version 1.3c
%% To view a copy of this license, visit
%% https://www.latex-project.org/lppl/lppl-1-3c/
%%
%% Version 2023-02-11 [6.10.18]
%% Departamento de Informática (www.di.fct.unl.pt)
%% Faculdade de Ciências e Tecnologia (www.fct.unl.pt)
%% Universidade NOVA de Lisboa (www.unl.pt)
%%
%% BUGS and SUGGESTIONS: please submit an issue at the project web page
%%      at: https://github.com/joaomlourenco/novathesis/
%%
%% HELP: please DO NOT SEND ME EMAILS about LaTeX or the NOVAthesis template
%%       please ask for help at GitHub Discussions page at
%%          https://github.com/joaomlourenco/novathesis/discussions
%%      or at the NOVAthesis facebook group at
%%          https://www.facebook.com/groups/novathesis
%%
%% AUTHOR @github:
%%      - joaomlourenco
%%
%% CONTRIBUTORS @github:
%%      https://github.com/joaomlourenco/novathesis/wiki#help-with-the-project-patches-and-new-features
%%
%% DONATIONS:
%%      If you think this template really helped you while writing your thesis, then
%%          1. Go to the project web page and giv it a star (on the top-right)
%%          2. Make a small donation using the URL below
%%                    https://www.paypal.com/donate/?hosted_button_id=8WA8FRVMB78W8
%%             We will keep a list thanking to all the identified donors that identify
%%             themselves in the “Add special instructions to the seller:” box.
%%
%% CITATION:
%%      If you use this template, please be kind and cite it in your bibliography:
%%           “João M. Lourenço, The NOVAthesis \LaTeX\ Template User’s Manual,
%%            NOVA University Lisbon, 2021,
%%            https://github.com/joaomlourenco/novathesis/raw/main/template.pdf.”
%%      The BibTeX entry is already in the exxample “bibliography.bib” file:
%%           @Manual{novathesis-manual,
%%              title       ={{The NOVAthesis \LaTeX\ Template User's Manual}},
%%              author      ={João M. Lourenço},
%%              organization={NOVA University Lisbon},
%%              year        ={2021},
%%              url         ={https://github.com/joaomlourenco/novathesis/raw/main/template.pdf},
%%           }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
%%% WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
%%%
%%%   You SHOULD NOT change this file (you are playing with fire!)
%%%
%%% WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
%%% WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}[2019-10-01]
\ProvidesClass{novathesis}[2023-02-11 novathesis template]

\NeedsTeXFormat{LaTeX2e}[2020-10-01]


%============================================================
% Save these definitions asap, to be used later in the “\annex” command,
% because "\@Roman" and "\Roman" were failing with pdflatex
% when loading the "greek" language (and LGR font encofing)
%============================================================
\let\oldRoman=\Roman
\let\old@Roman=\@Roman

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  MEMOIR CUSTOMIZATION AND LOADING
%%      Please open and edit the appropriate
%%       configuration file “Config/0_memoir.tex”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntmemoirsetup}[1]{\PassOptionsToClass{#1}{memoir}}
\input{Config/0_memoir}
\LoadClass{memoir}
\OnehalfSpacing% One-and-half spacing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with NOVATHESIS options and configuration files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{NOVAthesisFiles/options2}

% --------------------------------------------------------
% PROCESS PACKAGE OPTIONS
\def\splitbyslash#1/#2\relax#3#4{\edef#3{#1}\edef#4{#2}}

\options{/novathesis/.new family,
  % DOCUMENT
  doctype/.new choice           = {phd, phdprop, phdplan, msc, mscplan, bsc, plain},
  docstatus/.new choice         = {unset, working, provisional, final}, % in not defined by user, unset will be replaced  “working”
  media/.new choice             = {screen, paper},
  spine/.new choice             = {unset, no, full, trim},
  abstract/deforder/.new choice = {default={\@LANG@MAIN,en}, en={en,pt}},
  abstract/theorder/.new list   = {unset},
  setabstractorder/.new cmd        = {\optionsalso{/novathesis/abstract/theorder={#1}}},%
  % SCHOOL
  school/univ/.new value        = {},
  school/schl/.new value        = {},
  school/.new cmd               = {\splitbyslash#1\relax\@nt@univ\@nt@schl
                                   \optionsalso{school/univ/.expanded=\@nt@univ,
                                                school/schl/.expanded=\@nt@schl}},
  school                        = nova/fct,
  % STYLES
  style/chapter/.new value      = bar,
  style/font/.new value         = newpx,
  style/url/.new cmd            = {\AfterPreamble{\urlstyle{#1}}},
  color/links/.new cmd          = {\@ifpackageloaded{hyperref}%
                                                    {\hypersetup{allcolors=#1}}%
                                                    {\PassOptionsToPackage{allcolors=#1}{hyperref}}},
  % LANGUAGES
  lang/extra/.new list           = {},
  lang/main/.new choice         = {en, pt, fr, it, de, es, gr},
  lang/cover/.new choice        = {en, pt, fr, it, de, es, gr},
  lang/copyright/.new choice    = {en, pt, fr, it, de, es, gr},
  lang/.new cmd                 = {\optionsalso{/novathesis/lang/main=#1,
                                                /novathesis/lang/cover=#1,
                                                /novathesis/lang/copyright=#1}},
  lang                          = en,
  % PRINT ON/OFF
  print/committee/.new toggle   = false,
  print/adviser/.new toggle     = true,     % fake option - adviser should always be printed
  print/frontmatter/.new toggle = true,
  print/secondcover/.new toggle = false,
  print/copyright/.new toggle   = true,
  print/timestamp/.new toggle   = true,
  print/index/.new toggle       = false,
  print/webography/.new value   = {},        % empty means do not make a separate webography
  print/statement/.new toggle   = false,
  % MISC
  numberallpages/.new toggle    = false,
  gnumberlist/.new toggle       = true,
  tocintoc/.new toggle          = false,
  % DEBUG
  debug/.new list               = {},         % cover, index
  % DEGREEACR (for degree-specific configuration files)
  degreeacr/.new value          = {},
  degreeacr/phd/.new value      = {},
  degreeacr/msc/.new value      = {},
  degreeacr/bsc/.new value      = {},
  degreeacr/plain/.new value    = {},
% SCHOOL specific customization
% NOVA/ITQB
  nova/itqb/covercolor/.new choice             = {gray, green},
% UMINHO
  uminho/copyrightmodifier/.new choice         = {by-nc-sa, by-sa, by, by-nc, by-nd, by-nc-nd},
  uminho/skipblankcovers/.new toggle           = false,
% ULISBOA/FMV
  ulisboa/fmv/examdate/year/.new value         = {year},
  ulisboa/fmv/examdate/month/.new value        = {month},
  ulisboa/fmv/examdate/day/.new value          = {day},
  ulisboa/fmv/scientificarea/.new choice       = {C, MF, PASA, SA},
  ulisboa/fmv/embargo/period/.new choice       = {I, 6, 12},
  ulisboa/fmv/embargo/justification/.new value = {Justification for the temporary embargo.},
  ulisboa/fmv/reproduction/.new choice         = {I, P, N},
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SOME ESSENTIAL PACKAGES
%%    Others will be loaded later, in the file “packages.tex”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[table,svgnames]{xcolor}%
% \RequirePackage{tabularray}
% \UseTblrLibrary{booktabs}


\ifdefined\NewDocumentCommand\else\RequirePackage{xparse}\fi   % load xparse if necessary
\RequirePackage{xfor}
\RequirePackage{iftex}
\RequirePackage{etoolbox}
\RequirePackage{xstring}
\RequirePackage{NOVAthesisFiles/memory2}
\RequirePackage{NOVAthesisFiles/nt-version}






%%%%% Configure Graphics
\RequirePackage[nobeamer]{graphbox}% improved version of "graphicx"
\graphicspath{{Chapters/Figures/}}
\DeclareGraphicsExtensions{.pdf,.png,.jpg,.tif}
\providecommand*\appendtographicspath[1]{\xappto\Ginput@path{#1}}
\providecommand*\prependtographicspath[1]{\xpreto\Ginput@path{#1}}

%%%%% Options to sans serif fonts (will be loaded later)
\PassOptionsToPackage{scaled=0.95}{inter}
\PassOptionsToPackage{scaled=0.95}{helvet}
% \PassOptionsToPackage{scaled=0.95}{gillius2}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK IF USING LUALATEX OR XELATEX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \newif\ifxetexorluatex
% \begingroup\catcode94=7 \catcode0=9% ASCII 94 is ^
% \def\empty{}\def\next{^^^^0000}\expandafter\endgroup
% \ifx\next\empty\xetexorluatextrue\else\xetexorluatexfalse\fi
%
% \newcommand{\ifxeorlua}[2]{\ifxetexorluatex#1\else#2\fi}

\newcommand{\ifxeorlua}{\ifboolexpr{bool{luatex} or bool{xetex}}}
% \ifdef{\iftutex}{
    \newcommand{\ifxetexorluatex}{\iftutex}
% }{
%   \newif\ifxetexorluatex
%   \begingroup\catcode94=7 \catcode0=9% ASCII 94 is ^
%   \def\empty{}\def\next{^^^^0000}\expandafter\endgroup
%   \ifx\next\empty\xetexorluatextrue\else\xetexorluatexfalse\fi
% }


% \ifxetexorluatex  % xelatex or lualatex
% \else% pdflatex
%   %%%%% Configure font encoding
%   \RequirePackage[T1]{fontenc}    % Use new T1 fonts
%   %%%%% Configure input encoding
%   \RequirePackage[utf8]{inputenc}    % Format for the input file(s), see the "enc" option
% \fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\instring#1#2{TT\fi\begingroup
  \edef\x{\endgroup\noexpand\in@{#1}{#2}}\x\ifin@}

% --------------------------------------------------------
% The NOVAthesis logo
\ifdef{\iftutex}{
  \newcommand{\novathesis}
      {\includegraphics[height=1.1\fontcharht\font`A,vshift=-0.35pt]{NOVAthesisFiles/Images/novathesis-text}}
}{
  \newcommand{\novathesis}{\textsl{novathesis}}
}

% --------------------------------------------------------
% Define something (except counters) if undefined
\newcommand*{\defifundef}[2]{\ifundef{#1}{#2{#1}}{}}

% --------------------------------------------------------
% Variant of \@for with an optional final argument, that is
% executed iif the loop is not interrupted
\def\ntforbreak{\@endfortrue}
\long\def\ntfor#1:=#2\do#3{\@ifnextchar[{\ntfor@i#1:=#2\do#3}{\ntfor@i#1:=#2\do#3[]}}
\long\def\ntfor@i#1:=#2\do#3[#4]{%
  \@for#1:={#2}\do{\xdef#1{#1}#3}%
  \if@endfor\else#4\fi
}

% --------------------------------------------------------
% Print string between <...>
\newcommand*{\embrace}[1]{#1}
% \newcommand*{\embrace}[1]{$\langle$#1$\rangle$}

% --------------------------------------------------------
% Search if a data/memory is defined and returns value
\def\datamatch#1#2(#3){%
  % #1 = macro to set
  % #2 = data@memory
  % #3 = list of values
  % Search and match first value from the list, error if no match is found
  \datamatchtf{#1}{#2}(#3){}{\ClassError{novathesis}{Could not find “#2” defined with any of “(#3)”!}{}}%
}

\def\datamatchtf#1#2(#3)#4#5{%
  % #1 = macro to set
  % #2 = data@memory
  % #3 = list of values
  % #4 = true branch
  % #5 = false branch
  % Search and match first value from the list, true (found) and not true (not found) branches
  % \typeout{#2(#3)}%
  \ifdatadefinedor{\@match}{#2}(#3)%
    {\protect\xdef#1{\csuse{the#2}(\@match)}#4}%
    {\protect\xdef#1{}#5}%
}

% --------------------------------------------------------
% Check if a font file exists
\newcommand*{\ntcheckfont}[2]{%
  \IfFileExists{NOVAthesisFiles/FontStyles/Fonts/#1}{}%
    {\ClassError{novathesis}{Missing font “#1”! Please download from: “#2” and copy it to “NOVAthesisFiles/FontStyles/Fonts/#1”}{Please download from: “#2” and copy it to “NOVAthesisFiles/FontStyles/Fonts/#1”}}%
}


% --------------------------------------------------------
% Load and Helvetica-like font as the default SF font
\newcommand*{\LoadHelveticaLikeFont}{%
  \IfFileExists{inter.sty}%
    {\RequirePackage{inter}}%
  {\IfFileExists{helvet.sty}%
    {\RequirePackage{helvet}}%
  {\IfFileExists{gillius2.sty}%
    {\RequirePackage{gillius2}}%
    {\ClassWarning{novathesis}{Could not find a suitable Sans Serif font… using the default!}}}}%
}

% --------------------------------------------------------
% Trim spaces around argument
\ExplSyntaxOn
\cs_new_eq:NN \trimspaces \tl_trim_spaces:n
\ExplSyntaxOff

% --------------------------------------------------------
% Input the first file from the list (if any)
% #1 = file name
% #2 = list of directories
% #3 = code if succeed [OPTIONAL]
% #4 = code if fails [OPTIONAL]
\def\@nt@InputIfFileExists#1#2{%
  % \typeout{IIFE 1=[#1] 2=[#2]}\aaaa
  \@ifnextchar[{\@nt@InputIfFileExists@i{#1}#2}{\@nt@InputIfFileExists@i{#1}#2[]}%
}
\def\@nt@InputIfFileExists@i#1#2[#3]{%
  % \typeout{IIFE 1=[#1] 2=[#2] 3=[#3]}\aaaa
  \@ifnextchar[{\@nt@InputIfFileExists@ii{#1}#2[#3]}{\@nt@InputIfFileExists@ii{#1}#2[#3][]}%
}
\def\@nt@InputIfFileExists@ii#1#2[#3][#4]{
  % \typeout{IIFE 1=[#1] 2=[#2] 3=[#3] 4=[#4]}\aaaa
  \ntfor\dir:=#2\do{\IfFileExists{\dir#1}{\input{\dir#1}#3\ntforbreak}{}}[#4]%
}


\options{/@nt/.new family,
  lang/short/.new list={en, pt, fr, it, de, es, gr},
  lang/current/.new choice={en, pt, fr, it, de, es, gr},
  lang/loaded/.new list={},
  lang/shorttolong/.new choice={en=english, pt=portuguese, fr=french, it=italian, de=german, es=spanish, gr=greek},
  fontenc/.new choice={en=T1, pt=T1, fr=T1, it=T1, de=T1, es=T1, gr=LGR},
  biblatex/.new list,
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE FOLDERS PER CLASS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/folders/.new choice={
  bib=Bibliography,
  copyright=.,
  statement=.,
  dedicatory=Chapters,
  acknowledgements=Chapters,
  quote=Chapters,
  abstract=Chapters,
  glossaries=Chapters,
  chapter=Chapters,
  appendix=Chapters,
  annex=Chapters,
  cover=Chapters,
}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE DOCUMENT CLASSES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/document/.cd,
   docclass/.new choice={phd=phd, phdprop=phd, phdplan=phd, msc=msc, mscplan=msc, bsc=bsc, plain=plain},
   docmain/.new list={phd, msc, bsc, plain},
}

% --------------------------------------------------------
% Check if the document is of a specific class, i.e., bsc, msc, phd or main
\newcommand{\ifdocclass}[1]{\ifoptionequal{/@nt/document/docclass}{#1}}
\newcommand{\ifmaindoc}{\ifoptioncontains{/@nt/document/docmain}{\@DOCTYPE}}
\newcommand{\ifphddoc}{\ifdocclass{phd}}
\newcommand{\ifmscdoc}{\ifdocclass{msc}}
\newcommand{\ifbscdoc}{\ifdocclass{bsc}}
\newcommand{\ifplaindoc}{\ifdocclass{plain}}

\newcommand{\ifdocstatus}[1]{\ifoptionequal{/novathesis/docstatus}{#1}}
\newcommand{\ifdocfinal}{\ifdocstatus{final}}
\newcommand{\ifdocprovisional}{\ifdocstatus{provisional}}
\newcommand{\ifdocworking}{\ifdocstatus{working}}
\newcommand{\ifdocunset}{\ifdocstatus{unset}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE PERSON LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ntaddperson#1(#2,#3)#4{%
  % syntax: \ntaddperson{class}[key,gender]{filename}
  % #1=adviser | committee
  % #2={a,c}            {c,r,a,m,g}
  %     a=adviser        c=chair
  %     c=coadviser      r=rapporteur/referee
  %                      a=adviser
  %                      ca=adviser
  %                      m=other members
  %                      g=guests
  % #3={m,f}
  % #4={person name, position, etc}
  \noexpandarg
  \StrCut{#4}{,}\@nt@personname\@nt@dummy%was xStrCut
  \options{/@nt/#1/#2/name/.expanded/.cpush={\@nt@personname}}%
  \options{/@nt/#1/#2/full/.expanded/.cpush={#4}}%
  \options{/@nt/#1/#2/gender/.cpush={#3}}%
  % \typeout{NTADD [/@nt/#1/#2/name=\@nt@personname]}%
  \fullexpandarg
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE FILE LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntaddfile}[1]{%
  % syntax: \ntaddfile{class}[key]{filename}
  %         #1=file family (quote, abstract, chapter, etc)
  %         #2=[file lang] (OPTIONAL)
  %         #3=filename
  \@nt@addtolist{file}{#1}%
}

\newcommand*{\@nt@addtolist}[2]{%
  % syntax: \ntaddto{type}{class}[key]{filename}
  %         #1 ={file, person}
  %         #2=family {quote, abstract, chapter, etc} or {author, adviser, committee}
  %         #3=[file lang] (OPTIONAL)
  %         #4=filename
  \@ifnextchar[{\@nt@addtolist@iv[#1]#2}{\@nt@addtolist@iv[#1]#2[\option{/novathesis/doctype}]}%
}

\def\@nt@addtolist@iv[#1]#2[#3]#4{%
  % syntax: \@ntaddfile@iii{type}{class}[key]{filename}
  %         #1 ={file, person}
  %         #2=file family (quote, abstract, chapter, etc)
  %         #3=optional file lang
  %         #4=filename
  % \typeout{NT addtolist [#1] [#2] [#3] [#4]}%
  \StrLeft{#4}{1}[\@nt@firstchar]%
  \IfStrEqCase{\@nt@firstchar}{%
    {/}{\xdef\@nt@filewithpath{#4}}%
    {.}{\xdef\@nt@filewithpath{#4}}%
  }[%
    \options{/@nt/folders=#2}%
    \xdef\@nt@filewithpath{\option{/@nt/folders}/#4}%
  ]%
  \@for\i:=\expanded{#3}\do{%
    % \typeout{NT addtolist [#1] [#2] [\i] [#4]}\NTaddtolist%
    \options{/@nt/#1/#2/\i/.expanded/.cpush={\@nt@filewithpath}}%
  }%
}

\newcommand*{\@nt@foralllist}[3]{%
  % #1={file, person}
  % #2=file family (quote, abstract, chapter, etc)
  % #3=macro to be applied, which will receive the item from the list
  \optionlistdo{/@nt/#1/#2}{#3{##1}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multilingual support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntselectlang}[1]{%
  % #1=lang {pt, en, fr, it}
  \options{/@nt/lang/current=#1}%
  \options{/@nt/lang/shorttolong=#1}%
  \expandafter\selectlanguage\expandafter{\expanded{\option{/@nt/lang/shorttolong}}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ASSOCARRAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\initmemory}[2][\embrace{\thenotdefined(\@LANG@COVER)}]{%
  \optionlistdo{/@nt/lang/short}{\csuse{#2}(##1):={#1}}}

% For PDF bookmakrs
\newdata{bkmstring}


\newdata{notdefined}
\newdata{keywordsenvpre}
\newdata{keywordsenvpost}
\newdata{keywordsblockpre}
\newdata{keywordsblockpost}
\newdata{keywordspre}
\newdata{keywordssep}
% \newdata{keywordsboxlen}
\newdata{keywordsstring}
\newdata{keywordsstringprefix}
\newdata{keywordsstringsuffix}
\newdata{keywordsstringfont}
\keywordsblockpre()={\bigskip\noindent}
\keywordsstringsuffix()={:\enspace}
\keywordsstringfont()={\bfseries}
% \keywordssep()={\ \textbf{\Large\textperiodcentered}\ }
\keywordssep()={, }
% \keywordsboxlen()={\textwidth-\widthof{\usebox{\keywordsstringbox}}}

\newdata{specializationstring}
\newdata{departmentofstring}
\newdata{sponsor}
\newdata{andstring}
\newdata{commastring}
\optionlistdo{/@nt/lang/short}{%
  \commastring(#1):={,\ }%
}


\newdata{degreestring}
\newdata{degreestringfont}

\newdata{degreename}
\newdata{degreenamefont}

\newdata{degreenameprefix}
\newdata{degreenameprefixfont}

\newdata{doctypestring}
\newdata{doctypestringfont}



\newdata{adviserstring}            % e.g., "Adviser", "Co-adviser"
\newdata{adviserstringfont}
\newdata{adviserstringpre}
\newdata{adviserstringpost}

\newdata{advisernamepre}
\newdata{advisernamepost}
\newdata{advisernamefont}

\newdata{adviserremainderpre}
\newdata{adviserremainderpost}
\newdata{adviserremainderfont}
\adviserremainderfont()={\itshape\scriptsize}

% Committee stuff
\newdata{adviserorder}         %e.g., "{a,c}"
\adviserorder():={a,c}  % By default print advisers and co-advisers
\newdata{committeeorder}         %e.g., "{c,r,a,m,g}"

\newdata{committeetitlestring}      %e.g., "Examinaiton Committee"
\newdata{committeetitlestringpre}
\newdata{committeetitlestringpost}
\newdata{committeetitlestringfont}

\newdata{committeestring}
\newdata{committeestringpre}
\newdata{committeestringpost}
\newdata{committeestringfont}

\newdata{committeenamepre}
\newdata{committeenamepost}
\newdata{committeenamefont}

\newdata{committeeremainderpre}
\newdata{committeeremainderpost}
\newdata{committeeremainderfont}
\committeeremainderfont()={\itshape\scriptsize}

\newdata{personpost}
\newdata{persongrouppost}

\newdata{dissertationstring}
\newdata{dissertationstringfont}

\newdata{copyrighttextstring}
\newdata{acknowledgmentsstring}

\newdata{majorfield}
\newdata{minorfield}
\newdata{specialization}

\newdata{spine}
\newdata{thesiscover}
\newdata{margin}
\newdata{frontpageimage}

% \newcommand*{\@nt@newmemory}[1]{%
%   \newdata{#1}%
%   % \initmemory[\embrace{\MakeUppercase{#1}}]{#1}%
% }
% \forcsvlist{\@nt@newmemory}{university,school,department}
\newdata{university}
\newdata{school}
\newdata{department}

\newdata{doctitle}


% For each main language, list which abstracts shall be printed and in which order
% may have more than two (just be sure you include the languages above as well)
% \newdata{setabstractorder}
% \setabstractorder(pt):={pt,en}
% \setabstractorder(en):={en,pt}
% \setabstractorder(fr):={fr,en}
% \setabstractorder(it):={it,en}
% \setabstractorder(es):={es,en}
% \setabstractorder(de):={de,en}
% \setabstractorder(gr):={gr,en}





% --------------------------------------------------------
% PROCESSING CLASS OPTIONS
\options@ProcessOptions{/novathesis}
% --------------------------------------------------------
% NTSETUP2
\newcommand*{\ntsetup}[2][]{%
  % \typeout{NTSETUP [/novathesis/\option{/novathesis/school}/#1/\@ntopt]}\NTSETUP%
  \ntfor\arg:={#2}\do{%
    \StrCut{\arg}{=}{\@ntopt}{\@ntval}%
    % \typeout{NTSETUP2 [\@ntopt] = [\@ntval]}%
    \ifoptiondefined{/novathesis/\@nt@univ/\@nt@schl/#1/\@ntopt}%
                    {\options{/novathesis/\@nt@univ/\@nt@schl/#1/#2}}{%
    \ifoptiondefined{/novathesis/#1/\@ntopt}%
                    {\options{/novathesis/#1/#2}}{%
    \ifoptiondefined{/novathesis/\@nt@univ/\@nt@schl/\@ntopt}%
                     {\options{/novathesis/\@nt@univ/\@nt@schl/#2}}{%
    \ifoptiondefined{/novathesis/\@ntopt}%
                    {\options{/novathesis/#2}}{%
    \ClassError{Invalid class option: \@ntopt}{}{}}}}}}%
}

\newcommand*{\ntbibsetup}[1]{%
  \@ifpackageloaded{biblatex}{\bibsetup{#1}}{\PassOptionsToPackage{#1}{biblatex}}%
  % {\options{/@nt/biblatex/.push={#1}}}%
}

\newcommand*{\NTAddToHook}[2]{\options{/@nt/hook/#1/.cpush={#2}}}

\newcommand*{\NTRunHook}[1]{\optionlistdo{/@nt/hook/#1}{##1}}

% \newcommand*{\NTIfHook}[1]{%
%   \ifoptiondefined{/@nt/hook/#1}%
% }


% --------------------------------------------------------
% Pass the remaining options to memoir
% \letoptionlist{/options/remaining}\nt@remaining
% \PassOptionsToClass{\nt@remaining}{memoir}





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING CUSTOMIZATION STUFF - part 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% Define DEFAULT corollaryUES for COVER and COPYRIGHT languages
%     and HYPERLINK color
\options{/novathesis/.cd,
  lang/cover = \option{/novathesis/lang/main},
  lang/copyright = \option{/novathesis/lang/main},
  color/links = DarkBlue,
}


% \NTRunHook{memoir}

%============================================================
%  TEMPLATE CUSTOMIZATION / OPTIONS
%      Please open and edit the appropriate
%       configuration file “Config/1_novathesis.tex”
%============================================================
\input{Config/1_novathesis}
\def\@DOCTYPE{\option{/novathesis/doctype}}
\def\@DOCSTATUS{\option{/novathesis/docstatus}}

\options{/@nt/document/docclass=\@DOCTYPE}
\def\@DOCCLASS{\option{/@nt/document/docclass}}

\def\@LANG@COVER{\option{/novathesis/lang/cover}}
\def\@LANG@COPYRIGHT{\option{/novathesis/lang/copyright}}
\def\@LANG@MAIN{\option{/novathesis/lang/main}}
\options{/@nt/lang/shorttolong=\@LANG@MAIN}%
\edef\@LANG@MAIN@LONG{\option{/@nt/lang/shorttolong}}

\def\@DEGREEACR{\option{/novathesis/degreeacr/\@DOCCLASS}}

\bkmstring(1-1)={\thebkmstring(cover,\@LANG@COVER)}
\bkmstring(2-1)={\thebkmstring(frontpage,\@LANG@COVER)}
\bkmstring(N-2)={\thebkmstring(backcover,\@LANG@COVER)}
\bkmstring(spine)={\thebkmstring(spine,\@LANG@COVER)}
% \NTRunHook{novathesis}

\ifoptioncontains{/novathesis/abstract/theorder}{unset}{%
  \letoptionchoices{/novathesis/abstract/deforder}{\@abst@rder@langs}%
  \if\instring{,\@LANG@MAIN,}{,\@abst@rder@langs,}%
    \options{/novathesis/abstract/deforder=\@LANG@MAIN}%
  \else
    \options{/novathesis/abstract/deforder=default}%
  \fi
  \ntsetup{setabstractorder=\expanded{\option{/novathesis/abstract/deforder}}}%
}{}

%============================================================
% BIBLATEX CUSTOMIZATION
%      Please open and edit the appropriate
%       configuration file “Config/2_biblatex.tex”
%============================================================
\input{Config/2_biblatex}
% \NTRunHook{biblatex}


%============================================================
% LOAD ADDITIONAL PACKAGES
%============================================================

% Load additional symbols
% \RequirePackage[full]{textcomp}

%%%%% Configure multilingual language support
\RequirePackage{csquotes}
\RequirePackage{url}
\RequirePackage{xstring}

\RequirePackage[english]{babel}      % Support for multilingual documents
\RequirePackage{tikz}

\RequirePackage{translator} % Support month name translations for pgfcalendar
% \newcommand{\definelanguagealias}[2]{%
%   \@namedef{languagealias@#1}{#2}%
% }
% \definelanguagealias{portuguese}{portuguese}
% \letoptionchoices{/@nt/lang/shorttolong}\opt@choices
% \@for\i:=\opt@choices\do{%
%   \options{/@nt/lang/shorttolong=\i}
%   \typeout{CHOICE [\i, \option{/@nt/lang/shorttolong}]}%
%   \definelanguagealias{\expanded{\i}}{\expanded{\option{/@nt/lang/shorttolong}}}%
% }

% \RequirePackage{appendix}

% \RequirePackage{printlen}
% \uselengthunit{mm}\printlength{\linewidth}

%%%%% Fine tuning of typesetting
\ifxeorlua{}{% pdflatex
  \RequirePackage[%
    babel=true,
    activate={true,nocompatibility},  % activate={true,nocompatibility} - activate protrusion and expansion
    final,            % final - enable microtype; use "draft" to disable
    tracking=true,    % tracking=true - activate this technique
    kerning=true,     % kerning=true - activate this technique
    spacing=true,     % spacing=true - activate this technique
    factor=1100,      % factor=1100 - add 10% to the protrusion amount (default is 1000)
    stretch=10,       % stretch=10 - reduce stretchability (default is 20)
    shrink=10,        % shrink=10 - reduce shrinkability (default is 20)
  ]{microtype}
}

%%%%% Better support for string manipulation


% To use a wide range of color names
% \RequirePackage{xcolor}%

\RequirePackage{colortbl}
\definecolor{darkblue}{rgb}{0.0,0.08,0.45}%


\iftoggle{/novathesis/print/index}{
  \AtEndPreamble{
    \ntaddtoprintorder{mainmatter}{index}
    \RequirePackage{imakeidx}
    % \makeindex[intoc,columns=2,options=-s myindexstyle]%
    \makeindex[intoc,columns=2,options=-s  NOVAthesisFiles/ntindexstyle]
  }
}{}

% Fixing autoref in yperref
\RequirePackage{NOVAthesisFiles/fix-hyperref}

%--------------------------------
% “biblatex” stuff
\ntaddfile{bib}{./NOVAthesisFiles/fix-bib.bib}%
% \AtEndDocument{\nocite{novathesis-manual}}%
% \letoptionlist{/@nt/biblatex}\@nt@biblatex@opts%
\RequirePackage[hyperref=auto,defernumbers=true]{biblatex}%

%--------------------------------
% “hyperref” stuff
\RequirePackage[%
  , bookmarksnumbered=true%
  , breaklinks=true%
  , colorlinks=true%
  , pdfdisplaydoctitle=true%
  , unicode=true%
]{hyperref}%
\@nt@fixhyperref%
% \pdfstringdefDisableCommands{%
%   \def\\{}%
%   \def\texttt#1{#1}%
% }%
\RequirePackage{bookmark}%
% \RequirePackage{memhfixc}%   Must be used on memoir document class after hyperref

%--------------------------------
% “glossasries” stuff - after hyperref
\RequirePackage[%
  % , nonumberlist
  translate=babel,
  acronym,           % add acronyms listing
  symbols,           % add symbols listing
  % sanitizesort=false, % allow \gls inside descriptions
  xindy={language=\@LANG@MAIN@LONG},
  nolong,
  nosuper,
  nolist,
  notree,
  nostyles,
  automake,
]{glossaries-extra}% To create glossaries
\RequirePackage{NOVAthesisFiles/glossary-xltabular}%
\setglossarystyle{xltabular}%
\setabbreviationstyle[acronym]{long-short}%
\GlsXtrEnablePreLocationTag{\emph{(\small p.~}}{\emph{(\small pp.~}}
\patchcmd{\@gls@automake@immediate}{-I xindy}{-q -I xindy}{}{}
% \renewcommand{\gls@automake@makegloss}{makeglossaries -q}%
\renewcommand{\GlsXtrFormatLocationList}[1]{\emph{\small#1)}}
\renewcommand{\glsnamefont}[1]{\textbf{#1}}%

%--------------------------------
% “Process gnumberlist” option - after glossaries
\iftoggle{/novathesis/gnumberlist}{}{\setupglossaries{nonumberlist}}%
\AtEndPreamble{\@loadglossaryfiles\makeglossaries}%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include strings for all the languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@LANG@LOADED{}
\def\@langs@loaded@sep{}
\newcommand*{\@nt@loadlangs}[1]{%
  \optionlistdo{/novathesis/#1}{%
      % \typeout{LL=##1}\LL
      \InputIfFileExists{NOVAthesisFiles/Strings/strings-##1.ldf}%
                        {\if\instring{,##1,}{,\@LANG@LOADED,}\else
                          \eappto{\@LANG@LOADED}{\@langs@loaded@sep##1}\def\@langs@loaded@sep{,}\fi%
                        }%
                        {\ClassError{novathesis}{File not found: “NOVAthesisFiles/Strings/strings-##1.ldf” file!}%
                                                {Add a file with the translations for this language.}}%
  }%
}
\@nt@loadlangs{abstract/theorder}
\@nt@loadlangs{lang/extra}
% \letoptionlist{/@nt/lang/loaded}\LANGLOADED
% \typeout{LANGLOADED=\@LANG@LOADED}\LLLLL
\options{/@nt/lang/loaded/.expanded=\@LANG@LOADED}

% --------------------------------------------------------
% FIX BABEL TRANSLATION
\input{NOVAthesisFiles/fix-babel.tex}

% --------------------------------------------------------
% BABEL STUFF
\options{/@nt/lang/shorttolong=\@LANG@MAIN}%
\PassOptionsToPackage{main=\option{/@nt/lang/shorttolong}}{babel}
% \typeout{MAIN: [\@LANG@MAIN \option{/@nt/lang/shorttolong}]}\aaa
\optionlistdo{/novathesis/lang/extra}{%
  \options{/@nt/lang/shorttolong=#1}%
  \PassOptionsToPackage{\option{/@nt/lang/shorttolong}}{babel}%
  \PassOptionsToPackage{\option{/@nt/lang/shorttolong}}{translator}%
  % \typeout{USED: [#1] [\option{/@nt/lang/shorttolong}] [\option{/@nt/fontenc}]}\bbb
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEFINITIONS FOR THE REMINDER OF CUSTOMIZATION STUFF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------
% Department
\def\ntdepartment{\@ifstar{\@ntdepartmentifundef}{\@ntdepartment}}
\def\@ntdepartmentifundef(#1)#2{\ifdatadefined{department}(#1){}{\@ntdepartment(#1){#2}}}
\def\@ntdepartment(#1)#2{\department(#1):={#2}}

% --------------------------------------------------------
% Degree
\def\ntmajorfield{\@ifstar{\@ntmajorfieldifundef}{\@ntmajorfield}}
\def\@ntmajorfieldifundef(#1)#2{\ifdatadefined{majorfield}(#1){}{\@ntmajorfield(#1){#2}}}
\def\@ntmajorfield(#1)#2{\majorfield(#1):={#2}}

\def\ntdegreename{\@ifstar{\@ntdegreenameifundef}{\@ntdegreename}}
\def\@ntdegreenameifundef(#1)#2{\ifdatadefined{degreename}(#1){}{\@ntdegreename(#1){#2}}}
\def\@ntdegreename(#1)#2{%
  % #1 = ignored
  % #1 = lang
  % #2 = value
  \datamatch{\match}{degreenameprefix}(%
            {\@DOCTYPE,\@DEGREEACR,\@LANG@COVER},%
            {\@DOCCLASS,\@DEGREEACR,\@LANG@COVER},%
            {\@DEGREEACR,\@LANG@COVER},%
            {\@DOCTYPE,\@LANG@COVER},%
            {\@DOCCLASS,\@LANG@COVER},%
            {\@LANG@COVER}%
  )%
  \ifblank{\match}{\degreename(#1):={#2}}{\degreename(#1):={\match\ #2}}%
  \majorfield(#1):={#2}%
}
% --------------------------------------------------------
% Specialization
\def\ntminorfield{\@ifstar{\@ntminorfieldifundef}{\@ntminorfield}}
\def\@ntminorfieldifundef(#1)#2{\ifdatadefined{minorfield}(#1){}{\@ntminorfield(#1){#2}}}
\def\@ntminorfield(#1)#2{\minorfield(#1):={#2}}

\def\ntspecialization{\@ifstar{\@ntspecializationifundef}{\@ntspecialization}}
\def\@ntspecializationifundef(#1)#2{\ifdatadefined{specialization}(#1){}{\@ntspecialization(#1){#2}}}
\def\@ntspecialization(#1)#2{%
  \datamatch{\match}{specializationstring}(%
            {\@DOCTYPE,\@DEGREEACR,\@LANG@COVER},%
            {\@DOCCLASS,\@DEGREEACR,\@LANG@COVER}%
            {\@DEGREEACR,\@LANG@COVER},%
            {\@DOCTYPE,\@LANG@COVER},%
            {\@DOCCLASS,\@LANG@COVER},%
            {\@LANG@COVER}%
  )%
  \ifblank{\match}{\specialization(#1):={#2}}{\specialization(#1):={\match\ #2}}%
  \minorfield*(#1):={#2}%
}

% --------------------------------------------------------
% Sponsors
\def\ntsponsors(#1)#2{\sponsor(#1):={#2}}

% --------------------------------------------------------
% Title
\def\nttitle(#1,#2)#3{%
  % #1 = type (main, sub, spine) title
  % #2 = lang
  % #3 = value
  % \typeout{NT TITLE [#1] [#2] [#3]}%
  \noexpandarg
  \StrSubstitute{#3}{\\}{ }[\@nt@cleantitle]
  % \typeout{XXXX [\@nt@cleantitle]}\aaa
  \doctitle(#2,#1):={\@nt@cleantitle}%
  \doctitle(#2,#1,cover):={#3}%
  \IfStrEq{#1}{main}{\doctitle(#2,spine):={\@nt@cleantitle}}{}%
  % \doctitle(#2,#1):={\ntnolinebreak{#3}}%
  % \doctitle(#2,#1,cover):={#3}%
  % \IfStrEq{#1}{main}{\doctitle(#2,spine):={\ntnolinebreak{#3}}}{}%
  \fullexpandarg
}

% \newcommand{\ntnolinebreak}[1]{{\def\\{\ }#1}}
% --------------------------------------------------------



%============================================================
% Date and month
\newdata{ntdocdate}
\ntdocdate(year):={year}
\ntdocdate(month):={month}

\def\ntdate#1{\@ntdate@i#1--\@relax}
% \def\@ntdate@i#1-#2\@relax{\@ntdate@ii#1-#2-\@relax}
\def\@ntdate@i#1-#2-#3\@relax{%
  % year           -> [year] [] []
  % year-month     -> [year] [month] [-]
  % year-month-day -> [year] [month] [day--]
  % \typeout{NTDOCDATE [#1] [#2] [#3]}\NTDOCDATE
  \ntdocdate(year):={#1}%
  \ntdocdate(month):={#2}%
  \ifstrequal{#3}{-}{\ntdocdate(day):={}}{\StrGobbleRight{#3}{2}[\@nt@date@day]\ntdocdate(day):={\@nt@date@day}}%
  % \typeout{NTDOCDATE [\thentdocdate(year)] [\thentdocdate(month)] [\thentdocdate(day)]}\NTDOCDATE
}


%============================================================
% Author identification
\newdata{docauthor}
\docauthor(name):={Author Name}
\docauthor(name,short):={Author Short Name}
\docauthor(gender):={Author Gender}
\docauthor(degree,\@LANG@COVER):={Author Previous Degree}

\def\ntauthorname(#1)#2#3{% [m|f]{Long name}{Short name}
  \docauthor(gender):={#1}%
  \docauthor(name):={#2}%
  \docauthor(name,short):={#3}}

\def\ntauthordegree(#1)#2{\docauthor(degree,#1):={#2}}

%============================================================
% Adding list_of
\newcommand*{\ntaddlistof}[2][]{%
  \IfStrEqCase{#2}{%
    {tableofcontents}{\options{/@nt/list/listof/.cpush={%
            \iftoggle{/novathesis/tocintoc}{\tableofcontents}%
                  {\pdfbookmark{\contentsname}{toctarget}%
                  \hypertarget{toctarget}{\tableofcontents*}}}}}%
    {listoffigures*}{\options{/@nt/list/listof/.cpush={%
            \pdfbookmark{\listfigurename}{loftarget}%
            \hypertarget{loftarget}{\listoffigures*}}}}%
    {listoftables*}{\options{/@nt/list/listof/.cpush={%
            \pdfbookmark{\listtablename}{lottarget}%
            \hypertarget{lottarget}{\listoftables*}}}}%
    {listoflistings}{\options{/@nt/list/listof/.cpush={%
            \pdfbookmark{\listoflistingscaption}{loltarget}%
            \hypertarget{loltarget}{\listoflistings}}}}%
    {listofalgorithms}{\options{/@nt/list/listof/.cpush = {%
            \listofalgorithms
            \ifdefined\listalgorithmname%
              \addcontentsline{toc}{chapter}{\listalgorithmname}%
            \else\ifdefined\listalgorithmcfname%
              \addcontentsline{toc}{chapter}{\listalgorithmcfname}%
            \else
              \ClassError{novathesis}{Can't make list of algorithms. Please report this problem in the “novathesis” github. Thanks!}{}%
            \fi\fi}}}%
    % {listsofglossaries}{\options{/@nt/list/listof/.cpush={%
    %         \glstoctrue%
    %         % \iffileadded[glossary]{glossaries}{\patchcmd{\@glo@types}{,main}{}{}{}}{}}%
    %         }}%
    % {listsofglossaries*}{\options{/@nt/list/listof/.cpush={%
    %         \glstocfalse%
    %         % \iffileadded[glossary]{glossaries}{\patchcmd{\@glo@types}{,main}{}{}{}}{}}%
    %         }}%
  }[%
            \if\relax\detokenize{#1}\relax
              \options{/@nt/list/listof/.cpush={\ifdefmacro{#2}{#2}{\csuse{#2}}}}%
            \else
              \options{/@nt/list/listof/.cpush={\ifdefmacro{#2}{#2[#1]}{\csuse{#2}[#1]}}}%
            \fi
   ]%
}

%============================================================
% Print document “parts/sections/regions”
\newcommand*{\ntprint}[1]{%
  \IfStrEqCase{#1}{%
    {frontmatter}{%
          % \iftoggle{/novathesis/print/secondcover}{}{\setcounter{page}{1}}%
          \iftoggle{/novathesis/print/frontmatter}{\ntprintlist{/@nt/print/#1}}{}}%
    {mainmatter}{%
            \ntprintlist{/@nt/print/#1}}%
  }[\ifdefmacro{#1}{#1}{\csuse{ntprint#1}\clearforchapter}]%
  \ignorespaces%
}

\newcommand*{\ntprintlist}[1]{%
  \optionlistdo{#1}{%
    \ifdefmacro{##1}{##1}{%
      \ifcsmacro{ntprint##1}%
            {\NTRunHook{ntprint##1/pre}\csuse{ntprint##1}\NTRunHook{ntprint##1/post}}%
            {\ifcsmacro{##1}{\NTRunHook{##1/pre}\csuse{##1}\NTRunHook{##1/post}}
                            {\ClassError{novathesis}{Invalid contents for frontmatter or mainmatter: [##1]}{}}}}
    \clearforchapter}%
}

\newcommand*{\ntsetprintorder}[2]{%
  % #1 = frontmatter, mainmatter
  % #2 = list
  % \typeout{[#1] [#2]}
  \option@setlist[;]{/@nt/print/#1}{#2}%
}

\newcommand*{\ntaddtoprintorder}[2]{%
  % #1 = frontmatter, mainmatter
  % #2 = list
  % \typeout{[#1] [#2]}
  \options{/@nt/print/#1/.push=#2}%
}

% \newcommand*{\ntremovefromprintorder}[2]{%
% % #1 = frontmatter, mainmatter
% % #2 =single item to remove
%   \@for\@nt@item:=#2\do{\options{/@nt/print/#1/.remove = {\@nt@item}}}}

% --------------------------------------------------------
% DEFAULT VALUES FOR frontmatter AND mainmatter
\newdata{printorder}

\printorder(frontmatter,final):={%
  statement;       % The statement page
  copyright;       % (*) The copyright page
  dedicatory;      % (*) Print the dedicatory
  acknowledgements;% (*) Print the acknowledgments
  quote;           % (*) Print the quote
  abstracts;       % Print abstracts in multiple languages.
  alllistof;       % Print all the listof defined in “6_list_of.tex”
  printglossaries; % Print the Glossary, Acronyms, Symbols, etc…
}

\printorder(frontmatter,provisional):={%
  statement;       % The statement page
  copyright;       % (*) The copyright page
  dedicatory;      % (*) Print the dedicatory
  acknowledgements;% (*) Print the acknowledgments
  quote;           % (*) Print the quote
  abstracts;       % Print abstracts in multiple languages.
  alllistof;       % Print all the listof defined in “6_list_of.tex”
  printglossaries; % Print the Glossary, Acronyms, Symbols, etc…
}

\printorder(frontmatter,working):={%
  abstracts;       % Print abstracts in multiple languages.
  alllistof;       % Print all the listof defined in “6_list_of.tex”
  printglossaries; % Print the Glossary, Acronyms, Symbols, etc…
}

\ifoptionequal{/novathesis/print/webography}{}{%
  \ntsetprintorder{mainmatter}{
    chapters;        % Print document chapters
    bib;             % Print the bibliography.  Change to
     %    “bib[title=⟨title⟩]” to redefine the title!
    appendices;      % Print appendices; if any!
    annexes;         % Print annexes; if any!
  }%
}{%
  \ntsetprintorder{mainmatter}{
    chapters; % Print document chapters
    \printbibliography[nottype=online]; % Print the bibliography.
    \printbibliography[title=\option{/novathesis/print/webography},type=online]; % Print the bibliography.
    appendices; % Print appendices, if any!
    annexes; % Print annexes, if any!
  }%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COVER DEFINITION MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntaddtocover}[3][]{%
  % #1 = cover atrtibutes
  % #2 = list of covers where the code block should be applied
  % #3 = the block code
  % \typeout{NT ntaddtocover [/@nt/cover/\@nt@univ/\@nt@schl/element=#1]}%
  % \forcsvlist{\@ntaddtocover@iii{#1}{#3}}{#2}%
  \ntfor\arg:={#2}\do{\@ntaddtocover@iii{#1}{#3}{\arg}}%
}

\newcommand*{\@ntaddtocover@iii}[3]{%
  % \typeout{NT ntaddtocover #3}%
  % #1 = cover atrtibutes
  % #2 = the block code
  % #3 = covers where the code block should be applied
  \ntfor\arg:={#3}\do{\options{/@nt/cover/\@nt@univ/\@nt@schl/\arg/.cpush={{#1}\@nil{#2}}}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING SCHOOLS's “defaults.ldf”, including cover design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ntfor\match:={\@nt@univ,\@nt@univ/\@nt@schl}\do{%
    \IfFileExists{NOVAthesisFiles/Schools/\match/Images/DO_NOT_REMOVE_THIS_FILE.txt}{%
            \prependtographicspath{{NOVAthesisFiles/Schools/\match/Images/}}}{}}


%============================================================
%  UNIVERSITY/SCHOOL SPECIFIC MATERIALS
%  configuration file “Config/9_<university>_<school>.tex”
%============================================================
\IfFileExists{Config/9_\@nt@univ_\@nt@schl.tex}
     {\def\@ntsetuplevel{\@nt@univ/\@nt@schl/}\input{Config/9_\@nt@univ_\@nt@schl.tex}}
     {\def\@ntsetuplevel{\@nt@univ/}\InputIfFileExists{Config/9_\@nt@univ.tex}{}{}}
\def\@ntsetuplevel{}

\InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@univ-defaults.ldf}{}
    {\PackageError{novathesis}{Missing file “/\@nt@univ/\@nt@univ-defaults.ldf”}{}}

\ntfor\match:={%
      \@nt@univ-\@nt@schl-\@DEGREEACR,%
      \@nt@univ-\@nt@schl%
  }\do{%
      \IfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/\match-defaults.ldf}
              {\input{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/\match-defaults.ldf}\ntforbreak}{}%
  }
[\PackageError{novathesis}{Missing file “NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl-defaults.ldf”}{}]



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifxetexorluatex  % xelatex or lualatex
  \RequirePackage{fontspec}%
  \defaultfontfeatures{Ligatures=TeX}
\else% pdflatex
  \RequirePackage[T1]{fontenc}    % Use new T1 fonts
  % \RequirePackage[utf8]{inputenc}    % Format for the input file(s), see the "enc" option
\fi


% --------------------------------------------------------
% Customize the pagestyle
\makepagestyle{novathesis@mainmatter}
\makeoddfoot{novathesis@mainmatter}{}{\thepage}{}
\makeevenfoot{novathesis@mainmatter}{}{\thepage}{}
\makeheadrule{novathesis@mainmatter}{\textwidth}{\normalrulethickness}
\makeevenhead{novathesis@mainmatter}{\small\textsc{\leftmark}}{}{}
\makeoddhead{novathesis@mainmatter}{}{}{\small\textsc{\rightmark}}

\makepagestyle{novathesis@frontmatter}
\makeoddfoot{novathesis@frontmatter}{}{\thepage}{}
\makeevenfoot{novathesis@frontmatter}{}{\thepage}{}

\ifoptionequal{/novathesis/media}{paper}{\ntsetup{color/links=Black}}{}


% --------------------------------------------------------
% If option “debug={index}” option is active,
%     highlight index keywords in the main text
\providecommand*{\debugindexcolor}{red!50}
\ifoptioncontains{/novathesis/debug}{index}{%
  % \PassOptionsToPackage{inline}{showlabels}%
  \AtEndPreamble{\RequirePackage{showlabels}%
  \showlabels[\color{\debugindexcolor}]{index}}%
}{}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING CUSTOMIZATION STUFF - part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%============================================================
%  THESIS/DISSERTATION COVER DATA (title, author, etc)
%   Please open and edit the appropriate
%       configuration file “Config/3_cover.tex”
%============================================================
\input{Config/3_cover}
% \NTRunHook{cover}

% Patch month from number to string in the proper language
\IfInteger{\thentdocdate(month)}{%
  % \edef\@nt@datemonth{\thentdocdate(month)}%
  % \ntdocdate(month):={\bgroup\ntselectlang{\@LANG@COVER}\monthname[\thentdocdate(month)]\egroup}%
  \RequirePackage{pgfcalendar}%
  \ntdocdate(month):={\pgfcalendarmonthname{\thentdocdate(month)}}%
}{}

%============================================================
%  THESIS/DISSERTATION FILES
%   Please open and edit the appropriate
%       configuration file “Config/4_files.tex”
%============================================================
\input{Config/4_files}
% \NTRunHook{files}

%============================================================
% ADDITIONAL PACKAGES and MACROS
%      Please open and edit the appropriate
%       configuration file “Config/8_packages.tex”
%============================================================
% \newcommand{\BeforeHyperref}[1]{\NTAddToHook{packages/pre}{#1}}
% \newcommand{\AfterHyperref}[1]{\NTAddToHook{packages/post}{#1}}
% \NTRunHook{packages/pre}
\AtEndPreamble{\input{Config/5_packages}}
% \NTRunHook{packages/post}

%============================================================
%  WHICH LIST_OF TO PRINT
%   Please open and edit the appropriate
%       configuration file “Config/6_list_of.tex”
%============================================================
\AtEndPreamble{\makeatletter\NTRunHook{list_of/pre}\input{Config/6_list_of}\NTRunHook{list_of/post}}

\setcounter{biburlnumpenalty}{100}% Allow to break DOIs in bibliography
\optionlistdo{/@nt/file/bib/\option{/novathesis/doctype}}{%
  % \typeout{ADDBIB=#1}\ADDBIB
  \addbibresource{#1}%
}%

\ifdocunset{\ntsetup{docstatus=working}}{}

% \typeout{\theprintorder(frontmatter,\@DOCSTATUS)}
\ntsetprintorder{frontmatter}{\expanded{\theprintorder(frontmatter,\@DOCSTATUS)}}%

\ifoptionequal{/novathesis/spine}{unset}
    {\ifdocworking{\ntsetup{spine=no}}{\ifmaindoc{\ntsetup{spine=trim}}{\ntsetup{spine=no}}}}{}
\ifdocfinal{\ntsetup{print/committee=true}}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@nt@loadallfiles}[3][]{\optionlistdo{/@nt/file/#3/#2}{\@ntloadfile@i{##1}#1}}

\newcommand{\@ntloadfile@i}[2][]{\IfFileExists{#2}{\input{#2}}{#1}}

\newcommand{\@ntloadfiles@ii}[2][\option{/novathesis/doctype}]{%
  % #1=KEY
  % #2=file class
  \iffileadded[#1]{#2}{\@nt@loadallfiles[\clearforchapter]{#1}{#2}}{}%
}

\newcommand{\iffileadded}[2][\option{/novathesis/doctype}]{\ifoptiondefined{/@nt/file/#2/#1}}

% --------------------------------------------------------
% LOAD A DEFAULT COPYRIGHT PAGE DEFINITION
\newcommand{\@nt@AddFileIfExists}[1]{%
% #1 = class
% #2 = sub class [OPTIONAL]
% #3 = file name
% #4 = dir list
% #5 = action if not found [OPTIONAL]
  \@ifnextchar[{\@nt@AddFileIfExists@i{#1}}{\@nt@AddFileIfExists@i{#1}[\option{/novathesis/doctype}]}%
}

\def\@nt@AddFileIfExists@i#1[#2]#3#4{%
  \@ifnextchar[{\@nt@AddFileIfExists@ii{#1}[#2]{#3}#4}{\@nt@AddFileIfExists@ii{#1}[#2]{#3}#4[]}%
}

\long\def\@nt@AddFileIfExists@ii#1[#2]#3#4[#5]{%
  \ntfor\arg:=#4\do{\IfFileExists{\arg#3}{\ntaddfile{#1}[#2]{\arg#3}\ntforbreak}{}}[#5]%
}


% \newcommand{\@nt@AddFileIfExists}[4][]{%
% % #1 = OPTIONAL action if not found
% % #2 = class
% % #3 = file name
% % #4 = dir list
%   \ntfor\arg:=#4\do{\@nt@AddFileIfExists@i{#2}{#3}{\arg}}[#1]%
% }
%
% \newcommand{\@nt@AddFileIfExists@i}[3]{%
% % #1 = class
% % #2 = file name
% % #3 = dir list
%   \IfFileExists{#3#2}{\ntaddfile{#1}{#3#2}\ntforbreak}{}%
% }

\ifmaindoc{% only print if a main document
  \iftoggle{/novathesis/print/copyright}{% if copuyright toggle is on
    \@nt@AddFileIfExists{copyright}{copyright.ldf}{%
           {NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/}%
          ,{NOVAthesisFiles/Schools/\@nt@univ/}%
          ,{NOVAthesisFiles/}%
    }%
    \@ntloadfiles@ii{copyright}%
  }{}%
}{}

\ifoptionequal{/novathesis/spine}{no}{}{%
  \@nt@InputIfFileExists{spine.tex}{%
           {NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/}%
          ,{NOVAthesisFiles/Schools/\@nt@univ/}%
          ,{NOVAthesisFiles/}%
  }[][\ClassError{novathesis}{No “spine” file found.}{}]%
  \AtEndDocument{\csuse{ntprintspine}}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEBUG - print grid over covers and spine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\debuggrid}[1][orange]{%
  \begin{tikzpicture}[remember picture, semitransparent, overlay, shift=(current page.north west)]%
    \draw[step=1mm, line width=0.1mm, #1!30!white, yscale=-1] (\@nt@margin@left, \@nt@margin@top)
              grid (\paperwidth-\@nt@margin@right, \paperheight-\@nt@margin@bottom);
    \draw[step=5mm, line width=0.2mm, #1!40!white] (current page.north west)
              grid (current page.south east);
    \draw[step=1cm, line width=0.3mm, #1!90!white] (current page.north west)
              grid (current page.south east);
    \draw[step=5cm, line width=0.5mm, #1!50!white] (current page.north west)
              grid (current page.south east);
    \end{tikzpicture}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PRINT DOCUMENT PARTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ifcoverdefined}[3][1-1]{%
  % #1 = cover number
  % #2 = true branch
  % #3 = false branch
  % \edef\asd{/@nt/cover/\@nt@univ/\@nt@schl/#1}
  % \show\asd
  \ifoptiondefined{/@nt/cover/\@nt@univ/\@nt@schl/#1}{#2}{%
    \datamatchtf{\match}{thesiscover}(%
       {\@DOCTYPE,\@DEGREEACR,#1,bgcolor}%
      ,{\@DOCCLASS,\@DEGREEACR,#1,bgcolor}%
      ,{\@DEGREEACR,#1,bgcolor}%
      ,{\@DEGREEACR,bgcolor}%
      ,{\@DOCTYPE,\@DEGREEACR,#1,image}%
      ,{\@DOCCLASS,\@DEGREEACR,#1,image}%
      ,{\@DEGREEACR,#1,image}%
      ,{\@DEGREEACR,image}%
      ,{\@DOCTYPE,\@DEGREEACR,#1,bgcolor}%
      ,{\@DOCCLASS,\@DEGREEACR,#1,bgcolor}%
      ,{\@DEGREEACR,#1,bgcolor}%
      ,{\@DEGREEACR,bgcolor}%
      ,{\@DOCTYPE,\@DEGREEACR,#1,image}%
      ,{\@DOCCLASS,\@DEGREEACR,#1,image}%
      ,{\@DEGREEACR,#1,image}%
      ,{\@DEGREEACR,image}%
      ,{\@DOCTYPE,#1,bgcolor}%
      ,{\@DOCCLASS,#1,bgcolor}%
      ,{#1,bgcolor}%
      ,{bgcolor}%
      ,{\@DOCTYPE,#1,image}%
      ,{\@DOCCLASS,#1,image}%
      ,{#1,image}%
      ,{image}%
      ,{\@DOCTYPE,#1,bgcolor}%
      ,{\@DOCCLASS,#1,bgcolor}%
      ,{#1,bgcolor}%
      ,{bgcolor}%
      ,{\@DOCTYPE,#1,image}%
      ,{\@DOCCLASS,#1,image}%
      ,{#1,image}%
      ,{image}%
    ){#2}{#3}%
  }%
}

\newcommand{\ntprintspine}{%
  \pagenumbering{roman}%
  \setcounter{page}{0}
  \iffileadded[spine]{cover}{%
    \optionlistdo{/@nt/file/cover/spine}{%
      \bgroup\thispagestyle{empty}%
      \@ntloadfile@i[\ClassError{novathesis}{Invalid cover file: “##1”}{}]{##1}%
      \egroup\clearforchapter%
    }%
  }{\@ntprintspine}%
}

\newcommand{\ntprintbackcover}{%
  \pagenumbering{roman}%
  \setcounter{page}{0}
  \ifcoverdefined[N-1]{\pdfbookmark[-1]{\thebkmstring(backmatter,\@LANG@COVER)}{bmbackmatter1}}{%
  \ifcoverdefined[N-2]{\pdfbookmark[-1]{\thebkmstring(backmatter,\@LANG@COVER)}{bmbackmatter2}}{}}%
  \ntprintcoverpair{N}%
}

\newcommand{\ntprintcovers}[1][1,2]{%
  \begingroup
    \ntselectlang{\@LANG@COVER}%
    \NTRunHook{printcovers/pre}%
    \pdfbookmark[-1]{\thebkmstring(frontmatter,\@LANG@COVER)}{bmfrontmatter}%
    \NTAddToHook{mainmatter/pre}{\bookmarksetup{startatroot}}%
    % \forcsvlist{\ntprintcoverpair}{#1}%
    \ntfor\arg:={#1}\do{\ntprintcoverpair{\arg}}%
    \NTRunHook{printcovers/post}%
  \endgroup
  \setcounter{page}{1}
}

\newcommand{\ntprintcoverpair}[1]{%
  % #1 = major cover ID
  \iffileadded[1]{cover}{%
    \iffileadded[#1]{cover}{%
      \optionlistdo{/@nt/file/cover/#1}{%
        \bgroup\thispagestyle{empty}%
        \@ntloadfile@i[\ClassError{novathesis}{Invalid cover file: “##1”}{}]{##1}%
        \egroup\clearforchapter%
      }%
      \ntprintcoversingle{2}{1}%
    }{}%
  }{%
    \IfStrEqCase{#1}{%
      {1}{\ntprintcoversingle{#1}{1}\ntprintcoversingle{#1}{2}\clearforchapter}%
      {2}{\iftoggle{/novathesis/print/secondcover}
                   {\ntprintcoversingle{#1}{1}\ntprintcoversingle{#1}{2}\clearforchapter}{}}%
      {N}{\ntprintcoversingle{#1}{1}\ntprintcoversingle{#1}{2}}%
    }[\ClassWarning{Invalid cover number: #1}{}]%
  }
}

\newcommand{\ntprintcoversingle}[2]{%
  % #1 = major cover ID
  % #2 = minor cover ID
  \def\@nt@newpage{}%
  \gdef\@covernumber{#1-#2}%
  \IfStrEq{#2}{2}{%
    \ifbool{@openright}{\def\@nt@newpage{\thispagestyle{cleared}\cleartoevenpage}}{\clearpage}%
  }{}%
  % \IfStrEq{#1-#2}{2-1}{\setcounter{page}{1}}{}%
  \setcounter{page}{0}
  \edef\@cvn{#1-#2}
  \edef\@cvnonetwo{1-2}
  \edef\@cvnNone{N-1}
  \ifx\@cvn\@cvnonetwo\relax
    \iftoggle{/novathesis/uminho/skipblankcovers}{}
                       {\ifcoverdefined[#1-#2]{\@nt@newpage\@ntprintcover@i{#1-#2}}{}}%
  \else\ifx\@cvn\@cvnNone\relax
    \iftoggle{/novathesis/uminho/skipblankcovers}{}
                       {\ifcoverdefined[#1-#2]{\@nt@newpage\@ntprintcover@i{#1-#2}}{}}%
  \else
    \ifcoverdefined[#1-#2]{\@nt@newpage\@ntprintcover@i{#1-#2}}{}%a
  \fi\fi
}

\newcommand{\@ntprintcover@i}[1]{%
  % #1 = cover ID (major-minor)
  \begingroup%
    \NTRunHook{cover/pre}%
    \NTRunHook{cover/#1/pre}%
    \datamatchtf{\match}{thesiscover}(%
                {\@DOCTYPE,\@DEGREEACR,#1,textcolor}%
               ,{\@DOCCLASS,\@DEGREEACR,#1,textcolor}%
               ,{\@DEGREEACR,#1,textcolor}%
               ,{\@DEGREEACR,textcolor}%
               ,{\@DOCTYPE,#1,textcolor}%
               ,{\@DOCCLASS,#1,textcolor}%
               ,{#1,textcolor}%
               ,{textcolor}%
    ){\color{\match}}{}%
    % \ntselectlang{\@LANG@COVER}%
    % \ifdatadefined{bkmstring}(#1,\@LANG@COVER){
    \pdfbookmark[1]{\thebkmstring(#1)}{\thebkmstring(#1)}%
    % }{}%
    % \options{/@ntcoveropts/bookmark=#1}%
    % \ifoptionequal{/@ntcoveropts/bookmark}{}{}{%
    %   \pdfbookmark[1]{\option{/@ntcoveropts/bookmark}}{\option{/@ntcoveropts/bookmark}}%
    % }%
    \@ntmakeboxwithcover{#1}{\@fullcover@box}%
    \NTRunHook{cover/#1/post}%
    \NTRunHook{cover/post}%
  \endgroup%
}

\newcommand{\@ntmakeboxwithcover}[2]{%
    % #1 = cover ID (major-minor)
    % #2 = box name
    \@for\i:={top,bottom,left,right}\do{%
      \expandafter\datamatch\csname @nt@margin@\i\endcsname{margin}(%
        {cover,\@DOCTYPE,\@DEGREEACR,#1,\i}%
       ,{cover,\@DOCCLASS,\@DEGREEACR,#1,\i}%
       ,{cover,\@DEGREEACR,#1,\i}%
       ,{cover,\@DOCTYPE,\@DEGREEACR,\i}%
       ,{cover,\@DOCCLASS,\@DEGREEACR,\i}%
       ,{cover,\@DEGREEACR,\i}%
       ,{cover,\@DOCTYPE,#1,\i}%
       ,{cover,\@DOCCLASS,#1,\i}%
       ,{cover,#1,\i}%
       ,{cover,\@DOCTYPE,\i}%
       ,{cover,\@DOCCLASS,\i}%
       ,{cover,\i})%
    }
    % \datamatch{\@nt@margin@top}{margin}(%
    %   {cover,\@DOCTYPE,\@DEGREEACR,#1,top}%
    %  ,{cover,\@DOCCLASS,\@DEGREEACR,#1,top}%
    %  ,{cover,\@DEGREEACR,#1,top}%
    %  ,{cover,\@DOCTYPE,\@DEGREEACR,top}%
    %  ,{cover,\@DOCCLASS,\@DEGREEACR,top}%
    %  ,{cover,\@DEGREEACR,top}%
    %  ,{cover,\@DOCTYPE,#1,top}%
    %  ,{cover,\@DOCCLASS,#1,top}%
    %  ,{cover,#1,top}%
    %  ,{cover,\@DOCTYPE,top}%
    %  ,{cover,\@DOCCLASS,top}%
    %  ,{cover,top})%
    % \datamatch{\@nt@margin@bottom}{margin}(%
    % {cover,\@DOCTYPE,\@DEGREEACR,#1,bottom}%
    %  ,{cover,\@DOCCLASS,\@DEGREEACR,#1,bottom}%
    %  ,{cover,\@DEGREEACR,#1,bottom}%
    %  ,{cover,\@DOCTYPE,\@DEGREEACR,bottom}%
    %  ,{cover,\@DOCCLASS,\@DEGREEACR,bottom}%
    %  ,{cover,\@DEGREEACR,bottom}%
    %  ,{cover,\@DOCTYPE,#1,bottom}%
    %  ,{cover,\@DOCCLASS,#1,bottom}%
    %  ,{cover,#1,bottom}%
    %  ,{cover,\@DOCTYPE,bottom}%
    %  ,{cover,\@DOCCLASS,bottom}%
    %  ,{cover,bottom})%
    % \datamatch{\@nt@margin@left}{margin}(%
    % {cover,\@DOCTYPE,\@DEGREEACR,#1,left}%
    %  ,{cover,\@DOCCLASS,\@DEGREEACR,#1,left}%
    %  ,{cover,\@DEGREEACR,#1,left}%
    %  ,{cover,\@DOCTYPE,\@DEGREEACR,left}%
    %  ,{cover,\@DOCCLASS,\@DEGREEACR,left}%
    %  ,{cover,\@DEGREEACR,left}%
    %  ,{cover,\@DOCTYPE,#1,left}%
    %  ,{cover,\@DOCCLASS,#1,left}%
    %  ,{cover,#1,left}%
    %  ,{cover,\@DOCTYPE,left}%
    %  ,{cover,\@DOCCLASS,left}%
    %  ,{cover,left})%
    % \datamatch{\@nt@margin@right}{margin}(%
    % {cover,\@DOCTYPE,\@DEGREEACR,#1,right}%
    %  ,{cover,\@DOCCLASS,\@DEGREEACR,#1,right}%
    %  ,{cover,\@DEGREEACR,#1,right}%
    %  ,{cover,\@DOCTYPE,\@DEGREEACR,right}%
    %  ,{cover,\@DOCCLASS,\@DEGREEACR,right}%
    %  ,{cover,\@DEGREEACR,right}%
    %  ,{cover,\@DOCTYPE,#1,right}%
    %  ,{cover,\@DOCCLASS,#1,right}%
    %  ,{cover,#1,right}%
    %  ,{cover,\@DOCTYPE,right}%
    %  ,{cover,\@DOCCLASS,right}%
    %  ,{cover,right})%
    % \defifundef{#2}{\newsavebox}%
    \@ntmakecoverbgcolor{#1}{\@cover@bgcolor@box}%
    \@ntmakecoverimage{#1}{\@cover@image@box}%
    \@ntmakecovertext{#1}{\@cover@text@box}%
    \thispagestyle{empty}%
    \begin{tikzpicture}[remember picture, overlay]
    \node[inner sep=0, anchor=north]  at (current page.north)
    {\usebox{\@cover@bgcolor@box}};
    \node[inner sep=0, anchor=north]  at (current page.north)
    {\usebox{\@cover@image@box}};
    \node[inner sep=0
    , anchor=north west
    , xshift=\@nt@margin@left
    , yshift=-\@nt@margin@top] at (current page.north west)
    {\usebox{\@cover@text@box}};
    \end{tikzpicture}%
    \ifoptioncontains{/novathesis/debug}{cover}{%
    \NTRunHook{cover/#1/grid/pre}%
    \debuggrid%
    \NTRunHook{cover/#1/grid/post}%
    }{}%
}

\newcommand*{\@ntmakecoverbgcolor}[2]{%
    % #1 = cover ID (major-minor)
    % #2 = box name
    \defifundef{#2}{\newsavebox}%
    \datamatchtf{\match}{thesiscover}(%
      {\@DOCTYPE,\@DEGREEACR,#1,bgcolor}%
     ,{\@DOCCLASS,\@DEGREEACR,#1,bgcolor}%
     ,{\@DEGREEACR,#1,bgcolor}%
     ,{\@DEGREEACR,bgcolor}%
     ,{\@DOCTYPE,#1,bgcolor}%
     ,{\@DOCCLASS,#1,bgcolor}%
     ,{#1,bgcolor}%
     ,{bgcolor}%
    ){\savebox{#2}{\@ntcoverbgcolor{#1}{\match}}}{}%
}

\newcommand*{\@ntcoverbgcolor}[2]{%
    % #1 = cover ID (major-minor)
    % #2 = color
    \begingroup%
    \color{#2}%
    \NTRunHook{cover/#1/bgcolor/pre}%
    \rule{\paperwidth}{\paperheight}%
    \NTRunHook{cover/#1/gcolor/post}%
    \endgroup%
}

\newcommand*{\@ntmakecoverimage}[2]{%
    % #1 = cover ID (major-minor)
    % #2 = box name
    \NTRunHook{cover/#1/image/pre}%
    \defifundef{#2}{\newsavebox}%
    \datamatchtf{\match}{thesiscover}(%
      {\@DOCTYPE,\@DEGREEACR,#1,image}%
     ,{\@DOCCLASS,\@DEGREEACR,#1,image}%
     ,{\@DEGREEACR,#1,image}%
     ,{\@DEGREEACR,image}%
     ,{\@DOCTYPE,#1,image}%
     ,{\@DOCCLASS,#1,image}%
     ,{#1,image}%
     ,{image}%
    ){\savebox{#2}{\includegraphics[width=\paperwidth,height=\paperheight]{\match}}}{}%
    \ifdatadefined{thesiscover}(phd,1-1,bgcolor){}{}%
    \NTRunHook{cover/#1/image/post}%
}

\newcommand{\@ntmakecovertext}[2]{%
    % #1 = cover ID (major-minor)
    % #2 = box name
    \defifundef{#2}{\newsavebox}%
    \ifoptiondefined{/@nt/cover/\@nt@univ/\@nt@schl/#1}{%
    \begin{lrbox}{#2}%
    \begin{minipage}[l]%
    [\dimexpr\paperheight-\@nt@margin@top-\@nt@margin@bottom]%
    {\dimexpr\paperwidth-\@nt@margin@left-\@nt@margin@right}%
    \@ntcovertext{#1}%
    \end{minipage}%
    \end{lrbox}%
    }{}%
}

\newcommand{\@ntcovertext}[1]{%
    % #1 = cover ID (major-minor)
    \NTRunHook{cover/#1/text/pre}%
    \optionlistdo{/@nt/cover/\@nt@univ/\@nt@schl/#1}{\@ntcoverelement@iii{#1}##1}%
    \NTRunHook{cover/#1/text/post}%
}

\def\@ntcoverelement@iii#1#2\@nil#3{%
  % #1 = cover ID (major-minor)
  % #2 = cover element options
  % #3 = cover element code
  % \typeout{[#1] [#2]}\xxxx
  \ifblank{#3}{}{%
    \options{/@ntcoveropts,defaults}%.
    \options{/@ntcoveropts,#2}%
    \options{/@ntcoveropts,alignmap=\option{/@ntcoveropts/halign}}%
    % \StrCount{,\option{/@ntcoveropts/status},}{,\@DOCSTATUS,}[\@nt@instatus]%
    % \StrCount{,\option{/@ntcoveropts/degree},}{,\@DOCCLASS,}[\@nt@indegree]%
    % \typeout{OPT_DEGREE=[\option{/@ntcoveropts/degree}] DOCCLASS=[\@DOCCLASS]}%
    % \typeout{OPT_STATUS=[\option{/@ntcoveropts/status}] STATUS=[\@DOCSTATUS]}\aaaaa
    \defifundef{\ifmatchstatus}{\newif}
    \defifundef{\ifmatchdegree}{\newif}
    \matchstatustrue
    \matchdegreetrue
    \if&\option{/@ntcoveropts/status}&\relax
    \else
      \if\instring{,\@DOCSTATUS,}{,\option{/@ntcoveropts/status},}
      \else
        \matchstatusfalse
      \fi
    \fi
    \if&\option{/@ntcoveropts/degree}&\relax
    \else
      \if\instring{,\@DOCCLASS,}{,\option{/@ntcoveropts/degree},}
      \else
        \matchdegreefalse
      \fi
    \fi
    \ifmatchstatus
      \ifmatchdegree
        \@ntcoverelement@ii{#1}{#3}
      \fi
    \fi
     % \ifthenelse{%
     %          \(\equal{\option{/@ntcoveropts/status}}{}\OR\@nt@instatus>0\)\AND%
     %          \(\equal{\option{/@ntcoveropts/degree}}{}\OR\@nt@indegree>0\)}%
     %  {\@ntcoverelement@ii{#1}{#3}}%
     %  {}%
  }%
}

\options{/@ntcoveropts/.new family,
  % letter to macro for horizontal alignment
  alignmap/.new choice={c=\centering,l=\raggedright,r=\raggedleft,j=\null},
  % filters / conditional printing
  status/.new value,
  degree/.new value,
  % horizontal alighment and vertical alignments inside the box
  halign/.new choice={c, l, r, j},
  valign/.new choice={c, t, b},
  % height of the box (default = the natural height for the contents)
  height/.new value,
  % height of the box (default = the natural height for the contents)
  height/phd/.new value,
  % height of the box (default = the natural height for the contents)
  height/msc/.new value,
  % minheight of the box (default = the natural height for the contents)
  minheight/.new value,
  % width of the box (default = full width)
  width/.new value,
  % vertical spacing from precious box (default = 0ptcan also be an integer and,,
  % in this caseit means the weight of the vfill),
  vspace/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/phd/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/msc/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/1-1/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/2-1/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/phd/1-1/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/phd/2-1/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/msc/1-1/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/msc/2-1/.new value,
  % horizontal spacing from the left margin (or last box in the same line) (default = 0pt)
  hspace/.new value,
  % is the last box in the line (default = true)
  newpar/.new toggle,
  % text color for the box (default = black)
  color/.new color,
  % background color for the box (default = transparent)
  bgcolor/.new color,
  % default values
  defaults/.new style*={,
                  vspace=0pt,
                  vspace/msc={}, vspace/phd={},
                  vspace/1-1={}, vspace/2-1={},
                  vspace/msc/1-1={}, vspace/msc/2-1={},
                  vspace/phd/1-1={}, vspace/phd/2-1={},
                  status={}, degree={}, halign=c, valign=c,
                  height={}, height/phd={}, height/msc={},
                  minheight=0pt, width={}, hspace=0pt,
                  newpar=true, color={}, bgcolor={},
  }
  % set defaults
, defaults
}

\newcommand{\@ntcovervspace}[1]{%
  \ifoptionvoid{/@ntcoveropts/#1}{%
    % \typeout{NT blank [#1=\option{/@ntcoveropts/#1}]}
  }{%
    % \typeout{NT notblank [#1=\option{/@ntcoveropts/#1}]}%
    \IfInteger{\option{/@ntcoveropts/#1}}% USE vspace
      {\vskip 0pt plus \option{/@ntcoveropts/#1}fill}%
      {\vspace*{\option{/@ntcoveropts/#1}}}%
    \ntforbreak
  }%
}
\newcommand{\@ntcoverelement@ii}[2]{%
  % #1 = cover ID (major-minor)
  % #2 = code
  % If vspace is integer then replace by n*\vfill
  % otherwise it is absolute verstical space
  % \typeout{NT testblank [#1] =========}%
  \ntfor\match:={vspace/\@DOCTYPE/#1,vspace/\@DOCTYPE,vspace/#1,vspace}%
        \do{\@ntcovervspace{\match}}%
  % Typeset contents in a box
  \@nt@makeboxwithcoverelement@iii{#1}{#2}{\@nt@coverelement}%
  \noindent%
  \hspace*{\option{/@ntcoveropts/hspace}}%
  \ifoptioncontains{/novathesis/debug}{cover}{% If in debug mode surround element in box
    \setlength{\fboxsep}{0pt}\setlength{\fboxrule}{0.5pt}%
    \vspace*{-\fboxrule}\hspace*{-\fboxrule}%
    \fbox{\usebox{\@nt@coverelement}}%
  }{\usebox{\@nt@coverelement}}%
  \iftoggle{/@ntcoveropts/newpar}{\expandafter\par}{}%
}

\newcommand{\@nt@makeboxwithcoverelement@iii}[3]{%
  % #1 = cover ID (major-minor)
  % #2 = code
  % #3 = boxname
  \defifundef{\@mkcvelemwidth}{\newlength}%
  \ifoptionblank{/@ntcoveropts/width}%
    {\setlength{\@mkcvelemwidth}{\dimexpr\linewidth-\option{/@ntcoveropts/hspace}\relax}}%
    {\option{/@ntcoveropts/width}}%
  \ifoptionblank{/@ntcoveropts/height}%
    {}%
    {\edefoption{/@ntcoveropts/height}\@mkcvelemheight}%
  % Create destination boxes if undefined and save to it
  \defifundef{#3}{\newsavebox}%
  \begin{lrbox}{#3}%
    \begin{minipage}[t][0pt][t]{0pt}%
      \color{blue}\rule{0.000000000000001pt}{\option{/@ntcoveropts/minheight}}%
    \end{minipage}
    % Minipage definition is different if element height is given or not
    \ifoptionblank{/@ntcoveropts/height}%
        {\minipage[t][][\option{/@ntcoveropts/valign}]{\@mkcvelemwidth}}%
        {\minipage[t][\@mkcvelemheight][\option{/@ntcoveropts/valign}]{\@mkcvelemwidth}}%
            \ifoptionblank{/@ntcoveropts/color}{}{\color{\option{/@ntcoveropts/color}}}%
            \option{/@ntcoveropts/alignmap}%
            #2%
        \endminipage%
  \end{lrbox}%
  \begin{lrbox}{#3}%
    % Add background color if necessary
    \ifoptionblank{/@ntcoveropts/bgcolor}%
      {\usebox{#3}}%
      {\colorbox{\option{/@ntcoveropts/bgcolor}}{\usebox{#2}}}%
  \end{lrbox}%
}

\newcommand{\@ntfixspacing}[2]{%
    \bgroup%
    \newdata{ntfixspacingstring}
    \ntfixspacingstring()={This document was created with the (pdf/Xe/Lua)\LaTeX\ processor and the \href{https://github.com/joaomlourenco/novathesis}{NOVAthesis} template (v\novathesisversion)~\@ntcite{novathesis-manual}.}
    \renewcommand*{\bibfont}{\hypersetup{allcolors=#1}\color{#1}%
     \sffamily\fontsize{#2}{#2}\selectfont}%
    \defbibheading{bibliography}[\bibname]{%
    \ \textbf{##1}\\[-20pt]}
    \refsection%
    \begin{minipage}{\linewidth}%
    \bibfont%
    \thentfixspacingstring()%
    \printbibliography[title=12cc90221730b8ba41bb3b1f8b517acd]%
    \end{minipage}%
    \endrefsection%
    \egroup%
}

\newcommand{\ntfixspacing}{%
  \@ntfixspacing{white}{0.01}%
  % \@ntfixspacing{blue}{16}%
}

\newcommand*{\ntprintstatement}{%
  \iftoggle{/novathesis/print/statement}{% if statement toggle is on
    \ifmaindoc{%
      \NTRunHook{statement/pre}%
      \iffileadded{statement}{}{%ELSE
        \ntfor\match:={%
          \@nt@schl/statement-\@DEGREEACR-\@LANG@MAIN,%
          \@nt@schl/statement-\@DEGREEACR,%
          \@nt@schl/statement-\@LANG@MAIN,%
          \@nt@schl/statement,%
          statement-\@LANG@MAIN,%
          statement%
        }\do{%
          \IfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\match.tex}{%
            \ntaddfile{statement}{NOVAthesisFiles/Schools/\@nt@univ/\match.tex}%
            \ntforbreak%
          }{}%
        }[%
          \ClassError{novathesis}{No “statement.tex” found! Not defined with %
                                  \string\ntaddfile{statement}{filename} in folders %
                                  “NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl” nor %
                                  “NOVAthesisFiles/Schools/\@nt@univ”}{}
        ]%
      }{}%
      \pdfbookmark[1]{\thebkmstring(statement,\@LANG@MAIN)}{bmstatement}%
      \@ntloadfiles@ii{statement}%
      \NTRunHook{statement/post}%
    }{}%
  }{}%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print persons list {advisers | committee}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintpersons}[5][full]{%
  % #1 = { full | name | list }
  % #2 = width in % of textwidth
  % #3 = number of columns
  % #4 = adviser | committee
  % #5 = {a,c} | {c,r,a,m,g}
  % \typeout{NTPRINTPERSONS 1=[#1] 2=[#2] 3=[#3] 4=[#4] 5=[#5]}\aaa
  \iftoggle{/novathesis/print/#4}{%
    \IfStrEqCase{#3}{%
      {0}{\@ntprintpersonsaslist{#4}{#5}}%
      {1}{\@ntprintpersonsasonecolumn{#1}{#2}{#4}{#5}}%
      {2}{\@ntprintpersonsastwocolumns{#1}{#2}{#4}{#5}}%
    }[\ClassError{novathesis}{Ivalid argument [#3] to \string\ntprintpersons{#1}{#2}{#3}{#4}{#5}}{}]%
  }{}%
}

%============================================================
% Print persons list {advisers | committee} as list
%============================================================
\newcommand{\@ntprintpersonsaslist}[2]{%
  % #1 = adviser | committee
  % #2 = {a,c} | {c,r,a,m,g}
  % Build list of names
  \ifdatadefined{#1titlestring}(\@LANG@COVER){%
    \datadefault{#1titlestringpre}()%
    \datadefault{#1titlestringfont}()%
    \csuse{the#1titlestring}(\@LANG@COVER)%
    \datadefault{#1titlestringpost}()%
  }{}%
  \def\@nt@personlist{}%
  \def\@nt@listsep{}%
  \@for\i:=\expanded{#2}\do{%
    \ifoptionvoid{/@nt/#1/\i/name}{}{%
      \letoptionlist{/@nt/#1/\i/name}\@nt@person@sublist%
      \eappto\@nt@personlist{\@nt@listsep\@nt@person@sublist}\def\@nt@listsep{,}%
    }%
  }%
  \@replacelastcomma{\@nt@personlist}%
}

\def\@replacelastcomma#1{%
  % \typeout{REP1 [#1]}%
  % \@replacelastcomma@i{}{}#1,\nil}
  \expandafter\@replacelastcomma@i\expandafter{\expandafter}\expandafter{\expandafter}#1,\nil}

\def\@replacelastcomma@i#1#2#3,#4\nil{%
  % \typeout{REP2 [#1] [#2] [#3] [#4]}%
  \if\relax\detokenize{#4}\relax
    #2\trimspaces{#3}%
  \else % #4 is not empty
    #1\trimspaces{#3}%
    \@replacelastcomma@i{\thecommastring(\option{/@nt/lang/current})}%
        {\theandstring(\option{/@nt/lang/current})}#4\nil%
  \fi
}



%============================================================
% Print persons list {advisers | committee} as one and two columns
%============================================================
\newcommand{\@ntprintpersonsasonecolumn}[4]{%
  % #1 = { full | name | list }
  % #2 = width in % of textwidth
  % #3 = adviser | committee
  % #4 = {a,c} | {c,r,a,m,g}
  \csuse{#3stringpost}():={:\\[2pt]}%
  \csuse{#3remainderpre}()={{\\}}%
  \personpost()={\\[4pt]}%
  \persongrouppost()={\\[-4pt]}
  \begin{tabularx}{#2\linewidth}[t]{@{}X@{}}%
    \expandnext{\forcsvlist{\@nt@ntprintpersongroup[#1]{1}{#3}}}{\expanded{#4}}%
    % \@for\arg:=\expanded{#4}\do{\@nt@ntprintpersongroup{#1}{1}{#3}{\arg}}
  \end{tabularx}%
}

\newcommand{\@ntprintpersonsastwocolumns}[4]{%
  % #1 = { full | name | list }
  % #2 = width in % of textwidth
  % #3 = adviser | committee
  % #4 = {a,c} | {c,r,a,m,g}
  % \typeout{NTPRINTPERSONSASTWOCOLUMNS 1=[#1] 2=[#2] 3=[#3] 4=[#4]}%\aaa
  \csuse{#3stringpost}():={:&}%
  \csuse{#3remainderpre}()={{\\}}%
  \personpost()={\\[4pt]}%
  \persongrouppost()={\\[-6pt]}
  \committeetitlestringpre()={&}%
  \committeetitlestringpost()={\\[7pt]}%
  \begin{tabularx}{#2\linewidth}[t]{@{}r@{~~}>{\raggedright\arraybackslash}X@{}}%
    \ifdatadefined{#3titlestring}(\@LANG@COVER){%
      \datadefault{#3titlestringpre}()%
      \datadefault{#3titlestringfont}()%
      \csuse{the#3titlestring}(\@LANG@COVER)%
      \datadefault{#3titlestringpost}()%
    }{}%
    \expandnext{\forcsvlist{\@nt@ntprintpersongroup[#1]{2}{#3}}}{\expanded{#4}}%
    % \@for\i:=\expanded{#4}\do{\typeout{NTPRINTIIIII=\i}\@nt@ntprintpersongroup[#1]{2}{#3}{\i}}%
    % \foreach \i [expand list=true] in {#4} {\@nt@ntprintpersongroup{#1}{2}{#3}{\i}}%
  \end{tabularx}%
}

\newcommand{\@nt@ntprintpersongroup}[4][full]{%
  % #1 = { full | name | list }
  % #2 = {1 | 2}
  % #3 = {adviser | committee}
  % #4 = {a,c} | {c,r,a,m,g}
  \ifoptiondefined{/@nt/#3/#4/full}{%
  % \typeout{NTPRINTPERSONGROUP 1=[#1] 2=[#2] 3=[#3] 4=[#4]}%\aaa
    \@nt@reducegender{/@nt/#3/#4/gender}{\@nt@advgender}%
    \@nt@reducenumber{/@nt/#3/#4/full}{\@nt@advnumber}%
    \datadefault{#3stringpre}(#4)%
    \bgroup%
      \datadefault{#3stringfont}(#4)%
      \datadefault{#3string}(#4,\@nt@advnumber,\@nt@advgender,\@LANG@COVER)%
    \egroup%
    \datadefault{#3stringpost}(#4)%
    % \if#22\relax&\fi
    % \IfStrEq{#2}{2}{&}{}%
    \IfStrEq{#1}{list}{%
      \@ntprintpersonsaslist{#3}{#4}%
    }{%
      \begin{minipage}[t]{\linewidth}%
          \optionlistdo{/@nt/#3/#4/full}{\@nt@printonename{#1}{#3}{##1}}%
      \end{minipage}%
    }%
    \thepersongrouppost()%
  }{}%
}


%============================================================
% Print person aux funcitons
%============================================================
\newcommand{\@nt@printonename}[3]{%
% #1 = { full | name }
% #2 = adviser | coadviser | committee
% #3 = (co)adviser info
% \typeout{NTPRINTONENAME 1=[#1] 2=[#2] 3=[#3]}%\bbb
\begingroup
  \noexpandarg
  \raggedright%
  \StrCut{#3}{,}\@nt@name\@nt@remainder% split name from remainder
  \csuse{the#2namepre}()%
  \bgroup%
    \csuse{the#2namefont}()%
    \ignorespaces\@nt@name%
  \egroup%
  \csuse{the#2namepost}()%
  \IfStrEq{#1}{full}{%
    \IfStrEq{\@nt@remainder}{}{}{%
      \csuse{the#2remainderpre}()%
      \bgroup%
        \csuse{the#2remainderfont}()%
        \ignorespaces\raggedright\@nt@remainder%
      \egroup%
      \csuse{the#2remainderpost}()%
    }%
  }{}%
\endgroup
\thepersonpost()%
}

\newcommand*{\@nt@reducegender}[2]{%
    % #1=gender list
    % #2=result
    \gdef#2{f}%
    \optionlistdo{#1}{\if##1m\relax\gdef#2{m}\fi}%
}

\newcommand*{\@nt@reducenumber}[2]{%
    % #1=options list
    % #2=result (1|2)
    \ifnum\value{\option{#1/@size}}=1\gdef#2{1}\else\gdef#2{2}\fi
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtEndPreamble{\ntsetlayout}%

\newcommand*{\ntsetlayout}{%
    % \synctex=1% Use synctex
    \brokenpenalty=10000%
    \settypeoutlayoutunit{mm}%
    \setulmarginsandblock%
    {\themargin(\option{/novathesis/media},top)}%
    {\themargin(\option{/novathesis/media},bottom)}%
    {*}%
    \setlrmarginsandblock%
    {\themargin(\option{/novathesis/media},left)}%
    {\themargin(\option{/novathesis/media},right)}%
    {*}%
    \checkandfixthelayout%
    \ifoptionequal{/novathesis/media}{paper}{\openright}{}%
}

\newenvironment{newlayout}[2]{%
  \clearpage%
  % \typeout{V=#1 H=#2}\aaaa
  \@tempdima=\dimexpr#1\relax%
  \@tempdimb=\dimexpr#2\relax%
  % \showthe\@tempdima \showthe\@tempdimb
  \setstocksize{\the\@tempdima}{\the\@tempdimb}%
  \settrimmedsize{\stockheight}{\stockwidth}{*}%
  \settrims{0pt}{0pt}%
  \setlrmarginsandblock{0pt}{*}{*}%
  \setulmarginsandblock{0pt}{*}{*}%
  \setlength{\parskip}{0pt}%
  \setheadfoot{0pt}{0pt}%
  \setheaderspaces{*}{0pt}{*} %
  \setmarginnotes{0pt}{0pt}{0pt}%
  \checkandfixthelayout[fixed]%
  %
  %
  % \settrimmedsize{#2}{#1}{*}%
  % \settrims{0pt}{0pt}
  % \setlrmarginsandblock{0pt}{0pt}{*}%
  % \setulmarginsandblock{0pt}{*}{1}%
  % \setheadfoot{0pt}{0pt}%
  % \setheaderspaces{0pt}{*}{*}%
  % \checkandfixthelayout%
  \ifluatex%
    \pageheight=\stockheight% \pageheight=3in
    \pagewidth=\stockwidth% \pageheight=3in
  \else%
    \pdfpageheight=\stockwidth% \pdfpageheight=3in
    \pdfpagewidth=\stockheight% \pdfpageheight=3in
  \fi%
  \setlength{\@colht}{\textheight}%
  \setlength{\@colroom}{\textheight}%
  \setlength{\vsize}{\textheight}%
  \setlength{\columnwidth}{\textwidth}%
  \if@twocolumn%
    \advance\columnwidth-\columnsep%
    \divide\columnwidth\tw@%
    \@firstcolumntrue%
  \fi%
  \setlength{\hsize}{\columnwidth}%
  \setlength{\linewidth}{\hsize}%
}{%
  \clearpage%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Printing chapters and similars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@nt@printifmaindoc@i}[1]{%
  % \typeout{NT Attempt to load #1}%
  \ifmaindoc{% THEN it is a main document
    \NTRunHook{#1/pre}%
    \iffileadded{#1}{%
      \pdfbookmark[1]{\thebkmstring(#1,\@LANG@MAIN)}{bm#1}%
      \@ntloadfiles@ii{#1}%
    }{}%
    \NTRunHook{#1/post}%
  }{}% It is a plan or proposal type document
}

\newcommand{\ntprintdedicatory}{\@nt@printifmaindoc@i{dedicatory}}

\newcommand{\ntprintquote}{\@nt@printifmaindoc@i{quote}}

\newcommand{\ntprintacknowledgements}{\@nt@printifmaindoc@i{acknowledgements}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Abstract, Acronyms and Glossary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintabstracts}{%
  \letoptionchoices{/novathesis/abstract/deforder}{\@abst@rder@langs}%
  \if\instring{,\@LANG@MAIN,}{,\@abst@rder@langs,}%
    \options{/novathesis/abstract/deforder=\@LANG@MAIN}%
  \else
    \options{/novathesis/abstract/deforder=default}%
  \fi
  % \typeout{NTL=[\languagename] {\@LANG@MAIN}{\@abst@rder@langs} {\option{/novathesis/abstract/theorder}}}\AAAAAAA
  \@for\listitem:=\expanded{\option{/novathesis/abstract/theorder}}\do{\@ntprintabstract{\listitem}}%
  % \typeout{NTL=\languagename}\cccc
  % \ntselectlang{\@LANG@MAIN}%
}

\newcommand{\@ntprintabstract}[1]{%
  % \typeout{NT PRINT ABSTRACT=[#1]}\aaaa%
  \iffileadded[#1]{abstract}{%
    \begingroup
      % \typeout{NT PRINT ABSTRACT #1}\bbbb
      \StrCut{#1}{-}\@ABS@LANG\@dummy%
  		\ntselectlang{\@ABS@LANG}%
      % \typeout{NTL=\languagename [#1]}\bbbb
      \pdfbookmark[1]{\thebkmstring(abstract,#1)}{bmabstract#1}%
      \NTRunHook{abstract/pre}%
      \NTRunHook{abstract/#1/pre}%
      \printabstracttitle{#1}%
      \NTRunHook{abstract/#1/mid}%
      \NTRunHook{abstract/mid}%
      \@ntloadfiles@ii[#1]{abstract}%
      \NTRunHook{abstract/#1/post}%
      \NTRunHook{abstract/post}%
    \endgroup
  }{}%
}

\newcommand{\ntprintindex}{%
  % \printglossary[type=index]%
  \printindex
}

\newcommand*{\ntthesisfrontmatter}{%
  \NTRunHook{frontmatter/pre}%
  \frontmatter%
  \begingroup
  \pagestyle{novathesis@frontmatter}%
  \copypagestyle{chapter}{novathesis@frontmatter}
  % \ntselectlang{\@LANG@MAIN}%
  \pagenumbering{roman}%
  \NTRunHook{frontmatter/post}%
}

\newcommand*{\ntthesismainmatter}{%
  \endgroup
  \bookmarksetup{startatroot}%
  \NTRunHook{mainmatter/pre}%
  \ifbool{@openright}{}{% openany=true
    % Avoid cleardoublepage before "mainmatter"
    \let\oldcleardoublepage\cleardoublepage%
    \renewcommand{\cleardoublepage}{\clearforchapter}%
  }%
  \mainmatter%
  \ifbool{@openright}{}{% openany=true
    \let\cleardoublepage\oldcleardoublepage%
  }%
  \pagestyle{novathesis@mainmatter}%
  \ifxeorlua{}{\microtypesetup{protrusion=true}}%
  \NTRunHook{mainmatter/post}%
}

\newcommand{\ntindex}[2][]{%
  % \typeout{NTINDEX [#1] [#2]}
  \bgroup%
    \ifoptioncontains{/novathesis/debug}{index}{\showlabelsinline}{}%
    \StrRight{#1}{1}[\@nt@index]%
    \if\@nt@index!\relax
      \def\@nt@index{#1#2}%
    \else
      \def\@nt@index{#1}%
    \fi%
    \index{\@nt@index}#2%
    % \ifoptioncontains{/novathesis/debug}{index}{}%
    %                                            {\def\@nt@index{f}}%
    % \if\@nt@index t\relax
    %   \marginpar{#1#2}%
    % \fi%
  \egroup%
}

% \newcommand{\ntindex}[2][]{%
%   \if\relax\detokenize{#1}\relax
%     \index{#2}#2%
%   \else
%     \index{#1}#2%
%   \fi%
% }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntchapterfile}[1]{\listgadd{\@nt@chapter@list}{#1}}

\newcommand*{\ntprintchapters}{%
    \@nt@foralllist{file}{chapter}{\@ntloadfiles@ii{chapter}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Appendixes and Annexes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand*{\addappheadtotoc}{%
    \phantomsection\addtocontents{toc}%
    {\protect\contentsline{chapter}{\appendixtocname}{}{}}%
 }

\newcommand*{\ntprintappendices}{%
  \iffileadded{appendix}{%
    \renewcommand{\appendixtocname}{\appendixplname}%
    \appendix\addappheadtotoc%
    \@nt@foralllist{file}{appendix}{\@ntloadfiles@ii{appendix}}%
  }{}%
}

\newcommand*{\ntprintannexes}{%
  \iffileadded{annex}{%
    % \renewcommand{\appendixtocname}{\translate{Annexes}}%
    \renewcommand{\appendixtocname}{\annexplname}%
    \annex\addappheadtotoc%
    \@nt@foralllist{file}{annex}{\@ntloadfiles@ii{annex}}%
  }{}%
}

\ifdef{\annexcounter}{}{\def\annexcounter{\old@Roman}}
\newcommand*{\annex}{%
  \xdef\Hy@chapapp{annex}%
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\translate{annex}}%
  \gdef\thechapter{\annexcounter\c@chapter}%
}%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with optional lists in the frontmatter: listoftables, litoffigures, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntprintalllistof}{%
    \NTRunHook{listof/pre}%
    \optionlistdo{/@nt/list/listof}{##1\clearforchapter}%
    \NTRunHook{listof/post}%
}


% \def\option@listmatch@getval#1=#2{#2}
\newcommand*{\option@listmatch}[2]{
    % \typeout{NT LISTMATCH [#1] [#2]}%
    \StrCut{#2}{=}\option@listmatch@key\option@listmatch@value%was xStrCut
    % \typeout{K=\option@listmatch@key ~V=\option@listmatch@value}%
    \IfStrEq{#1}{\option@listmatch@key}{\listbreak}{}%
}%
\options{/handlers/getval/.new operation={%
    % \typeout{NT GETVAL [#1] [#2]}%
    \optionlistdo{#1}{\option@listmatch{#2}{##1}}%
    }%
}

\newcommand*{\@loadglossaryfiles}{%
  \@for\listitem:={glossary,acronyms,symbols}\do{%
    \iffileadded[\listitem]{glossaries}{\@nt@loadallfiles{\listitem}{glossaries}}{}%
  }%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand*{\ntprintbib}[1][]{%
  \NTRunHook{printbib/pre}%
  \printbibliography[#1]%
  \ntfixspacing%
  \NTRunHook{printbib/post}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintacknowledgementsblock}[1][\scriptsize]{%
    \NTRunHook{acknowledgementsblock/pre}%
    \noindent\parbox{\linewidth}{%
    \vspace*{2.5ex}\footnoterule#1\theacknowledgmentsstring(\@LANG@MAIN)}
    \NTRunHook{acknowledgementsblock/post}%
}

\newcommand*{\ntprintcopyright}{%
  \iftoggle{/novathesis/print/copyright}{%
    \ifmaindoc{%
      \begingroup
        \ntselectlang{\@LANG@COPYRIGHT}%
        \pdfbookmark[1]{\thebkmstring(copyright,\@LANG@MAIN)}{bmcopyright}%
        \NTRunHook{copyright/pre}%
        \ntprintcopyrightpage%
        \NTRunHook{copyright/post}%
        \ntprintacknowledgementsblock%
      \endgroup
    }{}%
   }{}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quoting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\hugequote}{%
  \bgroup%
    \color{black!30}%
    \fontsize{75}{80}\selectfont%
    \fontfamily{ptm}\selectfont%
    \textit{\glqq}%
  \egroup%
}

\newcommand{\ntquoteauthor}[1]{{\\[1.25ex]\footnotesize\bfseries---~#1}}
\newcommand{\ntquotewhere}[1]{{\footnotesize, #1}}
\newcommand{\ntquoteprofession}[1]{{\footnotesize\\[-0.75ex](#1)}}
\newcommand{\ntquotetext}[1]{{\itshape#1}}
\newcommand{\ntquoteskip}{\chapter*{\vspace*{-3.5ex}}}

\NewDocumentEnvironment{ntquoting}{sO{10cm}O{}O{}O{}O{\option{/novathesis/lang/main}}+b}{%
% 1 [*] => print big quote
% 2 [o] => max width of citation box
% 3 [o] => author name
% 4 [o] => where/source
% 5 [o] => profession
% 6 [o] => lang
% 7 [b] => quotation
  % \typeout{
  %          1=[#1]
  %          2=[#2]
  %          3=[#3]
  %          4=[#4]
  %          5=[#5]
  %          6=[#6]
  %          7=[#7]
  % }\asdfg
  \iftoggle{/novathesis/numberallpages}%
    {\thispagestyle{novathesis@frontmatter}}%
    {\thispagestyle{empty}}%
  \defifundef{\ntqbox}{\newsavebox}%
  \savebox{\ntqbox}{#7}
  \ifdim\wd\ntqbox<\ifblank{#2}{\textwidth}{#2}\relax
  \@tempdima=\wd\ntqbox
  \else
  \@tempdima=#2
  \fi
  \ntquoteskip
  \begin{flushright}
    \NTRunHook{ntquote/pre}%
    \IfBooleanTF{#1}{\hugequote}{}
    \begin{minipage}[t]{\@tempdima}
      \raggedleft\normalsize
      \options{/@nt/lang/shorttolong=#6}%
      \IfBooleanTF{#1}{%
        \foreigntextquote{\option{/@nt/lang/shorttolong}}{\ntquotetext{#7}}%
      }{\ntquotetext#7}
      \ifblank{#3}{}{\ntquoteauthor{#3}}%
      \ifblank{#4}{}{\ntquotewhere{#4}}%
      \ifblank{#5}{}{\ntquoteprofession{#5}}%
    \end{minipage}%
    \NTRunHook{ntquote/post}%
  \end{flushright}
}{}

\ExplSyntaxOn
\cs_new:cpn {ntquote} {\ntquoting*}
\cs_new_eq:cN {endntquote} \endntquoting
\cs_new:cpn {ntdedicatory} {\ntquoting}
\cs_new_eq:cN {endntdedicatory} \endntquoting
\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{ntacknowledgements}{%
    \chapter*{\thebkmstring(acknowledgements,\@LANG@MAIN)}%
}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\printabstracttitle}[1]{%
  \chapter*{\thebkmstring(abstract,#1)}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand{\keywords}[1]{%
    \NTRunHook{keywords/pre}%
    % \NTRunHook{keywords/#1/pre}%
    \def\and{\unskip\datadefault{keywordssep}(\option{/@nt/lang/current})}%
    % \def\and{{\textperiodcentered} }%
    \par\addvspace\baselineskip\noindent%
    \begingroup
    \datadefault{keywordsstringprefix}(\option{/@nt/lang/current})%
    \datadefault{keywordsstringfont}(\option{/@nt/lang/current})%
    \csuse{thekeywordsstring}(\option{/@nt/lang/current})%
    \datadefault{keywordsstringsuffix}(\option{/@nt/lang/current})%
    \endgroup
    % \enspace
    \ignorespaces#1%
    % \NTRunHook{keywords/#1/post}%
    \NTRunHook{keywords/post}%\
}%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand\thepresentationtext{%
    \thedissertationstringfont()%
    \ifdatadefined{issertationstring}(\@DOCTYPE,\@LANG@COVER){%
    \thedissertationstring(\@DOCTYPE,\@LANG@COVER)%
    }{%
    \thedissertationstring(\@DOCCLASS,\@LANG@COVER)%
    }
}

\providecommand\thecopyrightstr{%
    \iftoggle{/novathesis/numberallpages}%
     {\thispagestyle{novathesis@frontmatter}}%
     {\thispagestyle{empty}}%
    \noindent%
    Copyright \textcopyright\ \thedocauthor(name), %
    \theschool(\option{/novathesis/lang/copyright}), \theuniversity(\option{/novathesis/lang/copyright}).\\%
    \thecopyrighttextstring(\option{/novathesis/lang/copyright})%
    % \ntselectlang{\@LANG@MAIN}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Table of contents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setcounter{tocdepth}{2}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sectioning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\maxsecnumdepth{subsubsection}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fixes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fix spacing for pages with roman numerals in ToC
\renewcommand*{\@pnumwidth}{2.5em}% default is 1.55em


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Text style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifcsdef{chs@\option{/novathesis/style/chapter}}{%
  \chapterstyle{\option{/novathesis/style/chapter}}%
}{%
  \InputIfFileExists{NOVAthesisFiles/ChapStyles/\option{/novathesis/style/chapter}.ldf}{}{%
      \ClassError{novathesis}{Invalid Chapter Style: \option{/novathesis/style/chapter}}{}%
  }%
}
\InputIfFileExists{NOVAthesisFiles/FontStyles/\option{/novathesis/style/font}.ldf}{}{%
    \ClassError{novathesis}{Invalid Font Style: \option{/novathesis/style/font}}{}%
}

\ifxeorlua{\definecolor{nearlywhite}{gray}{0.999999}\colorlet{white}{nearlywhite}}{}

\AtBeginDocument{%
  \makeatletter%
  % \typeout{XXX [\thedocauthor(name)]}
  % \typeout{XXX [\thedoctitle(\@LANG@MAIN,main)]}
  % \typeout{XXX [\thedoctitle(\@LANG@MAIN,sub)]}
  \hypersetup{%
    pdfauthor={\thedocauthor(name)},
    pdftitle={\thedoctitle(\@LANG@MAIN,main)},
    pdfsubject={\thedoctitle(\@LANG@MAIN,sub)},
  }

  %--------------------------------
  % If subcaptin is laoded, let it hand handle subfigures
  % otherwise use memoir subfigures
  \@ifpackageloaded{subcaption}{}{\newsubfloat{figure}}
  \newcommand{\@ntcite}[1]{\ifdef{\parencite}{\parencite{#1}}{\cite{#1}}}
  \makeatother
}

