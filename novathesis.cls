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
%% Version 2020/11/27 [5.1.4]
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
\ProvidesClass{novathesis}[2020/11/27 novathesis template]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load iftex package
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{iftex}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOOK FOR PACKAGES ALSO IN "novathesis-files" folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand*{\input@path}{}
\edef\input@path{{./}{Chapters/}{novathesis-files/}\input@path}% subfolder path

\newcommand*{\coverprehook}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK IF USING LUALATEX OR XELATEX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\ifxetexorluatex
\begingroup\catcode94=7 \catcode0=9 % ASCII 94 is ^
\def\empty{}\def\next{^^^^0000}\expandafter\endgroup
\ifx\next\empty\xetexorluatextrue\else\xetexorluatexfalse\fi
% \newif\ifxetexorluatex
% \ifxetex
%   \xetexorluatextrue
% \else
%   \ifluatex
%     \xetexorluatextrue
%   \else
%     \xetexorluatexfalse
%   \fi
% \fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Do some magic defining arrays :)
\newcommand{\mynewdata}[1]{%
  \@namedef{#1}[##1]=##2{\@namedef{#1##1}{##2}}%
  \@namedef{the#1}[##1]{\@nameuse{#1##1}}%
}

\def\ifexists#1[#2]#3{%
  \ifcsname #1#2\endcsname%
    #3%
  \fi%
}

\newcommand{\iteratecsvlist}[2]{%
  \@for\novathesis@themember:=#2\do{#1{\novathesis@themember}}%
}

\def\instring#1#2{TT\fi\begingroup
  \edef\x{\endgroup\noexpand\in@{#1}{#2}}\x\ifin@}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE PERSON LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ntcommittee[#1,#2]#3{%
  \ntaddperson{committee}[#1,#2]{#3}%
}

\def\ntaddperson#1[#2]#3{%
  \if\instring{,}{#2}\@ntaddperson@iv{#1}[#2]{#3}\else\@ntaddperson@iv{#1}[,#2]{#3}\fi%
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
  \ifoptiondefined{/novathesis/#1/#2/name}%
    {}%
    {\options{/novathesis/#1/#2/name/.new list}\options{/novathesis/#1/#2/gender/.new list}}
  \options{/novathesis/#1/#2/gender/.push = {#3}}%
  \options{/novathesis/#1/#2/name/.push = {#4}}%
}

\newcommand*{\ntaddfile}[1]{%
  % syntax: \ntaddfile{class}[key]{filename}
  %         #1 = file family (quote, abstract, chapter, etc)
  %         #2 = [file lang] (OPTIONAL)
  %         #3 = filename
  % \typeout{NT ntaddfile [#1]}
  \@ntaddtolist{file}{#1}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE FILE LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\@ntaddtolist}[2]{%
  % syntax: \ntaddto{type}{class}[key]{filename}
  %         #1  = {file, person}
  %         #2 = family {quote, abstract, chapter, etc} or {author, adviser, committee}
  %         #3 = [file lang] (OPTIONAL)
  %         #4 = filename
  \@ifnextchar[{\@ntaddtolist@iv[#1]#2}{\@ntaddtolist@iv[#1]#2[VAL]}%
}

\def\@ntaddtolist@iv[#1]#2[#3]#4{%
  % syntax: \@ntaddfile@iii{type}{class}[key]{filename}
  %         #1  = {file, person}
  %         #2 = file family (quote, abstract, chapter, etc)
  %         #3 = optional file lang
  %         #4 = filename
  % \typeout{NT ADDFILE [#1] [#2] [#3] [#4]}%
  % \typeout{NT @ntaddlisthook#1#2 @ntaddlisthook#1#2#3}
  \ifcsdef{@ntaddlisthook#1#2}{\@nameuse{@ntaddlisthook#1#2}{#3}{#4}}{}%
  \ifcsdef{@ntaddlisthook#1#2#3}{\@nameuse{@ntaddlisthook#1#2#3}{#4}}{}%
  \@ntaddtolist@iii{#1}{#2}{#3=#4}%
}

\newcommand{\@ntaddtolist@iii}[3]{%
  % #1 = {file, person}
  % #2 = file family (quote, abstract, chapter, etc)
  % #3 = filename OR key=filename
  \ifoptiondefined{/novathesis/#1/#2}{}{\options{/novathesis/#1/#2/.new list}}%
  % \typeout{NT FILE ADD /novathesis/#1/#1 = #2}%
  \options{/novathesis/#1/#2/.push = {#3}}%
}

\newcommand{\@ntforalllist}[3]{%
  % #1 = {file, person}
  % #2 = file family (quote, abstract, chapter, etc)
  % #3 = macro to be applied, which will receive the item from the list
  \optionlistdo{/novathesis/#1/#2}{#3{##1}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multilingual support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\selectthelanguage}[1]{%
  \options{/novathesis/langshorttolong=#1}%
  \edef\nt@tmp{\option{/novathesis/langshorttolong}}%
  % \typeout{'NT SWITCHING LANG TO = '\nt@tmp}%
  \expandafter\selectlanguage\expandafter{\nt@tmp}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loading additinal files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% SOME PRELIMINARY LANGUAGE DEFINITIONS
\mynewdata{abstractorder}
\input{novathesis-files/lang-conf.clo}

% --------------------------------------------------------
% PROCESS PACKAGE OPTIONS
\input{novathesis-files/options.clo}

% --------------------------------------------------------
% LOAD MAIN CLASS AND ADDITIONAL PACKAGES
\LoadClass{memoir}
\OnehalfSpacing           % One-and-half spacing

% --------------------------------------------------------
% LOAD ADDITIONAL PACKAGES
\input{novathesis-files/packages.clo}

% --------------------------------------------------------
% FIX BABEL TRANSLATION
\input{novathesis-files/fix-babel.clo}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cover definition macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\newcover}{%
  \let\novathesis@coveritem@list=\undefined%
  \let\novathesis@secondcoveritem@list=\undefined%
}

\newcommand{\coverbackground}[1][\@nameuse{thesiscover\option{/novathesis/docdegree},front}]{%
  \ifthenelse{\equal{#1}{}}{}{%
    \AddToShipoutPictureBG*{%
      \includegraphics[width=\paperwidth,height=\paperheight]{#1}%
    }%
  }%
}

\newcommand{\coveritem}[3]{%
  % \typeout{NT COVER 1 BLOCK}%
  \listcsadd{novathesis@coveritem@list}{[#1][#2]{#3}}%
}

\newcommand{\secondcoveritem}[3]{%
  % \typeout{NT COVER 2 BLOCK}%
  \listcsadd{novathesis@secondcoveritem@list}{[#1][#2]{#3}}%
}

\newcounter{novathesis@myloop}
\def\novathesis@printcoveritem@i[#1][#2]#3{%
  \IfInteger{#2}{%IS INTEGER
    \setcounter{novathesis@myloop}{0}%
    \whileboolexpr{test{\ifnumless{\value{novathesis@myloop}}{#2}}}{%
      \stepcounter{novathesis@myloop}%
      \vfill%
    }%
  }{%IS NOT INTEGER
    \vspace*{#2}%
  }%
  \noindent\begin{minipage}[t]{\linewidth}%
    \ifthenelse{\equal{#1}{l}}{\raggedright}{%
      \ifthenelse{\equal{#1}{c}}{\centering}{%
        \ifthenelse{\equal{#1}{r}}{\raggedleft}{%
        }%
      }%
    }%
    #3%
  \end{minipage}\par%
}

\newcommand{\novathesis@printcoveritem}[1]{%
  \novathesis@printcoveritem@i#1%
}

\newcommand{\rawprintcoveritems}[1]{%
  \ifthenelse{\isundefined{\novathesis@coveritem@list}}{}{%
	\forlistcsloop{\novathesis@printcoveritem}{#1}}%
}

\newcommand{\ntprintcoveritems}{%
  \rawprintcoveritems{novathesis@coveritem@list}%
}

\newcommand{\ntprintsecondcoveritems}{%
  \rawprintcoveritems{novathesis@secondcoveritem@list}%
}

\newlength{\mpwidth}%
\newlength{\mpheight}%
\newsavebox{\novathesis@coverbox}%



\newcommand{\ntprintcoverpage}{%
  \bgroup%
    \coverprehook%
    % \thispagestyle{empty}%
    \selectthelanguage{\option{/novathesis/coverlang}}%
    \ntprintthecover%
    \clearforchapter%
    \ifthenelse{\equal{\option{/novathesis/secondcover}}{true}}%
      {% SECOND COVER TRUE
        \ifcsdef{novathesis@secondcoveritem@list}%
          {\ntprintthecover[second]}%
          {\ntprintthecover}%
          \clearforchapter%
      }%
      {}% NO SECOND COVER
    \selectthelanguage{\option{/novathesis/mainlang}}%
  \egroup%
}

\newcommand{\ntprintthecover}[1][]{%
  \thispagestyle{empty}%
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
      \@nameuse{ntprint#1coveritems}%
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
  \ifcsdef{@the#1coverbackpage}{\@nameuse{@the#1coverbackpage}}{}%
}


\newcommand{\@firstcoverbackpage}{%
  \newpage%
  \thispagestyle{empty}%
  \null\vfill%
  {\scriptsize%
      \begin{Spacing}{1}%
        \fontfamily{phv}\fontsize{6.3}{6.3}\selectfont% 
        \noindent%
        \hypersetup{allcolors=white}\textcolor{white}{\theacknowledgmentsstr[\option{/novathesis/coverlang}]}%
      \end{Spacing}%
  }%  
}

\newcommand{\ntprintbackcoverpage}{%
  \ifexists{thesiscover}[\option{/novathesis/docdegree},back]{%
    \clearforchapter%
    \thispagestyle{empty}%
    ~
    \clearpage%
    \thispagestyle{empty}%
    \coverbackground[\@nameuse{thesiscover\option{/novathesis/docdegree},back}]%
    ~% This space is important here so that the cover page is not empty anymore!
    \clearforchapter%
    \selectthelanguage{\option{/novathesis/mainlang}}%
  }%
}

\newcommand{\novathesis@aftercover@file}{}
\newcommand{\ntaftercoverfile}[1]{%
  \renewcommand{\novathesis@aftercover@file}{#1}%
}

\newcommand{\ntprintaftercover}{%
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
\newcommand\novathesis@undefined{\thenotdefined[\option{/novathesis/mainlang}]}

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

% --------------------------------------------------------
% Include the school's defaults
\InputIfFileExists{novathesis-files/Schools/\option{/novathesis/school}/defaults.clo}{}{}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\gdef\thepresentationtext{%
	\thedissertationstr[\option{/novathesis/docdegree},\option{/novathesis/coverlang}]%
}

\gdef\thecopyrightstr{%
  \thispagestyle{empty}%
  \selectthelanguage{\option{/novathesis/copyrightlang}}%
  \noindent%
  Copyright \textcopyright\ \theauthorname, %
  \thefaculty[\option{/novathesis/copyrightlang}], \theuniversity[\option{/novathesis/copyrightlang}].\\%
  \thecopyrighttextstr[\option{/novathesis/copyrightlang}]%
  \selectthelanguage{\option{/novathesis/mainlang}}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date and month
\newcommand{\thentdatemonth}{~ntdatemonth \novathesis@undefined}
\newcommand{\thentdateyear}{~ntdateyear \novathesis@undefined}

\newcommand{\ntdatemonth}[1]{\renewcommand{\thentdatemonth}{#1}}
\newcommand{\ntdateyear}[1]{\renewcommand{\thentdateyear}{#1}}

%% Author identification
\newcommand{\theauthorname}{~authorname \novathesis@undefined}
\newcommand{\theauthorshortname}{~authorshortname \novathesis@undefined}
\newcommand{\theauthorgender}{~authorgender \novathesis@undefined}
\newcommand{\theauthordegree}{~authordegree \novathesis@undefined}

\newcommand{\authorname}[3][m]{% [m|f]{Long name}{Short name}
  \renewcommand{\theauthorgender}{#1}%
  \renewcommand{\theauthorname}{#2\hypersetup{pdfauthor={#2}}}%
  \renewcommand{\theauthorshortname}{#3}%
}

\newcommand{\authordegree}[1]{%
  \renewcommand{\theauthordegree}{#1}%
}


%% Work identification
\newcommand{\thetitle}{~title \novathesis@undefined}
\renewcommand{\title}[2][]{%
  \ifthenelse{\equal{#1}{}}%
    {\newcommand{\covertitle}{#2}}%
    {\newcommand{\covertitle}{#1}}%
  \renewcommand{\thetitle}{#2\hypersetup{pdftitle={#2}}}%
}

\newcommand{\thesubtitle}{~subtitle \novathesis@undefined}
\newcommand{\subtitle}[1]{%
  \renewcommand{\thesubtitle}{#1}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NEW definition for committee with lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\ntprintadvisers}[1][0.90]{%
  \begin{minipage}{#1\textwidth}
  % % #1 = Percentage of \textwidth used by the advisers list
  \begin{tabularx}{\linewidth}{@{}rX@{}}%
  \forcsvlist{\@ntprintadvisergroup}{adviser,coadviser}
  \end{tabularx}%
  \end{minipage}
}

\newcommand{\@ntprintadvisergroup}[1]{%
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
  {\typeout{NT option[/novathesis/#1//name] undefined}}%
}

\newcommand{\ntprintcommittee}[1][0.75]{%
  \begin{minipage}{#1\textwidth}
  % #1 = Percentage of \textwidth used by the committee list
  \begin{tabularx}{\linewidth}{@{}rX@{}}%
  \@ntprintcommitteetitlestr\\[1ex]%
  \forcsvlist{\@ntprintcommitteegroup}{c,r,a,m,g}
  \end{tabularx}%
  \end{minipage}
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
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
  \StrCut{#2}{=}\option@listmatch@key\option@listmatch@value%
  % \typeout{NT @ntprintnext@ii TRYING TO LOAD \option@listmatch@value}%
  \InputIfFileExists{\option@listmatch@value}%
    {}%
    {}%
}

\newcommand{\@ntprintifmaindoc@i}[1]{%
  % \typeout{NT Attemnpting to load #1}%
	\ifthenelse{%
    % IF it is not a plan or proposal
		\equal{\option{/novathesis/docdegree}}{bsc}	% bsc
		\OR%
		\equal{\option{/novathesis/docdegree}}{msc}	% msc
		\OR%
		\equal{\option{/novathesis/docdegree}}{phd}	% phd
	}{% THEN it is a main document
    \@ntloadfisrt@ii{#1}%
	}{ % ELSE
    % It is a plan or proposal
	}%  
}

\newcommand{\ntprintdedicatory}{\clearforchapter\@ntprintifmaindoc@i{dedicatory}}
\newcommand{\ntprintquote}{\clearforchapter\@ntprintifmaindoc@i{quote}}
\newcommand{\ntprintacknowledgements}{\clearforchapter\@ntprintifmaindoc@i{acknowledgements}}



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
  \selectthelanguage{\option{/novathesis/mainlang}}%
}


\newcommand{\thesisfrontmatter}{%
  \frontmatter%
  \selectthelanguage{\option{/novathesis/mainlang}}%
  \pagenumbering{roman}%
  \setlength{\headheight}{15pt}%
}

\newcommand{\ntthesismainmatter}{%
  % enables protrusion locally for the remainder of the document
  \ifxetexorluatex\else\microtypesetup{protrusion=true}\fi%
	\mainmatter%
	\pagenumbering{arabic} %
	\setlength{\headheight}{15pt}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntchapterfile}[1]{\listgadd{\novathesis@chapter@list}{#1}}


\newcommand{\ntprintchapters}{%
    \@ntforalllist{file}{chapter}{\@ntloadnext@ii{chapter}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Appendixes and Annexes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\ntprintappendixes}{%
  \renewcommand{\appendixtocname}{\appendixnamepl}%
  \clearforchapter\appendix\addappheadtotoc%
  \@ntforalllist{file}{appendix}{\@ntloadnext@ii{appendix}}%
}

\newcommand{\ntprintannexes}{%
  \renewcommand{\appendixtocname}{\annexnamepl}%
  \clearforchapter\annex\addappheadtotoc%
  \@ntforalllist{file}{annex}{\@ntloadnext@ii{annex}}%
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
  \ifoptiondefined{/novathesis/list/indexes}{}{\options{/novathesis/list/indexes/.new list}}  %
  \ifthenelse{\equal{#1}{tableofcontents}}{\options{/novathesis/list/indexes/.push = {%
        \clearforchapter\tableofcontents*%
  }}}{}%
  \ifthenelse{\equal{#1}{listoffigures}}{\options{/novathesis/list/indexes/.push = {%
        \clearforchapter\listoffigures%
  }}}{}%
  \ifthenelse{\equal{#1}{listoftables}}{\options{/novathesis/list/indexes/.push = {%
        \clearforchapter\listoftables%
  }}}{}%
  \ifthenelse{\equal{#1}{listoflistings}}{\options{/novathesis/list/indexes/.push = {%
        \clearforchapter\lstlistoflistings%
  }}}{}%
  \ifthenelse{\equal{#1}{listsofglossaries}}{\options{/novathesis/list/indexes/.push = {%
          \setglossarystyle{long}%
          \setabbreviationstyle[acronym]{long-short}%
          \glsnogroupskiptrue%
          \setlength{\glsdescwidth}{0.75\textwidth}%
          \printnoidxglossaries\clearforchapter%
  }}}{}%
}

\newcommand{\ntprintallindexes}{\optionlistdo{/novathesis/list/indexes}{##1}}


% \def\option@listmatch@getval#1=#2{#2}
\newcommand*{\option@listmatch}[2]{
  % \typeout{NT LISTMATCH [#1] [#2]}%
  \StrCut{#2}{=}\option@listmatch@key\option@listmatch@value%
  \typeout{K=\option@listmatch@key ~V=\option@listmatch@value}
  \ifthenelse{\equal{\option@listmatch@key}{#1}}{\listbreak}{}%
  % \ifthenelse{\equal{\option@listmatch@key}{#1}}%
    % {\typeout{NT FOUND KEY=\option@listmatch@key VALUE=\option@listmatch@value}\listbreak}%
    % {\typeout{NT LOOKING KEY=\option@listmatch@key VALUE=\option@listmatch@value}}%
}%
\options{/handlers/getval/.new operation = {%
  % \typeout{NT GETVAL [#1] [#2]}%
    \optionlistdo{#1}{\option@listmatch{#2}{##1}}%
  }%
}

\newcommand*{\@loadglossaryfileifexists}[2]{%
  % #1 = glossary type
  % %2 = glossary key
  % \typeout{NT loadglossaryfileifexists [#1] [#2]}%
  \options{/novathesis/file/#1/.getval = {#2}}%
  % \typeout{NT loadglossaryfileifexists TRYING TO LOAD \option@listmatch@value}%
  \IfFileExists{\option@listmatch@value}%
    {\loadglsentries{\option@listmatch@value}}%
    {}%
}

\newcommand{\@loadglossaryfiles}{%
  \forcsvlist{\@loadglossaryfileifexists{glossaries}}{glossary,acronyms,symbols}%
}
  
\AtEndPreamble{
  \@loadglossaryfiles%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\@ntaddlisthookfilebib}[2]{%
  \letoptionlist{/novathesis/biblatex}\nt@tmp%
  \typeout{'NT PASSING TO BIBLATEX= '\nt@tmp}%
  \RequirePackage[hyperref=true,\nt@tmp]{biblatex}%
  \DeclareLanguageMapping{english}{american-apa}%
  \DeclareLanguageMapping{portuguese}{portuguese-apa}%
  \setcounter{biburlnumpenalty}{100}% Allow to break DOIs in bibliography
  \typeout{'NT ADD BIBLATEX RESOURCE= '#2}%
  \addbibresource{#2}%
}

\newcommand{\ntprintbib}{%
  \printbibliography%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintcopyright}{%
	\ifthenelse{%
		\equal{\option{/novathesis/docdegree}}{bsc}% bsc
		\OR%
		\equal{\option{/novathesis/docdegree}}{msc}% msc
		\OR%
		\equal{\option{/novathesis/docdegree}}{phd}% phd
	}{% THEN
		\ntprintcopyrightpage%
	}{% ELSE
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
\def\dedicatory{%%
	\thispagestyle{empty}%
	~\\[2cm]%
    \begin{flushright}%
    \begin{minipage}{100mm}%
    \quotefonti%
    \begin{flushright}%
}%
\def\enddedicatory{%
	\end{flushright}%
    \normalfont%
    \end{minipage}%
	\end{flushright}%
	\clearforchapter%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quote
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\quote{%%
	\thispagestyle{empty}%
	~\\[2cm]%
    \begin{flushright}%
    \begin{minipage}{100mm}%
    \quotefonti%
    \begin{flushright}}%
\def\endquote{%
	\end{flushright}%
    \normalfont%
    \end{minipage}%
	\end{flushright}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\acknowledgements}{%
  \chapter*{\theacknowledgementsstring[\option{/novathesis/mainlang}]}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\novathesis@keywordsstr}{}
\newcommand{\setabstractlang}[1]{%
	\selectthelanguage{#1}%
  \renewcommand{\novathesis@keywordsstr}{\thekeywordsstring[#1]}%
	\chapter*{\theabstractstring[#1]}%
	\rule{\textwidth}{0.2mm} ~\\[-3.5ex]%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\keywords{%
  \par\vskip\baselineskip\noindent{\bfseries\novathesis@keywordsstr: }%
}
\def\endkeywords{~\\[2ex]\rule{\textwidth}{0.2mm}}


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

\InputIfFileExists{novathesis-files/ChapStyles/\option{/novathesis/chapstyle}.clo}{}{}

\InputIfFileExists{novathesis-files/FontStyles/\option{/novathesis/fontstyle}.clo}{}{}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate book spine (if otion "spine=true")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% See file "novathesis-files/spine.clo"
% This file is loaded only if otion "spine=true"  :)
