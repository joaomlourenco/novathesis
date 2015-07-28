%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% unlthesis.cls
%% UNL thesis document class
%%
%% This work is licensed under the 
%% Creative Commons Attribution-NonCommercial 4.0 International License. 
%% To view a copy of this license, 
%% visit http://creativecommons.org/licenses/by-nc/4.0/.
%%
%% Version 2015/07/28 [3.0.0]
%% Departamento de Informática
%% Faculdade de Ciências e Tecnologia
%% Universidade Nova de Lisboa
%%
%% BUGS and SUGGESTIONS: please submit an issue at the project web page
%%      at: https://github.com/joaomlourenco/unlthesis/
%%
%% HELP: please ask for help at the unlthesis google group
%%      at: https://groups.google.com/forum/#!forum/unlthesis
%%
%% Authors / Contributors:
%%     - João Lourenço (joao.lourenco@fct.unl.pt)
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
\ProvidesClass{unlthesis}[2015/07/28 UNL Thesis Template]


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
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefine \cleardoublepage to use a really empty page…
\let\origcleardoublepage=\cleardoublepage
\def\cleardoublepage{%
  \newpage{\pagestyle{empty}\origcleardoublepage}
}

% Do some magic defining arrays :)
\newcommand{\mynewdata}[1]{%
  \@namedef{#1}[##1]=##2{\@namedef{#1##1}{##2}}
  \@namedef{the#1}[##1]{\@nameuse{#1##1}}
}

\newcommand{\iteratecsvlist}[2]{%
  \@for\unlthesis@themember:=#2\do{#1{\unlthesis@themember}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cover definition macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\coverbackground}[1][\@nameuse{thesiscover\unlthesis@opt@doctype}]{%
  \AddToShipoutPictureBG*{%
    \includegraphics[width=\paperwidth,height=\paperheight]{#1}
  }
}
\newcounter{unlthesis@myloop}
\def\unlthesis@printcoveritem@i[#1][#2]#3{%
  \IfInteger{#2}{%IS INTEGER
    \setcounter{unlthesis@myloop}{0}
    \whileboolexpr{test{\ifnumless{\value{unlthesis@myloop}}{#2}}}{%
      \stepcounter{unlthesis@myloop}
      \vfill
    }
  }{%IS NOT INTEGER
    \vspace*{#2}
  }
  \noindent\begin{minipage}[t]{\linewidth}
    \ifthenelse{\equal{#1}{l}}{\raggedright}{%
      \ifthenelse{\equal{#1}{c}}{\centering}{%
        \ifthenelse{\equal{#1}{r}}{\raggedleft}{%
        }
      }
    }
    #3
  \end{minipage}\par
}
\newcommand{\unlthesis@printcoveritem}[1]{
  \unlthesis@printcoveritem@i#1
}

\newcommand{\coveritem}[3][c]{%
  \listcsadd{unlthesis@coveritem@list}{[#1][#2]{#3}}
}

\newcommand{\printcoveritems}{%
  \ifthenelse{\isundefined{\unlthesis@coveritem@list}}{}{%
	\forlistcsloop{\unlthesis@printcoveritem}{unlthesis@coveritem@list}}
}

\newcommand{\printcoverpage}{
  \thispagestyle{empty}
  \newlength{\mpwidth}
  \setlength{\mpwidth}{\dimexpr%
    \paperwidth%
      -\themargin[\unlthesis@opt@doctype,left]%
      -\themargin[\unlthesis@opt@doctype,right]}
  \newlength{\mpheight}
  \setlength{\mpheight}{\dimexpr%
    \paperheight
      -\themargin[\unlthesis@opt@doctype,top]
      -\themargin[\unlthesis@opt@doctype,bottom]}
  \newsavebox{\unlthesis@coverbox}
  \sbox{\unlthesis@coverbox}{
    \parbox[t][\mpheight][t]{\mpwidth}{
      \printcoveritems
    }
  }
  \AddToShipoutPictureFG*{%
    \AtPageUpperLeft{
      \put(%
        \LenToUnit{\themargin[\unlthesis@opt@doctype,left]},%
        -\LenToUnit{\themargin[\unlthesis@opt@doctype,top]})%
        {\usebox{\unlthesis@coverbox}}
    }
  }
  ~% This space is important here so that the cover page is not empty anymore!
  \cleardoublepage  
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multilingual support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifthenelse{\equal{\unlthesis@opt@lang}{pt}}%
	{\selectlanguage{portuguese}}%
{\ifthenelse{\equal{\unlthesis@opt@lang}{en}}%
	{\selectlanguage{english}}%
	{\PackageError{unlthesis}{Wrong value for option 'lang'}{Please see the documentation}%
	\expandafter\endinput}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definition of fake arrays
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\mynewdata{abstractorder}
\mynewdata{abstractname}
\mynewdata{keywordsname}
\mynewdata{acknowledgementsname}
\mynewdata{notdefined}
\newcommand\unlthesis@undefined{\thenotdefined[\unlthesis@opt@lang]}

\mynewdata{adviserstr}
\mynewdata{adviserstrfont}
\adviserstrfont[]={}
\mynewdata{coadviserstr}
\mynewdata{coadviserstrfont}
\coadviserstrfont[]={}
\mynewdata{degreestr}
\mynewdata{degreestrfont}
\degreestrfont[]={}

\mynewdata{doctypestr}

\mynewdata{committeeorder}
\mynewdata{committeetitlestr}
\mynewdata{committeetitlestrfont}
\committeetitlestrfont[]={}
\mynewdata{commiteememberstr}
\mynewdata{commiteememberstrfont}
\commiteememberstrfont[]={}

\mynewdata{dissertationstr}
\mynewdata{dissertationstrfont}
\dissertationstrfont[]={}
\mynewdata{copyrighttextstr}
\mynewdata{acknowledgmentsstr}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main strings in multiple languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\input{unlthesis-files/lang-text.clo}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defaults for uniersity, faculty, degree, etc…
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\mynewdata{university}
\mynewdata{faculty}
\mynewdata{majorfield}
\mynewdata{logo}
\mynewdata{thesiscover}
\mynewdata{margin}

% --------------------------------------------------------
% Add school specific Images folder to the graphics path
\prependtographicspath{{unlthesis-files/Schools/\unlthesis@opt@school/Images/}}

% --------------------------------------------------------
% Include the file with the defaults
\InputIfFileExists{unlthesis-files/Schools/\unlthesis@opt@school/defaults.clo}{}{ERROR: File 'unlthesis-files/\unlthesis@opt@school/defaults.clo' does not exist!!!}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\gdef\thepresentationtext{%
	\thedissertationstr[\unlthesis@opt@doctype,\unlthesis@opt@coverlang]
}

\gdef\thecopyrightstr{%
\thispagestyle{empty}
\noindent
Copyright \copyright\ \theauthorname, \thefaculty[\unlthesis@opt@coverlang], \theuniversity[\unlthesis@opt@coverlang]

\bigskip
\noindent
\thecopyrighttextstr[\unlthesis@opt@coverlang]}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Date and month
\def\datemonth#1{\gdef\thedatemonth{#1}}
\def\dateyear#1{\gdef\thedateyear{#1}}

\def\thedatemonth{~datemonth \unlthesis@undefined}
\def\thedateyear{~dateyear \unlthesis@undefined}


%% Author identification
\newcommand{\theauthorname}{~authorname \unlthesis@undefined}
\newcommand{\theauthorshortname}{~authorshortname \unlthesis@undefined}
\newcommand{\theauthorgender}{~authorgender \unlthesis@undefined}
\newcommand{\theauthordegree}{~authordegree \unlthesis@undefined}

\newcommand{\authorname}[3][m]{% [m|f]{Long name}{Short name}
  \renewcommand{\theauthorgender}{#1}
  \renewcommand{\theauthorname}{#2}
  \renewcommand{\theauthorshortname}{#3}
  \hypersetup{pdfauthor={\theauthorname}}
}

\newcommand{\authordegree}[1]{%
  \renewcommand{\theauthordegree}{#1}
}


%% Work identification
\newcommand{\thetitle}{~title \unlthesis@undefined}
\renewcommand{\title}[1]{%
  \renewcommand{\thetitle}{#1}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NEW definition for committee with lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{unlthesis@committee@cnt}
\setcounter{unlthesis@committee@cnt}{0}

\def\committee[#1,#2]#3{% #1={c,r,a,m} #2={m,f} #3={member name}
  \ifcsname c@unlthesis@committee@#1@cnt\endcsname
  \else
    \newcounter{unlthesis@committee@#1@cnt}     % to count the total # of members in class
    \setcounter{unlthesis@committee@#1@cnt}{0}
    \newcounter{unlthesis@committee@#1m@cnt}    % to count the # of male members in class
    \setcounter{unlthesis@committee@#1m@cnt}{0}
    \newcounter{unlthesis@committee@#1f@cnt}    % to count the # of female members in class
    \setcounter{unlthesis@committee@#1f@cnt}{0}
  \fi
  \stepcounter{unlthesis@committee@#1@cnt}
  \stepcounter{unlthesis@committee@#1#2@cnt}
  \listcsadd{unlthesis@committee@#1@list}{#3}
}


\newcommand{\unlthesis@printcommitteeclassmembers}[1]{%
  & #1\\
}

\newcommand{\unlthesis@printcommitteemembers}[1]{
  % argument is classe of committee memeber {c,r,a,m}
  \ifthenelse{\equal{\value{unlthesis@committee@#1m@cnt}}{0}}
    {\def\unlthesis@tmp@gender{f}}  % for portuguese: only use female form if no males are present
    {\def\unlthesis@tmp@gender{m}}
  \ifthenelse{\equal{\value{unlthesis@committee@#1@cnt}}{1}}
    {\def\unlthesis@tmp@total{1}}  % for portuguese: only use female form if no males are present
    {\def\unlthesis@tmp@total{2}}
  { \thecommiteememberstrfont[]
    \thecommiteememberstr[#1,\unlthesis@tmp@total,\unlthesis@tmp@gender,\unlthesis@opt@coverlang]:
  }
  \forlistcsloop{\unlthesis@printcommitteeclassmembers}{unlthesis@committee@#1@list}
}

\newcommand{\printcommittee}{%
  \xdef\unlthesis@tmp{\expandafter\thecommitteetitlestr[\unlthesis@opt@coverlang]}
  \begin{tabular}{rl}
  \ifx\unlthesis@tmp\@empty
    % committeetitlestr[…] is empty
  \else
    \multicolumn{2}{c}{{%
            \thecommitteetitlestrfont[]
            \thecommitteetitlestr[\unlthesis@opt@coverlang]}
          }\\[1ex]
  \fi
  \xdef\unlthesis@tmp{\expandafter\thecommitteeorder[\unlthesis@opt@coverlang]}
  \iteratecsvlist{\unlthesis@printcommitteemembers}{\unlthesis@tmp}
  \end{tabular}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NEW definition for (co)advisers with lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\adviser}[4][m]{%
  \unlthesis@adviser{#1}{#2}{#3}{#4}
}

\newcommand{\coadviser}[4][m]{%
  \unlthesis@adviser[co]{#1}{#2}{#3}{#4}
}

\newcounter{unlthesis@adviser@cnt}
\setcounter{unlthesis@adviser@cnt}{0}
\newcounter{unlthesis@adviser@m@cnt}
\setcounter{unlthesis@adviser@m@cnt}{0}
\newcounter{unlthesis@adviser@f@cnt}
\setcounter{unlthesis@adviser@f@cnt}{0}
\newcounter{unlthesis@coadviser@cnt}
\setcounter{unlthesis@coadviser@cnt}{0}
\newcounter{unlthesis@coadviser@m@cnt}
\setcounter{unlthesis@coadviser@m@cnt}{0}
\newcounter{unlthesis@coadviser@f@cnt}
\setcounter{unlthesis@coadviser@f@cnt}{0}
% #1 = [] for adviser or [co] co co-adviser
% #2 = [m] or [f]
% #3 = {name}
% #4 = {category}
% #5 = {school/institution}
\newcommand{\unlthesis@adviser}[5][]{%
  \stepcounter{unlthesis@#1adviser@cnt}
  \stepcounter{unlthesis@#1adviser@#2@cnt}
	\listcsgadd{unlthesis@#1adviser@list}{{#3},{#4},{#5}}%
}

\def\printadvisers@iii#1,#2,#3{%
  #1, #2, #3
}
\newcommand{\printadvisers@ii}[1]{%
   & \printadvisers@iii#1\\
}

\newcommand{\printadvisers@i}[1][]{%
  \ifcsname unlthesis@#1adviser@list\endcsname
    \ifthenelse{\equal{\value{unlthesis@#1adviser@m@cnt}}{0}}
      {\def\unlthesis@tmp@gender{f}}  % for portuguese: only use female form if no males are present
      {\def\unlthesis@tmp@gender{m}}
    \ifthenelse{\equal{\value{unlthesis@#1adviser@cnt}}{1}}
      {\def\unlthesis@tmp@total{1}}  % for portuguese: only use female form if no males are present
      {\def\unlthesis@tmp@total{2}}
    {% new block to keep font changing local 
      \@nameuse{the#1adviserstrfont}[]
      \@nameuse{the#1adviserstr}%
              [\unlthesis@tmp@total,\unlthesis@tmp@gender,\unlthesis@opt@coverlang]:
    }
    \forlistcsloop{\printadvisers@ii}{unlthesis@#1adviser@list}
  \else
  \fi
}

\newcommand{\printadvisers}{%
  \newbox\unlthesis@savebox
  \sbox\unlthesis@savebox{%
    \begin{tabular}{@{}rl@{}}
      \printadvisers@i
      \printadvisers@i[co]
    \end{tabular}
  }
  \ifdim\wd\unlthesis@savebox>\linewidth
    \sbox\unlthesis@savebox{%
      \begin{tabularx}{0.99\linewidth}{@{}rX@{}}
      \printadvisers@i
      \printadvisers@i[co]
      \end{tabularx}
    }
  \else
  \fi
  \noindent\usebox\unlthesis@savebox
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
  {*}
\setlrmarginsandblock%
  {\themargin[\unlthesis@opt@media,left]}%
  {\themargin[\unlthesis@opt@media,right]}%
  {*}
\checkandfixthelayout

%% For debugging the page layout
\newcommand\unlthesis@typetwolengths[4]{
  % #1 = text before
  % #2 = first length
  % #3 = text between
  % #4 = second length
  \setlength\@tempdimc{\mem@tl@unitperpt #2}
  \edef\l@first{\strip@pt\@tempdimc}%
  \setlength\@tempdimc{\mem@tl@unitperpt #4}
  \edef\l@second{\strip@pt\@tempdimc}%
  #1: \l@first\mem@tl@unit\space#3\space\l@second\mem@tl@unit
}
\newcommand\unlthesis@typeonelength[2]{
  % #1 = text before
  % #2 = first length
  \setlength\@tempdimc{\mem@tl@unitperpt #2}
  \edef\l@first{\strip@pt\@tempdimc}%
  #1: \l@first\mem@tl@unit
}
\newcommand*{\typelayout}{%
  \hrule
  \unlthesis@typetwolengths{Stock height and width}{\stockheight}{by}{\stockwidth}\\
  \unlthesis@typetwolengths{Top and edge trims}{\trimtop}{and}{\trimedge}\\
  \unlthesis@typetwolengths{Page height and width}{\paperheight}{by}{\paperwidth}\\
  \unlthesis@typetwolengths{Text height and width}{\textheight}{by}{\textwidth}\\
  \unlthesis@typetwolengths{Spine and edge margins}{\spinemargin}{and}{\foremargin}\\
  \unlthesis@typetwolengths{Upper and lower margins}{\uppermargin}{and}{\lowermargin}\\
  \unlthesis@typetwolengths{Headheight and headsep}{\headheight}{and}{\headsep}\\
  \unlthesis@typeonelength{Footskip}{\footskip}\\
  \unlthesis@typetwolengths{Columnsep and columnseprule}{\columnsep}{and}{\columnseprule}\\
  \unlthesis@typetwolengths{Marginparsep and marginparwidth}{\marginparsep}{and}{\marginparwidth}\\
  \unlthesis@typetwolengths{Sidecapsep and sidecapwidth}{\sidecapsep}{and}{\sidecapwidth}\\
  \unlthesis@typetwolengths{Sidebarhsep and sidebarwidth}{\sidebarhsep}{and}{\sidebarwidth}\\
  \unlthesis@typetwolengths{Sidebarvsep and sidebartopsep}{\sidebarvsep}{and}{\sidebartopsep}\\
  \unlthesis@typeonelength{Sidebarheight}{\dimen\sideins}\\
  \unlthesis@typetwolengths{Sidefoothsep and sidefootwidth}{\sidefoothsep}{and}{\sidefootwidth}\\
  \unlthesis@typetwolengths{Sidefootvsep and sidefootheight}{\sidefootvsep}{and}{\sidefootheight}\\
  \hrule
  }
    


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fonts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\quotefont{\normalfont\normalsize}
\newcommand\quotefonti{\itshape\normalsize}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Including chapters and similars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\dedicatoryfile#1{%
  \gdef\@dedicatoryfile{#1}}
\def\@dedicatoryfile{\@empty}

\ifx\@dedicatoryfile\@empty
\def\printdedicatory{}
\else
\def\printdedicatory{
	\ifthenelse{%
		\equal{\unlthesis@opt@doctype}{bsc}	% bsc
		\OR
		\equal{\unlthesis@opt@doctype}{msc}	% msc
		\OR
		\equal{\unlthesis@opt@doctype}{phd}	% phd
	}{% THEN
		\InputIfFileExists{Chapters/\@dedicatoryfile}{%
			% File dedicatory.tex exists and is read
			\global\let\@dedicatoryfile\@empty
			\cleardoublepage
		}{%
			% File does not exist
		}	
	}{ % ELSE
	}
}
\fi


\def\quotefile#1{%
  \gdef\@quotefile{#1}}
\def\@quotefile{\@empty}

\ifx\@quotefile\@empty
\def\printquote{}
\else
\def\printquote{
	\ifthenelse{%
		\equal{\unlthesis@opt@doctype}{bsc}	% bsc
		\OR
		\equal{\unlthesis@opt@doctype}{msc}	% msc
		\OR
		\equal{\unlthesis@opt@doctype}{phd}	% phd
	}{% THEN
		\InputIfFileExists{Chapters/\@quotefile}{%
			% File qualtefile.tex exists and is read
			\global\let\@quotefile\@empty
			\cleardoublepage
		}{%
			% File quotefile.tex is not found, ignore
		}	
	}{ % ELSE
	}
}
\fi


\def\acknowledgementsfile#1{%
  \gdef\unlthesis@acknowledgementsfile{#1}}
\def\unlthesis@acknowledgementsfile{\@empty}

\def\printacknowledgements{%
	\IfFileExists{Chapters/\unlthesis@acknowledgementsfile}{%
		\ifthenelse{%
			\equal{\unlthesis@opt@doctype}{bsc}	% bsc
			\OR
			\equal{\unlthesis@opt@doctype}{msc}	% msc
			\OR
			\equal{\unlthesis@opt@doctype}{phd}	% phd
		}{% THEN
			\input{Chapters/\unlthesis@acknowledgementsfile}
			\cleardoublepage
		}{ % ELSE
		}
	}
	{}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\def\unlthesis@abstractfile@pt{\@empty}
\def\unlthesis@abstractfile@en{\@empty}

\def\abstractfile[#1]#2{%
	\expandafter\gdef\csname unlthesis@abstractfile@#1\endcsname{#2}}

\def\selectthelanguage#1{%
	\ifthenelse{\equal{#1}{pt}}{\selectlanguage{portuguese}}{}
	\ifthenelse{\equal{#1}{en}}{\selectlanguage{english}}{}
}


\def\unlthesis@printabstract@lang#1{%
{ % Extra braces to force language changes to be local
	\edef\unlthesis@filetoinclude{Chapters/\@nameuse{unlthesis@abstractfile@#1}}
	\selectthelanguage{#1}
	\InputIfFileExists{\unlthesis@filetoinclude}%
    {}%
    {}
  \cleardoublepage
}
}


\def\printabstract{% 
	\xdef\unlthesis@tmp{\expandafter\theabstractorder[\unlthesis@opt@lang]}
  \iteratecsvlist{\unlthesis@printabstract@lang}{\unlthesis@tmp}
  % disables protrusion locally in the document for the forthcoming tables of contents
  \microtypesetup{protrusion=false} 
}



\def\thesisfrontmatter{%
  \frontmatter
  % \pagestyle{unlthesis@myvf}
  \pagenumbering{roman}
  \setlength{\headheight}{15pt}
}

\def\thesismainmatter{%
  % enables protrusion locally for the remainder of the document
  \microtypesetup{protrusion=true} 
	\mainmatter
	\pagenumbering{arabic} 
	\setlength{\headheight}{15pt}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\chapterfile#1{%
	\listgadd{\unlthesis@chapter@list}{#1}
}

\def\unlthesis@printchapter#1{%
	\InputIfFileExists{Chapters/#1}{}{ERROR: File '#1' does not exist!!!}
}

\def\printchapthers{%
	\ifthenelse{\isundefined\unlthesis@chapter@list}{}%
		{\forlistloop{\unlthesis@printchapter}{\unlthesis@chapter@list}}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Appendixes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\appendixfile#1{%
	\listgadd{\unlthesis@appendix@list}{#1}
}

\def\unlthesis@printappendix#1{%
	\InputIfFileExists{Chapters/#1}{}{ERROR: File '#1' does not exist!!!}
}

\def\printappendixes{%
	\ifthenelse{\isundefined\unlthesis@appendix@list}{}%
		{\cleardoublepage\appendix%
		 \forlistloop{\unlthesis@printappendix}{\unlthesis@appendix@list}}%
}





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with optional lists in the frontmatter: listoftables, litoffigures, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\unlthesis@printlist#1{%
	#1\cleardoublepage
}

\def\addlisttofrontmatter#1{%
	\listgadd{\unlthesis@frontmatter@list}{#1}
}

\def\printotherlists{%
	\ifthenelse{\isundefined\unlthesis@frontmatter@list}{}%
		{\cleardoublepage%
		 \forlistloop{\unlthesis@printlist}{\unlthesis@frontmatter@list}}%
  \cleardoublepage
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\addbibfile#1{%
  \addbibresource{#1}}

\def\printbib{%
	\if\unlthesis@bibbychapter0
		\printbibliography
	\fi
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\printcopyright{%
	\ifthenelse{%
		\equal{\unlthesis@opt@doctype}{bsc}	% bsc
		\OR
		\equal{\unlthesis@opt@doctype}{msc}	% msc
		\OR
		\equal{\unlthesis@opt@doctype}{phd}	% phd
	}{% THEN
		\printcopyrightpage
	}{ % ELSE
	}
}

\def\printcopyrightpage{%
	\cleardoublepage
	\null\vfill
  \noindent
  \textbf{\large \thetitle}\par
  \bigskip
  \thecopyrightstr\par
  \vskip\baselineskip
  {\scriptsize
      \begin{Spacing}{1}
        \fontfamily{phv}\selectfont\noindent\theacknowledgmentsstr[\unlthesis@opt@coverlang]
      \end{Spacing}
  }
  \cleardoublepage
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dedicatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\dedicatory{%
	\if@openright\cleardoublepage\else\clearpage\fi
	\thispagestyle{empty}
	~\\[2cm]
    \begin{flushright}
    \begin{minipage}{100mm}
    \quotefonti
    \begin{flushright}}
\def\enddedicatory{
	\end{flushright}
    \normalfont
    \end{minipage}
	\end{flushright}
\if@openright\cleardoublepage\else\clearpage\fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quote
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\quote{%
	\if@openright\cleardoublepage\else\clearpage\fi
	\thispagestyle{empty}
	~\\[2cm]
    \begin{flushright}
    \begin{minipage}{100mm}
    \quotefonti
    \begin{flushright}}
\def\endquote{
	\end{flushright}
    \normalfont
    \end{minipage}
	\end{flushright}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\acknowledgements{%
  \def\unlthesis@ack{\theacknowledgementsname[\unlthesis@opt@lang]}
  \chapter*{\unlthesis@ack}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\setabstractlang}[1]{%
	\selectthelanguage{#1}
	\gdef\unlthesis@keywordsstr{\thekeywordsname[#1]}
	\expandafter\chapter*{\theabstractname[#1]}
	\rule{\textwidth}{0.2mm} ~\\[-3.5ex]
}

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\keywords{%
  \par\vskip\baselineskip\noindent{\bfseries\unlthesis@keywordsstr: }}
\def\endkeywords{~\\[2ex]\rule{\textwidth}{0.2mm}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quotations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Table of contents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setcounter{tocdepth}{2}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sectioning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\maxsecnumdepth{subsubsection}

\definecolor{backGrayColor}{rgb}{0.7,0.7,0.7} % Background title color



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Text style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\InputIfFileExists{unlthesis-files/ChapStyles/\unlthesis@opt@chapstyle.clo}{}{}

\InputIfFileExists{unlthesis-files/FontStyles/\unlthesis@opt@fontstyle.clo}{}{}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate book spine (if otion "spine=true")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\printthespine{%
\cleardoublepage
\setulmarginsandblock{0.1cm}{0.1cm}{*}%
\setlrmarginsandblock{0.1cm}{0.1cm}{*}%
\fixthelayout
\cleardoublepage
\pagestyle{empty}
\thispagestyle{empty}

\newlength\unlthesis@spinewidth 
\setlength\unlthesis@spinewidth{1mm * (\thelastpage + 19) / 20}
\fontsize{11}{12}\selectfont

\newlength\unlthesis@heighttwolines
\setlength\unlthesis@heighttwolines{\heightof{\parbox{2cm}{m\\m}}}
\newlength\unlthesis@thinkspineskip
\setlength\unlthesis@thinkspineskip{(\unlthesis@spinewidth-\unlthesis@heighttwolines)/6}
\newsavebox{\unlthesis@spine@thick}
\sbox\unlthesis@spine@thick{%
	\begin{tabular}{c}
		\thetitle\\[\unlthesis@thinkspineskip]
		\theauthorshortname
	\end{tabular}
}
\newlength\unlthesis@thick@spineheight
\setlength\unlthesis@thick@spineheight{\heightof{\usebox{\unlthesis@spine@thick}}}
\addtolength\unlthesis@thick@spineheight{\depthof{\usebox{\unlthesis@spine@thick}}}



\newsavebox{\unlthesis@spine@year}
\sbox\unlthesis@spine@year{%
	\thedateyear
}
\newlength\unlthesis@spine@yearwidth
\setlength\unlthesis@spine@yearwidth{\widthof{~\usebox{\unlthesis@spine@year}~}}
\centering
\framebox[\unlthesis@spinewidth]{\rotatebox{90}{%
	\begin{tabularx}{\textheight-1em}{@{\hspace*{1.5em}}m{\unlthesis@spine@yearwidth}X@{}c@{}X@{}c@{}X@{}m{\unlthesis@spinewidth}@{\hspace*{1em}}}
		\ifthenelse{\unlthesis@spinewidth > \unlthesis@spine@yearwidth}
				{\rotatebox[origin=br]{-90}{\parbox{\unlthesis@spinewidth}
						{\centering\hspace*{4pt}\thedateyear}}}
				{\thedateyear}
		& & \ifthenelse
				{\unlthesis@spinewidth > \unlthesis@thick@spineheight}
				{& \usebox{\unlthesis@spine@thick} &}
				{\theauthorshortname & & \thetitle} 
		& & 
    \vspace*{4pt}
    \includegraphics[origin=c,angle=-90,height=0.9\unlthesis@spinewidth]{\thelogo[spine]}
	\end{tabularx}
}}
\cleardoublepage
}


