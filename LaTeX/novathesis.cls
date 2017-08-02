%!TEX root = template.tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% novathesis.clsnova
%% NOVA thesis document class
%%
%% This work is licensed under the 
%% Creative Commons Attribution-NonCommercial 4.0 International License. 
%% To view a copy of this license, 
%% visit http://creativecommons.org/licenses/by-nc/4.0/.
%%
%% Version 2017/07/26 [4.1.2]
%% Departamento de Informática
%% Faculdade de Ciências e Tecnologia
%% Universidade Nova de Lisboa
%%
%% BUGS and SUGGESTIONS: please submit an issue at the project web page
%%      at: https://github.com/joaomlourenco/novathesis/
%%
%% HELP: please ask for help at the novathesis google group at
%%          https://groups.google.com/forum/#!forum/novathesis
%%      or at the facebook page
%%          https://www.facebook.com/groups/novathesis/
%%
%% Authors / Contributors:
%%      - João Lourenço <joao.lourenco@fct.unl.pt>
%%      - Bruno Candeias <b.candeias@campus.fct.unl.pt>
%%      — Flávio Martins <flaviomartins@acm.org>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
\ProvidesClass{novathesis}[2017/07/26 novathesis template]



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefine \cleardoublepage to use a really empty page…
\let\origcleardoublepage=\cleardoublepage
\renewcommand\cleardoublepage{%
  \newpage{\pagestyle{empty}\origcleardoublepage}%
}

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multilingual support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\selectthelanguage}[1]{%
  \xdef\novathesis@tmp{\thelangabbrev[#1]}%
  \expandafter\selectlanguage\expandafter{\novathesis@tmp}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loading additinal files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\newcommand{\novathesisAtEndClassFile}[1]{%
  \listcsadd{novathesis@atendclassfile@list}{#1}%
}

\newcommand{\novathesis@executemacro}[1]{%
  #1%
}

\newcommand{\novathesisExecuteAtEndClassFile}{%
  \forlistcsloop{\novathesis@executemacro}{novathesis@atendclassfile@list}%
}

% --------------------------------------------------------
% SOME PRELIMINARY LANGUAGE DEFINITIONS
\mynewdata{langabbrev}
\mynewdata{langsused}
\mynewdata{abstractorder}
\input{novathesis-files/lang-conf.clo}

% --------------------------------------------------------
% PROCESS PACKAGE OPTIONS
\input{novathesis-files/options.clo}


% --------------------------------------------------------
% LOAD MAIN CLASS AND ADDITIONAL PACKAGES
\LoadClass{memoir}
\OnehalfSpacing           % One-and-half spacing
\newsubfloat{figure}      % To handle subfigures


% --------------------------------------------------------
% LOAD ADDITIONAL PACKAGES
\input{novathesis-files/packages.clo}


% --------------------------------------------------------
% FIX BABEL TRANSLATION
\input{novathesis-files/fix-babel.clo}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cover definition macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% PUT THIS IN A MORE ADEQUATE PLACE
\newif\if@printcommitteeaux
\@printcommitteeauxfalse % aux variable

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\coverbackground}[1][\@nameuse{thesiscover\novathesis@opt@docdegree,front}]{%
  \AddToShipoutPictureBG*{%
    \includegraphics[width=\paperwidth,height=\paperheight]{#1}%
  }%
}

\newcommand{\coveritem}[3][c]{%
  \listcsadd{novathesis@coveritem@list}{[#1][#2]{#3}}%
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

\newcommand{\printcoveritems}{%
  \ifthenelse{\isundefined{\novathesis@coveritem@list}}{}{%
	\forlistcsloop{\novathesis@printcoveritem}{novathesis@coveritem@list}}%
}

\newlength{\mpwidth}%
\newlength{\mpheight}%
\newsavebox{\novathesis@coverbox}%

\newcommand{\printcoverpage}{%
  \thispagestyle{empty}%
  \selectthelanguage{\novathesis@opt@coverlang}%
  
  \setlength{\mpwidth}{\dimexpr%
    \paperwidth%
      -\themargin[\novathesis@opt@docdegree,left]%
      -\themargin[\novathesis@opt@docdegree,right]}%
  
  \setlength{\mpheight}{\dimexpr%
    \paperheight%
      -\themargin[\novathesis@opt@docdegree,top]%
      -\themargin[\novathesis@opt@docdegree,bottom]}%

  \sbox{\novathesis@coverbox}{%
    \parbox[t][\mpheight][t]{\mpwidth}{%
      \printcoveritems%
    }%
  }%
  \AddToShipoutPictureFG*{%
    \AtPageUpperLeft{%
      \put(%
        \LenToUnit{\themargin[\novathesis@opt@docdegree,left]},%
        -\LenToUnit{\themargin[\novathesis@opt@docdegree,top]})%
        {\usebox{\novathesis@coverbox}}%
    }%
  }%
  ~% This space is important here so that the cover page is not empty anymore!
  \cleardoublepage%
  
  %% Print second conver page if school is ul/fc
  \@printcommitteeauxtrue
  \setcounter{@novathesis@cnt}{0}%	reset counter used in the name listing
  \ifthenelse{%
  	\equal{\novathesis@opt@school}{ul/fc}%
  	\AND\(%
  		\equal{\novathesis@opt@docdegree}{phd}%
  		\OR\equal{\novathesis@opt@docdegree}{phdprop}%
  		\OR\equal{\novathesis@opt@docdegree}{phdplan}%
		\)%
	}%
	{
		\thispagestyle{empty}%
	  \selectthelanguage{\novathesis@opt@coverlang}%
	  \setlength{\mpwidth}{\dimexpr%
	    \paperwidth%
	      -\themargin[\novathesis@opt@docdegree,left]%
	      -\themargin[\novathesis@opt@docdegree,right]}%
	  \setlength{\mpheight}{\dimexpr%
	    \paperheight%
	      -\themargin[\novathesis@opt@docdegree,top]%
	      -\themargin[\novathesis@opt@docdegree,bottom]}%
	  \newsavebox{\novathesis@aftercoverbox}%
	  \sbox{\novathesis@aftercoverbox}{%
	    \parbox[t][\mpheight][t]{\mpwidth}{%
	      \printcoveritems%
	    }%
	  }%
	  \AddToShipoutPictureFG*{%
	    \AtPageUpperLeft{%
	      \put(%
	        \LenToUnit{\themargin[\novathesis@opt@docdegree,left]},%
	        -\LenToUnit{\themargin[\novathesis@opt@docdegree,top]})%
	        {\usebox{\novathesis@aftercoverbox}}%
	    }%
	  }%
	  ~% This space is important here so that the cover page is not empty anymore!
	  \cleardoublepage%
  }%
  {}%
  \selectthelanguage{\novathesis@opt@lang}%
}

\newcommand{\printbackcoverpage}{%
  \ifexists{thesiscover}[\novathesis@opt@docdegree,back]{
    \cleardoublepage%
    \thispagestyle{empty}%
    ~
    \clearpage%
    \thispagestyle{empty}%
    \coverbackground[\@nameuse{thesiscover\novathesis@opt@docdegree,back}]
    ~% This space is important here so that the cover page is not empty anymore!
    \cleardoublepage%
    \selectthelanguage{\novathesis@opt@lang}%
  }
}

\newcommand{\novathesis@aftercover@file}{}
\newcommand{\aftercoverfile}[1]{%
  \renewcommand{\novathesis@aftercover@file}{#1}%
}



\newcommand{\printaftercover}{%
  \ifthenelse{\equal{\novathesis@opt@aftercover}{true}}%
  {%
    \InputIfFileExists{Chapters/\novathesis@aftercover@file}%
      {\cleardoublepage}%
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
\newcommand\novathesis@undefined{\thenotdefined[\novathesis@opt@lang]}

\mynewdata{adviserstr}
\mynewdata{adviserstrfont}
\adviserstrfont[\novathesis@opt@coverlang]={}
\mynewdata{coadviserstr}
\mynewdata{coadviserstrfont}
\coadviserstrfont[\novathesis@opt@coverlang]={}
\mynewdata{degreestr}
\mynewdata{degreestrfont}
\degreestrfont[\novathesis@opt@coverlang]={}

\mynewdata{docdegreestr}

\mynewdata{committeeorder}
\mynewdata{committeetitlestr}
\mynewdata{committeetitlestrfont}
\committeetitlestrfont[\novathesis@opt@coverlang]={}
\mynewdata{commiteememberstr}
\mynewdata{commiteememberstrfont}
\commiteememberstrfont[\novathesis@opt@coverlang]={}

\mynewdata{dissertationstr}
\mynewdata{dissertationstrfont}
\dissertationstrfont[\novathesis@opt@coverlang]={}
\mynewdata{copyrighttextstr}
\mynewdata{acknowledgmentsstr}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include strings in the used languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\novathesis@includestrings@lang}[1]{%
  \edef\novathesis@filetoinclude{novathesis-files/Strings/strings-#1.clo}
  \input{\novathesis@filetoinclude}%
}
\iteratecsvlist{\novathesis@includestrings@lang}{\novathesis@tmp}%



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

% --------------------------------------------------------
% Add school specific Images folder to the graphics path
\prependtographicspath{{novathesis-files/Schools/\novathesis@opt@school/Images/}}

% --------------------------------------------------------
% Include the file with the defaults
\InputIfFileExists{novathesis-files/Schools/\novathesis@opt@school/defaults.clo}{}{}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\gdef\thepresentationtext{%
	\thedissertationstr[\novathesis@opt@docdegree,\novathesis@opt@coverlang]%
}

\gdef\thecopyrightstr{%
  \thispagestyle{empty}%
  \selectthelanguage{\novathesis@opt@copyrightlang}%
  \noindent%
  Copyright \textcopyright\ \theauthorname, %
  \thefaculty[\novathesis@opt@copyrightlang], \theuniversity[\novathesis@opt@copyrightlang].\\%
  \thecopyrighttextstr[\novathesis@opt@copyrightlang]%
  \selectthelanguage{\novathesis@opt@lang}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Date and month
\newcommand{\thedatemonth}{~datemonth \novathesis@undefined}
\newcommand{\thedateyear}{~dateyear \novathesis@undefined}

\newcommand{\datemonth}[1]{\renewcommand{\thedatemonth}{#1}}
\newcommand{\dateyear}[1]{\renewcommand{\thedateyear}{#1}}


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

\newcounter{novathesis@committee@cnt}
\setcounter{novathesis@committee@cnt}{0}

\def\committee[#1,#2]#3{% #1={c,r,a,m,g} #2={m,f} #3={member name}
  \ifcsname c@novathesis@committee@#1@cnt\endcsname%
  \else
    \newcounter{novathesis@committee@#1@cnt}%    to count the total # of members in class
    \setcounter{novathesis@committee@#1@cnt}{0}%
    \newcounter{novathesis@committee@#1m@cnt}%   to count the # of male members in class
    \setcounter{novathesis@committee@#1m@cnt}{0}%
    \newcounter{novathesis@committee@#1f@cnt}%   to count the # of female members in class
    \setcounter{novathesis@committee@#1f@cnt}{0}%
  \fi
  \stepcounter{novathesis@committee@#1@cnt}%
  \stepcounter{novathesis@committee@#1#2@cnt}%
  \listcsadd{novathesis@committee@#1@list}{#3}%
}


\newcommand{\novathesis@printcommitteeclassmembers}[1]{%
  & #1\\%
}

\newcommand{\novathesis@printcommitteemembers}[1]{%
  % argument is classe of committee memeber {c,r,a,m,g}
  \ifcsname novathesis@committee@#1@list\endcsname
  \ifthenelse{\equal{\value{novathesis@committee@#1m@cnt}}{0}}%
    {\def\novathesis@tmp@gender{f}}% for portuguese: only use female form if no males are present
    {\def\novathesis@tmp@gender{m}}%
  \ifthenelse{\equal{\value{novathesis@committee@#1@cnt}}{1}}%
    {\def\novathesis@tmp@total{1}}% for portuguese: only use female form if no males are present
    {\def\novathesis@tmp@total{2}}%
  {\thecommiteememberstrfont[\novathesis@opt@coverlang] %
    \thecommiteememberstr[#1,\novathesis@tmp@total,\novathesis@tmp@gender,\novathesis@opt@coverlang]:%
  }%
  \forlistcsloop{\novathesis@printcommitteeclassmembers}{novathesis@committee@#1@list}%
  \fi
}

\newcommand{\printcommittee@i}{%
  \xdef\novathesis@tmp{\thecommitteetitlestr[\novathesis@opt@coverlang]}%
  \begin{tabular}{rl}%
  \ifx\novathesis@tmp\@empty%
    % committeetitlestr[…] is empty
  \else%
    \multicolumn{2}{c}{{%%
            \thecommitteetitlestrfont[\novathesis@opt@coverlang] %
            \thecommitteetitlestr[\novathesis@opt@coverlang]}%
          }\\[1ex]%
  \fi%
  \xdef\novathesis@tmp{\thecommitteeorder[all]}%
  \iteratecsvlist{\novathesis@printcommitteemembers}{\novathesis@tmp}%
  \end{tabular}%
}

\newcommand{\printcommittee}{%
  \ifthenelse{\equal{\novathesis@opt@printcommittee}{true}}%
  {\printcommittee@i}
  {}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NEW definition for (co)advisers with lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\adviser}[4][m]{%
  \novathesis@adviser{#1}{#2}{#3}{#4}%
}

\newcommand{\coadviser}[4][m]{%
  \novathesis@adviser[co]{#1}{#2}{#3}{#4}%
}

\newcounter{novathesis@adviser@cnt}%
\setcounter{novathesis@adviser@cnt}{0}%
\newcounter{novathesis@adviser@m@cnt}%
\setcounter{novathesis@adviser@m@cnt}{0}%
\newcounter{novathesis@adviser@f@cnt}%
\setcounter{novathesis@adviser@f@cnt}{0}%
\newcounter{novathesis@coadviser@cnt}%
\setcounter{novathesis@coadviser@cnt}{0}%
\newcounter{novathesis@coadviser@m@cnt}%
\setcounter{novathesis@coadviser@m@cnt}{0}%
\newcounter{novathesis@coadviser@f@cnt}%
\setcounter{novathesis@coadviser@f@cnt}{0}%
% #1 = [] for adviser or [co] co co-adviser
% #2 = [m] or [f]
% #3 = {name}
% #4 = {category}
% #5 = {school/institution}
\newcommand{\novathesis@adviser}[5][]{%
  \stepcounter{novathesis@#1adviser@cnt}%
  \stepcounter{novathesis@#1adviser@#2@cnt}%
	\listcsgadd{novathesis@#1adviser@list}{{#3},{#4},{#5}}%
}

\def\printadvisers@iii#1,#2,#3{%
  #1, #2, #3%
}
\newcommand{\printadvisers@ii}[1]{%
   & \printadvisers@iii#1\\[0.4ex]%
}

\newcommand{\printadvisers@i}[1][]{%
  \ifcsname novathesis@#1adviser@list\endcsname%
    \ifthenelse{\equal{\value{novathesis@#1adviser@m@cnt}}{0}}%
      {\def\novathesis@tmp@gender{f}}% for portuguese: only use female form if no males are present
      {\def\novathesis@tmp@gender{m}}%
    \ifthenelse{\equal{\value{novathesis@#1adviser@cnt}}{1}}%
      {\def\novathesis@tmp@total{1}}% for portuguese: only use female form if no males are present
      {\def\novathesis@tmp@total{2}}%
    {% new block to keep font changing local
      \@nameuse{the#1adviserstrfont}[\novathesis@opt@coverlang]%
      \@nameuse{the#1adviserstr}%
              [\novathesis@tmp@total,\novathesis@tmp@gender,\novathesis@opt@coverlang]:%
%              [\novathesis@tmp@total][\novathesis@tmp@gender][\novathesis@opt@coverlang]\\
    }
    \forlistcsloop{\printadvisers@ii}{novathesis@#1adviser@list}%
  \fi%
}

\newcommand{\printadvisers}{%
  \newbox\novathesis@savebox%
  \sbox\novathesis@savebox{%
    \begin{tabular}{@{}rl@{}}%
      \printadvisers@i%
      \printadvisers@i[co]%
    \end{tabular}%
  }%
  \ifdim\wd\novathesis@savebox>\linewidth%
    \sbox\novathesis@savebox{%
      \begin{tabularx}{0.99\linewidth}{@{}rX@{}}%
      \printadvisers@i%
      \printadvisers@i[co]%
      \end{tabularx}%
    }%
  \fi%
  \noindent\usebox\novathesis@savebox%
}


\newcounter{@novathesis@cnt}%
\setcounter{@novathesis@cnt}{0}%
\newcommand{\printadvisersaslist@ii}[1]{%
  \stepcounter{@novathesis@cnt}%
  \ifthenelse{\equal{\value{@novathesis@cnt}}{1}}%
  {}%
  {\ifthenelse{\equal{\value{@novathesis@cnt}}{\value{@novathesis@alladvisers@cnt}}}%
              { and }%
              {, }%
  }%
  #1%
}%

\newcounter{@novathesis@alladvisers@cnt}
\setcounter{@novathesis@alladvisers@cnt}{0}
\def\makelistwithalladvisers@ii#1,#2,#3{%
  \!\!%
  \listcsadd{@novathesis@listwithhalladvisers}{#1}%
}%
\newcommand{\makelistwithalladvisers@i}[1]{
  \stepcounter{@novathesis@alladvisers@cnt}%
  \makelistwithalladvisers@ii#1%
}%
\newcommand{\makelistwithalladvisers}{
  \ifcsname novathesis@adviser@list\endcsname%
    \!%
    \forlistcsloop{\makelistwithalladvisers@i}{novathesis@adviser@list}%
  \fi%
  \ifcsname novathesis@coadviser@list\endcsname%
    \!%
    \forlistcsloop{\makelistwithalladvisers@i}{novathesis@coadviser@list}
  \fi%
}%

\newcommand{\printadvisersaslist}{%
  \makelistwithalladvisers%
% [\arabic{@novathesis@alladvisers@cnt}]
  \ifcsname @novathesis@listwithhalladvisers\endcsname%
    \forlistcsloop{\printadvisersaslist@ii}{@novathesis@listwithhalladvisers}%
  \fi%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\synctex=1 % Uase synctex
\brokenpenalty=10000

\settypeoutlayoutunit{mm}
\setulmarginsandblock%
  {\themargin[\novathesis@opt@media,top]}%
  {\themargin[\novathesis@opt@media,bottom]}%
  {*}%
\setlrmarginsandblock%
  {\themargin[\novathesis@opt@media,left]}%
  {\themargin[\novathesis@opt@media,right]}%
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
%% Including chapters and similars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@dedicatoryfile}{\@empty}
\newcommand{\dedicatoryfile}[1]{\renewcommand{\@dedicatoryfile}{#1}}

\ifx\@dedicatoryfile\@empty%
\newcommand{\printdedicatory}{}%
\else%
\newcommand{\printdedicatory}{%
	\ifthenelse{%
		\equal{\novathesis@opt@docdegree}{bsc}	% bsc
		\OR%
		\equal{\novathesis@opt@docdegree}{msc}	% msc
		\OR%
		\equal{\novathesis@opt@docdegree}{phd}	% phd
	}{% THEN
		\InputIfFileExists{Chapters/\@dedicatoryfile}{%
			% File dedicatory.tex exists and is read
			\global\let\@dedicatoryfile\@empty%
			\cleardoublepage%
		}{%
			% File does not exist
		}%
	}{ % ELSE
	}%
}
\fi


\newcommand{\@quotefile}{\@empty}
\newcommand{\quotefile}[1]{\renewcommand{\@quotefile}{#1}}

\ifx\@quotefile\@empty%
  \newcommand{\printquote}{}%
\else%
  \newcommand{\printquote}{%
  	\ifthenelse{%
  		\equal{\novathesis@opt@docdegree}{bsc}	% bsc
  		\OR%
  		\equal{\novathesis@opt@docdegree}{msc}	% msc
  		\OR%
  		\equal{\novathesis@opt@docdegree}{phd}	% phd
  	}{% THEN
  		\InputIfFileExists{Chapters/\@quotefile}{%
  			% File qualtefile.tex exists and is read
  			\global\let\@quotefile\@empty%
  			\cleardoublepage%
  		}{%
  			% File quotefile.tex is not found, ignore
  		}	%
  	}{ % ELSE
  	}%
  }%
\fi


\newcommand{\novathesis@acknowledgementsfile}{\@empty}
\newcommand{\acknowledgementsfile}[1]{%
  \renewcommand{\novathesis@acknowledgementsfile}{#1}%
}

\newcommand{\printacknowledgements}{%
	\IfFileExists{Chapters/\novathesis@acknowledgementsfile}{%
		\ifthenelse{%
			\equal{\novathesis@opt@docdegree}{bsc}	% bsc
			\OR%
			\equal{\novathesis@opt@docdegree}{msc}	% msc
			\OR%
			\equal{\novathesis@opt@docdegree}{phd}	% phd
		}{% THEN
			\input{Chapters/\novathesis@acknowledgementsfile}%
			\cleardoublepage%
		}{% ELSE
		}%
	}%
	{}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Abstract, Acronyms and Glossary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\glossaryfile}[1]{%
  \InputIfFileExists{Chapters/#1}{}{}
}%

\newcommand{\acronymsfile}[1]{%
  \InputIfFileExists{Chapters/#1}{}{}
}%

\def\abstractfile[#1]#2{%
	\expandafter\xdef\csname novathesis@abstractfile@#1\endcsname{#2}}%

\newcommand{\novathesis@printabstract@lang}[1]{%
  { % Extra braces to force language changes to be local
    \setabstractlang{#1}%
  	\edef\novathesis@filetoinclude{Chapters/\@nameuse{novathesis@abstractfile@#1}}%
  	\InputIfFileExists{\novathesis@filetoinclude}%
      {}%
      {}%
    \selectthelanguage{\novathesis@opt@lang}
    \cleardoublepage%
  }%
}


\newcommand{\printabstract}{% 
	\xdef\novathesis@tmp{\theabstractorder[\novathesis@opt@lang]}%
  \iteratecsvlist{\novathesis@printabstract@lang}{\novathesis@tmp}%
  % disables protrusion locally in the document for the forthcoming tables of contents
  \microtypesetup{protrusion=false}%
}



\newcommand{\thesisfrontmatter}{%
  \frontmatter%
  \selectthelanguage{\novathesis@opt@lang}
  % \pagestyle{novathesis@myvf}
  \pagenumbering{roman}%
  \setlength{\headheight}{15pt}%
}

\newcommand{\thesismainmatter}{%
  % enables protrusion locally for the remainder of the document
  \microtypesetup{protrusion=true} %
	\mainmatter%
	\pagenumbering{arabic} %
	\setlength{\headheight}{15pt}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\chapterfile}[1]{\listgadd{\novathesis@chapter@list}{#1}}

\newcommand{\novathesis@printchapter}[1]{%
	\InputIfFileExists{Chapters/#1}{\cleardoublepage}{ERROR: File '#1' does not exist!!!}%
}

\newcommand{\printchapthers}{%
	\ifthenelse{\isundefined\novathesis@chapter@list}{}%
		{\forlistloop{\novathesis@printchapter}{\novathesis@chapter@list}}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Appendixes and Annexes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\appendixfile}[1]{%
	\listgadd{\novathesis@appendix@list}{#1}%
}

\newcommand{\novathesis@printappendix}[1]{%
	\InputIfFileExists{Chapters/#1}{\cleardoublepage}{}%
}

\newcommand{\printappendixes}{%
	\ifthenelse{\isundefined\novathesis@appendix@list}{}%
		{\cleardoublepage\appendix%
		 \forlistloop{\novathesis@printappendix}{\novathesis@appendix@list}}%
} 

\newcommand{\annexfile}[1]{%
	\listgadd{\novathesis@annex@list}{#1}%
}

\newcommand{\novathesis@printannex}[1]{%
	\InputIfFileExists{Chapters/#1}{\cleardoublepage}{}%
}

\newcommand{\printannexes}{%
	\ifthenelse{\isundefined\novathesis@annex@list}{}%
		{\cleardoublepage\annex%
		 \forlistloop{\novathesis@printannex}{\novathesis@annex@list}}%
} 

\newcommand{\annex}{\par
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\annexname}%
  \gdef\thechapter{\@Roman\c@chapter}%
  }



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with optional lists in the frontmatter: listoftables, litoffigures, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\novathesis@printlist}[1]{%
	#1\cleardoublepage%
}

\newcommand{\addlisttofrontmatter}[1]{%
	\listgadd{\novathesis@frontmatter@list}{#1}%
}

\newcommand{\printtoc}{%
  \pdfbookmark[0]{\contentsname}{contents}
	\tableofcontents*
}

\newcommand{\printotherlists@i}{%
	\ifthenelse{\isundefined\novathesis@frontmatter@list}%
    {}%
		{\cleardoublepage%
      \forlistloop{\novathesis@printlist}{\novathesis@frontmatter@list}%
    }%
  \cleardoublepage%
}

\newcommand{\printotherlists}{%
  \cleardoublepage%
  % printotherlists [\novathesis@opt@otherlistsat]
  \ifthenelse{\equal{\novathesis@opt@otherlistsat}{front}}%
  {%
    \if@mainmatter%
    \else%
      \printotherlists@i%
    \fi%
  }%
  {}%
  \ifthenelse{\equal{\novathesis@opt@otherlistsat}{back}}%
  {%
    \if@mainmatter%
      \printotherlists@i%
    \else%
    \fi%
  }%
  {}%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\addbibfile}[1]{\addbibresource{#1}}

\newcommand{\printbib}{\printbibliography}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\printcopyright}{%
	\ifthenelse{%
		\equal{\novathesis@opt@docdegree}{bsc}% bsc
		\OR%
		\equal{\novathesis@opt@docdegree}{msc}% msc
		\OR%
		\equal{\novathesis@opt@docdegree}{phd}% phd
	}{% THEN
		\printcopyrightpage%
	}{% ELSE
	}%
}

\newcommand{\printcopyrightpage}{%
	\cleardoublepage%
	\null\vfill%
  \noindent%
  \textbf{\large \thetitle}\par%
  \bigskip%
  \thecopyrightstr\par%
  \vskip\baselineskip%
  {\scriptsize%
      \begin{Spacing}{1}%
        \fontfamily{phv}\fontsize{6.3}{6.3}\selectfont%
        \noindent\theacknowledgmentsstr[\novathesis@opt@coverlang]%
      \end{Spacing}%
  }%
  \cleardoublepage%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dedicatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\dedicatory{%%
	\cleardoublepage%
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
	\cleardoublepage%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quote
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\quote{%%
	\cleardoublepage%
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
  \chapter*{\theacknowledgementsstring[\novathesis@opt@lang]}%
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

\InputIfFileExists{novathesis-files/ChapStyles/\novathesis@opt@chapstyle.clo}{}{}

\InputIfFileExists{novathesis-files/FontStyles/\novathesis@opt@fontstyle.clo}{}{}




\novathesisExecuteAtEndClassFile

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate book spine (if otion "spine=true")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% See file "novathesis-files/spine.clo"
% This file is loaded only if otion "spine=true"  :)
