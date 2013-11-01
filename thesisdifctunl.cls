%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% thesisdifctunl.cls
%%% DI/FCT/UNL Dissertation document class
%%%
%%% By João Lourenço (joao.lourenco@di.fct.unl.pt)
%%% Version of February 2012
%%%
%%% This template is vaguely based on a template from the
%%%     University of Pernambuco
%%%
%%% BUGS and SUGGETSIONS: please send email to "joao.lourenco@fct.unl.pt"
%%%     or sumit a ticket in the the project web page at
%%%     http://code.google.com/p/thesisdifctunl/
%%%
%%% CONTRIBUTERS are welcome. Please contact "joao.lourenco@fct.unl.pt"
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesisdifctunl}[2011/11/10]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OPTIONS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% == Languages ===
\DeclareOption{pt}{%
  \let\@language=0%
  \PassOptionsToPackage{portuguese,english}{babel}}

\DeclareOption{en}{%
  \let\@language=1%
  \PassOptionsToPackage{portuguese,english}{babel}}

% == Printing ===
\DeclareOption{oneside}{%
  \PassOptionsToClass{oneside}{book}}

\DeclareOption{twoside}{%
  \PassOptionsToClass{twoside}{book}}

% == Paper type/format (dfault A4) ===
\PassOptionsToClass{a4paper}{book} % Default paper format

\DeclareOption{a4}{%
	\PassOptionsToClass{a4paper}{book}}

\DeclareOption{a4paper}{%
	\PassOptionsToClass{a4paper}{book}}

\DeclareOption{letter}{%
	\PassOptionsToClass{letterpaper}{book}}

\DeclareOption{letterpaper}{%
	\PassOptionsToClass{letterpaper}{book}}


% == Font Size ===
\PassOptionsToClass{11pt}{book} % Default point size

\DeclareOption{11pt}{%
	\PassOptionsToClass{11pt}{book}}

\DeclareOption{12pt}{%
	\PassOptionsToClass{12pt}{book}}


% == Text Encoding ===
\let\@utf=1
\DeclareOption{latin1}{\let\@utf=0}
\DeclareOption{utf8}{\let\@utf=1}


% == Type of Document ===
% \@degreetype=0	BSc report
% \@degreetype=1	MSc preliminary report
% \@degreetype=2	MSc dissertation
% \@degreetype=3	PhD proposal
% \@degreetype=4	PhD preliminary report
% \@degreetype=5	PhD thesis
\let\@degreetype=9
\DeclareOption{bsc}{
	\let\@degreetype=0
	\def\@degree{\@bachelordegree}
	\def\@dissertationtype{\@bscdissertationtstr}
}
\DeclareOption{prepmsc}{
	\let\@degreetype=1
	\def\@degree{\@mastersdegree}
	\def\@dissertationtype{\@prepmscdissertationtstr}
}
\DeclareOption{msc}{
	\let\@degreetype=2
	\def\@degree{\@mastersdegree}
	\def\@dissertationtype{\@mscdissertationtstr}
}
\DeclareOption{propphd}{
	\let\@degreetype=3
	\def\@degree{\@pdhdegree}
	\def\@dissertationtype{\@propphhdissertationtstr}
}
\DeclareOption{prepphd}{
	\let\@degreetype=4
	\def\@degree{\@pdhdegree}
	\def\@dissertationtype{\@prepphhdissertationtstr}
}
\DeclareOption{phd}{
	\let\@degreetype=5
	\def\@degree{\@pdhdegree}
	\def\@dissertationtype{\@phhdissertationtstr}
}

% == bibbychapter ===
\let\@bibbychapter=0
\DeclareOption{bibbychapter}{
	\let\@bibbychapter=1	
}


% == Default Options ===
\ExecuteOptions{en,msc}
\ProcessOptions

\LoadClass{book}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PACKAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Latin1
\if\@utf0
\RequirePackage[latin1]{inputenc}
% UTF8
\else\if\@utf1
\RequirePackage[utf8]{inputenc}
\fi\fi



\RequirePackage[T1]{fontenc}

% \RequirePackage{amsmath,amsfonts,amssymb,amsthm}

\RequirePackage{csquotes}
\RequirePackage{babel}

\RequirePackage[toc]{appendix}

% \RequirePackage{tabularx}

\RequirePackage{ifthen}

\RequirePackage{titlesec}           % To format the headings
\RequirePackage{fancyhdr}           % Headings configuration

% Set inter-line spacing
\RequirePackage{setspace}           % One-and-half spacing
\onehalfspacing

%\RequirePackage{mathptmx}
\RequirePackage[scaled]{helvet}
\RequirePackage{courier}
\RequirePackage{palatino}

\usepackage{ifpdf}		% This is now the recommended way for checking for PDFLaTeX:
\ifpdf
\RequirePackage[pdftex]{graphicx}
\DeclareGraphicsExtensions{.pdf, .png, .jpg, .tif}
\RequirePackage[pdftex,usenames]{color}
\definecolor{mydarkblue}{rgb}{0.0,0.08,0.45}
\RequirePackage[pdftex,breaklinks,colorlinks,pdfdisplaydoctitle,citecolor=mydarkblue,linkcolor=mydarkblue,urlcolor=mydarkblue]{hyperref}
\else
\RequirePackage{graphicx}
\DeclareGraphicsExtensions{.eps, .png, .jpg}
\RequirePackage[usenames]{color}
\definecolor{mydarkblue}{rgb}{0.0,0.08,0.45}
\RequirePackage[breaklinks,colorlinks,pdfdisplaydoctitle,citecolor=mydarkblue,linkcolor=mydarkblue,urlcolor=mydarkblue]{hyperref}
\fi

% \definecolor{myblue}{rgb}{0.39,0.69,1}
% \definecolor{myyellow}{rgb}{0.95,0.93,0.78}

\RequirePackage[top=3cm,bottom=3cm,inner=3.5cm,outer=2.5cm]{geometry}[2010/02/12]
% \setlength{\marginparwidth}{2cm}


% AAdd an image to the backgroung
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


\RequirePackage{ctable}

\RequirePackage[%
	backend=bibtex,
	sorting=nyt,%
	style=alphabetic,%
% labelyear=false,%
	defernumbers=true,%
	maxnames=20,%
	firstinits=true,%
	uniquename=init,%
% dashed=false,%
% sortcites=true,
	]{biblatex}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \let\origcleardoublepage=\cleardoublepage
% \def\cleardoublepage{%
%   \newpage{\pagestyle{empty}\origcleardoublepage}
% }

%%
% For use with the pseudocode package
% \def\@lopcchapterspace{\relax}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Some relevant strings

\gdef\@singlemadviserstr{Orientador}
\gdef\@singlefadviserstr{Orientadora}
\gdef\@manymadviserstr{Orientadores}
\gdef\@manyfadviserstr{Orientadoras}
\gdef\@singlemcoadviserstr{Co-orientador}
\gdef\@singlefcoadviserstr{Co-orientadora}
\gdef\@manymcoadviserstr{Co-orientadores}
\gdef\@manyfcoadviserstr{Co-orientadoras}

\gdef\@mbachelordegreestr{Licenciado}
\gdef\@fbachelordegreestr{Licenciada}
\gdef\@mmastersdegreestr{Mestre}
\gdef\@fmastersdegreestr{Mestre}
\gdef\@mphddegreestr{Doutor}
\gdef\@fphddegreestr{Doutora}

% \gdef\doutor{Dr.\ }
% \gdef\doutora{Drª.\ }
% \gdef\profdoutor{Prof.\ Dr.\ }
% \gdef\profdoutora{Profª.\ Drª.\ }

\gdef\@bachelordissertationstr{Trabalho de Licenciatura}
\gdef\@mastersdissertationstr{Dissertação de Mestrado}
\gdef\@mastersqualifyingstr{Preparação de Dissertação}
\gdef\@phdqualifyingstr{Preparação de Tese}
\gdef\@phdproposalstr{Proposta de Tese de Doutoramento}
\gdef\@phdthesisstr{Tese de Doutoramento}

\gdef\@jurystr{Júri}

\gdef\@bscdissertationtstr{Relatório para obtenção do Grau 
de\@degree em\\\@majorfield}
\gdef\@prepmscdissertationtstr{Relatório intermédio para obtenção do Grau 
de\@degree em\\\@majorfield}
\gdef\@mscdissertationtstr{Dissertação para obtenção do Grau 
de\@degree em\\\@majorfield}
\gdef\@propphhdissertationtstr{Proposta de tese para obtenção do Grau 
de \@degree em\\\@majorfield}
\gdef\@prepphhdissertationtstr{Relatório intermédio para obtenção do Grau de\@degree em\\\@majorfield}
\gdef\@phhdissertationtstr{Dissertação para obtenção do Grau 
de\@degree em\\\@majorfield}

\gdef\@presentationtext{\@dissertationtype}

\gdef\thecopyrightstr{%
\noindent
Copyright \copyright\ \@author, \@faculty, \@university

\bigskip
\noindent
A \@faculty\ e a \@university\ têm o direito, perpétuo e sem limites geográficos, de arquivar e publicar esta dissertação através de exemplares impressos reproduzidos em papel ou de forma digital, ou por qualquer outro meio conhecido ou que venha a ser inventado, e de a divulgar através de repositórios científicos e de admitir a sua cópia e distribuição com objectivos educacionais ou de investigação, não comerciais, desde que seja dado crédito ao autor e editor.}

%% Language dependent

\gdef\@abstrnamePT{Resumo}
\gdef\@abstrnameEN{Abstract}

\gdef\@keywordsnamePT{Palavras-chave}
\gdef\@keywordsnameEN{Keywords}


%% Language Dependent

% Portuguese
\if\@language0
  \gdef\@notdefined{NÃO DEFINIDO}
  \gdef\acknowledgementsname{Agradecimentos}
  \def\lstlistlistingname{Listagens}
% English
\else\if\@language1
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
\newcount\@theadvisercount	% number of advisers
\@theadvisercount 0\relax
\def\@thecoadvisergender{f}	% default for female co-advisers
\newcount\@thecoadvisercount	% number of co-advisers
\@thecoadvisercount 0\relax

% 
% \newcount\@myi
% \@myi 0\relax
% \loop
% 	\advance\@myi 1\relax
% 	\expandafter\let\csname @showadviser\number\@myi\endcsname=0
% 	\expandafter\let\csname @showcoadviser\number\@myi\endcsname=0
% \ifnum \@myi < 10
% \repeat

% \repeat \for{i} \from{1} \to{9} \do {
% 	\expandafter\let\csname @showadviser\number\i\endcsname=0
% 	\expandafter\let\csname @showcoadviser\number\i\endcsname=0
% 	\expandafter\let\csname @showjury\number\i\endcsname=0
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
  \expandafter\advance\csname @the#1advisercount\endcsname 1\relax
  \ifx#2m
  	\expandafter\def\csname @the#1advisergender\endcsname{m}
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
  \expandafter\gdef\csname @#1advisername\expandafter\number\csname @the#1advisercount\endcsname\endcsname{#3}
  \expandafter\gdef\csname @#1advisercat\expandafter\number\csname @the#1advisercount\endcsname\endcsname{#4}
  \expandafter\gdef\csname @#1adviserschool\expandafter\number\csname @the#1advisercount\endcsname\endcsname{#5}
}

\def\@theadviserstr[#1]{%
	\@ptheadviserstr[#1]{\expandafter\csname @the#1advisercount\endcsname}{\expandafter\csname @the#1advisergender\endcsname}
}

\def\@ptheadviserstr[#1]#2#3{%
	\ifnum #2 > 1
  		\expandafter\csname @many#3#1adviserstr\endcsname
	\else
  		\expandafter\csname @single#3#1adviserstr\endcsname
	\fi
}

\def\printadviser[#1]#2{%
	\ifcsname @#1advisername#2\endcsname
		\ifnum #2 = 1
			& \\[-2ex]
			\@theadviserstr[#1]:
		\fi
		&
		\expandafter\csname @#1advisername#2\endcsname,
		\expandafter\csname @#1advisercat#2\endcsname,
		\expandafter\csname @#1adviserschool#2\endcsname
	\\
	\fi
}




%% Work identification

\def\title#1{%
  \gdef\@title{#1}
  \hypersetup{pdftitle={\@title}}}
\def\@title{~title \@notdefined}

\def\@texttype{%
  \if\@degreetype0
    \@bachelordissertationstr
  \else\if\@degreetype1
    \@mastersqualifyingstr
  \else\if\@degreetype2
  \@mastersdissertationstr
  \else\if\@degreetype3
    \@phdproposalstr
  \else\if\@degreetype4
   \@phdqualifyingstr
   \else\if\@degreetype5
    \@phdthesisstr
  \fi\fi\fi\fi\fi\fi}

\def\thedegree#1#2{%
	\expandafter\csname @#1#2\endcsname}

\def\@degree{%
  \if\@degreetype0
    \thedegree{\ader}{bachelordegreestr}
  \else\if\@degreetype1
    \thedegree{\authorgender}{mastersdegreestr}
  \else\if\@degreetype2
    \thedegree{\authorgender}{mastersdegreestr}
  \else\if\@degreetype3
    \thedegree{\authorgender}{phddegreestr}
  \else\if\@degreetype4
    \thedegree{\authorgender}{phddegreestr}
   \else\if\@degreetype5
    \thedegree{\authorgender}{phddegreestr}
  \fi\fi\fi\fi\fi\fi}



% Juri
\newcount\@thejurypcount	% number of presidents (must be one)
\@thejurypcount 0\relax
\newcount\@thejuryacount	% number of referees
\@thejuryacount 0\relax
\newcount\@thejuryvcount	% number of other memebrs of the jury
\@thejuryvcount 0\relax

\def\jury{%
  \@ifnextchar [%
    {\@pjury}%
    {\@pjury[v]}}


% #1 = [p] for president, [a] for referee, [v] for others
% #2 = {name}
\def\@pjury[#1]#2{%
	\expandafter\advance\csname @thejury#1count\endcsname 1\relax
  	\expandafter\gdef\csname @jury#1name\expandafter\number\csname @thejury#1count\endcsname\endcsname{#2}
}

\def\printthejuryp{%
	\ifnum \@thejurypcount = 1
		& \\[-2ex]
		Presidente: & \csname @jurypname1\endcsname \\
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

\def\@printthejurya[#1]{%
	\ifcsname @juryaname#1\endcsname
	\ifnum #1 = 1
		& \\[-2ex]
		Arguente\ifnum \@thejuryacount > 1 s\fi:
	\fi
	& \expandafter\csname @juryaname#1\endcsname\relax \\
	\fi
}

\def\printthejurya{%
	\ifnum \@thejuryacount > 0
		\@printthejurya[1]
		\@printthejurya[2]
		\@printthejurya[3]
		\@printthejurya[4]
		\@printthejurya[5]
		\@printthejurya[6]
		\@printthejurya[7]
		\@printthejurya[8]
		\@printthejurya[9]
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

\def\@printthejuryv[#1]{%
	\ifcsname @juryvname#1\endcsname
	\ifnum #1 = 1
		& \\[-2ex]
		Voga\ifnum \@thejuryvcount = 1 l\else is\fi:
	\fi
	& \expandafter\csname @juryvname#1\endcsname\relax \\
	\fi
}

\def\printthejuryv{%
	\ifnum \@thejuryvcount > 0
		\@printthejuryv[1]
		\@printthejuryv[2]
		\@printthejuryv[3]
		\@printthejuryv[4]
		\@printthejuryv[5]
		\@printthejuryv[6]
		\@printthejuryv[7]
		\@printthejuryv[8]
		\@printthejuryv[9]
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
	& \@jurystr: \\
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
\newcommand\quotefonti{\it\normalsize}

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
	\if\@degreetype0
		\@input@{Chapters/\@dedicatoryfile}\global\let\@dedicatoryfile\@empty
	\else\if\@degreetype1
	\else\if\@degreetype2
		\@input@{Chapters/\@dedicatoryfile}\global\let\@dedicatoryfile\@empty
	\else\if\@degreetype3
	\else\if\@degreetype4
	\else\if\@degreetype5
		\@input@{Chapters/\@dedicatoryfile}\global\let\@dedicatoryfile\@empty
	\fi\fi\fi\fi\fi\fi
}
\fi


\def\quotefile#1{%
  \gdef\@quotefile{#1}}
\def\@quotefile{\@empty}

\ifx\@quotefile\@empty
\def\printquote{}
\else
\def\printquote{
	\if\@degreetype0
		\@input@{Chapters/\@quotefile}\global\let\@quotefile\@empty
	\else\if\@degreetype1
	\else\if\@degreetype2
		\@input@{Chapters/\@quotefile}\global\let\@quotefile\@empty
	\else\if\@degreetype3
	\else\if\@degreetype4
	\else\if\@degreetype5
		\@input@{Chapters/\@quotefile}\global\let\@quotefile\@empty
	\fi\fi\fi\fi\fi\fi
}
\fi

\def\acknowledgementsfile#1{%
  \gdef\@acknowledgementsfile{#1}}
\def\@acknowledgementsfile{~acknowledgementsfile \@notdefined}

\def\printacknowledgements{
	\if\@degreetype0
		\@input@{Chapters/\@acknowledgementsfile}\global\let\@acknowledgementsfile\@empty
	\else\if\@degreetype1
	\else\if\@degreetype2
		\@input@{Chapters/\@acknowledgementsfile}\global\let\@acknowledgementsfile\@empty
	\else\if\@degreetype3
	\else\if\@degreetype4
	\else\if\@degreetype5
		\@input@{Chapters/\@acknowledgementsfile}\global\let\@acknowledgementsfile\@empty
	\fi\fi\fi\fi\fi\fi
}

\def\ptabstractfile#1{%
  \gdef\@ptabstractfile{#1}}
\def\@ptabstractfile{\@empty}
% \def\@ptabstractfile{~ptabstractfile \@notdefined}

\def\enabstractfile#1{%
  \gdef\@enabstractfile{#1}}
\def\@enabstractfile{\@empty}
% \def\@enabstractfile{~enabstractfile \@notdefined}

\if\@language0   % Sumário-PT + Abstract-EN para tese em Português
\def\@ptabstractfile{~ptabstractfile \@notdefined}
\else\if\@language1   % Abstract-EN + Sumário-PT for thesis in English
\def\@enabstractfile{~enabstractfile \@notdefined}
\fi\fi


\def\printabstract{%
	\if\@language0   % Sumário-PT + Abstract-EN para tese em Português
		\selectlanguage{portuguese}
		\@input@{Chapters/\@ptabstractfile}\global\let\@ptabstractfile\@empty
		\ifx\@enabstractfile\@empty
		\else
			\selectlanguage{english}
			\@input@{Chapters/\@enabstractfile}\global\let\@enabstractfile\@empty
			\selectlanguage{portuguese}
		\fi
	\else\if\@language1   % Abstract-EN + Sumário-PT for thesis in English
		\selectlanguage{english}
		\@input@{Chapters/\@enabstractfile}\global\let\@enabstractfile\@empty
		\ifx\@ptabstractfile\@empty
		\else
			\selectlanguage{portuguese}
			\@input@{Chapters/\@ptabstractfile}\global\let\@ptabstractfile\@empty
			\selectlanguage{english}
		\fi
	\fi\fi
}

\def\thesismainmatter{%
	\mainmatter
	\pagestyle{fancy}
	\fancyhead{}
	\setlength{\headheight}{15pt}
	\fancyhead[RO,LE]{\leftmark\hfill\rightmark}
	\def\chaptermark##1{\markboth{\fontfamily{phv}%
		\selectfont\footnotesize\thechapter.\ \textsc{##1}}{}}
	\def\sectionmark##1{\markright{\fontfamily{phv}%
	 	\selectfont\footnotesize\thesection.\ ##1}}
	\if\@language0   % Tese em Português
		\selectlanguage{portuguese}
	\else\if\@language1   % Thesis in English
		\selectlanguage{english}
	\fi\fi
}

\def\endthesismainmatter{%
	\fancyhead{}
	\lhead{\nouppercase{\textsc{\leftmark}}}
	\rhead{}
}


% Chapters
\newcount\@chapcount
\@chapcount 0\relax

\def\chapterfile#1{%
	\advance\@chapcount 1\relax
	\expandafter\gdef\csname @chapterfile\number\@chapcount\endcsname{Chapters/#1}
}

\def\printchapthers{%
	\thesismainmatter
	\newcount\@myi
	\@myi 0\relax
	\loop
		\advance\@myi 1\relax
		\def\@chapname{\expandafter\csname @chapterfile\number\@myi\endcsname}
		\if\@bibbychapter1
			\begin{refsegment}
		\fi
		\@input@{\@chapname}
		\if\@bibbychapter1
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
	\expandafter\gdef\csname @appendixfile\number\@appxcount\endcsname{Chapters/#1}
}

\def\printappendixes{%	
	\appendix
	\newcount\@myi
	\@myi 0\relax
	\loop
		\advance\@myi 1\relax
		\def\@appxname{\expandafter\csname @appendixfile\number\@myi\endcsname}
		\@input@{\@appxname}
	\ifnum \@myi < \@appxcount
	\repeat
}


\def\printlistoffigures{%
  \gdef\@printlistoffigures{\listoffigures}}
\def\@printlistoffigures{}

\def\printlistoftables{%
  \gdef\@printlistoftables{\listoftables}}
\def\@printlistoftables{}

\def\printlistoflistings{%
  \gdef\@printlistoflistings{\lstlistoflistings}}
\def\@printlistoflistings{}

\def\printotherlists{%
	\@printlistoffigures
	\@printlistoftables
	\if\@language0   % Estamos a usar o Português
		\def\lstlistlistingname{Listagens}
	\fi
	\@printlistoflistings
}


\def\addbibfile#1{%
  \addbibresource{#1}}

\def\printbib{%
	\if\@bibbychapter0
		\printbibliography
	\fi
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Frontpage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\frontpage{
\thispagestyle{empty}

\if\@degreetype0
	\def\@defcoverbg{\@thesiscovermsc}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=4.5cm,rmargin=3.3cm}
\else\if\@degreetype1
	\def\@defcoverbg{\@thesiscovermsc}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=4.5cm,rmargin=3.3cm}
\else\if\@degreetype2
	\def\@defcoverbg{\@thesiscovermsc}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=4.5cm,rmargin=3.3cm}
\else\if\@degreetype3
	\def\@defcoverbg{\@thesiscoverphd}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=5.5cm,rmargin=2.5cm}
\else\if\@degreetype4
	\def\@defcoverbg{\@thesiscoverphd}
	\newgeometry{tmargin=4cm,bmargin=1.3cm,lmargin=5.5cm,rmargin=2.5cm}
\else\if\@degreetype5
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
\if\@degreetype0
\printthejury
\else\if\@degreetype1
\else\if\@degreetype2
\printthejury
\else\if\@degreetype3
\printthejury
\else\if\@degreetype4
\else\if\@degreetype5
\printthejury
\fi\fi\fi\fi\fi\fi

\vfill\vfill\vfill

% Date
\fontsize{12}{13}
\selectfont
\textbf{\@themonth, \@theyear}
	
\end{center}
\restoregeometry
\newpage
\thispagestyle{empty}
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
\if\@degreetype0
	\printcopyrightpage
\else\if\@degreetype1
\else\if\@degreetype2
	\printcopyrightpage
\else\if\@degreetype3
\else\if\@degreetype4
\else\if\@degreetype5
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
  \chapter*{\@abstrnamePT}
   \rule{\textwidth}{0.2mm} ~\\[-3.5ex]
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\abstractEN{%
  \selectlanguage{english}
  \gdef\@keywordsname{\@keywordsnameEN}
  \chapter*{\@abstrnameEN}
  \rule{\textwidth}{0.2mm} ~\\[-3.5ex]
}
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@keywordsname{\@defaultkeywordsname}
\def\keywords{%
  \par\vskip\baselineskip\noindent{\bf\@keywordsname: }}
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

\setcounter{secnumdepth}{3}

\definecolor{backGrayColor}{rgb}{0.7,0.7,0.7} % Background title color



\titleformat{\chapter}[display]
{\bfseries\Huge}				% format
{\hfill\colorbox{backGrayColor}{\fontsize{100}{120}\selectfont{\textcolor{white}{\thechapter}}}} % label
{1ex}							% sep
{%\titlerule
  \vspace{2ex}\filleft}			% before
%\colorbox{backGrayColor}{}
[\vspace{1cm}					%\titlerule
]


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

