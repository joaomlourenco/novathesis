%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% unlthesis.cls
%%% UNL thesis document class
%%%
%%% By João Lourenço (joao.lourenco@di.fct.unl.pt)
%%% Version of September 4, 2014
%%%
%%% BUGS and SUGGETSIONS: please send email to "joao.lourenco@fct.unl.pt"
%%%
%%% CONTRIBUTERS are welcome. Please contact "joao.lourenco@fct.unl.pt"
%%%
%%% WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
%%% WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
%%% 
%%%   You SHOULD NOT change this file (you are playing with fire!)
%%% 
%%% WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
%%% WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{unlthesis}[2014/09/04 UNL Thesis Template]



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROCESS KEY-VAL OPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{kvoptions-patch}
\RequirePackage{xkeyval}
\RequirePackage{xifthen}



% --------------------------------------------------------
% DOCUMENT TYPE		UNL@doctype=?
%
% BSc report			bsc
% MSc preliminary report	prepmsc
% MSc dissertation		msc
% PhD proposal			propphd
% PhD preliminary report	prepphd
% PhD thesis			phd

\DeclareOptionX{doctype}{
	\typeout{'doctype'=#1}
	\gdef\UNL@doctype{#1}
}


% --------------------------------------------------------
% MAIN LANGUAGE		Only PT and EN are accepted for now
%
%			    UNL@lang=?
% Portuguese			0
% English			1

\gdef\UNL@lang{pt}
\DeclareOptionX{lang}{
	\typeout{'lang'=#1}
	\ifthenelse{\equal{#1}{pt}\OR\equal{#1}{PT}}{\gdef\UNL@lang{pt}\PassOptionsToPackage{english,portuguese}{babel}}
	{\ifthenelse{\equal{#1}{en}\OR\equal{#1}{EN}}{\gdef\UNL@lang{en}\PassOptionsToPackage{portuguese,english}{babel}}{
	\PackageError{thesisdifctunl}{Wrong value for option 'lang'}{Please see the documentation}
	\expandafter\endinput
	}}
}


% --------------------------------------------------------
% linkscolor	COLOR
%
% black
% blue
% ...

\DeclareOptionX{linkscolor}{
	\typeout{'linkscolor'=#1}
	\PassOptionsToPackage{allcolors=#1}{hyperref}
}


% --------------------------------------------------------
% ENCODING		Anything valid for package "inputenc"
%
% utf8
% latin1
% ...

\DeclareOptionX{enc}{
	\typeout{'enc'=#1}
	\PassOptionsToPackage{#1}{inputenc}
}


% --------------------------------------------------------
% PRINTSPINE		Print (don't print) the book spine
%
% true
% false

\DeclareOptionX{spine}[true]{
	\typeout{'spine'=#1}
	\ifthenelse{\equal{#1}{true}}{\AtEndDocument{\printthespine}}{}
}


% --------------------------------------------------------
% DRAFT		Draft version, print the current date at the bottom of the cover page
%
% true
% false

% \DeclareOptionX{draft}[true]{
% 	\typeout{'draft'=#1}
% 	\PassOptionsToPackage{#1}{memoir}
% }


% --------------------------------------------------------
% FINAL		Final version, print the MONTH and YEAR as defined by the user
%                  at the bottom of the cover page
%
% true
% false

% \DeclareOptionX{draft}[true]{
% 	\typeout{'draft'=#1}
% 	\PassOptionsToClass{#1}{memoir}
% }


% --------------------------------------------------------
% BIBLATEX OPTIONS		Are passed to the biblatex package
%
% style= numeric | alphabetic | 
% ...
%
% \DeclareOptionX{style}{
% 	\typeout{'biblatex style'=#1}
% 	\PassOptionsToPackage{style=#1}{biblatex}
% }
% \DeclareOptionX{sorting}{
% 	\typeout{'biblatex sorting'=#1}
% 	\PassOptionsToPackage{sorting=#1}{biblatex}
% }
\DeclareOptionX{biblatex}{
 	\typeout{'biblatex'=#1}
	\PassOptionsToPackage{#1}{biblatex}
}


% --------------------------------------------------------
% BOOK OPTIONS		Are passed to the main class (book)
%
% twoside
% a4paer
% ...

\DeclareOptionX{memoir}{
	\typeout{'memoir'=#1}
	\PassOptionsToClass{#1}{memoir}
}


% --------------------------------------------------------
% DEFAULT OPTIONS
% \PassOptionsToPackage{portuguese,english}{babel}

\ExecuteOptionsX{
	doctype=phd,
	lang=en,
	enc=utf8,
	spine=false,
	biblatex={
		% sorting=nyt,%
		% style=alphabetic,%
		% labelyear=false,%
		maxalphanames=2,
		defernumbers=true,%
		maxbibnames=20,%
		maxcitenames=2,%
		mincitenames=1,%
		firstinits=true,% will render all first and middle names as initials
		uniquename=init,%
		% dashed=false,%
		sortcites=true,
	},
	memoir={a4paper, 11pt, draft}
}



% --------------------------------------------------------
% BIBBYCHAPTER		Bibliography per chaper… Ignored for now!
\let\UNL@bibbychapter=0
% \DeclareOption{bibbychapter}{
% 	\let\UNL@bibbychapter=1
% }



% --------------------------------------------------------
% PROCESSING OPTIONS
\ProcessOptionsX\relax



% --------------------------------------------------------
% LOAD MAIN CLASS AND ADDITIONAL PACKAGES
\LoadClass{memoir}


\OnehalfSpacing           % One-and-half spacing


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PACKAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% Configure input file format
\RequirePackage{inputenc}		% Format for the input file(s), see the "enc" option


%%%%% Configure fonts
\RequirePackage[T1]{fontenc}		% Use new T1 fonts
\RequirePackage{mathpazo}		% Font with fixes dor math support: Palatino
\RequirePackage[scaled=.95]{helvet}
\RequirePackage{courier}


%%%%% Fine tuning of typesetting
\RequirePackage{microtype}


%%%%% Configure multilingual language support
\RequirePackage{babel}			% Support for bilingual documents
\RequirePackage{memory}		% To keep records to store strings


%%%%% Better support for calculations
\RequirePackage{calc}


%%%%% Configure Graphics
% \RequirePackage[pdftex]{graphicx}
\RequirePackage{graphicx}
\DeclareGraphicsExtensions{.pdf, .png, .jpg, .tif}


%%%%% Configure HyperRefs
% \RequirePackage[pdftex,usenames]{color}
% \RequirePackage[pdftex]{xcolor}
% \RequirePackage[usenames]{color}
\RequirePackage{xcolor}
\definecolor{darkblue}{rgb}{0.0,0.08,0.45}
\RequirePackage[breaklinks, colorlinks=true, pdfdisplaydoctitle]{hyperref}
\usepackage{memhfixc}		% Must be used on memoir document class after hyperref


%%%%% Configure page geometry
% Needs version equal or later to 2010/02/12, which support the "newgeometry" command
\RequirePackage[top=3cm,bottom=3cm,inner=3.5cm,outer=2.5cm]{geometry}[2010/02/12]


%%%%% Condditional processing for PDF file
% \RequirePackage{ifpdf}		% This is now the recommended way for checking for PDFLaTeX:
% \ifpdf
% % \pdfinfo{
% %    /Author (Author's name)
% %    /Title (PhD Thesis)
% %    /Keywords (One; Two;Three)
% %    /CreationDate (D:\pdfdate)
% % }
% \else
% \fi


% AAdd an image to the backgroung
% 	Used to inser the background image in the cover page
\RequirePackage{eso-pic}
\newcommand{\BackgroundPic}[1]{
    \put(0,0){
	\parbox[b][\paperheight]{\paperwidth}{%
		\vfill
		\centering
		\includegraphics[width=\paperwidth,height=\paperheight,
		keepaspectratio]{#1}%
		\vfill
}}}


% To process the bibliography
\RequirePackage[backend=bibtex]{biblatex}



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
	{\PackageError{thesisdifctunl}{Wrong value for option 'lang'}{Please see the documentation}%
	\expandafter\endinput}}



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

\newdata*{UNL@jurytitlestr}
\newdata*{UNL@presidentstr}
\newdata*{UNL@refereestr}
\newdata*{UNL@memberstr}
	

\newdata*{UNL@dissertationstr}
\newdata*{UNL@copyrighttext}

% Input definitions for strings above in multiple languages
\InputIfFileExists{langsupport}{}{}

% Portuguese
\ifthenelse{\equal{\UNL@lang}{pt}}
	{\def\lstlistlistingname{Listagens}}
	{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\gdef\UNL@presentationtext{%
	\UNL@dissertationstr[\UNL@doctype,\UNL@cover@lang]
}

\gdef\thecopyrightstr{%
\thispagestyle{empty}
\noindent
Copyright \copyright\ \@author, \@faculty, \@university

\bigskip
\noindent
\UNL@copyrighttext[\UNL@cover@lang]}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Default cover background
\def\thesiscoverphd#1{%
  \gdef\@thesiscoverphd{#1}}
\def\@thesiscoverphd{~thesiscoverphd \UNL@notdefined}

\def\thesiscovermsc#1{%
  \gdef\@thesiscovermsc{#1}}
\def\@thesiscovermsc{~thesiscovermsc \UNL@notdefined}

\def\thesiscoverplain#1{%
  \gdef\@thesiscoverplain{#1}}
\def\@thesiscoverplain{~thesiscoverempty \UNL@notdefined}


% \def\university#1{%
%   \gdef\@university{#1}}
% \def\@university{~university \UNL@notdefined}
% 
% \def\faculty#1{%
%   \gdef\@faculty{#1}}
% \def\@faculty{~faculty\UNL@notdefined}
% 
% \def\department#1{%
%   \gdef\@department{#1}}
% \def\@department{~department \UNL@notdefined}

\def\majorfield#1{%
  \gdef\@majorfield{#1}}
\def\@majorfield{~majorfield \UNL@notdefined}

\def\address#1{%
  \gdef\@address{#1}}
\def\@address{~address \UNL@notdefined}

\def\faculty#1{%
  \gdef\@faculty{#1}}
\def\@majorfield{~faculty \UNL@notdefined}

\def\university#1{%
  \gdef\@university{#1}}
\def\@majorfield{~university \UNL@notdefined}

% \@input@{repeat}

\@input@{defaults}
%% Date

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
%%% NEW definition for jury with lists
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% To process lists and other stuff
\RequirePackage{etoolbox}


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


\def\jury{%
  \@ifnextchar [%
    {\UNL@jury}%
    {\UNL@jury[v]}}

\def\UNL@jury[#1]#2{%
	\listcsgadd{UNL@jury@#1@list}{#2}
}

\newcommand{\UNL@do@jury@tabular}[1]{
	& #1\\
}

\def\printthejury{%
	\begin{tabular}{ll}
	& \UNL@jurytitlestr[\UNL@cover@lang]:\\
	\ifthenelse{\isundefined\UNL@jury@p@list}{}{%
			\listcssize{UNL@jury@p@list}%
			\ifthenelse{\equal{\the\UNL@listsize@cnt}{1}}%
				{\gdef\UNL@jury@n@p{1}}%
				{\gdef\UNL@jury@n@p{2}}%
			\UNL@presidentstr[\UNL@jury@n@p,\UNL@cover@lang]:
			\forlistcsloop{\UNL@do@jury@tabular}{UNL@jury@p@list}
	}
	\ifthenelse{\isundefined\UNL@jury@a@list}{}{%
			\listcssize{UNL@jury@a@list}%
			\ifthenelse{\equal{\the\UNL@listsize@cnt}{1}}%
				{\gdef\UNL@jury@n@p{1}}%
				{\gdef\UNL@jury@n@p{2}}%
			\UNL@refereestr[\UNL@jury@n@p,\UNL@cover@lang]:
			\forlistcsloop{\UNL@do@jury@tabular}{UNL@jury@a@list}
	}
	\ifthenelse{\isundefined\UNL@jury@v@list}{}{%
			\listcssize{UNL@jury@v@list}%
			\ifthenelse{\equal{\the\UNL@listsize@cnt}{1}}%
				{\gdef\UNL@jury@n@p{§}}%
				{\gdef\UNL@jury@n@p{2}}%
			\UNL@memberstr[\UNL@jury@n@p,\UNL@cover@lang]:
			\forlistcsloop{\UNL@do@jury@tabular}{UNL@jury@v@list}
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
	\listcsgadd{UNL@#1adviser@gender@list}{#2}
	\listcsgadd{UNL@#1adviser@name@list}{#3}
	\listcsgadd{UNL@#1adviser@category@list}{#4}
	\listcsgadd{UNL@#1adviser@school@list}{#5}
	\listcsgadd{UNL@#1adviser@list}{{#3},{#4},{#5}}
}

\newcount\UNL@listgenderf@cnt
\newcommand{\UNL@do@listgenderf@count}[1]{%
	\ifthenelse{\equal{#1}{f}}{\advance\UNL@listgenderf@cnt 1\relax}{}%
}
\def\listcsgenderf#1{%
	\UNL@listgenderf@cnt 0\relax%
	\ifthenelse{\expandafter\isundefined\csname #1\endcsname}{%
	}{%
	\forlistcsloop{\UNL@do@listgenderf@count}{#1}%
	}%
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
	\def\UNL@adv{\csname UNL@#1adviserstr\endcsname}
	\UNL@adv[\UNL@adviser@n,\UNL@adviser@g,\UNL@cover@lang]
}


% \newsavebox{\UNL@adviser@tabular@item@box}
% \newlength{\UNL@adviser@tabular@item@box@w}
\def\UNL@do@adviser@tabular@item#1,#2,#3{%
		& \mbox{#1}, \mbox{#2}, \mbox{#3}\\%
}
\def\UNL@do@adviser@tabular#1{%
	\UNL@do@adviser@tabular@item#1
}


\def\printtheadvisers{%
	% \begin{tabularx}{\linewidth}{lX<{\raggedright}}
	\begin{tabu} spread 0pt {lX[1,l,p]}
	\ifthenelse{\isundefined\UNL@adviser@gender@list}{}{%
			\UNL@adviser@str{}: %
			\forlistcsloop{\UNL@do@adviser@tabular}{UNL@adviser@list}%
	}
	\ifthenelse{\isundefined\UNL@coadviser@gender@list}{}{%
			\UNL@adviser@str{co}: %
			\forlistcsloop{\UNL@do@adviser@tabular}{UNL@coadviser@list}%
	}
	\end{tabu}
	% \end{tabularx}
	\par
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Draw the cover page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set cover language to Portuguese.
%% In the future this will be configurable, but not yet! :(
\def\UNL@cover@lang{pt}


\def\coverpage{
\thispagestyle{empty}
\pagestyle{empty}

%% Define cover page margins
\ifthenelse{%
	\equal{\UNL@doctype}{bsc}%
	\OR\equal{\UNL@doctype}{prepmsc}%
	\OR\equal{\UNL@doctype}{msc}}{% MSc
		\def\@defcoverbg{\@thesiscovermsc}
		\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=4.5cm,rmargin=3.3cm}
	}{%
\ifthenelse{%
	\equal{\UNL@doctype}{prepphd}%
	\OR\equal{\UNL@doctype}{propphd}%
	\OR\equal{\UNL@doctype}{phd}}{% PhD
		\def\@defcoverbg{\@thesiscoverphd}
		\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=5.5cm,rmargin=2.5cm}
	}
{	% Plain
	\def\@defcoverbg{\@thesiscoverplain}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=4.5cm,rmargin=3.3cm}
}}

%% Add background image	
\AddToShipoutPicture*{\BackgroundPic{\@defcoverbg}}


\begin{center}
	\fontfamily{phv}

% Name of Candidate
	\fontsize{15}{17}
	\selectfont
	\textbf{\@author}
	
\vspace{0.25cm}	
% Academic qualifications
	\fontsize{12}{13}
	\selectfont
	\@authordegree

\vspace{4.25cm}
% Title of Dissertation
	\fontsize{18}{20}
	\selectfont
	\textbf{\UNL@title}\\[0.75cm]

\vspace{0.75cm}
% Degree
	\fontsize{12}{13}
	\selectfont
	\UNL@presentationtext
	
	\vfill
	% Advisers
	\fontsize{13}{14}
	\selectfont
	\printtheadvisers

\vfill\vfill
% Referee board
	\ifthenelse{%
		\equal{\UNL@doctype}{bsc}%
		\OR\equal{\UNL@doctype}{msc}%
		% \OR\equal{\UNL@doctype}{propphd}%
		\OR\equal{\UNL@doctype}{phd}}
	{\hfill\fontsize{10}{11}\selectfont\printthejury}
	{}

\vfill\vfill\vfill

% Date
	\fontsize{12}{13}
	\selectfont
	\ifdraftdoc 
		\textbf{DRAFT: \today}
	\else
		\textbf{\@themonth, \@theyear}
	\fi	

\end{center}
\restoregeometry
\cleardoublepage
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
	\xdef\UNL@tmp{\expandafter\csname UNL@abstractorder@en\endcsname}
	\expandafter\docsvlist\expandafter{\UNL@tmp}
}



\def\thesisfrontmatter{%
	\frontmatter
	% \pagestyle{fancy}
	\pagenumbering{roman} 
	% \fancyhead{}
	\setlength{\headheight}{15pt}
	% \fancyhead[RO,LE]{}
	% \if\UNL@lang0   % Tese em Português
	% 	\selectlanguage{portuguese}
	% \else\if\UNL@lang1   % Thesis in English
	% 	\selectlanguage{english}
	% \fi\fi
}

\def\thesismainmatter{%
	\mainmatter
	% \pagestyle{fancy}
	\pagenumbering{arabic} 
	% \fancyhead{}
	\setlength{\headheight}{15pt}
	% \fancyhead[RO,LE]{\leftmark\hfill\rightmark}
	% \def\chaptermark##1{\markboth{\fontfamily{phv}%
	% 	\selectfont\footnotesize\thechapter.\ \textsc{##1}}{}}
	% \def\sectionmark##1{\markright{\fontfamily{phv}%
	%  	\selectfont\footnotesize\thesection.\ ##1}}
	% \if\UNL@lang0   % Tese em Português
	% 	\selectlanguage{portuguese}
	% \else\if\UNL@lang1   % Thesis in English
	% 	\selectlanguage{english}
	% \fi\fi
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\chapterfile#1{%
	\listgadd{\UNL@chapter@list}{#1}
}

\def\UNL@printchapter#1{%
% 	\if\UNL@bibbychapter1
% 		\begin{refsegment}
% 	\fi
	\InputIfFileExists{Chapters/#1}{}{ERROR: File '#1' does not exist!!!}
%	\if\UNL@bibbychapter1
%		\printbibliography[segment=\arabic{chapter},heading=subbibintoc]
%		\end{refsegment}
%	\fi
}

\def\printchapthers{%
	\forlistloop{\UNL@printchapter}{\UNL@chapter@list}
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
	\forlistloop{\UNL@printappendix}{\UNL@appendix@list}
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
	\cleardoublepage
	\forlistloop{\UNL@printlist}{\UNL@frontmatter@list}%
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



% \titleformat{\chapter}[display]
% {\bfseries\Huge}				% format
% {\hfill\colorbox{backGrayColor}{\fontsize{100}{120}\selectfont{\textcolor{white}{\thechapter}}}} % label
% {1ex}							% sep
% {%\titlerule
%   \vspace{2ex}\filleft}			% before
% %\colorbox{backGrayColor}{}
% [\vspace{1cm}					%\titlerule
% ]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Headers & footers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tables and figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mathematics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{soul}
\newsavebox{\UNL@chapter} 
\newcommand\UNL@chapter@marker[1][4cm]{%
	\sbox\UNL@chapter{% 
		\resizebox{!}{#1}{\fboxsep=1pt%
			\colorbox{lightgray}{\color{white}\thechapter}% 
		}}%
		\rotatebox{90}{% 
			\resizebox{%
				\heightof{\usebox{\UNL@chapter}}+\depthof{\usebox{\UNL@chapter}}}% 
			{!}{\scshape\so\@chapapp}}\quad%
		\raisebox{\depthof{\usebox{\UNL@chapter}}}{\usebox{\UNL@chapter}}%
} 
\newcommand\UNL@chm[1][4cm]{%
	\sbox\UNL@chapter{\UNL@chapter@marker[#1]}% 
	\makebox[0pt][c]{% aka \rlap
		\makebox[1cm][r]{\usebox\UNL@chapter}%
	}}
\makechapterstyle{UNLchapstyle}{
	\renewcommand\chapnamefont{\normalfont\Large\scshape\raggedleft\so} 
	\renewcommand\chaptitlefont{\normalfont\LARGE\bfseries\scshape} 
	\renewcommand\chapternamenum{} \renewcommand\printchaptername{} 
	\renewcommand\printchapternum{\null\hfill\UNL@chm[2.5cm]\hspace*{14pt}\par} 
	\renewcommand\afterchapternum{\par\vskip\midchapskip} 
	\renewcommand\printchaptertitle[1]{\color{darkgray}\chaptitlefont\raggedleft ##1\par}
} 
\chapterstyle{UNLchapstyle}
%
% UNL guidelines:
%
% The pages should be numbered consecutively at the bottom centre of the
% page.
\makepagestyle{UNL@myvf} 
\makeoddfoot{UNL@myvf}{}{\thepage}{} 
\makeevenfoot{UNL@myvf}{}{\thepage}{} 
\makeheadrule{UNL@myvf}{\textwidth}{\normalrulethickness} 
\makeevenhead{UNL@myvf}{\small\textsc{\leftmark}}{}{} 
\makeoddhead{UNL@myvf}{}{}{\small\textsc{\rightmark}}
\pagestyle{UNL@myvf}
%
\frenchspacing
% Fills blank pages until next odd-numbered page. Used to emulate single-sided
% frontmatter. This will work for title, abstract and declaration. Though the
% contents sections will each start on an odd-numbered page they will
% spill over onto the even-numbered pages if extending beyond one page
% (hopefully, this is ok).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate book spine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \makepagestyle{UNL@spine@pagestyle}
% \makeoddfoot{UNL@spine@pagestyle}{}{}{}
% \makeevenfoot{UNL@spine@pagestyle}{}{}{}
% \makeevenhead{UNL@spine@pagestyle}{}{}{}
% \makeoddhead{UNL@spine@pagestyle}{}{}{}
% \pagestyle{UNL@spine@pagestyle}

\def\shortauthor#1{\gdef\UNL@shortauthor{#1}} % \spine is used to print the author short name (maybe there is a more elegant solution for this
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
		& & \vspace*{4pt}\includegraphics[origin=c,angle=-90,height=0.9\UNL@spinewidth]{logoUNL}
	\end{tabularx}
}}
\restoregeometry
\cleardoublepage
}


