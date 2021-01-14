%!TEX root = template.tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% novathesis.cls
%% NOVA thesis document class
%%
%% This work is licensed under the
%% The LaTeX project public license (LPPL), version 1.3c
%% To view a copy of this license, visit
%% https://www.latex-project.org/lppl/lppl-1-3c/
%%
%% Version 2021-01-09 [5.2.1]
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
%%      - bcandeias, flaviomartins, tmonteiro2344, jsaramago, 
%%        microlina, riclas, pedrovieira
%%
%% DONATIONS:
%%     If you think this template really helped you while writing your thesis,
%%     think about making a small donation. Just access the website
%%     https://paypal.me/novathesis
%%     and click in the “Donation” link.  We will keep a list thanking to all 
%%     the identified donors that identify themselves in the “Add special 
%%     instructions to the seller:” box.
%%
%% CITATION:
%%     If you use this template, please be kind and cite it in your bibliography:
%%           “João M. Lourenço, \emph{The NOVAthesis \LaTeX\ Template User’s Manual},
%%            NOVA School of Science and Technology, NOVA University Lisbon, 2021,
%%            \url{https://github.com/joaomlourenco/novathesis/raw/master/template.pdf}.”
%%    The BibTeX entry is:
%%           @ Manual{novathesis-manual,
%%            title        = {{The NOVAthesis Template User's Manual}},
%%            author       = {João M. Lourenço},
%%            organization = {NOVA University Lisbon},
%%            year         = {2021},
%%            url          = {https://github.com/joaomlourenco/novathesis/raw/master/template.pdf},
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

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{novathesis}[2020/12/02 novathesis template]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOOK FOR PACKAGES ALSO IN "NOVAthesisFiles" folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand*{\input@path}{}
\g@addto@macro\input@path{{./}{Chapters/}{NOVAthesisFiles/}}% subfolder path


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TWO BASIC REQUIRED PACKAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{options-nt}
\RequirePackage{xifthen}
\RequirePackage{xstring}
\RequirePackage{repeat-nt}
\RequirePackage{assocarray}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK IF USING LUALATEX OR XELATEX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\ifxetexorluatex
\begingroup\catcode94=7 \catcode0=9% ASCII 94 is ^
\def\empty{}\def\next{^^^^0000}\expandafter\endgroup
\ifx\next\empty\xetexorluatextrue\else\xetexorluatexfalse\fi

\newcommand*{\ifxeorlua}[2]{\ifxetexorluatex#1\else#2\fi}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Hook AtEndClass
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\@nt@AtEnfClass@hook}{}
\newcommand{\@AtEndClass}[2][app]{\csuse{#1to}\nt@AtEnfClass@hook{#2}}


 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% If necessary create, then initialize the counter
\newcommand*{\setnewcounter}[2]{%
  \ifcsname c@#1\endcsname\else\newcounter{#1}\fi%
  \setcounter{#1}{#2}%
}

% --------------------------------------------------------
% Check if a string contains a character
\newcommand{\instring}[2]{TT\fi\begingroup
  % #1 = character to look for
  % #2 = string
  \edef\x{\endgroup\noexpand\in@{#1}{#2}}\x\ifin@%
}

% --------------------------------------------------------
% Print string between <...>
\newcommand{\embrace}[1]{\texorpdfstring{$\langle$}{<}#1\texorpdfstring{$\rangle$}{>}}

% --------------------------------------------------------
% Split a string by a character
\newcommand*{\ntgetkeyval}[4][=]{%
  % #1 = character to look for
  % #2 = string to split
  % #3 = macro to receive the left part
  % #4 = macro to receive the right part
  \StrCut{#2}{#1}#3#4%
}

% --------------------------------------------------------
% Alias for consistency in template.tex
\def\ntmajorfield(#1)#2{\majorfield(#1):={#2}}
\def\ntdegreename(#1)#2{\degreename(#1):={#2}}
\def\ntspecialization(#1)#2{\specialization(#1):={#2}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE DOCUMENT CLASSES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/.cd
  , document/fallback/.new list = {phdprop=phd, phdplan=phd, mscplan=msc}
  , document/class/phd/.new list = {phd, phdprop, phdplan}
  , document/class/msc/.new list = {msc, mscplan}
  , document/class/bsc/.new list = {bsc}
  , document/class/main/.new list = {phd, msc, bsc}
}

\newcommand{\@ifdocclass@ii}[2]{%
  % #1 = document tyoe
  % %2 = possible document calss 
  \ifoptioncontains{/@nt/document/class/#2}{#1}
}

% --------------------------------------------------------
% Check if the document is of a specific class, i.e., bsc, msc, phd or main
\newcommand{\ifmaindoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{#1}{main}}
\newcommand{\ifphddoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{#1}{phd}}
\newcommand{\ifmscdoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{#1}{msc}}
\newcommand{\ifbscdoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{#1}{bsc}}

\newcommand{\ifdocfinal}{\ifoptionequal{/novathesis/docstatus}{final}}
\newcommand{\ifdocprovisional}{\ifoptionequal{/novathesis/docstatus}{provisional}}
\newcommand{\ifdocdraft}{\ifoptionequal{/novathesis/docstatus}{draft}}
\newcommand{\ifdocworking}{\ifoptionequal{/novathesis/docstatus}{working}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FRONTEND FOR MANAGING PERSON LISTS - nunsued for now
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ntcommittee[#1,#2]#3{%
  \ntaddperson{committee}[#1,#2]{#3}%
}

\def\ntauthor[#1,#2]#3{%
  \ntaddperson{author}[#1,#2]{#3}%
}

\def\ntadviser[#1,#2]#3{%
  \ntaddperson{adviser}[#1,#2]{#3}%
}

\def\ntcoadviser[#1,#2]#3{%
  \ntaddperson{coadviser}[#1,#2]{#3}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE PERSON LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ntaddperson#1[#2]#3{%
  % See "\@ntaddperson@iv" below
  \IfSubStr{#2}{,}%
    {\@ntaddperson@iv{#1}[#2]{#3}}%
    {\@ntaddperson@iv{#1}[,#2]{#3}}%
}

\def\@ntaddperson@iv#1[#2,#3]#4{%
  % #1 = {author, adviser, committee}
  % #2={c,r,a,m}
  %     c = chair
  %     r = raporteur/referee
  %     a = adviser
  %     m = other members
  %     g = guests
  % #3={m,f}
  % #4={committee member name, position, etc}
  \options{/@nt/#1/#2/gender/.cpush = {#3}}%
  \options{/@nt/#1/#2/name/.cpush = {#4}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE FILE LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntaddfile}[1]{%
  % syntax: \ntaddfile{class}[key]{filename}
  %         #1 = file family (quote, abstract, chapter, etc)
  %         #2 = [file lang] (OPTIONAL)
  %         #3 = filename
  % \typeout{NT ntaddfile [#1]}
  \@nt@addtolist{file}{#1}%
}

\newcommand*{\@nt@addtolist}[2]{%
  % syntax: \ntaddto{type}{class}[key]{filename}
  %         #1  = {file, person}
  %         #2 = family {quote, abstract, chapter, etc} or {author, adviser, committee}
  %         #3 = [file lang] (OPTIONAL)
  %         #4 = filename
  \@ifnextchar[{\@nt@addtolist@iv[#1]#2}{\@nt@addtolist@iv[#1]#2[VAL]}%
}

\def\@nt@addtolist@iv[#1]#2[#3]#4{%
  % syntax: \@ntaddfile@iii{type}{class}[key]{filename}
  %         #1  = {file, person}
  %         #2 = file family (quote, abstract, chapter, etc)
  %         #3 = optional file lang
  %         #4 = filename
  % \typeout{NT ADDFILE [#1] [#2] [#3] [#4]}%
  % \typeout{NT @ntaddlisthook#1#2 @ntaddlisthook#1#2#3}
  \ifcsdef{@ntaddlisthook#1#2}{\@nameuse{@ntaddlisthook#1#2}{#3}{#4}}{}%
  \ifcsdef{@ntaddlisthook#1#2#3}{\@nameuse{@ntaddlisthook#1#2#3}{#4}}{}%
  \@nt@addtolist@iii{#1}{#2}{#3=#4}%
}

\newcommand*{\@nt@addtolist@iii}[3]{%
  % #1 = {file, person}
  % #2 = file family (quote, abstract, chapter, etc)
  % #3 = filename OR key=filename
  % \typeout{NT FILE ADD /novathesis/#1/#1 = #2}%
  \options{/@nt/#1/#2/.cpush = {#3}}%
}

\newcommand{\@nt@foralllist}[3]{%
  % #1 = {file, person}
  % #2 = file family (quote, abstract, chapter, etc)
  % #3 = macro to be applied, which will receive the item from the list
  \optionlistdo{/@nt/#1/#2}{#3{##1}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multilingual support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\@nt@select@lang}[1]{%
  % #1 = lang {pt, en, fr, it}
  \options{/@nt/langshorttolong=#1}%
  \edef\@nt@tmp{\option{/@nt/langshorttolong}}%
  % \typeout{'NT SWITCHING LANG TO = '\nt@tmp}%
  \expandafter\selectlanguage\expandafter{\@nt@tmp}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING ADDITINAL FILES BEFORE LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% SOME PRELIMINARY LANGUAGE DEFINITIONS
\assocarray{abstractorder}
\input{NOVAthesisFiles/lang-conf.tex}

% --------------------------------------------------------
% PROCESS PACKAGE OPTIONS
\input{NOVAthesisFiles/options.tex}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% LOAD MAIN CLASS AND ADDITIONAL PACKAGES
\LoadClass{memoir}
\OnehalfSpacing% One-and-half spacing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING ADDITINAL FILES AFTER LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% LOAD ADDITIONAL PACKAGES
\input{NOVAthesisFiles/packages.tex}

% --------------------------------------------------------
% FIX BABEL TRANSLATION
\input{NOVAthesisFiles/fix-babel.tex}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COVER DEFINITION MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntaddtocover}[4]{%
  % #1 = cover number {1, 2}    (1 is the default)
  % #2 = position {l, c, r}
  % #3 = distance from previous {length, integer}  (if integer uses proportional spacing)
  % #4 = the code
  % \typeout{NT ntaddtocover [/@nt/cover/\option{/novathesis/school}/element = #1 #2]}
  \options{/@nt/cover/\option{/novathesis/school}/element/.cpush = {#1=[#2][#3]{#4}}}
}

\newlength{\mpwidth}%
\newlength{\mpheight}%
\newsavebox{\@nt@coverbox}%

\newcommand*{\ntprintcovers}{%
  \bgroup%
    % \thispagestyle{empty}%
    \ntcoverprehook{1}%
    \@nt@select@lang{\option{/novathesis/coverlang}}%
    \@nt@printthecover{1}%
    \ntcoverposthook{1}%
    \iftoggle{/novathesis/secondcover}%
      {% SECOND COVER TRUE
          \ntcoverprehook{2}%
          \@nt@printthecover{2}%
          \ntcoverposthook{2}%
      }%
      {}% NO SECOND COVER
    \@nt@select@lang{\option{/novathesis/mainlang}}%
  \egroup%
}

\newcommand*{\ntcoverprehook}[1]{%
  \ifxeorlua{\setmainfont[Ligatures=TeX]{Helvetica}}{\fontfamily{phv}}%
}

\newcommand*{\ntcoverposthook}[1]{}

\def\thecovernumber{}
\newcommand{\casecovernumber}{%
  \expandafter\if\thecovernumber1\relax\expandafter\@firstoftwo\else\expandafter\@secondoftwo\fi%
}

\newcommand*{\@nt@printthecover}[1]{%
  % #1 = cover number {1, 2}    (1 is the default)
  \def\thecovernumber{#1}%
  \iftoggle{/novathesis/debugcover}%
    {%
      \color{blue}%
      \edef\@nt@tmpleft{\themargin(\option{/novathesis/docdegree},left)}%
      \edef\@nt@tmpright{\themargin(\option{/novathesis/docdegree},right)}%
      \edef\@nt@tmptop{\themargin(\option{/novathesis/docdegree},top)}%
      \edef\@nt@tmpbottom{\themargin(\option{/novathesis/docdegree},bottom)}%
      \fgrulerthickcm{}{}{1pt}
      % \setfgruler{numsep=-17pt}
      \fgruler[cm]{upperleft}{\@nt@tmpleft}{\@nt@tmptop}
      \fgruler[cm]{lowerright}{\@nt@tmpright}{\@nt@tmpbottom}
      % \fgruler[cm]{upperleft}{\themargin(\option{/novathesis/docdegree},left)}{\themargin(\option{/novathesis/docdegree},top)}
      % \fgruler[cm]{lowerright}{\themargin(\option{/novathesis/docdegree},right)}{\themargin(\option{/novathesis/docdegree},bottom)}
    }%
    {}%
  \thispagestyle{empty}%
  \setlength{\mpwidth}{\dimexpr%
    \paperwidth%
      -\themargin(\option{/novathesis/docdegree},left)%
      -\themargin(\option{/novathesis/docdegree},right)}%
  \setlength{\mpheight}{\dimexpr%
    \paperheight%
      -\themargin(\option{/novathesis/docdegree},top)%
      -\themargin(\option{/novathesis/docdegree},bottom)}%
  \sbox{\@nt@coverbox}{%
    \begin{minipage}[t][\mpheight][t]{\mpwidth}%
      \@nt@printcovergroup{#1}%      
    \end{minipage}%
  }%
  \AddToShipoutPictureFG*{%
    \AtPageUpperLeft{%
      \put(%
        \LenToUnit{\themargin(\option{/novathesis/docdegree},left)},%
        -\LenToUnit{\themargin(\option{/novathesis/docdegree},top)})%
        {\usebox{\@nt@coverbox}}%
    }%
  }%
  ~% This space is important here so that the cover page is not empty anymore!
  \csuse{@thecover#1backpage}%
  \clearforchapter
}

\newcommand*{\@nt@printcovergroup}[1]{%
  % #1 = cover number {1, 2}    (1 is the default)
  \optionlistdo{/@nt/cover/\option{/novathesis/school}/element}{%
    % \typeout{NT printcovergroup [##1]}
    \@nt@printcoverelement@iv##1[#1]%
  }%
}

\def\@nt@printcoverelement@iv#1=[#2][#3]#4[#5]{%
  % #1 = cover number to apply to {1, 2, {1,2}}
  % #2 = position {l, c, r}
  % #3 = distance from previous {length, integer}  (if integer uses proportional spacing)
  % #4 = the code
  % #5 = curernt cover number {1, 2, {1,2}}
  % \typeout{NT novathesis@printcoveritem [#1] [#2]}
  \IfSubStr{#1}{#5}{%
    \IfInteger{#3}{%IS INTEGER
      \ntrepeat\to{#3}\do{\vfill}
    }{%IS NOT INTEGER
      \vspace*{#3}%
    }%
    \noindent%
    \iftoggle{/novathesis/debugcover}{% IF in debug mode surround element in box
      \setlength{\fboxsep}{0pt}%
      \fbox{%
        \begin{minipage}[t]{\linewidth}%
          \if#2l\relax\raggedright\fi%
          \if#2c\relax\centering\fi%
          \if#2r\relax\raggedleft\fi%
          #4%
        \end{minipage}%
      }%
    }{% Not in debug mode
      \begin{minipage}[t]{\linewidth}%
        \if#2l\relax\raggedright\fi%
        \if#2c\relax\centering\fi%
        \if#2r\relax\raggedleft\fi%
        #4%
      \end{minipage}%
    }%
    \par%
  }{}%
}

\newcommand{\ntfixspacing}{%
  \iftoggle{/@nt/ntfixspacing}{}
  {%
    % \options{/@nt/ntfixspacing = true}
    \newpage%
    \thispagestyle{empty}%
    \null\vfill%
    \begin{Spacing}{1}%
      \scriptsize%
      \ifxeorlua{\setmainfont[Ligatures=TeX]{Helvetica}}{\fontfamily{phv}}%
      \fontsize{6.3}{6.3}\selectfont% 
      \noindent%
      \hypersetup{allcolors=white}\textcolor{white}%
                 {\theacknowledgmentsstr(\option{/novathesis/coverlang})}%
    \end{Spacing}%
  }
}

\csdef{@thecover1backpage}{%
  \ntfixspacing%
}

\csdef{@thecover2backpage}{%
  \ntfixspacing%
}

\newcommand{\ntprintbackcoverpage}{%
  \ifaadefined{thesiscover}(\option{/novathesis/docdegree},back){%
    \clearforchapter%
    \thispagestyle{empty}%
    ~%
    \clearpage%
    \thispagestyle{empty}%
    \ntcoverbackground(\@nameuse{thesiscover\option{/novathesis/docdegree},back})%
    ~% This space is important here so that the cover page is not empty anymore!
    \clearforchapter%
    \@nt@select@lang{\option{/novathesis/mainlang}}%
  }{}%
}

% \newcommand{\ntcoverbackground}[1][\@nameuse{thesiscover\option{/novathesis/docdegree},front}]{%
\newcommand{\ntcoverbackground}[1][\thethesiscover(\option{/novathesis/docdegree},front)]{%
  \IfEq{#1}{}{}{%ELSE
    \AddToShipoutPictureBG*{%
      \includegraphics[width=\paperwidth,height=\paperheight]{#1}%
    }%
  }%
}

\newcommand*{\ntprintaftercover}{%
  \ifthenelse{\equal{\option{/novathesis/aftercover}}{true}}%
  {%
    \InputIfFileExists{Chapters/\@nt@aftercover@file}%
      {\clearforchapter}%
      {}%
	}%
  {}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definition of associative arrays
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\@nt@undefined[1][]{\embrace{#1 \thenotdefined(\option{/novathesis/mainlang})}}

\assocarray{abstractstring}
\assocarray{keywordsstring}
\assocarray{acknowledgementsstring}
\assocarray{notdefined}
\assocarray{specializationstr}

\assocarray{adviserstr}
\assocarray{adviserstrfont}
\assocarray{coadviserstr}
\assocarray{coadviserstrfont}
\assocarray{degreestr}
\assocarray{degreestrfont}

\assocarray{degreename}

\assocarray{docdegreestr}

\assocarray{committeeorder}
\assocarray{committeetitlestr}
\assocarray{committeetitlestrfont}
\assocarray{committeememberstr}
\assocarray{committeememberstrfont}

\assocarray{dissertationstr}
\assocarray{dissertationstrfont}
\assocarray{copyrighttextstr}
\assocarray{acknowledgmentsstr}

\assocarray{majorfield}
\assocarray{specialization}

\newcommand{\initassocarray}[2][\embrace{\notdefined(\option{/novathesis/coverlang})}]{
  \optionlistdo{/@nt/langsshort}{%
    \csuse{#2}(##1):={#1}%
  }%
}

\optionlistdo{/@nt/langsshort}{%
  \adviserstrfont(#1):={}%
  \coadviserstrfont(#1):={}%
  \committeememberstrfont(#1):={}%
  \committeetitlestrfont(#1):={}%
  \degreestrfont(#1):={}%
  \dissertationstrfont(#1):={}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include strings for all the languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\optionlistdo{/@nt/langsshort}{%
  \InputIfFileExists{NOVAthesisFiles/Strings/strings-#1.ldf}%
    {}%
    {}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defaults for uniersity, faculty, degree, etc…
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \assocarray{university}
% \assocarray{faculty}
% \assocarray{department}
\assocarray{spine}
\assocarray{thesiscover}
\assocarray{margin}
\assocarray{frontpageimage}


\newcommand{\@nt@newassocarray}[1]{%
  \assocarray{#1}%
  \initassocarray[\embrace{\MakeUppercase{#1}}]{#1}%
}
\forcsvlist{\@nt@newassocarray}{university,faculty,department}

% --------------------------------------------------------
% Add school specific Images folder to the graphics path
\prependtographicspath{{NOVAthesisFiles/Schools/\option{/novathesis/school}/Images/}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\gdef\thepresentationtext{%
	\thedissertationstr(\option{/novathesis/docdegree},\option{/novathesis/coverlang})%
}

\gdef\thecopyrightstr{%
  \thispagestyle{empty}%
  \@nt@select@lang{\option{/novathesis/copyrightlang}}%
  \noindent%
  Copyright \textcopyright\ \theauthorname, %
  \thefaculty(\option{/novathesis/copyrightlang}), \theuniversity(\option{/novathesis/copyrightlang}).\\%
  \thecopyrighttextstr(\option{/novathesis/copyrightlang})%
  \@nt@select@lang{\option{/novathesis/mainlang}}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date and month
\newcommand{\thentdatemonth}{\@nt@undefined[Month]}
\newcommand{\thentdateyear}{\@nt@undefined[Year]}

\newcommand{\ntdatemonth}[1]{\renewcommand{\thentdatemonth}{#1}}
\newcommand{\ntdateyear}[1]{\renewcommand{\thentdateyear}{#1}}

%% Author identification
\newcommand{\theauthorname}{\@nt@undefined[Author Name]}
\newcommand{\theauthorshortname}{\@nt@undefined[Author Short Name]}
\newcommand{\theauthorgender}{\@nt@undefined[Author Gender]}
\newcommand{\theauthordegree}{\@nt@undefined[Author Degree]}

\newcommand{\ntauthorname}[3][m]{% [m|f]{Long name}{Short name}
  \renewcommand{\theauthorgender}{#1}%
  \renewcommand{\theauthorname}{#2}%
  \renewcommand{\theauthorshortname}{#3}%
  \AtBeginDocument{\hypersetup{pdfauthor = {#2}}}
}

\newcommand{\ntauthordegree}[1]{%
  \renewcommand{\theauthordegree}{#1}%
}

 
%% Work identification
\newcommand{\thecovertitle}[1][]{%
  % \typeout{NT thecovertitle [#1]}
  \ifstrempty{#1}%
    {\thedoccovertitle(\option{/novathesis/coverlang})}%
    {\thedoccovertitlecaps(\option{/novathesis/coverlang})}
}

\newcommand{\thetitle}[1][\option{/novathesis/coverlang}]{%
  \thedoctitle(#1)%
}

\assocarray{doccovertitle}
\assocarray{doccovertitlecaps}
\assocarray{doctitle}

\def\@thetitle{}

\newcommand{\nttitle}[2][\option{/novathesis/coverlang}]{%
  % \typeout{NT nttitle [#1] [#2]}
    \saveexpandmode\noexpandarg% set \noexpandarg locally
      \StrSubstitute[0]{#2}{\\}{ }[\@thetitle]%
      \StrSubstitute[0]{#2}{\\}{\newline}[\@thetitleii]%
      % \def\@thetitleiii{\expandafter\MakeUppercase\expandafter{\@thetitleii}}
      % \StrSubstitute[0]{\@thetitleiii}{@}{\newline}[\@thetitleiv]%
    \restoreexpandmode% restore the previous mode
    \doccovertitle(#1):={#2}%
    \doccovertitlecaps(#1):={\expandafter\MakeUppercase\expandafter{\@thetitleii}}%
    \doctitle(#1):=\@thetitle%
    \ifthenelse{\equal{#1}{\option{/novathesis/coverlang}}}{%
      \AtBeginDocument{%
        \hypersetup{pdftitle = {\@thetitle}}%
        \hypersetup{pdfsubject = {\thepresentationtext}}
      }%
    }{}%
  % \typeout{NT TITLE = [#2][\@thetitle]}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print option list as a comma separated list
%%% with "and" prefixing the last element
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \newcommand{\printoptionlist}[3]{%
%   % #1 = options list
%   % #2 = separator (e.g, ",")
%   % #3 = last separator (e.g., "and")
%   \letoptionlist{#1}\@nt@list
%   \StrCount{\@nt@list}{,}[\@nt@count]
%   \ifcase\@nt@count
%     % case 0
%     #1
%   \or
%     % case 1
%     \StrSubstitute{\@nt@list}{,}{ and }
%   \else
%     % other
%     \StrSubstitute[\the\numexpr \@nt@count-1]{\@nt@list}{,}{|}[\@nt@list@i]
%     \StrSubstitute{\@nt@list@i}{,}{ #3 }[\@nt@list@ii]
%     \StrSubstitute{\@nt@list@ii}{|}{#2}
%   \fi
% }

%%%% Alternative hand-made implementation
% \newcommand{\@nt@printoptionlist}[3]{%
  % #1 = options list
  % #2 = separator (e.g, ",")
  % #3 = last separator (e.g., "and")
%   \@nt@newcounter[1]{@ntprintoptionlist@cnt}
%   \def\@nt@comma{}%
%   \optionlistdo{#1}{%
%     \StrCut{##1}{,}\@nt@name\@nt@rest%
%     \@nt@comma\@nt@name%
%     \stepcounter{@ntprintoptionlist@cnt}%
%     \ifnum\value{\option{#1/@size}}=\value{@ntprintoptionlist@cnt}%
%       \def\@nt@comma{#3}%
%     \else%
%       \def\@nt@comma{#2}%
%     \fi%
%   }%
% }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print advisers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintadvisersaslist}[1][adviser,coadviser]{%
  % \printoptionlist{/@nt/#1//name}{, }{ and }
  \gdef\@nt@addviserslist{}%
  \setnewcounter{@nt@advisertotal}{0}%
  \forcsvlist\@nt@getadvisername{#1}%
  \setnewcounter{@nt@advisern}{0}%
  \expandnext{\forcsvlist\@nt@printadvisersaslist}{\@nt@addviserslist}%
}

\newcommand{\@nt@getadvisername}[1]{%
  \optionlistdo{/@nt/#1//name}{%
    \StrCut{##1}{,}\@nt@tmpl\@nt@tmpr%
    \xdef\@nt@addviserslist{\@nt@addviserslist,\@nt@tmpl}%
    \stepcounter{@nt@advisertotal}%
  }%
}

\newcommand{\@nt@printadvisersaslist}[1]{%
  \stepcounter{@nt@advisern}%
  \ifnum\value{@nt@advisern}=\value{@nt@advisertotal}%
    { and }%
  \else\ifnum\value{@nt@advisern}>1%
    {, }%
  \fi\fi%
  #1%
}

\newcommand{\ntprintadvisersgroup}[2][0.90]{%
  % #1 = width
  % %2 = {adviser,coadviser}
  \ifoptiondefined{/@nt/#2//name}{%
    \bgroup
      \csuse{the#2strfont}(\option{/novathesis/coverlang})%
      \csuse{the#2str}(\option{/novathesis/coverlang})\\[1ex]%
    \egroup
    \begin{minipage}[t]{#1\linewidth}%
      \centering
      \optionlistdo{/@nt/#2//name}{\@nt@printadvisersgroup##1,\@nil}%
    \end{minipage}%
  }%
  {\ClassWarning{novathesis}{option[/@nt/#1//name] undefined}}%
}

\def\@nt@printadvisersgroup#1,#2\@nil{%
  #1\\
  \IfEq{#2}{}{\medskip}{\@nt@printadvisersgroup#2\@nil}%
}

\newcommand{\ntprintadvisers}[1][0.90]{%
  \begin{minipage}{#1\textwidth}
  % #1 = Percentage of \textwidth used by the advisers list
  \begin{tabularx}{\linewidth}{@{}rX@{}}%
  \forcsvlist{\@nt@printadvisergroup}{adviser,coadviser}
  \end{tabularx}%
  \end{minipage}
}

\newcommand{\@nt@printadvisergroup}[1]{%
  % #1={adviser,coadviser}
    \ifoptiondefined{/@nt/#1//name}{%
      \@nt@reducegender{/@nt/#1//gender}{\mygender}%
      \@nt@reducenumber{/@nt/#1//name}{\mynumber}%
      \smallskip%
      \csuse{the#1strfont}(\option{/novathesis/coverlang})%
      \csuse{the#1str}(\mynumber,\mygender,\option{/novathesis/coverlang}): & %
      \begin{minipage}[t]{\linewidth}\raggedright%
      \optionlistdo{/@nt/#1//name}{##1\\[1pt]}%
      \end{minipage}\\%
    }%
    {\ClassWarning{novathesis}{option[/@nt/#1//name] undefined}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print committee
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintcommittee}[1][0.75]{\ifmaindoc{\@nt@printcommittee@i{#1}}{}}

\newcommand{\@nt@printcommittee@i}[1]{%
  \iftoggle{/novathesis/printcommittee}{% TRUE
    \begin{minipage}{#1\textwidth}%
    % #1 = Percentage of \textwidth used by the committee list
    \begin{tabularx}{\linewidth}{@{}rX@{}}%
    \@ntprintcommitteetitlestr\\[1ex]%
    \forcsvlist{\@ntprintcommitteegroup}{c,r,a,m,g}%
    \end{tabularx}%
    \end{minipage}
  }%
  {%% FASLE
  }%
}

\newcommand*{\@ntprintcommitteetitlestr}{%
  % \ifx\@nt@tmp\@empty%
  \expandnext{\ifx}{\thecommitteetitlestr(\option{/novathesis/coverlang})}\@empty%
    % committeetitlestr[…] is empty
  \else%
    \multicolumn{2}{c}{{%%
            \thecommitteetitlestrfont(\option{/novathesis/coverlang})%
            \thecommitteetitlestr(\option{/novathesis/coverlang}):}%
          }%
  \fi%
}

\newcommand{\@ntprintcommitteegroup}[1]{%
  % #1={c,r,a,m,g}
  \ifoptiondefined{/@nt/committee/#1/name}{%
    \@nt@reducegender{/@nt/committee/#1/gender}{\mygender}%
    \@nt@reducenumber{/@nt/committee/#1/name}{\mynumber}%
    \smallskip%
    \thecommitteememberstrfont(\option{/novathesis/coverlang})%
    \thecommitteememberstr(#1,\mynumber,\mygender,\option{/novathesis/coverlang}): & %
    \begin{minipage}[t]{\linewidth}\raggedright%
    \optionlistdo{/@nt/committee/#1/name}{##1\\[1pt]}%
    \end{minipage}\\%
  }%
  {}%
}

\newcommand*{\@nt@reducegender}[2]{%
  % #1 = gender list
  % #2 = result
  \gdef#2{f}%
  \optionlistdo{#1}{\if##1m\relax\gdef#2{m}\fi}%
}

\newcommand{\@nt@reducenumber}[2]{%
  % #1 = number
  % #2 = result
  \ifnum\value{\option{#1/@size}}=1%
    \gdef#2{1}%
  \else%
    \gdef#2{2}%
  \fi%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include the School's defaults
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\InputIfFileExists{NOVAthesisFiles/Schools/\option{/novathesis/school}/defaults.ldf}{}{}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtEndPreamble{\ntsetlayout}

\newcommand{\ntsetlayout}{%
  \synctex=1% Use synctex
  \brokenpenalty=10000
  \settypeoutlayoutunit{mm}
  \setulmarginsandblock%
    {\themargin(\option{/novathesis/media},top)}%
    {\themargin(\option{/novathesis/media},bottom)}%
    {*}%
  \setlrmarginsandblock%
    {\themargin(\option{/novathesis/media},left)}%
    {\themargin(\option{/novathesis/media},right)}%
    {*}%
  \checkandfixthelayout%
}

%% For debugging the page layout
\newcommand\@nt@typetwolengths[4]{%
  % #1 = text before
  % #2 = first length
  % #3 = text between
  % #4 = second length
  \setlength\@tempdimc{\mem@tl@unitperpt #2}%
  \edef\l@first{\strip@pt\@tempdimc}%
  \setlength\@tempdimc{\mem@tl@unitperpt #4}%
  \edef\l@second{\strip@pt\@tempdimc}%
  #1: \l@first\mem@tl@unit\space#3\space\l@second\mem@tl@unit%
}

\newcommand\@nt@typeonelength[2]{%
  % #1 = text before
  % #2 = first length
  \setlength\@tempdimc{\mem@tl@unitperpt #2}%
  \edef\l@first{\strip@pt\@tempdimc}%
  #1: \l@first\mem@tl@unit%
}

\newcommand*{\typelayout}{%
  \hrule%
  \@nt@typetwolengths{Stock height and width}{\stockheight}{by}{\stockwidth}\\%
  \@nt@typetwolengths{Top and edge trims}{\trimtop}{and}{\trimedge}\\%
  \@nt@typetwolengths{Page height and width}{\paperheight}{by}{\paperwidth}\\%
  \@nt@typetwolengths{Text height and width}{\textheight}{by}{\textwidth}\\%
  \@nt@typetwolengths{Spine and edge margins}{\spinemargin}{and}{\foremargin}\\%
  \@nt@typetwolengths{Upper and lower margins}{\uppermargin}{and}{\lowermargin}\\%
  \@nt@typetwolengths{Headheight and headsep}{\headheight}{and}{\headsep}\\%
  \@nt@typeonelength{Footskip}{\footskip}\\%
  \@nt@typetwolengths{Columnsep and columnseprule}{\columnsep}{and}{\columnseprule}\\%
  \@nt@typetwolengths{Marginparsep and marginparwidth}{\marginparsep}{and}{\marginparwidth}\\%
  \@nt@typetwolengths{Sidecapsep and sidecapwidth}{\sidecapsep}{and}{\sidecapwidth}\\%
  \@nt@typetwolengths{Sidebarhsep and sidebarwidth}{\sidebarhsep}{and}{\sidebarwidth}\\%
  \@nt@typetwolengths{Sidebarvsep and sidebartopsep}{\sidebarvsep}{and}{\sidebartopsep}\\%
  \@nt@typeonelength{Sidebarheight}{\dimen\sideins}\\%
  \@nt@typetwolengths{Sidefoothsep and sidefootwidth}{\sidefoothsep}{and}{\sidefootwidth}\\%
  \@nt@typetwolengths{Sidefootvsep and sidefootheight}{\sidefootvsep}{and}{\sidefootheight}\\%
  \hrule%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fonts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\quotefont{\normalfont\normalsize}
\newcommand\quotefonti{\itshape\normalsize}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Printing chapters and similars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\@ntloadfisrt@ii}[2][VAL]{%
  % #1 = KEY
  % #2 = file class
  \options{/@nt/file/#2/.getval = {#1}}%
  % \typeout{NT TRYING TO LOAD \option@listmatch@value}%
  \InputIfFileExists{\option@listmatch@value}{}{}%
}

\newcommand{\@ntloadnext@ii}[2]{%
  % #1 = file class
  % #2 = KEY=value
  % \typeout{NT @ntprintnext@ii [#1] [#2]}%
  \ntgetkeyval{#2}{\option@listmatch@key}{\option@listmatch@value}%
  % \typeout{NT @ntprintnext@ii TRYING TO LOAD \option@listmatch@value}%
  \InputIfFileExists{\option@listmatch@value}{}{}%
}

\newcommand{\@nt@printifmaindoc@i}[1]{%
  % \typeout{NT Attemnpting to load #1}%
	\ifmaindoc{% THEN it is a main document
    \@ntloadfisrt@ii{#1}%
	}{% ELSE
    % It is a plan or proposal type document
	}%  
}

\newcommand{\ntprintdedicatory}{\@nt@printifmaindoc@i{dedicatory}\ntfixspacing\clearforchapter}

\newcommand{\ntprintquote}{\@nt@printifmaindoc@i{quote}\ntfixspacing\clearforchapter}

\newcommand{\ntprintacknowledgements}{\@nt@printifmaindoc@i{acknowledgements}\ntfixspacing\clearforchapter}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Abstract, Acronyms and Glossary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintabstracts}{%
  \xdef\@nt@tmp{\theabstractorder(\option{/novathesis/mainlang})}%
  \expandnext{\forcsvlist{\@ntprintabstract}}{\@nt@tmp}%
}

\newcommand{\@ntprintabstract}[1]{%
  % \typeout{NT PRINT ABSTRACT #1}%
  \setabstractlang{#1}%
  \@ntloadfisrt@ii[#1]{abstract}%
  \@nt@select@lang{\option{/novathesis/mainlang}}%
  \ntfixspacing%
}


\newcommand{\thesisfrontmatter}{%
  \frontmatter%
  \@nt@select@lang{\option{/novathesis/mainlang}}%
  \pagenumbering{roman}%
  \setlength{\headheight}{15pt}%
}

\newcommand{\ntthesismainmatter}{%
  % enables protrusion locally for the remainder of the document
  \ifxeorlua{}{\microtypesetup{protrusion=true}}%
	\mainmatter%
	\pagenumbering{arabic}%
	\setlength{\headheight}{15pt}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntchapterfile}[1]{\listgadd{\@nt@chapter@list}{#1}}


\newcommand{\ntprintchapters}{%
    \@nt@foralllist{file}{chapter}{\@ntloadnext@ii{chapter}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Appendixes and Annexes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\ntprintappendixes}{%
  \renewcommand{\appendixtocname}{\appendixnamepl}%
  \clearforchapter\appendix\addappheadtotoc%
  \@nt@foralllist{file}{appendix}{\@ntloadnext@ii{appendix}}%
}

\newcommand{\ntprintannexes}{%
  \renewcommand{\appendixtocname}{\annexnamepl}%
  \clearforchapter\annex\addappheadtotoc%
  \@nt@foralllist{file}{annex}{\@ntloadnext@ii{annex}}%
}


\newcommand{\annex}{
  \xdef\Hy@chapapp{annex}%
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\annexname}%
  \gdef\thechapter{\@Roman\c@chapter}%
  }



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with optional lists in the frontmatter: listoftables, litoffigures, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newlistof{lstlistoflistings}{lol}{\lstlistlistingname}


\newcommand{\ntaddindex}[1]{%
  \ifthenelse{\equal{#1}{tableofcontents}}{\options{/@nt/list/indexes/.cpush = {%
        \clearforchapter\tableofcontents*%
  }}}{}%
  \ifthenelse{\equal{#1}{listoffigures}}{\options{/@nt/list/indexes/.cpush = {%
        \clearforchapter\listoffigures%
  }}}{}%
  \ifthenelse{\equal{#1}{listoftables}}{\options{/@nt/list/indexes/.cpush = {%
        \clearforchapter\listoftables%
  }}}{}%
  \ifthenelse{\equal{#1}{listoflistings}}{\options{/@nt/list/indexes/.cpush = {%
        \clearforchapter\lstlistoflistings%
  }}}{}%
  \ifthenelse{\equal{#1}{listsofglossaries}}{\options{/@nt/list/indexes/.cpush = {%
          \printnoidxglossaries\clearforchapter%
  }}}{}%
}

\newcommand{\ntprintallindexes}{\optionlistdo{/@nt/list/indexes}{##1}}


% \def\option@listmatch@getval#1=#2{#2}
\newcommand*{\option@listmatch}[2]{
  % \typeout{NT LISTMATCH [#1] [#2]}%
  \StrCut{#2}{=}\option@listmatch@key\option@listmatch@value%
  % \typeout{K=\option@listmatch@key ~V=\option@listmatch@value}
  \ifthenelse{\equal{\option@listmatch@key}{#1}}{\listbreak}{}%
}%
\options{/handlers/getval/.new operation = {%
  % \typeout{NT GETVAL [#1] [#2]}%
    \optionlistdo{#1}{\option@listmatch{#2}{##1}}%
  }%
}

\newcommand{\@loadglossaryfiles}{%
  \optionlistdo{/@nt/file/glossaries}{\@loadglossaryfile{##1}}
}

\newcommand{\@loadglossaryfile}[1]{%
  % #1 = {glossary, acronyms, symbols}={filename}
  \ntgetkeyval{#1}{\@nt@key}{\@nt@value}
  % \typeout{NT @loadglossaryfile [\@nt@key][\@nt@value]}
  \IfFileExists{\@nt@value}%
    {\loadglsentries{\@nt@value}}%
    {}%
}

\AtEndPreamble{\@loadglossaryfiles}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\@ntaddlisthookfilebib}[2]{%
  \letoptionlist{/@nt/biblatex}\nt@tmp%
  % \typeout{'NT PASSING TO BIBLATEX= '\nt@tmp}%
  \RequirePackage[hyperref=true,\nt@tmp]{biblatex}%
  \setcounter{biburlnumpenalty}{100}% Allow to break DOIs in bibliography
  % \typeout{'NT ADD BIBLATEX RESOURCE= '#2}%
  \addbibresource{#2}%
}

\newcommand{\ntprintbib}[1][]{%
  \ifthenelse{\isempty{#1}}%
  {\printbibliography}%
  {\printbibliography[title=#1]}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintcopyright}{%
	\ifmaindoc{% THEN
    \iftoggle{/novathesis/printcopyright}%
      {\ntprintcopyrightpage\ntfixspacing\clearforchapter}%
      {}%
	}{}%
}

\newcommand{\ntprintcopyrightpage}{%
	\clearforchapter%
	\null\vfill%
  \noindent%
  \textbf{\large \thetitle}\par%
  \bigskip%
  \thecopyrightstr\par%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dedicatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewEnviron{ntdedicatory}{
  \thispagestyle{empty}%
  ~\\[2cm]%
  \begin{minipage}{\linewidth}%
    \raggedleft%
    \begin{minipage}{100mm}%
      \raggedleft%
      \quotefonti%
      \BODY
      \normalfont%
    \end{minipage}%
  \end{minipage}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quote
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewEnviron{ntquote}{%%
  \thispagestyle{empty}%
  ~\\[2cm]%
  \begin{minipage}{\linewidth}%
    \raggedleft%
    \begin{minipage}{100mm}%
      \raggedleft
      \quotefonti%
      \BODY%
      \normalfont%
    \end{minipage}%
  \end{minipage}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewEnviron{ntacknowledgements}{%
  \chapter*{\theacknowledgementsstring(\option{/novathesis/mainlang})}%
  \BODY
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@nt@keywordsstr}{}
\newcommand{\setabstractlang}[1]{%
	\@nt@select@lang{#1}%
  \renewcommand{\@nt@keywordsstr}{\thekeywordsstring(#1)}%
	\chapter*{\theabstractstring(#1)}%
	\rule{\textwidth}{0.2mm} ~\\[-3.5ex]%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newtoggle{@nt@keywords@defined}
\togglefalse{@nt@keywords@defined}
\NewEnviron{keywords}[1][\option{/@nt/langshorttolong}]{%
  \csdef{@nt@keywords@#1}{\BODY}
  \iftoggle{@nt@keywords@defined}%
    {}%
    {\hypersetup{pdfkeywords = {\BODY}}}
  \par\vskip\baselineskip\noindent{\bfseries\@nt@keywordsstr: }%
  \BODY%
  \\[2ex]\rule{\textwidth}{0.2mm}  
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
% Text style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtEndPreamble{%
\InputIfFileExists{NOVAthesisFiles/ChapStyles/\option{/novathesis/chapstyle}.ldf}{}{}%
\InputIfFileExists{NOVAthesisFiles/FontStyles/\option{/novathesis/fontstyle}.ldf}{}{}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fixes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fix spacing for pages with roman numerals in ToC
\renewcommand{\@pnumwidth}{2.5em}% default is 1.55em


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compatibility with legacy “template.tex”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Title
\renewcommand{\title}[2][]{\ifthenelse{\equal{#1}{}}{\nttitle{#2}}{\nttitle{#1}}}
\newcommand{\authorname}{\ntauthorname}
\newcommand{\authordegree}{\ntauthordegree}
\newcommand{\datemonth}{\ntdatemonth}
\newcommand{\dateyear}{\ntdateyear}
\newcommand{\adviser}[4][m]{\ntaddperson{adviser}[#1]{#2, #3}}
\newcommand{\coadviser}[4][m]{\ntaddperson{coadviser}[#1]{#2, #3}}
\newcommand{\committee}[2][m]{\ntaddperson{committee}[#1]{#2}}
\newcommand{\dedicatoryfile}[1]{\ntaddfile{dedicatory}{#1}}
\newcommand{\acknowledgementsfile}[1]{\ntaddfile{acknowledgements}{#1}}
\newcommand{\quotefile}[1]{\ntaddfile{quote}{#1}}
\newcommand{\aftercoverfile}[1]{\ntaddfile{aftercover}{#1}}
\newcommand{\abstractfile}[2][pt]{\ntaddfile{abstract}[#1]{#2}}
\newcommand{\chapterfile}[1]{\ntaddfile{chapter}{#1}}
\newcommand{\addbibfile}[1]{\ntaddfile{bib}{#1}}
\newcommand{\glossaryfile}[1]{\ntaddfile{glossaries}[glossary]{#1}}
\newcommand{\acronymsfile}[1]{\ntaddfile{glossaries}[acronyms]{#1}}
\newcommand{\symbolsfile}[1]{\ntaddfile{glossaries}[symbols]{#1}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of Class Hook
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\@nt@AtEnfClass@hook
