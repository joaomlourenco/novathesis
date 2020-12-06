%!TEX root = template.tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% novathesis.cls
%% NOVA thesis document class
%%
%% This work is licensed under the
%% Creative Commons Attribution-NonCommercial 4.0 International License.
%% To view a copy of this license,
%% visit http://creativecommons.org/licenses/by-nc/4.0/.
%%
%% Version 2020-12-05 [5.1.7]
%% Departamento de Informática (www.di.fct.unl.pt)
%% Faculdade de Ciências e Tecnologia (www.fct.unl.pt)
%% Universidade NOVA de Lisboa (www.unl.pt)
%%
%% BUGS and SUGGESTIONS: please submit an issue at the project web page
%%      at: https://github.com/joaomlourenco/novathesis/
%%
%% HELP: please DO NOT SEND ME EMAILS about LaTeX or the NOVAthesis template
%%       please ask for help at the NOVAthesis google group at
%%          https://groups.google.com/forum/#!forum/novathesis
%%      or at the NOVAthesis facebook group at
%%          https://www.facebook.com/groups/novathesis/
%%
%% AUTHOR @github:
%%      - joaomlourenco
%%
%% CONTRIBUTORS @github:
%%      - bcandeias, flaviomartins, tmonteiro2344, jsaramago, microlina, riclas, pedrovieira
%%
%% DONATIONS:
%%     If you think this templatze really helped you while writing your thesis,
%%     think about doing a small donation. Just access the website
%%     https://github.com/joaomlourenco/novathesis/
%%     and click in the “Donation” link.
%%     I'll keep a list thanking to all the identified donors that identify
%%     themselves in the “*Add special instructions to the seller:*” box.
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
%% LOOK FOR PACKAGES ALSO IN "novathesis-files" folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand*{\input@path}{}
\g@addto@macro\input@path{{./}{Chapters/}{novathesis-files/}}% subfolder path


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK IF USING LUALATEX OR XELATEX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\ifxetexorluatex
\begingroup\catcode94=7 \catcode0=9 % ASCII 94 is ^
\def\empty{}\def\next{^^^^0000}\expandafter\endgroup
\ifx\next\empty\xetexorluatextrue\else\xetexorluatexfalse\fi

\newcommand*{\ifxeorlua}[2]{\ifxetexorluatex#1\else#2\fi}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% Do some magic defining arrays :)
\newcommand*{\mynewdata}[1]{%
  \@namedef{#1}[##1]=##2{\@namedef{#1##1}{##2}}%
  \@namedef{the#1}[##1]{\@nameuse{#1##1}}%
}

\def\ifexists#1[#2]#3{\ifcsname #1#2\endcsname#3\fi}

% --------------------------------------------------------
% Check if it is a main document type, i.e., bsc, msc or phd
\newcommand{\ifmaindoc}{
	\ifthenelse{%
    % IF it is not a plan or proposal document type
		\equal{\option{/novathesis/docdegree}}{bsc}% bsc
		\OR%
		\equal{\option{/novathesis/docdegree}}{msc}% msc
		\OR%
		\equal{\option{/novathesis/docdegree}}{phd}% phd
	}%
}
\newcommand{\ifphddoc}{
	\ifthenelse{%
    % IF it is a PHD related document
		\equal{\option{/novathesis/docdegree}}{phd}% phd thesis
		\OR%
		\equal{\option{/novathesis/docdegree}}{phdprop}% phd proposal
		\OR%
		\equal{\option{/novathesis/docdegree}}{phdplan}% phd plan
	}%
}
\newcommand{\ifmscdoc}{
	\ifthenelse{%
    % IF it is a MSC related document
		\equal{\option{/novathesis/docdegree}}{phd}% msc dissertation
		\OR%
		\equal{\option{/novathesis/docdegree}}{phdplan}% man plan
	}%
}

% --------------------------------------------------------
% If necessary create, then initialize the counter
\newcommand*{\@nt@newcounter}[2][0]{%
  \ifcsname c@#2\endcsname\else\newcounter{#2}\fi%
  \setcounter{#2}{#1}%
}

% --------------------------------------------------------
% Itelare a comma separated list
\newcommand{\iteratecsvlist}[2]{%
  \@for\novathesis@themember:=#2\do{#1{\novathesis@themember}}%
}

% --------------------------------------------------------
% Check if a string contains a character
\newcommand{\instring}[2]{TT\fi\begingroup
  % #1 = character to look for
  % #2 = string
  \edef\x{\endgroup\noexpand\in@{#1}{#2}}\x\ifin@%
}

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
\def\ntmajorfield[#1]#2{\majorfield[#1]={#2}}
\def\ntdegreename[#1]#2{\degreename[#1]={#2}}
\def\specialization[#1]#2{\specialization[#1]={#2}}


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
  \if\instring{,}{#2}%
    \@ntaddperson@iv{#1}[#2]{#3}%
  \else%
    \@ntaddperson@iv{#1}[,#2]{#3}%
  \fi%
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
  \options{/novathesis/#1/#2/gender/.cpush = {#3}}%
  \options{/novathesis/#1/#2/name/.cpush = {#4}}%
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
  \options{/novathesis/#1/#2/.cpush = {#3}}%
}

\newcommand{\@nt@foralllist}[3]{%
  % #1 = {file, person}
  % #2 = file family (quote, abstract, chapter, etc)
  % #3 = macro to be applied, which will receive the item from the list
  \optionlistdo{/novathesis/#1/#2}{#3{##1}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multilingual support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\@nt@select@lang}[1]{%
  % #1 = lang {pt, en, fr, it}
  \options{/novathesis/langshorttolong=#1}%
  \edef\@nt@tmp{\option{/novathesis/langshorttolong}}%
  % \typeout{'NT SWITCHING LANG TO = '\nt@tmp}%
  \expandafter\selectlanguage\expandafter{\@nt@tmp}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING ADDITINAL FILES BEFORE LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% SOME PRELIMINARY LANGUAGE DEFINITIONS
\mynewdata{abstractorder}
\input{novathesis-files/lang-conf.clo}

% --------------------------------------------------------
% PROCESS PACKAGE OPTIONS
\input{novathesis-files/options.clo}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% LOAD MAIN CLASS AND ADDITIONAL PACKAGES
\LoadClass{memoir}
\OnehalfSpacing           % One-and-half spacing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING ADDITINAL FILES AFTER LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% LOAD ADDITIONAL PACKAGES
\input{novathesis-files/packages.clo}

% --------------------------------------------------------
% FIX BABEL TRANSLATION
\input{novathesis-files/fix-babel.clo}

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
\newsavebox{\novathesis@coverbox}%

\newcommand*{\ntprintcovers}{%
  \begingroup%
    \@nt@coverprehook%
    % \thispagestyle{empty}%
    \@nt@select@lang{\option{/novathesis/coverlang}}%
    \@nt@printthecover{1}%
    \clearforchapter%
    \iftoggle{/novathesis/secondcover}%
      {% SECOND COVER TRUE
          \@nt@printthecover{2}%
          \clearforchapter%
      }%
      {}% NO SECOND COVER
    \@nt@select@lang{\option{/novathesis/mainlang}}%
  \endgroup%
}

\newcommand*{\@nt@coverprehook}{%
  \ifxeorlua{\setmainfont[Ligatures=TeX]{Helvetica}}{\fontfamily{phv}}%
}

\newcommand*{\@nt@printthecover}[1]{%
  % #1 = cover number {1, 2}    (1 is the default)
  \iftoggle{/novathesis/debugcover}%
    {\thispagestyle{measurestyle}}%
    {\thispagestyle{empty}}
  \setlength{\mpwidth}{\dimexpr%
    \paperwidth%
      -\themargin[\option{/novathesis/docdegree},left]%
      -\themargin[\option{/novathesis/docdegree},right]}%
  \setlength{\mpheight}{\dimexpr%
    \paperheight%
      -\themargin[\option{/novathesis/docdegree},top]%
      -\themargin[\option{/novathesis/docdegree},bottom]}%
  \sbox{\novathesis@coverbox}{%
    \parbox[t][\mpheight][t]{\mpwidth}{%
      \@nt@printcovergroup{#1}%
    }%
  }%
  \AddToShipoutPictureFG*{%
    \AtPageUpperLeft{%
      \put(%
        \LenToUnit{\themargin[\option{/novathesis/docdegree},left]},%
        -\LenToUnit{\themargin[\option{/novathesis/docdegree},top]})%
        {\usebox{\novathesis@coverbox}}%
    }%
  }%
  ~% This space is important here so that the cover page is not empty anymore!
  \csuse{@thecover#1backpage}%
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
  \if\instring{#5}{#1}%
    \IfInteger{#3}{%IS INTEGER
      \Repeat{#3}{\vfill}
    }{%IS NOT INTEGER
      \vspace*{#3}%
    }%
    \noindent\begin{minipage}[t]{\linewidth}%
      \if#2l\relax\raggedright\fi%
      \if#2c\relax\centering\fi%
      \if#2r\relax\raggedleft\fi%
        #4%
    \end{minipage}\par%
  \fi%
}

\csdef{@thecover1backpage}{%
  \newpage%
  \thispagestyle{empty}%
  \null\vfill%
  {\scriptsize%
      \begin{Spacing}{1}%
        \ifxeorlua{\setmainfont[Ligatures=TeX]{Helvetica}}{\fontfamily{phv}}%
        \fontsize{6.3}{6.3}\selectfont% 
        \noindent%
        \hypersetup{allcolors=white}\textcolor{white}%
                   {\theacknowledgmentsstr[\option{/novathesis/coverlang}]}%
      \end{Spacing}%
  }%  
}

\newcommand{\ntprintbackcoverpage}{%
  \ifexists{thesiscover}[\option{/novathesis/docdegree},back]{%
    \clearforchapter%
    \thispagestyle{empty}%
    ~%
    \clearpage%
    \thispagestyle{empty}%
    \ntcoverbackground[\@nameuse{thesiscover\option{/novathesis/docdegree},back}]%
    ~% This space is important here so that the cover page is not empty anymore!
    \clearforchapter%
    \@nt@select@lang{\option{/novathesis/mainlang}}%
  }%
}

\newcommand{\ntcoverbackground}[1][\@nameuse{thesiscover\option{/novathesis/docdegree},front}]{%
  \ifthenelse{\equal{#1}{}}{}{%
    \AddToShipoutPictureBG*{%
      \includegraphics[width=\paperwidth,height=\paperheight]{#1}%
    }%
  }%
}

\newcommand*{\ntprintaftercover}{%
  \ifthenelse{\equal{\option{/novathesis/aftercover}}{true}}%
  {%
    \InputIfFileExists{Chapters/\novathesis@aftercover@file}%
      {\clearforchapter}%
      {}%
	}%
  {}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definition of fake arrays
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\mynewdata{abstractstring}
\mynewdata{keywordsstring}
\mynewdata{acknowledgementsstring}
\mynewdata{notdefined}
\newcommand\novathesis@undefined[1][]{$<$ #1 \thenotdefined[\option{/novathesis/mainlang}] $>$}
\mynewdata{specializationstr}

\mynewdata{adviserstr}
\mynewdata{adviserstrfont}
\adviserstrfont[\option{/novathesis/coverlang}]={}
\mynewdata{coadviserstr}
\mynewdata{coadviserstrfont}
\coadviserstrfont[\option{/novathesis/coverlang}]={}
\mynewdata{degreestr}
\mynewdata{degreestrfont}
\degreestrfont[\option{/novathesis/coverlang}]={}

\mynewdata{degreename}

\mynewdata{docdegreestr}

\mynewdata{committeeorder}
\mynewdata{committeetitlestr}
\mynewdata{committeetitlestrfont}
\committeetitlestrfont[\option{/novathesis/coverlang}]={}
\mynewdata{committeememberstr}
\mynewdata{committeememberstrfont}
\committeememberstrfont[\option{/novathesis/coverlang}]={}

\mynewdata{dissertationstr}
\mynewdata{dissertationstrfont}
\dissertationstrfont[\option{/novathesis/coverlang}]={}
\mynewdata{copyrighttextstr}
\mynewdata{acknowledgmentsstr}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include strings for all the languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\optionlistdo{/novathesis/langsshort}{%
  \InputIfFileExists{novathesis-files/Strings/strings-#1.clo}%
    {}%
    {}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defaults for uniersity, faculty, degree, etc…
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\mynewdata{university}
\mynewdata{faculty}
\mynewdata{department}
\mynewdata{majorfield}
\mynewdata{specialization}
\mynewdata{spine}
\mynewdata{thesiscover}
\mynewdata{margin}
\mynewdata{frontpageimage}

% --------------------------------------------------------
% Add school specific Images folder to the graphics path
\prependtographicspath{{novathesis-files/Schools/\option{/novathesis/school}/Images/}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\gdef\thepresentationtext{%
	\thedissertationstr[\option{/novathesis/docdegree},\option{/novathesis/coverlang}]%
}

\gdef\thecopyrightstr{%
  \thispagestyle{empty}%
  \@nt@select@lang{\option{/novathesis/copyrightlang}}%
  \noindent%
  Copyright \textcopyright\ \theauthorname, %
  \thefaculty[\option{/novathesis/copyrightlang}], \theuniversity[\option{/novathesis/copyrightlang}].\\%
  \thecopyrighttextstr[\option{/novathesis/copyrightlang}]%
  \@nt@select@lang{\option{/novathesis/mainlang}}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date and month
\newcommand{\thentdatemonth}{\novathesis@undefined[Month]}
\newcommand{\thentdateyear}{\novathesis@undefined[Year]}

\newcommand{\ntdatemonth}[1]{\renewcommand{\thentdatemonth}{#1}}
\newcommand{\ntdateyear}[1]{\renewcommand{\thentdateyear}{#1}}

%% Author identification
\newcommand{\theauthorname}{\novathesis@undefined[Author Name]}
\newcommand{\theauthorshortname}{\novathesis@undefined[Author Short Name]}
\newcommand{\theauthorgender}{\novathesis@undefined[Author Gender]}
\newcommand{\theauthordegree}{\novathesis@undefined[Author Degree]}

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
\newcommand{\thetitle}{\novathesis@undefined[The Thesis Title]}
\newcommand{\nttitle}[1]{%
  \newcommand{\thecovertitle}{#1}%
    \saveexpandmode\noexpandarg % set \noexpandarg locally
      \StrSubstitute[0]{#1}{\\}{ }[\@thetitle]
    \restoreexpandmode % restore the previous mode
  \renewcommand{\thetitle}{\@thetitle}%
  \AtBeginDocument{%
    \hypersetup{pdftitle = {\thetitle}}%
    \hypersetup{pdfsubject = {\thepresentationtext}}
  }%
  % \typeout{NT TITLE = [#1][\@thetitle]}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print option list as a comma separated list
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@nt@printoptionlist}[3]{%
  \@nt@newcounter[1]{@ntprintoptionlist@cnt}
  \def\@nt@comma{}%
  \optionlistdo{#1}{%
    \StrCut{##1}{,}\@nt@name\@nt@rest%
    \@nt@comma\@nt@name%
    \stepcounter{@ntprintoptionlist@cnt}%
    \ifnum\value{\option{#1/@size}}=\value{@ntprintoptionlist@cnt}%
      \def\@nt@comma{#3}%
    \else%
      \def\@nt@comma{#2}%
    \fi%
  }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print advisers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintadvisersaslist}[1][adviser]{%
  \@nt@printoptionlist{/novathesis/#1//name}{, }{ and }
}

\newcommand{\ntprintadvisers}[1][0.90]{%
  \begin{minipage}{#1\textwidth}
  % % #1 = Percentage of \textwidth used by the advisers list
  \begin{tabularx}{\linewidth}{@{}rX@{}}%
  \forcsvlist{\@nt@printadvisergroup}{adviser,coadviser}
  \end{tabularx}%
  \end{minipage}
}

\newcommand{\@nt@printadvisergroup}[1]{%
  % #1={adviser,coadviser}
  \ifoptiondefined{/novathesis/#1//name}{%
    \@nt@reducegender{/novathesis/#1//gender}{\mygender}%
    \@nt@reducenumber{/novathesis/#1//name}{\mynumber}%
    \smallskip%
    \csname the#1str\endcsname[\mynumber,\mygender,\option{/novathesis/coverlang}]: & %
    \begin{minipage}[t]{\linewidth}\raggedright%
    \optionlistdo{/novathesis/#1//name}{##1\\[1pt]}%
    \end{minipage}\\%
  }%
  {\ClassWarning{novathesis}{option[/novathesis/#1//name] undefined}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print advisers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintcommittee}[1][0.75]{%
  \ifmaindoc{% A main document may have committee
    \begin{minipage}{#1\textwidth}
    % #1 = Percentage of \textwidth used by the committee list
    \begin{tabularx}{\linewidth}{@{}rX@{}}%
    \@ntprintcommitteetitlestr\\[1ex]%
    \forcsvlist{\@ntprintcommitteegroup}{c,r,a,m,g}
    \end{tabularx}%
    \end{minipage}
  }%
  {%
    % A plan or propoal does not have a formal commitee
  }%
}

\newcommand*{\@ntprintcommitteetitlestr}{%
  % \ifx\novathesis@tmp\@empty%
  \expandnext{\ifx}{\thecommitteetitlestr[\option{/novathesis/coverlang}]}\@empty%
    % committeetitlestr[…] is empty
  \else%
    \multicolumn{2}{c}{{%%
            \thecommitteetitlestrfont[\option{/novathesis/coverlang}]%
            \thecommitteetitlestr[\option{/novathesis/coverlang}]:}%
          }%
  \fi%
}

\newcommand{\@ntprintcommitteegroup}[1]{%
  % #1={c,r,a,m,g}
  \ifoptiondefined{/novathesis/committee/#1/name}{%
    \@nt@reducegender{/novathesis/committee/#1/gender}{\mygender}%
    \@nt@reducenumber{/novathesis/committee/#1/name}{\mynumber}%
    \smallskip\thecommitteememberstr[#1,\mynumber,\mygender,\option{/novathesis/coverlang}]: & %
    \begin{minipage}[t]{\linewidth}\raggedright%
    \optionlistdo{/novathesis/committee/#1/name}{##1\\[1pt]}%
    \end{minipage}\\%
  }%
  {}%
}

\newcommand*{\@nt@reducegender}[2]{%
  % #1 = gender list
  % %2 = result
  \gdef#2{f}%
  \optionlistdo{#1}{\if##1m\relax\gdef#2{m}\fi}%
}

\newcommand{\@nt@reducenumber}[2]{%
  % #1 = number
  % %2 = result
  % \ifnum#1>1\relax\let#2=2\else\let#2=1\fi%
  % \show#1
  \ifnum\value{\option{#1/@size}}=1%
    \gdef#2{1}%
  \else%
    \gdef#2{2}%
  \fi%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include the School's defaults
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\InputIfFileExists{novathesis-files/Schools/\option{/novathesis/school}/defaults.clo}{}{}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtEndPreamble{\ntsetlayout}
\newcommand{\ntsetlayout}{%
  \synctex=1 % Use synctex
  \brokenpenalty=10000
  \settypeoutlayoutunit{mm}
  \setulmarginsandblock%
    {\themargin[\option{/novathesis/media},top]}%
    {\themargin[\option{/novathesis/media},bottom]}%
    {*}%
  \setlrmarginsandblock%
    {\themargin[\option{/novathesis/media},left]}%
    {\themargin[\option{/novathesis/media},right]}%
    {*}%
  \checkandfixthelayout%
}

%% For debugging the page layout
\newcommand\novathesis@typetwolengths[4]{%
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

\newcommand\novathesis@typeonelength[2]{%
  % #1 = text before
  % #2 = first length
  \setlength\@tempdimc{\mem@tl@unitperpt #2}%
  \edef\l@first{\strip@pt\@tempdimc}%
  #1: \l@first\mem@tl@unit%
}

\newcommand*{\typelayout}{%
  \hrule%
  \novathesis@typetwolengths{Stock height and width}{\stockheight}{by}{\stockwidth}\\%
  \novathesis@typetwolengths{Top and edge trims}{\trimtop}{and}{\trimedge}\\%
  \novathesis@typetwolengths{Page height and width}{\paperheight}{by}{\paperwidth}\\%
  \novathesis@typetwolengths{Text height and width}{\textheight}{by}{\textwidth}\\%
  \novathesis@typetwolengths{Spine and edge margins}{\spinemargin}{and}{\foremargin}\\%
  \novathesis@typetwolengths{Upper and lower margins}{\uppermargin}{and}{\lowermargin}\\%
  \novathesis@typetwolengths{Headheight and headsep}{\headheight}{and}{\headsep}\\%
  \novathesis@typeonelength{Footskip}{\footskip}\\%
  \novathesis@typetwolengths{Columnsep and columnseprule}{\columnsep}{and}{\columnseprule}\\%
  \novathesis@typetwolengths{Marginparsep and marginparwidth}{\marginparsep}{and}{\marginparwidth}\\%
  \novathesis@typetwolengths{Sidecapsep and sidecapwidth}{\sidecapsep}{and}{\sidecapwidth}\\%
  \novathesis@typetwolengths{Sidebarhsep and sidebarwidth}{\sidebarhsep}{and}{\sidebarwidth}\\%
  \novathesis@typetwolengths{Sidebarvsep and sidebartopsep}{\sidebarvsep}{and}{\sidebartopsep}\\%
  \novathesis@typeonelength{Sidebarheight}{\dimen\sideins}\\%
  \novathesis@typetwolengths{Sidefoothsep and sidefootwidth}{\sidefoothsep}{and}{\sidefootwidth}\\%
  \novathesis@typetwolengths{Sidefootvsep and sidefootheight}{\sidefootvsep}{and}{\sidefootheight}\\%
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
  \options{/novathesis/file/#2/.getval = {#1}}%
  % \typeout{NT TRYING TO LOAD \option@listmatch@value}%
  \InputIfFileExists{\option@listmatch@value}%
    {}%
    {}%
}

\newcommand{\@ntloadnext@ii}[2]{%
  % #1 = file class
  % #2 = KEY=value
  % \typeout{NT @ntprintnext@ii [#1] [#2]}%
  \ntgetkeyval{#2}{\option@listmatch@key}{\option@listmatch@value}%
  % \typeout{NT @ntprintnext@ii TRYING TO LOAD \option@listmatch@value}%
  \InputIfFileExists{\option@listmatch@value}%
    {}%
    {}%
}

\newcommand{\@nt@printifmaindoc@i}[1]{%
  % \typeout{NT Attemnpting to load #1}%
	\ifmaindoc{% THEN it is a main document
    \@ntloadfisrt@ii{#1}%
	}{ % ELSE
    % It is a plan or proposal type document
	}%  
}

\newcommand{\ntprintdedicatory}{\clearforchapter\@nt@printifmaindoc@i{dedicatory}}
\newcommand{\ntprintquote}{\clearforchapter\@nt@printifmaindoc@i{quote}}
\newcommand{\ntprintacknowledgements}{\clearforchapter\@nt@printifmaindoc@i{acknowledgements}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Abstract, Acronyms and Glossary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintabstracts}{%
  \xdef\novathesis@tmp{\theabstractorder[\option{/novathesis/mainlang}]}%
  \iteratecsvlist{\@ntprintabstract}{\novathesis@tmp}%
}

\newcommand{\@ntprintabstract}[1]{%
  % \typeout{NT PRINT ABSTRACT #1}%
  \setabstractlang{#1}%
  \@ntloadfisrt@ii[#1]{abstract}%
  \@nt@select@lang{\option{/novathesis/mainlang}}%
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
	\pagenumbering{arabic} %
	\setlength{\headheight}{15pt}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntchapterfile}[1]{\listgadd{\novathesis@chapter@list}{#1}}


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
  \ifthenelse{\equal{#1}{tableofcontents}}{\options{/novathesis/list/indexes/.cpush = {%
        \clearforchapter\tableofcontents*%
  }}}{}%
  \ifthenelse{\equal{#1}{listoffigures}}{\options{/novathesis/list/indexes/.cpush = {%
        \clearforchapter\listoffigures%
  }}}{}%
  \ifthenelse{\equal{#1}{listoftables}}{\options{/novathesis/list/indexes/.cpush = {%
        \clearforchapter\listoftables%
  }}}{}%
  \ifthenelse{\equal{#1}{listoflistings}}{\options{/novathesis/list/indexes/.cpush = {%
        \clearforchapter\lstlistoflistings%
  }}}{}%
  \ifthenelse{\equal{#1}{listsofglossaries}}{\options{/novathesis/list/indexes/.cpush = {%
          \printnoidxglossaries\clearforchapter%
  }}}{}%
}

\newcommand{\ntprintallindexes}{\optionlistdo{/novathesis/list/indexes}{##1}}


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
  \optionlistdo{/novathesis/file/glossaries}{\@loadglossaryfile{##1}}
}

\newcommand{\@loadglossaryfile}[1]{%
  % #1 = {glossary, acronyms, symbols}={filename}
  \ntgetkeyval{#1}{\@nt@key}{\@nt@value}
  % \typeout{NT @loadglossaryfile [\@nt@key][\@nt@value]}
  \IfFileExists{\@nt@value}%
    {\loadglsentries{\@nt@value}}%
    {\ClassWarning{novathesis}{File \option@listmatch@value~doe not exist!}{}}%
}

\AtEndPreamble{\@loadglossaryfiles}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\@ntaddlisthookfilebib}[2]{%
  \letoptionlist{/novathesis/biblatex}\nt@tmp%
  % \typeout{'NT PASSING TO BIBLATEX= '\nt@tmp}%
  \RequirePackage[hyperref=true,\nt@tmp]{biblatex}%
  \setcounter{biburlnumpenalty}{100}% Allow to break DOIs in bibliography
  % \typeout{'NT ADD BIBLATEX RESOURCE= '#2}%
  \addbibresource{#2}%
}

\newcommand{\ntprintbib}{%
  \printbibliography%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintcopyright}{%
	\ifmaindoc{% THEN
		\ntprintcopyrightpage%
	}{% ELSE
    % do nothing
	}%
}

\newcommand{\ntprintcopyrightpage}{%
	\clearforchapter%
	\null\vfill%
  \noindent%
  \textbf{\large \thetitle}\par%
  \bigskip%
  \thecopyrightstr\par%
  \clearforchapter%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dedicatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewEnviron{thededicatory}{
  \thispagestyle{empty}%
  ~\\[2cm]%
  \raggedleft%
  \begin{minipage}{100mm}%
    \raggedleft%
    \quotefonti%
    \BODY
    \normalfont%
  \end{minipage}%
	\clearforchapter%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quote
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewEnviron{thequote}{%%
  \thispagestyle{empty}%
  ~\\[2cm]%
  \raggedleft
  \begin{minipage}{100mm}%
    \raggedleft
    \quotefonti%
    \BODY%
    \normalfont%
  \end{minipage}%
	\clearforchapter%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewEnviron{acknowledgements}{%
  \chapter*{\theacknowledgementsstring[\option{/novathesis/mainlang}]}%
  \BODY
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\novathesis@keywordsstr}{}
\newcommand{\setabstractlang}[1]{%
	\@nt@select@lang{#1}%
  \renewcommand{\novathesis@keywordsstr}{\thekeywordsstring[#1]}%
	\chapter*{\theabstractstring[#1]}%
	\rule{\textwidth}{0.2mm} ~\\[-3.5ex]%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newtoggle{@nt@keywords@defined}
\togglefalse{@nt@keywords@defined}
\NewEnviron{keywords}[1][en]{%
  \csdef{@nt@keywords@#1}{\BODY}
  \iftoggle{@nt@keywords@defined}%
    {}%
    {\hypersetup{pdfkeywords = {\BODY}}}
  \par\vskip\baselineskip\noindent{\bfseries\novathesis@keywordsstr: }%
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
\InputIfFileExists{novathesis-files/ChapStyles/\option{/novathesis/chapstyle}.clo}{}{}%
\InputIfFileExists{novathesis-files/FontStyles/\option{/novathesis/fontstyle}.clo}{}{}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate book spine (if otion "spine=true")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% See file "novathesis-files/spine.clo"
% This file is loaded only if otion "spine=true"  :)
