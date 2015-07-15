%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% unlthesis.cls
%% UNL thesis document class
%%
%% Version 15072015 (Jul 2015)
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
\ProvidesClass{unlthesis}[2015/01/15 UNL Thesis Template]


% --------------------------------------------------------
% PROCESS PACKAGE OPTIONS
\input{unlthesis-files/options.sty}


% --------------------------------------------------------
% LOAD MAIN CLASS AND ADDITIONAL PACKAGES
\LoadClass{memoir}
\OnehalfSpacing           % One-and-half spacing
\newsubfloat{figure}      % To handle subfigures


% --------------------------------------------------------
% LOAD ADDITIONAL PACKAGES
\input{unlthesis-files/packages.sty}


% --------------------------------------------------------
% FIX BABEL TRANSLATION
\input{unlthesis-files/fix-babel.sty}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Redefine \cleardoublepage to use a really empty page…
\let\origcleardoublepage=\cleardoublepage
\def\cleardoublepage{%
  \newpage{\pagestyle{empty}\origcleardoublepage}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multilingual support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifthenelse{\equal{\UNL@lang}{pt}}%
	{\selectlanguage{portuguese}}%
{\ifthenelse{\equal{\UNL@lang}{en}}%
	{\selectlanguage{english}}%
	{\PackageError{unlthesis}{Wrong value for option 'lang'}{Please see the documentation}%
	\expandafter\endinput}}


% --------------------------------------------------------
% Fake the definition of the abstract array
%
% \newdata*{UNL@abstractorder}
\def\UNL@abstractorder[#1]=#2{
	\expandafter\gdef\csname UNL@abstractorder@#1\endcsname{#2}}
% \newdata*{UNL@abstractname}
\def\UNL@abstractname[#1]=#2{
	\expandafter\gdef\csname UNL@abstractname@#1\endcsname{#2}}
% \newdata*{UNL@keywordsname}
\def\UNL@keywordsname[#1]=#2{
	\expandafter\gdef\csname UNL@keywordsname@#1\endcsname{#2}}
% \newdata*{UNL@acknowledgementsname}
\def\UNL@acknowledgementsname[#1]=#2{%
	\expandafter\gdef\csname UNL@acknowledgementsname@#1\endcsname{#2}}
% \newdata*{UNL@notdefined}
\def\UNL@notdefined[#1]=#2{
	\expandafter\gdef\csname UNL@notdefined@#1\endcsname{#2}}


\newdata*{UNL@adviserstr}
\newdata*{UNL@coadviserstr}
\newdata*{UNL@degreestr}

\newdata*{UNL@doctypestr}

\newdata*{UNL@committeetitlestr}
\newdata*{UNL@chairstr}
\newdata*{UNL@raporteurstr}
\newdata*{UNL@memberstr}
	

\newdata*{UNL@dissertationstr}
\newdata*{UNL@copyrighttext}

% Input definitions for strings above in multiple languages
\input{unlthesis-files/lang-text.sty}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defaults for uniersity, faculty, degree, etc…
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newdata*{university}
\newdata*{faculty}
\newdata*{majorfield}
% \newdata*{logo}
% \newdata*{thesiscover}

% --------------------------------------------------------
% Fake the definitions for the 'thesiscover' and 'logo' arrays
%
\def\thesiscover[#1]=#2{
  \expandafter\gdef\csname UNL@thesiscover@#1\endcsname{#2}}
\def\logo[#1]=#2{
  \expandafter\gdef\csname UNL@logo@#1\endcsname{#2}}


% --------------------------------------------------------
% Include the file with the defaults
%
\InputIfFileExists{unlthesis-files/Schools/\UNL@school/defaults.sty}{}{ERROR: File 'unlthesis-files/\UNL@school/defaults.sty' does not exist!!!}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\gdef\UNL@presentationtext{%
	\UNL@dissertationstr[\UNL@doctype,\UNL@cover@lang]
}

\gdef\thecopyrightstr{%
\thispagestyle{empty}
\noindent
Copyright \copyright\ \@author, \faculty[\UNL@cover@lang], \university[\UNL@cover@lang]

\bigskip
\noindent
\UNL@copyrighttext[\UNL@cover@lang]}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\themonth#1{\gdef\@themonth{#1}}
\def\@themonth{~themonth \UNL@notdefined}

\def\theyear#1{\gdef\@theyear{#1}}
\def\@theyear{~theyear \UNL@notdefined}


%% Authors identification
\def\author{%
  \@ifnextchar [%
    {\@pauthor}%
    {\@pauthor[m]}}

\def\@pauthor[#1]#2{%
  \if#1m
  	\def\authorgender{m}
  \else\if#1f
	\def\authorgender{f}
  \else
  \typeout{^^J%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^^J%
!  Please specify author gender using [m] or [f] as the first^^J%
!  argument of the "author" macro.  See the template! ;)^^J%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^^J%
}
   \errhelp{Please be gentle and follow the template recommendations.}
   \errmessage{Please specify author gender!}
  \fi\fi

  \gdef\@author{#2}
  \hypersetup{pdfauthor={\@author}}}

\def\@author{~author \UNL@notdefined}

\def\authordegree#1{%
  \gdef\@authordegree{#1}}
\def\@authordegree{~authordegree \UNL@notdefined}


%% Work identification

\def\title#1{%
  \gdef\UNL@title{#1}
  \hypersetup{pdftitle={\UNL@title}}}
\def\UNL@title{~title \UNL@notdefined}

\def\UNL@degree{%
	\UNL@degreestr[\UNL@doctype,\authorgender,\UNL@cover@lang]%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NEW definition for committee with lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find the size of a list
\newcount\UNL@listsize@cnt
\newcommand{\UNL@do@listfind@count}[1]{%
	\advance\UNL@listsize@cnt 1\relax%
}
\def\listcssize#1{%
	\UNL@listsize@cnt 0\relax%
	\ifthenelse{\expandafter\isundefined\csname #1\endcsname}{%
	}{%
		\forlistcsloop{\UNL@do@listfind@count}{#1}%
	}%
}


\def\committee{%
  \@ifnextchar [%
    {\UNL@committee}%
    {\UNL@committee[v]}}

\def\UNL@committee[#1]#2{%
	\listcsgadd{UNL@committee@#1@list}{#2}
}

\newcommand{\UNL@do@committee@tabular}[1]{
	& #1\\
}

\def\printthecommittee{%
	\begin{tabular}{rl}
	& \UNL@committeetitlestr[\UNL@cover@lang]:\\
	\ifthenelse{\isundefined\UNL@committee@p@list}{}{%
			\listcssize{UNL@committee@p@list}%
			\ifthenelse{\equal{\the\UNL@listsize@cnt}{1}}%
				{\gdef\UNL@committee@n@p{1}}%
				{\gdef\UNL@committee@n@p{2}}%
			\UNL@chairstr[\UNL@committee@n@p,\UNL@cover@lang]:
			\forlistcsloop{\UNL@do@committee@tabular}{UNL@committee@p@list}
	}
	\ifthenelse{\isundefined\UNL@committee@a@list}{}{%
			\listcssize{UNL@committee@a@list}%
			\ifthenelse{\equal{\the\UNL@listsize@cnt}{1}}%
				{\gdef\UNL@committee@n@p{1}}%
				{\gdef\UNL@committee@n@p{2}}%
			\UNL@raporteurstr[\UNL@committee@n@p,\UNL@cover@lang]:
			\forlistcsloop{\UNL@do@committee@tabular}{UNL@committee@a@list}
	}
	\ifthenelse{\isundefined\UNL@committee@v@list}{}{%
			\listcssize{UNL@committee@v@list}%
			\ifthenelse{\equal{\the\UNL@listsize@cnt}{1}}%
				{\gdef\UNL@committee@n@p{1}}%
				{\gdef\UNL@committee@n@p{2}}%
			\UNL@memberstr[\UNL@committee@n@p,\UNL@cover@lang]:
			\forlistcsloop{\UNL@do@committee@tabular}{UNL@committee@v@list}
	}
	\end{tabular}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% NEW definition for (co)advisers with lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{tabu}

\def\adviser{%
  \@ifnextchar [%
    {\UNL@adviser[]}%
    {\UNL@adviser[][m]}}

\def\coadviser{%
  \@ifnextchar [%
    {\UNL@adviser[co]}%
    {\UNL@adviser[co][m]}}

% #1 = [] for adviser or [co] co co-adviser
% #2 = [m] or [f]
% #3 = {name}
% #4 = {category}
% #5 = {school/institution}
\def\UNL@adviser[#1][#2]#3#4#5{%
	\listcsgadd{UNL@#1adviser@gender@list}{#2}%
	\listcsgadd{UNL@#1adviser@name@list}{#3}%
	\listcsgadd{UNL@#1adviser@category@list}{#4}%
	\listcsgadd{UNL@#1adviser@school@list}{#5}%
	\listcsgadd{UNL@#1adviser@list}{{#3},{#4},{#5}}%
}

\newcount\UNL@listgenderf@cnt
\newcommand{\UNL@do@listgenderf@count}[1]{%
	\ifthenelse{\equal{#1}{f}}{\advance\UNL@listgenderf@cnt 1\relax}{}%
}
\def\listcsgenderf#1{%
	\UNL@listgenderf@cnt 0\relax%
	\ifthenelse{\expandafter\isundefined\csname #1\endcsname}{}%
		{\forlistcsloop{\UNL@do@listgenderf@count}{#1}}%
}


\def\UNL@adviser@str#1{%
	\listcssize{UNL@#1adviser@gender@list}%
	\ifthenelse{\equal{\the\UNL@listsize@cnt}{1}}%
		{\gdef\UNL@adviser@n{1}}%
		{\gdef\UNL@adviser@n{2}}%
	\listcsgenderf{UNL@#1adviser@gender@list}%
	\ifthenelse{\equal{\the\UNL@listsize@cnt}{\the\UNL@listgenderf@cnt}}%
		{\gdef\UNL@adviser@g{f}}%
		{\gdef\UNL@adviser@g{m}}%
	\def\UNL@adv{\csname UNL@#1adviserstr\endcsname}%
	\UNL@adv[\UNL@adviser@n,\UNL@adviser@g,\UNL@cover@lang]%
}


% \newsavebox{\UNL@adviser@tabular@item@box}
% \newlength{\UNL@adviser@tabular@item@box@w}
\def\UNL@do@adviser@tabular@item#1,#2,#3{%
    & \parbox[t]{\linewidth}{\raggedright#1, #2, #3}
    % & \mbox{#1}, \mbox{#2}, \parbox{\linewidth}{\mbox{}\\[-0.5ex]\raggedright#3}%
}
\def\UNL@do@adviser@tabular#1{%
	\UNL@do@adviser@tabular@item#1\\[5pt]%
}


\def\printtheadvisers{%
	% \begin{tabularx}{\linewidth}{lX<{\raggedright}}
	\begin{tabu} spread 0pt {rX[1,l,p]}%
	\ifthenelse{\isundefined\UNL@adviser@gender@list}{}{%
			\UNL@adviser@str{}: %
			\forlistcsloop{\UNL@do@adviser@tabular}{UNL@adviser@list}%
	}%
	\ifthenelse{\isundefined\UNL@coadviser@gender@list}{}{%
			& \\[-1.5ex]%
			\UNL@adviser@str{co}: %
			\forlistcsloop{\UNL@do@adviser@tabular}{UNL@coadviser@list}%
	}%
	\end{tabu}
	% \end{tabularx}
	\par
}





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\synctex=1 % Uase synctex
\brokenpenalty=10000

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
		\equal{\UNL@doctype}{bsc}	% bsc
		\OR
		\equal{\UNL@doctype}{msc}	% msc
		\OR
		\equal{\UNL@doctype}{phd}	% phd
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
		\equal{\UNL@doctype}{bsc}	% bsc
		\OR
		\equal{\UNL@doctype}{msc}	% msc
		\OR
		\equal{\UNL@doctype}{phd}	% phd
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
  \gdef\UNL@acknowledgementsfile{#1}}
\def\UNL@acknowledgementsfile{\@empty}

\def\printacknowledgements{%
	\IfFileExists{Chapters/\UNL@acknowledgementsfile}{%
		\ifthenelse{%
			\equal{\UNL@doctype}{bsc}	% bsc
			\OR
			\equal{\UNL@doctype}{msc}	% msc
			\OR
			\equal{\UNL@doctype}{phd}	% phd
		}{% THEN
			\input{Chapters/\UNL@acknowledgementsfile}
			\cleardoublepage
		}{ % ELSE
		}
	}
	{}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\def\UNL@abstractfile@pt{\@empty}
\def\UNL@abstractfile@en{\@empty}

\def\abstractfile[#1]#2{%
	\expandafter\gdef\csname UNL@abstractfile@#1\endcsname{#2}}

\def\selectthelanguage#1{%
	\ifthenelse{\equal{#1}{pt}}{\selectlanguage{portuguese}}{}
	\ifthenelse{\equal{#1}{en}}{\selectlanguage{english}}{}
}


\def\UNL@printabstract@lang#1{%
{ % Extra braces to force language changes to be local
	\def\UNL@filetoinclude{Chapters/\csname UNL@abstractfile@#1\endcsname}
	\selectthelanguage{#1}
	\IfFileExists{\UNL@filetoinclude}{%
		\input{\UNL@filetoinclude}
		\cleardoublepage
	}{}
}
}


\def\printabstract{% 
	\renewcommand*{\do}[1]{\UNL@printabstract@lang{##1}}
	\xdef\UNL@tmp{\expandafter\csname UNL@abstractorder@\UNL@lang\endcsname}
	\expandafter\docsvlist\expandafter{\UNL@tmp}
}



\def\thesisfrontmatter{%
  \frontmatter
  % \pagestyle{UNL@myvf}
  \pagenumbering{roman}
  \setlength{\headheight}{15pt}
}

\def\thesismainmatter{%
	\mainmatter
	\pagenumbering{arabic} 
	\setlength{\headheight}{15pt}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\chapterfile#1{%
	\listgadd{\UNL@chapter@list}{#1}
}

\def\UNL@printchapter#1{%
	\InputIfFileExists{Chapters/#1}{}{ERROR: File '#1' does not exist!!!}
}

\def\printchapthers{%
	\ifthenelse{\isundefined\UNL@chapter@list}{}%
		{\forlistloop{\UNL@printchapter}{\UNL@chapter@list}}
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Appendixes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\appendixfile#1{%
	\listgadd{\UNL@appendix@list}{#1}
}

\def\UNL@printappendix#1{%
	\InputIfFileExists{Chapters/#1}{}{ERROR: File '#1' does not exist!!!}
}

\def\printappendixes{%
	\ifthenelse{\isundefined\UNL@appendix@list}{}%
		{\cleardoublepage\appendix%
		 \forlistloop{\UNL@printappendix}{\UNL@appendix@list}}%
}





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with optional lists in the frontmatter: listoftables, litoffigures, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\UNL@printlist#1{%
	#1\cleardoublepage
}

\def\addlisttofrontmatter#1{%
	\listgadd{\UNL@frontmatter@list}{#1}
}

\def\printotherlists{%
	\ifthenelse{\isundefined\UNL@frontmatter@list}{}%
		{\cleardoublepage%
		 \forlistloop{\UNL@printlist}{\UNL@frontmatter@list}}%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\addbibfile#1{%
  \addbibresource{#1}}

\def\printbib{%
	\if\UNL@bibbychapter0
		\printbibliography
	\fi
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\printcopyrightpage{%
	\cleardoublepage
	\null\vfill
	\noindent
	\textbf{\large \UNL@title}\par
	\bigskip
	\thecopyrightstr
}

\def\printcopyright{%
	\ifthenelse{%
		\equal{\UNL@doctype}{bsc}	% bsc
		\OR
		\equal{\UNL@doctype}{msc}	% msc
		\OR
		\equal{\UNL@doctype}{phd}	% phd
	}{% THEN
		\printcopyrightpage
	}{ % ELSE
	}
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
  \def\UNL@ack{\csname UNL@acknowledgementsname@\UNL@lang\endcsname}
  \chapter*{\UNL@ack}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\abstractlang}[1]{%
	\selectthelanguage{#1}
	\gdef\UNL@keywordsstr{\csname UNL@keywordsname@#1\endcsname}
	\expandafter\chapter*{\csname UNL@abstractname@#1\endcsname}
	\rule{\textwidth}{0.2mm} ~\\[-3.5ex]
}

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\keywords{%
  \par\vskip\baselineskip\noindent{\bfseries\UNL@keywordsstr: }}
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
\InputIfFileExists{unlthesis-files/Styles/\UNL@docstyle.sty}{}{ERROR: File 'unlthesis-files/Styles/\UNL@docstyle.sty' does not exist!!!}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate book spine (if otion "spine=true")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\shortauthor#1{\gdef\UNL@shortauthor{#1}}
\def\UNL@shortauthor{~shot~author \UNL@notdefined}

\def\printthespine{%
\newgeometry{left=0.1cm,right=0.1cm,top=0.1cm,bottom=0.1cm}
\cleardoublepage
\pagestyle{empty}
\thispagestyle{empty}

\newlength\UNL@spinewidth 
\setlength\UNL@spinewidth{1mm * (\thelastpage + 19) / 20}
\fontsize{11}{12}\selectfont

\newlength\UNL@heighttwolines
\setlength\UNL@heighttwolines{\heightof{\parbox{2cm}{m\\m}}}
\newlength\UNL@thinkspineskip
\setlength\UNL@thinkspineskip{(\UNL@spinewidth-\UNL@heighttwolines)/6}
\newsavebox{\UNL@spine@thick}
\sbox\UNL@spine@thick{%
	\begin{tabular}{c}
		\UNL@title\\[\UNL@thinkspineskip]
		\UNL@shortauthor
	\end{tabular}
}
\newlength\UNL@thick@spineheight
\setlength\UNL@thick@spineheight{\heightof{\usebox{\UNL@spine@thick}}}
\addtolength\UNL@thick@spineheight{\depthof{\usebox{\UNL@spine@thick}}}



\newsavebox{\UNL@spine@year}
\sbox\UNL@spine@year{%
	\@theyear
}
\newlength\UNL@spine@yearwidth
\setlength\UNL@spine@yearwidth{\widthof{~\usebox{\UNL@spine@year}~}}
\centering
\framebox[\UNL@spinewidth]{\rotatebox{90}{%
	\begin{tabularx}{\textheight-1em}{@{\hspace*{1.5em}}m{\UNL@spine@yearwidth}X@{}c@{}X@{}c@{}X@{}m{\UNL@spinewidth}@{\hspace*{1em}}}
		\ifthenelse{\UNL@spinewidth > \UNL@spine@yearwidth}
				{\rotatebox[origin=br]{-90}{\parbox{\UNL@spinewidth}
						{\centering\hspace*{4pt}\@theyear}}}
				{\@theyear}
		& & \ifthenelse
				{\UNL@spinewidth > \UNL@thick@spineheight}
				{& \usebox{\UNL@spine@thick} &}
				{\UNL@shortauthor & & \UNL@title} 
		& & 
    \vspace*{4pt}
    \includegraphics[origin=c,angle=-90,height=0.9\UNL@spinewidth]{\UNL@logo@spine}
	\end{tabularx}
}}
\restoregeometry
\cleardoublepage
}


