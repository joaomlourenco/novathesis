%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% unlthesis.cls
%%% UNL thesis document class
%%%
%%% By João Lourenço (joao.lourenco@di.fct.unl.pt)
%%% Version of August 1, 2014
%%%
%%% BUGS and SUGGETSIONS: please send email to "joao.lourenco@fct.unl.pt"
%%%
%%% CONTRIBUTERS are welcome. Please contact "joao.lourenco@fct.unl.pt"
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{unlthesis}[2014/08/01 UNL Thesis Template]



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PROCESS KEY-VAL OPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{kvoptions-patch}
\RequirePackage{xkeyval}
\RequirePackage{xifthen}



% --------------------------------------------------------
% DOCUMENT TYPE		UNL@doctype=?
%
% BSc report			0
% MSc preliminary report	1
% MSc dissertation		2
% PhD proposal			3
% PhD preliminary report	4
% PhD thesis			5

\DeclareOptionX{doctype}{
	\typeout{'doctype'=#1}
	\ifthenelse{\equal{#1}{bsc}}{\gdef\UNL@doctype{0}}
	{\ifthenelse{\equal{#1}{prepmsc}}{\gdef\UNL@doctype{1}}
	{\ifthenelse{\equal{#1}{msc}}{\gdef\UNL@doctype{2}}{
	{\ifthenelse{\equal{#1}{propphd}}{\gdef\UNL@doctype{3}}{
	}{\ifthenelse{\equal{#1}{prepphd}}{\gdef\UNL@doctype{4}}{
	}{\ifthenelse{\equal{#1}{phd}}{\gdef\UNL@doctype{5}}{
	\PackageError{thesisdifctunl}{Wrong value for option 'doctype': #1}{Please see the documentation}
	\expandafter\endinput
	}}}}}}}
}


% --------------------------------------------------------
% MAIN LANGUAGE		Only PT and EN are accepted for now
%
%			    UNL@lang=?
% Portuguese			0
% English			1

\DeclareOptionX{lang}{
	\typeout{'lang'=#1}
	\ifthenelse{\equal{#1}{pt}\OR\equal{#1}{PT}}{\def\UNL@lang{0}}
	{\ifthenelse{\equal{#1}{en}\OR\equal{#1}{EN}}{\def\UNL@lang{1}}{
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

\DeclareOptionX{spine}{
	\typeout{'spine'=#1}
	\ifthenelse{\equal{#1}{true}}{\AtEndDocument{\printthespine}}{}
}


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
\PassOptionsToPackage{portuguese,english}{babel}

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
	memoir={a4paper, 11pt}
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


%%%%% Configure multilingual language support
\RequirePackage{babel}			% Support for bilingual documents


%%%%% Better support for calculations
\RequirePackage{calc}


%%%%% Configure Graphics
\RequirePackage[pdftex]{graphicx}
\DeclareGraphicsExtensions{.pdf, .png, .jpg, .tif}


%%%%% Configure HyperRefs
\RequirePackage[pdftex,usenames]{color}
\RequirePackage[pdftex]{xcolor}
\definecolor{darkblue}{rgb}{0.0,0.08,0.45}
\RequirePackage[breaklinks, colorlinks=true, pdfdisplaydoctitle]{hyperref}
\usepackage{memhfixc}		% Must be used on memoir document class after hyperref


%%%%% Configure page geometry
\RequirePackage[top=3cm,bottom=3cm,inner=3.5cm,outer=2.5cm]{geometry}[2010/02/12]


%%%%% Configure gloassaries
\RequirePackage[nonumberlist]{glossaries}
\glsdisablehyper
\makenoidxglossaries


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


% Required to draw the cover page
\RequirePackage{ctable}


% To process the bibliography
\RequirePackage[backend=bibtex]{biblatex}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \let\origcleardoublepage=\cleardoublepage
% \def\cleardoublepage{%
%   \newpage{\pagestyle{empty}\origcleardoublepage}
% }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Some relevant strings

\gdef\UNL@singlemadviserstr{Orientador}
\gdef\UNL@singlefadviserstr{Orientadora}
\gdef\UNL@manymadviserstr{Orientadores}
\gdef\UNL@manyfadviserstr{Orientadoras}
\gdef\UNL@singlemcoadviserstr{Co-orientador}
\gdef\UNL@singlefcoadviserstr{Co-orientadora}
\gdef\UNL@manymcoadviserstr{Co-orientadores}
\gdef\UNL@manyfcoadviserstr{Co-orientadoras}

\gdef\UNL@mbachelordegreestr{Licenciado}
\gdef\UNL@fbachelordegreestr{Licenciada}
\gdef\UNL@mmastersdegreestr{Mestre}
\gdef\UNL@fmastersdegreestr{Mestre}
\gdef\UNL@mphddegreestr{Doutor}
\gdef\UNL@fphddegreestr{Doutora}

% \gdef\doutor{Dr.\ }
% \gdef\doutora{Drª.\ }
% \gdef\profdoutor{Prof.\ Dr.\ }
% \gdef\profdoutora{Profª.\ Drª.\ }

\gdef\UNL@bachelordissertationstr{Projeto de Licenciatura}
\gdef\UNL@mastersdissertationstr{Dissertação de Mestrado}
\gdef\UNL@mastersqualifyingstr{Preparação de Dissertação}
\gdef\UNL@phdqualifyingstr{Preparação de Tese}
\gdef\UNL@phdproposalstr{Proposta de Tese de Doutoramento}
\gdef\UNL@phdthesisstr{Tese de Doutoramento}

\gdef\UNL@jurystr{Júri}

\gdef\UNL@bscdissertationtstr{Relatório para obtenção do Grau de \\\UNL@degree em \@majorfield}
\gdef\UNL@prepmscdissertationtstr{Relatório intermédio para obtenção do Grau de \\\UNL@degree em \@majorfield}
\gdef\UNL@mscdissertationtstr{Dissertação para obtenção do Grau de \\\UNL@degree em \@majorfield}
\gdef\UNL@propphhdissertationtstr{Proposta de tese para obtenção do Grau de \\\UNL@degree em \@majorfield}
\gdef\UNL@prepphhdissertationtstr{Relatório intermédio para obtenção do Grau de \\\UNL@degree em \@majorfield}
\gdef\UNL@phhdissertationtstr{Dissertação para obtenção do Grau de \\\UNL@degree em \@majorfield}


\if\UNL@doctype0
    \gdef\@presentationtext{\UNL@bscdissertationtstr}
\else\if\UNL@doctype1
    \gdef\@presentationtext{\UNL@prepmscdissertationtstr}
\else\if\UNL@doctype2
    \gdef\@presentationtext{\UNL@mscdissertationtstr}
\else\if\UNL@doctype3
    \gdef\@presentationtext{\UNL@propphhdissertationtstr}
\else\if\UNL@doctype4
    \gdef\@presentationtext{\UNL@prepphhdissertationtstr}
\else\if\UNL@doctype5
    \gdef\@presentationtext{\UNL@phhdissertationtstr}
\fi\fi\fi\fi\fi\fi

\gdef\thecopyrightstr{%
\thispagestyle{empty}
\noindent
Copyright \copyright\ \@author, \@faculty, \@university

\bigskip
\noindent
A \@faculty\ e a \@university\ têm o direito, perpétuo e sem limites geográficos, de arquivar e publicar esta dissertação através de exemplares impressos reproduzidos em papel ou de forma digital, ou por qualquer outro meio conhecido ou que venha a ser inventado, e de a divulgar através de repositórios científicos e de admitir a sua cópia e distribuição com objectivos educacionais ou de investigação, não comerciais, desde que seja dado crédito ao autor e editor.}

%% Language dependent

\gdef\UNL@abstrnamePT{Resumo}
\gdef\UNL@abstrnameEN{Abstract}

\gdef\@keywordsnamePT{Palavras-chave}
\gdef\@keywordsnameEN{Keywords}


%% Language Dependent

% Portuguese
\if\UNL@lang0
  \gdef\@notdefined{NÃO DEFINIDO}
  \gdef\acknowledgementsname{Agradecimentos}
  \def\lstlistlistingname{Listagens}
% English
\else\if\UNL@lang1
  \gdef\@notdefined{UNDEFINED}
  \gdef\acknowledgementsname{Acknowledgements}
\fi\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \def\universitylogo#1{%
%   \gdef\@universitylogo{#1}}
% \def\@universitylogo{~universitylogo \@notdefined}
% 
% \def\universitylogowidth#1{%
%   \gdef\@universitylogowidth{#1}}
% \def\@universitylogowidth{2cm}

% Default cover background
\def\thesiscoverphd#1{%
  \gdef\@thesiscoverphd{#1}}
\def\@thesiscoverphd{~thesiscoverphd \@notdefined}

\def\thesiscovermsc#1{%
  \gdef\@thesiscovermsc{#1}}
\def\@thesiscovermsc{~thesiscovermsc \@notdefined}

\def\thesiscoverplain#1{%
  \gdef\@thesiscoverplain{#1}}
\def\@thesiscoverplain{~thesiscoverempty \@notdefined}


% \def\university#1{%
%   \gdef\@university{#1}}
% \def\@university{~university \@notdefined}
% 
% \def\faculty#1{%
%   \gdef\@faculty{#1}}
% \def\@faculty{~faculty\@notdefined}
% 
% \def\department#1{%
%   \gdef\@department{#1}}
% \def\@department{~department \@notdefined}

\def\majorfield#1{%
  \gdef\@majorfield{#1}}
\def\@majorfield{~majorfield \@notdefined}

\def\address#1{%
  \gdef\@address{#1}}
\def\@address{~address \@notdefined}

\def\faculty#1{%
  \gdef\@faculty{#1}}
\def\@majorfield{~faculty \@notdefined}

\def\university#1{%
  \gdef\@university{#1}}
\def\@majorfield{~university \@notdefined}

% \@input@{repeat}

\@input@{defaults}


%% Date

\def\themonth#1{\gdef\@themonth{#1}}
\def\@themonth{~themonth \@notdefined}

\def\theyear#1{\gdef\@theyear{#1}}
\def\@theyear{~theyear \@notdefined}


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

\def\@author{~author \@notdefined}

\def\authordegree#1{%
  \gdef\@authordegree{#1}}
\def\@authordegree{~authordegree \@notdefined}


%% Advisors and Co-Advisers identification (at most 9 of each)
%% \adviser[m|f]{Name}{Category/Position}{School}
%% where N i a number from 1 to 9
\def\@theadvisergender{f}	% default for female advisers
\newcount\UNL@theadvisercount	% number of advisers
\UNL@theadvisercount 0\relax
\def\UNL@thecoadvisergender{f}	% default for female co-advisers
\newcount\UNL@thecoadvisercount	% number of co-advisers
\UNL@thecoadvisercount 0\relax

% 
% \newcount\@myi
% \@myi 0\relax
% \loop
% 	\advance\@myi 1\relax
% 	\expandafter\let\csname UNL@showadviser\number\@myi\endcsname=0
% 	\expandafter\let\csname UNL@showcoadviser\number\@myi\endcsname=0
% \ifnum \@myi < 10
% \repeat

% \repeat \for{i} \from{1} \to{9} \do {
% 	\expandafter\let\csname UNL@showadviser\number\i\endcsname=0
% 	\expandafter\let\csname UNL@showcoadviser\number\i\endcsname=0
% 	\expandafter\let\csname UNL@showjury\number\i\endcsname=0
% }


\def\adviser{%
  \@ifnextchar [%
    {\@padviser[]}%
    {\@padviser[][m]}}

\def\coadviser{%
  \@ifnextchar [%
    {\@padviser[co]}%
    {\@padviser[co][m]}}

% #1 = [] for adviser or [co] co co-adviser
% #2 = [m] or [f]
% #3 = {name}
% #4 = {category}
% #5 = {school/institution}
\def\@padviser[#1][#2]#3#4#5{%
  \expandafter\advance\csname UNL@the#1advisercount\endcsname 1\relax
  \ifx#2m
  	\expandafter\def\csname UNL@the#1advisergender\endcsname{m}
  \else\ifx#2f
  \else
  \typeout{^^J%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^^J%
!  Please specify #1adviser gender using [m] or [f] as the second^^J%
!  argument of the "#1adviser" macro.  See the template! ;)^^J%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^^J%
}
   \errhelp{Please be gentle and follow the template recommendations.}
   \errmessage{Please specify adviser gender!}
  \fi\fi
  \expandafter\gdef\csname UNL@#1advisername\expandafter\number\csname UNL@the#1advisercount\endcsname\endcsname{#3}
  \expandafter\gdef\csname UNL@#1advisercat\expandafter\number\csname UNL@the#1advisercount\endcsname\endcsname{#4}
  \expandafter\gdef\csname UNL@#1adviserschool\expandafter\number\csname UNL@the#1advisercount\endcsname\endcsname{#5}
}

\def\UNL@theadviserstr[#1]{%
	\UNL@ptheadviserstr[#1]{\expandafter\csname UNL@the#1advisercount\endcsname}{\expandafter\csname UNL@the#1advisergender\endcsname}%
}

\def\UNL@ptheadviserstr[#1]#2#3{%
	\ifnum #2 > 1
  		\expandafter\csname UNL@many#3#1adviserstr\endcsname
	\else
  		\expandafter\csname UNL@single#3#1adviserstr\endcsname
	\fi
}

\def\printadviser[#1]#2{%
	\ifcsname UNL@#1advisername#2\endcsname
		\ifnum #2 = 1
			& \\[-2ex]
			\UNL@theadviserstr[#1]:
		\fi
		&
		\expandafter\csname UNL@#1advisername#2\endcsname,\\&
		\expandafter\csname UNL@#1advisercat#2\endcsname,
		\expandafter\csname UNL@#1adviserschool#2\endcsname
	\\
	\fi
}




%% Work identification

\def\title#1{%
  \gdef\@title{#1}
  \hypersetup{pdftitle={\@title}}}
\def\@title{~title \@notdefined}

\def\@texttype{%
  \if\UNL@doctype0
    \UNL@bachelordissertationstr
  \else\if\UNL@doctype1
    \UNL@mastersqualifyingstr
  \else\if\UNL@doctype2
  \UNL@mastersdissertationstr
  \else\if\UNL@doctype3
    \UNL@phdproposalstr
  \else\if\UNL@doctype4
   \UNL@phdqualifyingstr
   \else\if\UNL@doctype5
    \UNL@phdthesisstr
  \fi\fi\fi\fi\fi\fi}

\def\thedegree#1#2{%
	\expandafter\csname UNL@#1#2\endcsname}

\def\UNL@degree{%
  \if\UNL@doctype0
    \thedegree{\ader}{bachelordegreestr}
  \else\if\UNL@doctype1
    \thedegree{\authorgender}{mastersdegreestr}
  \else\if\UNL@doctype2
    \thedegree{\authorgender}{mastersdegreestr}
  \else\if\UNL@doctype3
    \thedegree{\authorgender}{phddegreestr}
  \else\if\UNL@doctype4
    \thedegree{\authorgender}{phddegreestr}
   \else\if\UNL@doctype5
    \thedegree{\authorgender}{phddegreestr}
  \fi\fi\fi\fi\fi\fi}



% Juri
\newcount\UNL@thejurypcount	% number of presidents (must be one)
\UNL@thejurypcount 0\relax
\newcount\UNL@thejuryacount	% number of referees
\UNL@thejuryacount 0\relax
\newcount\UNL@thejuryvcount	% number of other memebrs of the jury
\UNL@thejuryvcount 0\relax

\def\jury{%
  \@ifnextchar [%
    {\@pjury}%
    {\@pjury[v]}}


% #1 = [p] for president, [a] for referee, [v] for others
% #2 = {name}
\def\@pjury[#1]#2{%
	\expandafter\advance\csname UNL@thejury#1count\endcsname 1\relax
  	\expandafter\gdef\csname UNL@jury#1name\expandafter\number\csname UNL@thejury#1count\endcsname\endcsname{#2}
}

\def\printthejuryp{%
	\ifnum \UNL@thejurypcount = 1
		& \\[-2ex]
		Presidente: & \csname UNL@jurypname1\endcsname \\
	\else
  		\typeout{^^J%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^^J%
!  Please identify one and only one president of the jury with^^J%
!  the [p] argument of the "jury" macro.  See the template! ;)^^J%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^^J%
}
   		\errhelp{Please be gentle and follow the template recommendations.}
   		\errmessage{Please specify president of the jury!}
	\fi
}

\def\UNL@printthejurya[#1]{%
	\ifcsname UNL@juryaname#1\endcsname
	\ifnum #1 = 1
		& \\[-2ex]
		Arguente\ifnum \UNL@thejuryacount > 1 s\fi:
	\fi
	& \expandafter\csname UNL@juryaname#1\endcsname\relax \\
	\fi
}

\def\printthejurya{%
	\ifnum \UNL@thejuryacount > 0
		\UNL@printthejurya[1]
		\UNL@printthejurya[2]
		\UNL@printthejurya[3]
		\UNL@printthejurya[4]
		\UNL@printthejurya[5]
		\UNL@printthejurya[6]
		\UNL@printthejurya[7]
		\UNL@printthejurya[8]
		\UNL@printthejurya[9]
	\else
  		\typeout{^^J%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^^J%
!  Please identify at least one referee with the [a] argument ^^J%
!  of the "jury" macro.  See the template! ;)^^J%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^^J%
}
   		\errhelp{Please be gentle and follow the template recommendations.}
   		\errmessage{Please specify referees of the jury!}
	\fi
}

\def\UNL@printthejuryv[#1]{%
	\ifcsname @juryvname#1\endcsname
	\ifnum #1 = 1
		& \\[-2ex]
		Voga\ifnum \@thejuryvcount = 1 l\else is\fi:
	\fi
	& \expandafter\csname UNL@juryvname#1\endcsname\relax \\
	\fi
}

\def\printthejuryv{%
	\ifnum \UNL@thejuryvcount > 0
		\UNL@printthejuryv[1]
		\UNL@printthejuryv[2]
		\UNL@printthejuryv[3]
		\UNL@printthejuryv[4]
		\UNL@printthejuryv[5]
		\UNL@printthejuryv[6]
		\UNL@printthejuryv[7]
		\UNL@printthejuryv[8]
		\UNL@printthejuryv[9]
	\else
  		\typeout{^^J%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^^J%
!  Please identify at least one jury with the [v] argument ^^J%
!  of the "jury" macro.  See the template! ;)^^J%
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!^^J%
}
   		\errhelp{Please be gentle and follow the template recommendations.}
   		\errmessage{Please specify at least one element of the jury!}
	\fi
}

\def\printthejury{%
	\fontsize{11}{12}
	\selectfont
	\ctable[
		cap=,
		caption=,
		label=,
		pos=h,
		maxwidth=1\linewidth,
		right,
	]{rX}{}{
	& \UNL@jurystr: \\
 	\printthejuryp
	\printthejurya
	\printthejuryv
	}
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
		\equal{\UNL@doctype}{0}	% bsc
		\OR
		\equal{\UNL@doctype}{2}	% msc
		\OR
		\equal{\UNL@doctype}{5}	% phd
	}{% THEN
		\InputIfFileExists{Chapters/\@dedicatoryfile}{%
			% File glossary.tex exists and is read
			\global\let\@dedicatoryfile\@empty
			\clearemptydoublepage
		}{%
			% File glossary.tex is not found, ignore
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
		\equal{\UNL@doctype}{0}	% bsc
		\OR
		\equal{\UNL@doctype}{2}	% msc
		\OR
		\equal{\UNL@doctype}{5}	% phd
	}{% THEN
		\InputIfFileExists{Chapters/\@quotefile}{%
			% File glossary.tex exists and is read
			\global\let\@quotefile\@empty
			\clearemptydoublepage
		}{%
			% File glossary.tex is not found, ignore
		}	
	}{ % ELSE
	}
}
\fi


\def\acknowledgementsfile#1{%
  \gdef\@acknowledgementsfile{#1}}
\def\@acknowledgementsfile{\@empty}

\ifx\@acknowledgementsfile\@empty
\def\printacknowledgements{}
\else
\def\printacknowledgements{
	\ifthenelse{%
		\equal{\UNL@doctype}{0}	% bsc
		\OR
		\equal{\UNL@doctype}{2}	% msc
		\OR
		\equal{\UNL@doctype}{5}	% phd
	}{% THEN
		\InputIfFileExists{Chapters/\@acknowledgementsfile}{%
			% File glossary.tex exists and is read
			\global\let\@acknowledgementsfile\@empty
			\clearemptydoublepage
		}{%
			% File glossary.tex is not found, ignore
		}	
	}{ % ELSE
	}
}
\fi


\def\ptabstractfile#1{%
  \gdef\UNL@ptabstractfile{#1}}
\def\UNL@ptabstractfile{\@empty}
% \def\UNL@ptabstractfile{~ptabstractfile \@notdefined}

\def\enabstractfile#1{%
  \gdef\UNL@enabstractfile{#1}}
\def\UNL@enabstractfile{\@empty}
% \def\UNL@enabstractfile{~enabstractfile \@notdefined}

\if\UNL@lang0   % Sumário-PT + Abstract-EN para tese em Português
\def\UNL@ptabstractfile{~ptabstractfile \@notdefined}
\else\if\UNL@lang1   % Abstract-EN + Sumário-PT for thesis in English
\def\UNL@enabstractfile{~enabstractfile \@notdefined}
\fi\fi


\def\printabstract{%
	\if\UNL@lang0   % Sumário-PT + Abstract-EN para tese em Português
		\selectlanguage{portuguese}
		\@input@{Chapters/\UNL@ptabstractfile}\global\let\UNL@ptabstractfile\@empty
		\ifx\UNL@enabstractfile\@empty
		\else
			\selectlanguage{english}
			\@input@{Chapters/\UNL@enabstractfile}\global\let\UNL@enabstractfile\@empty
			\selectlanguage{portuguese}
		\fi
	\else\if\UNL@lang1   % Abstract-EN + Sumário-PT for thesis in English
		\selectlanguage{english}
		\@input@{Chapters/\UNL@enabstractfile}\global\let\UNL@enabstractfile\@empty
		\ifx\UNL@ptabstractfile\@empty
		\else
			\selectlanguage{portuguese}
			\@input@{Chapters/\UNL@ptabstractfile}\global\let\UNL@ptabstractfile\@empty
			\selectlanguage{english}
		\fi
	\fi\fi
	\clearemptydoublepage
}

\def\thesisfrontmatter{%
	\frontmatter
	% \pagestyle{fancy}
	\pagenumbering{roman} 
	% \fancyhead{}
	\setlength{\headheight}{15pt}
	% \fancyhead[RO,LE]{}
	\if\UNL@lang0   % Tese em Português
		\selectlanguage{portuguese}
	\else\if\UNL@lang1   % Thesis in English
		\selectlanguage{english}
	\fi\fi
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
	\if\UNL@lang0   % Tese em Português
		\selectlanguage{portuguese}
	\else\if\UNL@lang1   % Thesis in English
		\selectlanguage{english}
	\fi\fi
}

\def\endthesismainmatter{%
	% \fancyhead{}
	% \lhead{\nouppercase{\textsc{\leftmark}}}
	% \rhead{}
}


% Chapters
\newcount\@chapcount
\@chapcount 0\relax

\def\chapterfile#1{%
	\advance\@chapcount 1\relax
	\expandafter\gdef\csname UNL@chapterfile\number\@chapcount\endcsname{Chapters/#1}
}

\def\printchapthers{%
	\newcount\@myi
	\@myi 0\relax
	\loop
		\advance\@myi 1\relax
		\def\@chapname{\expandafter\csname UNL@chapterfile\number\@myi\endcsname}
		\if\UNL@bibbychapter1
			\begin{refsegment}
		\fi
		\@input@{\@chapname}
		\if\UNL@bibbychapter1
			\printbibliography[segment=\arabic{chapter},heading=subbibintoc]
			\end{refsegment}
		\fi
	\ifnum \@myi < \@chapcount
	\repeat
	\endthesismainmatter
}


% Appendixes
\newcount\@appxcount
\@appxcount 0\relax

\def\appendixfile#1{%
	\advance\@appxcount 1\relax
	\expandafter\gdef\csname UNL@appendixfile\number\@appxcount\endcsname{Chapters/#1}
}

\def\printappendixes{%	
	\appendix
	\newcount\@myi
	\@myi 0\relax
	\loop
		\advance\@myi 1\relax
		\def\@appxname{\expandafter\csname UNL@appendixfile\number\@myi\endcsname}
		\@input@{\@appxname}
	\ifnum \@myi < \@appxcount
	\repeat
}


\def\UNL@printlistoffigures{}
\def\printlistoffigures{%
  \gdef\UNL@printlistoffigures{\listoffigures\clearemptydoublepage}}

\def\UNL@printlistoftables{}
\def\printlistoftables{%
  \gdef\UNL@printlistoftables{\listoftables\clearemptydoublepage}}

\def\UNL@printlistoflistings{}
\def\printlistoflistings{%
  \gdef\UNL@printlistoflistings{\lstlistoflistings\clearemptydoublepage}}

\def\UNL@printglossary{}
\def\printglossary{%
  \gdef\UNL@printglossary{\printnoidxglossary[]\clearemptydoublepage}}

\def\printotherlists{%
	\clearemptydoublepage
	\UNL@printlistoffigures
	\UNL@printlistoftables
	\if\UNL@lang0   % Estamos a usar o Português
		\def\lstlistlistingname{Listagens}
	\fi
	\UNL@printlistoflistings
	\UNL@printglossary
}


\def\addbibfile#1{%
  \addbibresource{#1}}

\def\printbib{%
	\if\UNL@bibbychapter0
		\printbibliography
	\fi
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Frontpage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\frontpage{
\thispagestyle{empty}

\if\UNL@doctype0
	\def\@defcoverbg{\@thesiscovermsc}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=4.5cm,rmargin=3.3cm}
\else\if\UNL@doctype1
	\def\@defcoverbg{\@thesiscovermsc}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=4.5cm,rmargin=3.3cm}
\else\if\UNL@doctype2
	\def\@defcoverbg{\@thesiscovermsc}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=4.5cm,rmargin=3.3cm}
\else\if\UNL@doctype3
	\def\@defcoverbg{\@thesiscoverphd}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=5.5cm,rmargin=2.5cm}
\else\if\UNL@doctype4
	\def\@defcoverbg{\@thesiscoverphd}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=5.5cm,rmargin=2.5cm}
\else\if\UNL@doctype5
	\def\@defcoverbg{\@thesiscoverphd}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=5.5cm,rmargin=2.5cm}
\else
	\def\@defcoverbg{\@thesiscoverplain}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=4.5cm,rmargin=3.3cm}
\fi\fi\fi\fi\fi\fi
	
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
	\textbf{\@title}\\[0.75cm]

\vspace{0.75cm}
% Degree
	\fontsize{12}{13}
	\selectfont
	\@presentationtext
	
	\vfill
	% Advisers
	\fontsize{13}{14}
	\selectfont
	\ctable[
		cap=,
		caption=,
		label=,
		pos=h,
		maxwidth=1\linewidth,
	]{rX}{}{
		\printadviser[]{1}
		\printadviser[]{2}
		\printadviser[]{3}
		\printadviser[]{4}
		\printadviser[]{5}
		\printadviser[]{6}
		\printadviser[]{7}
		\printadviser[]{8}
		\printadviser[]{9}
		\printadviser[co]{1}
		\printadviser[co]{2}
		\printadviser[co]{3}
		\printadviser[co]{4}
		\printadviser[co]{5}
		\printadviser[co]{6}
		\printadviser[co]{7}
		\printadviser[co]{8}
		\printadviser[co]{9}
}


\vfill\vfill
% Referee board
\if\UNL@doctype0
\printthejury
\else\if\UNL@doctype1
\else\if\UNL@doctype2
\printthejury
\else\if\UNL@doctype3
\printthejury
\else\if\UNL@doctype4
\else\if\UNL@doctype5
\printthejury
\fi\fi\fi\fi\fi\fi

\vfill\vfill\vfill

% Date
\fontsize{12}{13}
\selectfont
\ifdraftdoc 
	% \RequirePackage[firstpage]{draftwatermark}				%Sets watermarks up.
	% \SetWatermarkScale{0.2}
	% \SetWatermarkLightness{0.75}
	% \SetWatermarkText{\textbf{Draft: \today}}
	% \SetWatermarkAngle{0.0}
	\textbf{DRAFT: \today}
\else
	\textbf{\@themonth, \@theyear}
\fi	
\end{center}
\restoregeometry
\clearemptydoublepage
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\printcopyrightpage{%
	\cleardoublepage
	\ 
	\vfill
	\noindent
	\textbf{\large \@title}

	\bigskip
	\thecopyrightstr
}

\def\printcopyright{
\if\UNL@doctype0
	\printcopyrightpage
\else\if\UNL@doctype1
\else\if\UNL@doctype2
	\printcopyrightpage
\else\if\UNL@doctype3
\else\if\UNL@doctype4
\else\if\UNL@doctype5
	\printcopyrightpage
\fi\fi\fi\fi\fi\fi}



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
  \chapter*{\acknowledgementsname}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Resumo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\abstractPT{%
  \selectlanguage{portuguese}
  \gdef\@keywordsname{\@keywordsnamePT}
  \chapter*{\UNL@abstrnamePT}
   \rule{\textwidth}{0.2mm} ~\\[-3.5ex]
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\abstractEN{%
  \selectlanguage{english}
  \gdef\@keywordsname{\@keywordsnameEN}
  \chapter*{\UNL@abstrnameEN}
  \rule{\textwidth}{0.2mm} ~\\[-3.5ex]
}
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@keywordsname{\@defaultkeywordsname}
\def\keywords{%
  \par\vskip\baselineskip\noindent{\bfseries\@keywordsname: }}
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
\newcommand{\clearemptydoublepage}{\newpage{\thispagestyle{empty}\cleardoublepage}}



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
\def\UNL@shortauthor{~shot~author \@notdefined}

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
		\@title\\[\UNL@thinkspineskip]
		\UNL@shortauthor
	\end{tabular}
}
\newlength\UNL@thick@spineheight
\setlength\UNL@thick@spineheight{\heightof{\usebox{\UNL@spine@thick}}}
\addtolength\UNL@thick@spineheight{\depthof{\usebox{\UNL@spine@thick}}}

% \newlength\UNL@thin@spineheight
% \newlength\UNL@thin@spinewidth
% \setlength\UNL@thin@spineheight{\heightof{\usebox{\UNL@spine@thin}}}
% \setlength\UNL@thin@spinewidth{\widthof{\usebox{\UNL@spine@thin}}}

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
				{\UNL@shortauthor & & \@title} 
		& & \vspace*{4pt}\includegraphics[origin=c,angle=-90,height=0.9\UNL@spinewidth]{logoUNL}
	\end{tabularx}
}}
\restoregeometry
\cleardoublepage
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Include acronym and glossary if files exsist
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add glossary / abbreviations
\InputIfFileExists{Chapters/acronyms}{%
  % File glossary.tex exists and is read
}{%
  % File glossary.tex is not found, ignore
}
\InputIfFileExists{Chapters/glossary}{%
  % File glossary.tex exists and is read
}{%
  % File glossary.tex is not found, ignore
}
