%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% unlthesis.cls
%% UNL thesis document class
%%
%% This work is licensed under the 
%% Creative Commons Attribution-NonCommercial 4.0 International License. 
%% To view a copy of this license, 
%% visit http://creativecommons.org/licenses/by-nc/4.0/.
%%
%% Version 2016/02/22 [3.1.2]
%% Departamento de Informática
%% Faculdade de Ciências e Tecnologia
%% Universidade Nova de Lisboa
%%
%% BUGS and SUGGESTIONS: please submit an issue at the project web page
%%      at: https://github.com/joaomlourenco/unlthesis/
%%
%% HELP: please ask for help at the unlthesis google group at
%%          https://groups.google.com/forum/#!forum/unlthesis
%%      or at the facebook page
%%          https://www.facebook.com/groups/unlthesis/
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
\ProvidesClass{unlthesis}[2016/02/22 unlthesis template]



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
  \@for\unlthesis@themember:=#2\do{#1{\unlthesis@themember}}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multilingual support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\selectthelanguage}[1]{%
  \xdef\unlthesis@tmp{\thelangabbrev[#1]}%
  \expandafter\selectlanguage\expandafter{\unlthesis@tmp}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Loading additinal files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\newcommand{\unlthesisAtEndClassFile}[1]{%
  \listcsadd{unlthesis@atendclassfile@list}{#1}%
}

\newcommand{\unlthesis@executemacro}[1]{%
  #1%
}

\newcommand{\unlthesisExecuteAtEndClassFile}{%
  \forlistcsloop{\unlthesis@executemacro}{unlthesis@atendclassfile@list}%
}

% --------------------------------------------------------
% SOME PRELIMINARY LANGUAGE DEFINITIONS
\mynewdata{langabbrev}
\mynewdata{langsused}
\mynewdata{abstractorder}
\input{unlthesis-files/lang-conf.clo}

% --------------------------------------------------------
% PROCESS PACKAGE OPTIONS
\input{unlthesis-files/options.clo}


% --------------------------------------------------------
% LOAD MAIN CLASS AND ADDITIONAL PACKAGES
\LoadClass{memoir}
\OnehalfSpacing           % One-and-half spacing
\newsubfloat{figure}      % To handle subfigures


% --------------------------------------------------------
% LOAD ADDITIONAL PACKAGES
\input{unlthesis-files/packages.clo}


% --------------------------------------------------------
% FIX BABEL TRANSLATION
\input{unlthesis-files/fix-babel.clo}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cover definition macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\coverbackground}[1][\@nameuse{thesiscover\unlthesis@opt@doctype,front}]{%
  \AddToShipoutPictureBG*{%
    \includegraphics[width=\paperwidth,height=\paperheight]{#1}%
  }%
}

\newcommand{\coveritem}[3][c]{%
  \listcsadd{unlthesis@coveritem@list}{[#1][#2]{#3}}%
}

\newcounter{unlthesis@myloop}
\def\unlthesis@printcoveritem@i[#1][#2]#3{%
  \IfInteger{#2}{%IS INTEGER
    \setcounter{unlthesis@myloop}{0}%
    \whileboolexpr{test{\ifnumless{\value{unlthesis@myloop}}{#2}}}{%
      \stepcounter{unlthesis@myloop}%
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

\newcommand{\unlthesis@printcoveritem}[1]{%
  \unlthesis@printcoveritem@i#1%
}

\newcommand{\printcoveritems}{%
  \ifthenelse{\isundefined{\unlthesis@coveritem@list}}{}{%
	\forlistcsloop{\unlthesis@printcoveritem}{unlthesis@coveritem@list}}%
}

\newcommand{\printcoverpage}{%
  \thispagestyle{empty}%
  \selectthelanguage{\unlthesis@opt@coverlang}%
  \newlength{\mpwidth}%
  \setlength{\mpwidth}{\dimexpr%
    \paperwidth%
      -\themargin[\unlthesis@opt@doctype,left]%
      -\themargin[\unlthesis@opt@doctype,right]}%
  \newlength{\mpheight}%
  \setlength{\mpheight}{\dimexpr%
    \paperheight%
      -\themargin[\unlthesis@opt@doctype,top]%
      -\themargin[\unlthesis@opt@doctype,bottom]}%
  \newsavebox{\unlthesis@coverbox}%
  \sbox{\unlthesis@coverbox}{%
    \parbox[t][\mpheight][t]{\mpwidth}{%
      \printcoveritems%
    }%
  }%
  \AddToShipoutPictureFG*{%
    \AtPageUpperLeft{%
      \put(%
        \LenToUnit{\themargin[\unlthesis@opt@doctype,left]},%
        -\LenToUnit{\themargin[\unlthesis@opt@doctype,top]})%
        {\usebox{\unlthesis@coverbox}}%
    }%
  }%
  ~% This space is important here so that the cover page is not empty anymore!
  \cleardoublepage%
  \selectthelanguage{\unlthesis@opt@lang}%
}

\newcommand{\printbackcoverpage}{%
  \ifexists{thesiscover}[\unlthesis@opt@doctype,back]{
    \cleardoublepage%
    \thispagestyle{empty}%
    ~
    \clearpage%
    \thispagestyle{empty}%
    \coverbackground[\@nameuse{thesiscover\unlthesis@opt@doctype,back}]
    ~% This space is important here so that the cover page is not empty anymore!
    \cleardoublepage%
    \selectthelanguage{\unlthesis@opt@lang}%
  }
}

\newcommand{\unlthesis@aftercover@file}{}
\newcommand{\aftercoverfile}[1]{%
  \renewcommand{\unlthesis@aftercover@file}{#1}%
}

\newcommand{\printaftercover}{%
  \ifthenelse{\equal{\unlthesis@opt@aftercover}{true}}%
  {%
    \InputIfFileExists{Chapters/\unlthesis@aftercover@file}%
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
\newcommand\unlthesis@undefined{\thenotdefined[\unlthesis@opt@lang]}

\mynewdata{adviserstr}
\mynewdata{adviserstrfont}
\adviserstrfont[\unlthesis@opt@coverlang]={}
\mynewdata{coadviserstr}
\mynewdata{coadviserstrfont}
\coadviserstrfont[\unlthesis@opt@coverlang]={}
\mynewdata{degreestr}
\mynewdata{degreestrfont}
\degreestrfont[\unlthesis@opt@coverlang]={}

\mynewdata{doctypestr}

\mynewdata{committeeorder}
\mynewdata{committeetitlestr}
\mynewdata{committeetitlestrfont}
\committeetitlestrfont[\unlthesis@opt@coverlang]={}
\mynewdata{commiteememberstr}
\mynewdata{commiteememberstrfont}
\commiteememberstrfont[\unlthesis@opt@coverlang]={}

\mynewdata{dissertationstr}
\mynewdata{dissertationstrfont}
\dissertationstrfont[\unlthesis@opt@coverlang]={}
\mynewdata{copyrighttextstr}
\mynewdata{acknowledgmentsstr}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include strings in the used languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\unlthesis@includestrings@lang}[1]{%
  \edef\unlthesis@filetoinclude{unlthesis-files/Strings/strings-#1.clo}
  \input{\unlthesis@filetoinclude}
}
\iteratecsvlist{\unlthesis@includestrings@lang}{\unlthesis@tmp}%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defaults for uniersity, faculty, degree, etc…
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\mynewdata{university}
\mynewdata{faculty}
\mynewdata{majorfield}
\mynewdata{spine}
\mynewdata{thesiscover}
\mynewdata{margin}

% --------------------------------------------------------
% Add school specific Images folder to the graphics path
\prependtographicspath{{unlthesis-files/Schools/\unlthesis@opt@school/Images/}}

% --------------------------------------------------------
% Include the file with the defaults
\InputIfFileExists{unlthesis-files/Schools/\unlthesis@opt@school/defaults.clo}{}{}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\gdef\thepresentationtext{%
	\thedissertationstr[\unlthesis@opt@doctype,\unlthesis@opt@coverlang]%
}

\gdef\thecopyrightstr{%
  \thispagestyle{empty}%
  \selectthelanguage{\unlthesis@opt@copyrightlang}%
  \noindent%
  Copyright \textcopyright\ \theauthorname, %
  \thefaculty[\unlthesis@opt@copyrightlang], \theuniversity[\unlthesis@opt@copyrightlang].\\%
  \thecopyrighttextstr[\unlthesis@opt@copyrightlang]%
  \selectthelanguage{\unlthesis@opt@lang}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Date and month
\newcommand{\thedatemonth}{~datemonth \unlthesis@undefined}
\newcommand{\thedateyear}{~dateyear \unlthesis@undefined}

\newcommand{\datemonth}[1]{\renewcommand{\thedatemonth}{#1}}
\newcommand{\dateyear}[1]{\renewcommand{\thedateyear}{#1}}


%% Author identification
\newcommand{\theauthorname}{~authorname \unlthesis@undefined}
\newcommand{\theauthorshortname}{~authorshortname \unlthesis@undefined}
\newcommand{\theauthorgender}{~authorgender \unlthesis@undefined}
\newcommand{\theauthordegree}{~authordegree \unlthesis@undefined}

\newcommand{\authorname}[3][m]{% [m|f]{Long name}{Short name}
  \renewcommand{\theauthorgender}{#1}%
  \renewcommand{\theauthorname}{#2\hypersetup{pdfauthor={#2}}}%
  \renewcommand{\theauthorshortname}{#3}%
}

\newcommand{\authordegree}[1]{%
  \renewcommand{\theauthordegree}{#1}%
}


%% Work identification
\newcommand{\thetitle}{~title \unlthesis@undefined}
\renewcommand{\title}[1]{%
  \renewcommand{\thetitle}{#1\hypersetup{pdftitle={#1}}}%
}

\newcommand{\thesubtitle}{~subtitle \unlthesis@undefined}
\newcommand{\subtitle}[1]{%
  \renewcommand{\thesubtitle}{#1}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NEW definition for committee with lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{unlthesis@committee@cnt}
\setcounter{unlthesis@committee@cnt}{0}

\def\committee[#1,#2]#3{% #1={c,r,a,m,g} #2={m,f} #3={member name}
  \ifcsname c@unlthesis@committee@#1@cnt\endcsname%
  \else
    \newcounter{unlthesis@committee@#1@cnt}%    to count the total # of members in class
    \setcounter{unlthesis@committee@#1@cnt}{0}%
    \newcounter{unlthesis@committee@#1m@cnt}%   to count the # of male members in class
    \setcounter{unlthesis@committee@#1m@cnt}{0}%
    \newcounter{unlthesis@committee@#1f@cnt}%   to count the # of female members in class
    \setcounter{unlthesis@committee@#1f@cnt}{0}%
  \fi
  \stepcounter{unlthesis@committee@#1@cnt}%
  \stepcounter{unlthesis@committee@#1#2@cnt}%
  \listcsadd{unlthesis@committee@#1@list}{#3}%
}


\newcommand{\unlthesis@printcommitteeclassmembers}[1]{%
  & #1\\%
}

\newcommand{\unlthesis@printcommitteemembers}[1]{%
  % argument is classe of committee memeber {c,r,a,m,g}
  \ifcsname unlthesis@committee@#1@list\endcsname
  \ifthenelse{\equal{\value{unlthesis@committee@#1m@cnt}}{0}}%
    {\def\unlthesis@tmp@gender{f}}% for portuguese: only use female form if no males are present
    {\def\unlthesis@tmp@gender{m}}%
  \ifthenelse{\equal{\value{unlthesis@committee@#1@cnt}}{1}}%
    {\def\unlthesis@tmp@total{1}}% for portuguese: only use female form if no males are present
    {\def\unlthesis@tmp@total{2}}%
  {\thecommiteememberstrfont[\unlthesis@opt@coverlang] %
    \thecommiteememberstr[#1,\unlthesis@tmp@total,\unlthesis@tmp@gender,\unlthesis@opt@coverlang]:%
  }%
  \forlistcsloop{\unlthesis@printcommitteeclassmembers}{unlthesis@committee@#1@list}%
  \fi
}

\newcommand{\printcommittee@i}{%
  \xdef\unlthesis@tmp{\thecommitteetitlestr[\unlthesis@opt@coverlang]}%
  \begin{tabular}{rl}%
  \ifx\unlthesis@tmp\@empty%
    % committeetitlestr[…] is empty
  \else%
    \multicolumn{2}{c}{{%%
            \thecommitteetitlestrfont[\unlthesis@opt@coverlang] %
            \thecommitteetitlestr[\unlthesis@opt@coverlang]}%
          }\\[1ex]%
  \fi%
  \xdef\unlthesis@tmp{\thecommitteeorder[all]}%
  \iteratecsvlist{\unlthesis@printcommitteemembers}{\unlthesis@tmp}%
  \end{tabular}%
}

\newcommand{\printcommittee}{%
  \ifthenelse{\equal{\unlthesis@opt@printcommittee}{true}}%
  {\printcommittee@i}
  {}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NEW definition for (co)advisers with lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\adviser}[4][m]{%
  \unlthesis@adviser{#1}{#2}{#3}{#4}%
}

\newcommand{\coadviser}[4][m]{%
  \unlthesis@adviser[co]{#1}{#2}{#3}{#4}%
}

\newcounter{unlthesis@adviser@cnt}%
\setcounter{unlthesis@adviser@cnt}{0}%
\newcounter{unlthesis@adviser@m@cnt}%
\setcounter{unlthesis@adviser@m@cnt}{0}%
\newcounter{unlthesis@adviser@f@cnt}%
\setcounter{unlthesis@adviser@f@cnt}{0}%
\newcounter{unlthesis@coadviser@cnt}%
\setcounter{unlthesis@coadviser@cnt}{0}%
\newcounter{unlthesis@coadviser@m@cnt}%
\setcounter{unlthesis@coadviser@m@cnt}{0}%
\newcounter{unlthesis@coadviser@f@cnt}%
\setcounter{unlthesis@coadviser@f@cnt}{0}%
% #1 = [] for adviser or [co] co co-adviser
% #2 = [m] or [f]
% #3 = {name}
% #4 = {category}
% #5 = {school/institution}
\newcommand{\unlthesis@adviser}[5][]{%
  \stepcounter{unlthesis@#1adviser@cnt}%
  \stepcounter{unlthesis@#1adviser@#2@cnt}%
	\listcsgadd{unlthesis@#1adviser@list}{{#3},{#4},{#5}}%
}

\def\printadvisers@iii#1,#2,#3{%
  #1, #2, #3%
}
\newcommand{\printadvisers@ii}[1]{%
   & \printadvisers@iii#1\\[0.4ex]%
}

\newcommand{\printadvisers@i}[1][]{%
  \ifcsname unlthesis@#1adviser@list\endcsname%
    \ifthenelse{\equal{\value{unlthesis@#1adviser@m@cnt}}{0}}%
      {\def\unlthesis@tmp@gender{f}}% for portuguese: only use female form if no males are present
      {\def\unlthesis@tmp@gender{m}}%
    \ifthenelse{\equal{\value{unlthesis@#1adviser@cnt}}{1}}%
      {\def\unlthesis@tmp@total{1}}% for portuguese: only use female form if no males are present
      {\def\unlthesis@tmp@total{2}}%
    {% new block to keep font changing local
      \@nameuse{the#1adviserstrfont}[\unlthesis@opt@coverlang]%
      \@nameuse{the#1adviserstr}%
              [\unlthesis@tmp@total,\unlthesis@tmp@gender,\unlthesis@opt@coverlang]:%
    }
    \forlistcsloop{\printadvisers@ii}{unlthesis@#1adviser@list}%
  \fi%
}

\newcommand{\printadvisers}{%
  \newbox\unlthesis@savebox%
  \sbox\unlthesis@savebox{%
    \begin{tabular}{@{}rl@{}}%
      \printadvisers@i%
      \printadvisers@i[co]%
    \end{tabular}%
  }%
  \ifdim\wd\unlthesis@savebox>\linewidth%
    \sbox\unlthesis@savebox{%
      \begin{tabularx}{0.99\linewidth}{@{}rX@{}}%
      \printadvisers@i%
      \printadvisers@i[co]%
      \end{tabularx}%
    }%
  \fi%
  \noindent\usebox\unlthesis@savebox%
}


\newcounter{@unlthesis@cnt}%
\setcounter{@unlthesis@cnt}{0}%
\newcommand{\printadvisersaslist@ii}[1]{%
  \stepcounter{@unlthesis@cnt}%
  \ifthenelse{\equal{\value{@unlthesis@cnt}}{1}}%
  {}%
  {\ifthenelse{\equal{\value{@unlthesis@cnt}}{\value{@unlthesis@alladvisers@cnt}}}%
              { and }%
              {, }%
  }%
  #1%
}%

\newcounter{@unlthesis@alladvisers@cnt}
\setcounter{@unlthesis@alladvisers@cnt}{0}
\def\makelistwithalladvisers@ii#1,#2,#3{%
  \!\!%
  \listcsadd{@unlthesis@listwithhalladvisers}{#1}%
}%
\newcommand{\makelistwithalladvisers@i}[1]{
  \stepcounter{@unlthesis@alladvisers@cnt}%
  \makelistwithalladvisers@ii#1%
}%
\newcommand{\makelistwithalladvisers}{
  \ifcsname unlthesis@adviser@list\endcsname%
    \!%
    \forlistcsloop{\makelistwithalladvisers@i}{unlthesis@adviser@list}%
  \fi%
  \ifcsname unlthesis@coadviser@list\endcsname%
    \!%
    \forlistcsloop{\makelistwithalladvisers@i}{unlthesis@coadviser@list}
  \fi%
}%

\newcommand{\printadvisersaslist}{%
  \makelistwithalladvisers%
% [\arabic{@unlthesis@alladvisers@cnt}]
  \ifcsname @unlthesis@listwithhalladvisers\endcsname%
    \forlistcsloop{\printadvisersaslist@ii}{@unlthesis@listwithhalladvisers}%
  \fi%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\synctex=1 % Uase synctex
\brokenpenalty=10000

\settypeoutlayoutunit{mm}
\setulmarginsandblock%
  {\themargin[\unlthesis@opt@media,top]}%
  {\themargin[\unlthesis@opt@media,bottom]}%
  {*}%
\setlrmarginsandblock%
  {\themargin[\unlthesis@opt@media,left]}%
  {\themargin[\unlthesis@opt@media,right]}%
  {*}%
\checkandfixthelayout%

%% For debugging the page layout
\newcommand\unlthesis@typetwolengths[4]{%
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
\newcommand\unlthesis@typeonelength[2]{%
  % #1 = text before
  % #2 = first length
  \setlength\@tempdimc{\mem@tl@unitperpt #2}%
  \edef\l@first{\strip@pt\@tempdimc}%
  #1: \l@first\mem@tl@unit%
}
\newcommand*{\typelayout}{%
  \hrule%
  \unlthesis@typetwolengths{Stock height and width}{\stockheight}{by}{\stockwidth}\\%
  \unlthesis@typetwolengths{Top and edge trims}{\trimtop}{and}{\trimedge}\\%
  \unlthesis@typetwolengths{Page height and width}{\paperheight}{by}{\paperwidth}\\%
  \unlthesis@typetwolengths{Text height and width}{\textheight}{by}{\textwidth}\\%
  \unlthesis@typetwolengths{Spine and edge margins}{\spinemargin}{and}{\foremargin}\\%
  \unlthesis@typetwolengths{Upper and lower margins}{\uppermargin}{and}{\lowermargin}\\%
  \unlthesis@typetwolengths{Headheight and headsep}{\headheight}{and}{\headsep}\\%
  \unlthesis@typeonelength{Footskip}{\footskip}\\%
  \unlthesis@typetwolengths{Columnsep and columnseprule}{\columnsep}{and}{\columnseprule}\\%
  \unlthesis@typetwolengths{Marginparsep and marginparwidth}{\marginparsep}{and}{\marginparwidth}\\%
  \unlthesis@typetwolengths{Sidecapsep and sidecapwidth}{\sidecapsep}{and}{\sidecapwidth}\\%
  \unlthesis@typetwolengths{Sidebarhsep and sidebarwidth}{\sidebarhsep}{and}{\sidebarwidth}\\%
  \unlthesis@typetwolengths{Sidebarvsep and sidebartopsep}{\sidebarvsep}{and}{\sidebartopsep}\\%
  \unlthesis@typeonelength{Sidebarheight}{\dimen\sideins}\\%
  \unlthesis@typetwolengths{Sidefoothsep and sidefootwidth}{\sidefoothsep}{and}{\sidefootwidth}\\%
  \unlthesis@typetwolengths{Sidefootvsep and sidefootheight}{\sidefootvsep}{and}{\sidefootheight}\\%
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
		\equal{\unlthesis@opt@doctype}{bsc}	% bsc
		\OR%
		\equal{\unlthesis@opt@doctype}{msc}	% msc
		\OR%
		\equal{\unlthesis@opt@doctype}{phd}	% phd
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
  		\equal{\unlthesis@opt@doctype}{bsc}	% bsc
  		\OR%
  		\equal{\unlthesis@opt@doctype}{msc}	% msc
  		\OR%
  		\equal{\unlthesis@opt@doctype}{phd}	% phd
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


\newcommand{\unlthesis@acknowledgementsfile}{\@empty}
\newcommand{\acknowledgementsfile}[1]{%
  \renewcommand{\unlthesis@acknowledgementsfile}{#1}%
}

\newcommand{\printacknowledgements}{%
	\IfFileExists{Chapters/\unlthesis@acknowledgementsfile}{%
		\ifthenelse{%
			\equal{\unlthesis@opt@doctype}{bsc}	% bsc
			\OR%
			\equal{\unlthesis@opt@doctype}{msc}	% msc
			\OR%
			\equal{\unlthesis@opt@doctype}{phd}	% phd
		}{% THEN
			\input{Chapters/\unlthesis@acknowledgementsfile}%
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
	\expandafter\xdef\csname unlthesis@abstractfile@#1\endcsname{#2}}%

\newcommand{\unlthesis@printabstract@lang}[1]{%
  { % Extra braces to force language changes to be local
    \setabstractlang{#1}%
  	\edef\unlthesis@filetoinclude{Chapters/\@nameuse{unlthesis@abstractfile@#1}}%
  	\InputIfFileExists{\unlthesis@filetoinclude}%
      {}%
      {}%
    \selectthelanguage{\unlthesis@opt@lang}
    \cleardoublepage%
  }%
}


\newcommand{\printabstract}{% 
	\xdef\unlthesis@tmp{\theabstractorder[\unlthesis@opt@lang]}%
  \iteratecsvlist{\unlthesis@printabstract@lang}{\unlthesis@tmp}%
  % disables protrusion locally in the document for the forthcoming tables of contents
  \microtypesetup{protrusion=false}%
}



\newcommand{\thesisfrontmatter}{%
  \frontmatter%
  \selectthelanguage{\unlthesis@opt@lang}
  % \pagestyle{unlthesis@myvf}
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
\newcommand{\chapterfile}[1]{\listgadd{\unlthesis@chapter@list}{#1}}

\newcommand{\unlthesis@printchapter}[1]{%
	\InputIfFileExists{Chapters/#1}{}{ERROR: File '#1' does not exist!!!}%
}

\newcommand{\printchapthers}{%
	\ifthenelse{\isundefined\unlthesis@chapter@list}{}%
		{\forlistloop{\unlthesis@printchapter}{\unlthesis@chapter@list}}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Appendixes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\appendixfile}[1]{%
	\listgadd{\unlthesis@appendix@list}{#1}%
}

\newcommand{\unlthesis@printappendix}[1]{%
	\InputIfFileExists{Chapters/#1}{}{}%
}

\newcommand{\printappendixes}{%
	\ifthenelse{\isundefined\unlthesis@appendix@list}{}%
		{\cleardoublepage\appendix%
		 \forlistloop{\unlthesis@printappendix}{\unlthesis@appendix@list}}%
} 





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with optional lists in the frontmatter: listoftables, litoffigures, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\unlthesis@printlist}[1]{%
	#1\cleardoublepage%
}

\newcommand{\addlisttofrontmatter}[1]{%
	\listgadd{\unlthesis@frontmatter@list}{#1}%
}

\newcommand{\printotherlists@i}{%
	\ifthenelse{\isundefined\unlthesis@frontmatter@list}%
    {}%
		{\cleardoublepage%
      \forlistloop{\unlthesis@printlist}{\unlthesis@frontmatter@list}%
    }%
  \cleardoublepage%
}

\newcommand{\printotherlists}{%
  \cleardoublepage%
  % printotherlists [\unlthesis@opt@otherlistsat]
  \ifthenelse{\equal{\unlthesis@opt@otherlistsat}{front}}%
  {%
    \if@mainmatter%
    \else%
      \printotherlists@i%
    \fi%
  }%
  {}%
  \ifthenelse{\equal{\unlthesis@opt@otherlistsat}{back}}%
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
		\equal{\unlthesis@opt@doctype}{bsc}% bsc
		\OR%
		\equal{\unlthesis@opt@doctype}{msc}% msc
		\OR%
		\equal{\unlthesis@opt@doctype}{phd}% phd
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
        \noindent\theacknowledgmentsstr[\unlthesis@opt@coverlang]%
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
  \chapter*{\theacknowledgementsstring[\unlthesis@opt@lang]}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\unlthesis@keywordsstr}{}
\newcommand{\setabstractlang}[1]{%
	\selectthelanguage{#1}%
  \renewcommand{\unlthesis@keywordsstr}{\thekeywordsstring[#1]}%
	\chapter*{\theabstractstring[#1]}%
	\rule{\textwidth}{0.2mm} ~\\[-3.5ex]%
}

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\keywords{%
  \par\vskip\baselineskip\noindent{\bfseries\unlthesis@keywordsstr: }%
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

\InputIfFileExists{unlthesis-files/ChapStyles/\unlthesis@opt@chapstyle.clo}{}{}

\InputIfFileExists{unlthesis-files/FontStyles/\unlthesis@opt@fontstyle.clo}{}{}




\unlthesisExecuteAtEndClassFile

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate book spine (if otion "spine=true")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% See file "unlthesis-files/spine.clo"
% This file is loaded only if otion "spine=true"  :)
