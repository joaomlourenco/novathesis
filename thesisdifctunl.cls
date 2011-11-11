%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% thesisdifctunl.cls
%%% DI/FCT/UNL Dissertation document class
%%%
%%% Version 2.0 (November 2011)
%%% By João Lourenço (joao.lourenco@di.fct.unl.pt)
%%%
%%% This template is vaguely based on a template from the
%%%     University of Pernambuco
%%%
%%% BUGS and SUGGETSIONS: please send email to "joao.lourenco@di.fct.unl.pt"
%%%     or sumit a ticket in the the project web page at
%%%     http://code.google.com/p/thesisdifctunl/
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

\RequirePackage{babel}


\RequirePackage{tabularx}

\RequirePackage{titlesec}           % To format the headings
\RequirePackage{fancyhdr}           % Headings configuration

% Set inter-line spacing
\usepackage{setspace}           % One-and-half spacing
\onehalfspacing

%\RequirePackage{mathptmx}
\RequirePackage[scaled=0.9]{helvet}
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

%% Language Independent

\gdef\@maleadviserstr{Orientador}
\gdef\@femaleadviserstr{Orientadora}
\gdef\@malecoadviserstr{Co-orientador}
\gdef\@femalecoadviserstr{Co-orientadora}

\gdef\@bachelordissertation{Trabalho de Licenciatura}
\gdef\@mastersdissertation{Dissertação de Mestrado}
\gdef\@mastersqualifying{Preparação de Dissertação}
\gdef\@phdqualifying{Preparação de Tese}
\gdef\@phdproposal{Proposta de Tese de Doutoramento}
\gdef\@phdthesis{Tese de Doutoramento}

\gdef\@bachelordegree{Licenciado}
\gdef\@mastersdegree{Mestre}
\gdef\@phddegree{Doutor}

\gdef\@maleprofdout{Prof.\ Doutor}
\gdef\@femaleprofdout{Profª.\ Doutora}

\gdef\@bscdissertationtstr{Relatório para obtenção do Grau de \@degree\ em\\\@majorfield}
\gdef\@prepmscdissertationtstr{Relatório intermédio para obtenção do Grau de \@degree\ em\\\@majorfield}
\gdef\@mscdissertationtstr{Dissertação para obtenção do Grau de \@degree\ em\\\@majorfield}
\gdef\@propphhdissertationtstr{Proposta de tese para obtenção do Grau de \@degree\ em\\\@majorfield}
\gdef\@prepphhdissertationtstr{Relatório intermédio para obtenção do Grau de \@degree\ em\\\@majorfield}
\gdef\@phhdissertationtstr{Dissertação para obtenção do Grau de \@degree\ em\\\@majorfield}


\gdef\@presentationtext{\@dissertationtype}


\gdef\@jurystr{Júri}


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

\@input@{repeat}

\@input@{defaults}


%% Date

\def\themonth#1{\gdef\@themonth{#1}}
\def\@themonth{~themonth \@notdefined}

\def\theyear#1{\gdef\@theyear{#1}}
\def\@theyear{~theyear \@notdefined}


%% Authors identification
\def\author#1{%
  \gdef\@author{#1}
  \hypersetup{pdfauthor={\@author}}}
\def\@author{~author \@notdefined}

\def\authordegree#1{%
  \gdef\@authordegree{#1}}
\def\@authordegree{~authordegree \@notdefined}


%% Advisors and Co-Advisers identification (at most 9 of each)
%% \adviser[N][m|f]{Name}
%% where N i a number from 1 to 9
\repeat \for{i} \from{1} \to{9} \do {
	\expandafter\let\csname @showadviser\number\i\endcsname=0
	\expandafter\let\csname @showcoadviser\number\i\endcsname=0
	\expandafter\let\csname @showjury\number\i\endcsname=0
}

\def\adviser[#1]{%
  \@ifnextchar [%
    {\@padviser[#1]}%
    {\@padviser[#1][m]}}

\def\@padviser[#1][#2]#3{%
  \if#2m
    \expandafter\gdef\csname @adviserstr#1\endcsname{\@maleadviserstr}
	\expandafter\gdef\csname @advisertitle#1\endcsname{\@maleprofdout}
  \else\if#2f
    \expandafter\gdef\csname @adviserstr#1\endcsname{\@femaleadviserstr}
	\expandafter\gdef\csname @advisertitle#1\endcsname{\@femaleprofdout}
  \else
    \ClassError{thesisdifctunl}{Wrong gender in adviser}{Gender must be "m" (male) of "f" (female)}
  \fi\fi
  \expandafter\gdef\csname @adviser#1\endcsname{#3}
  \expandafter\let\csname @showadviser#1\endcsname=1
}

\def\coadviser[#1]{%
  \@ifnextchar [%
    {\@pcoadviser[#1]}%
    {\@pcoadviser[#1][m]}}

\def\@pcoadviser[#1][#2]#3{%
  \if#2m
    \expandafter\gdef\csname @coadviserstr#1\endcsname{\@malecoadviserstr}
	\expandafter\gdef\csname @coadvisertitle#1\endcsname{\@maleprofdout}
  \else\if#2f
    \expandafter\gdef\csname @coadviserstr#1\endcsname{\@femalecoadviserstr}
	\expandafter\gdef\csname @coadvisertitle#1\endcsname{\@femaleprofdout}
  \else
    \ClassError{thesisdifctunl}{Wrong gender in coadviser}{Gender must be "m" (male) of "f" (female)}
  \fi\fi
  \expandafter\gdef\csname @coadviser#1\endcsname{#3}
  \expandafter\let\csname @showcoadviser#1\endcsname=1
}


%% Work identification

\def\title#1{%
  \gdef\@title{#1}
  \hypersetup{pdftitle={\@title}}}
\def\@title{~title \@notdefined}

\def\@texttype{%
  \if\@degreetype0
    \@bachelordissertation
  \else\if\@degreetype1
    \@mastersqualifying
  \else\if\@degreetype2
  \@mastersdissertation 
  \else\if\@degreetype3
    \@phdproposal
  \else\if\@degreetype4
   \@phdqualifying
   \else\if\@degreetype5
    \@phdthesis
  \fi\fi\fi\fi\fi\fi}

\def\@degree{%
  \if\@degreetype0
    \@bachelordegree
  \else\if\@degreetype1
    \@mastersdegree
  \else\if\@degreetype2
    \@mastersdegree
  \else\if\@degreetype3
    \@phddegree
  \else\if\@degreetype4
    \@phddegree
   \else\if\@degreetype5
    \@phddegree
  \fi\fi\fi\fi\fi\fi}


% Juri
\def\jury[#1]{%
  \@ifnextchar [%
    {\@pjury[#1]}%
    {\@pjury[#1][m]}}

\def\@pjury[#1][#2]#3{%
  \if#2m
	\expandafter\gdef\csname @jurytitle#1\endcsname{\@maleprofdout}
  \else\if#2f
	\expandafter\gdef\csname @jurytitle#1\endcsname{\@femaleprofdout}
  \else
    \ClassError{thesisdifctunl}{Wrong gender in jury member #1}{Gender must be "m" (male) of "f" (female)}
  \fi\fi
  \expandafter\gdef\csname @juryname#1\endcsname{#3}
  \expandafter\let\csname @showjury#1\endcsname=1
}




\def\printconditionaladv#1#2{
	\if\csname @show#1#2\endcsname1\csname @#1str#2\endcsname: & \csname @#1title#2\endcsname\ \csname @#1#2\endcsname\\\fi
}

\def\printconditionaljury#1#2#3{
	\if\csname @show#2#3\endcsname1 #1 & \csname @#2title#3\endcsname\ \csname @#2name#3\endcsname\\\fi
}

\def\printthejury{%
\fontsize{10}{12}
\selectfont
\hfill\begin{tabular}{rl}
	& \@jurystr:\\
	& \\[-2ex]
	\printconditionaljury{Presidente:}{jury}{1}
	& \\[-2ex]
	\printconditionaljury{Arguentes:}{jury}{2}
	\printconditionaljury{}{jury}{3}
	& \\[-2ex]
	\printconditionaljury{Vogais:}{jury}{4}
	\printconditionaljury{}{jury}{5}
	\printconditionaljury{}{jury}{6}
	\printconditionaljury{}{jury}{7}
	\printconditionaljury{}{jury}{8}
	\printconditionaljury{}{jury}{9}
\end{tabular}
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
\def\@quotefile{}

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
\def\@ptabstractfile{~ptabstractfile \@notdefined}

\def\enabstractfile#1{%
  \gdef\@enabstractfile{#1}}
\def\@enabstractfile{~enabstractfile \@notdefined}

\def\printabstract{%
	\if\@language0   % Sumário-PT + Abstract-EN para tese em Português
		\selectlanguage{portuguese}
		\@input@{Chapters/\@ptabstractfile}\global\let\@ptabstractfile\@empty
		\selectlanguage{english}
		\@input@{Chapters/\@enabstractfile}\global\let\@enabstractfile\@empty
		\selectlanguage{portuguese}
	\else\if\@language1   % Abstract-EN + Sumário-PT for thesis in English
		\selectlanguage{english}
		\@input@{Chapters/\@enabstractfile}\global\let\@enabstractfile\@empty
		\selectlanguage{portuguese}
		\@input@{Chapters/\@ptabstractfile}\global\let\@ptabstractfile\@empty
		\selectlanguage{english}
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


% Print Chapters
\def\chapterfile[#1]#2{%
	\ifnum #1=1\gdef\printchapterfileone{\thesismainmatter\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=2\gdef\printchapterfiletwo{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=3\def\printchapterfilethree{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=4\gdef\printchapterfilefour{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=5\gdef\printchapterfilefive{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=6\gdef\printchapterfilesix{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=7\gdef\printchapterfileseven{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=8\gdef\printchapterfileeight{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=9\gdef\printchapterfilenine{\noexpand{\@input@{Chapters/#2}}}\fi
}

\def\printchapterfileone{}
\def\printchapterfiletwo{}
\def\printchapterfilethree{}
\def\printchapterfilefour{}
\def\printchapterfilefive{}
\def\printchapterfilesix{}
\def\printchapterfileseven{}
\def\printchapterfileeight{}
\def\printchapterfilenine{}

\def\printchapters{%
	\printchapterfileone
	\printchapterfiletwo
	\printchapterfilethree
	\printchapterfilefour
	\printchapterfilefive
	\printchapterfilesix
	\printchapterfileseven
	\printchapterfileeight
	\printchapterfilenine
	\endthesismainmatter
}

\def\appendixfile[#1]#2{%
	\ifnum #1=1\gdef\printappendixfileone{\noexpand{\appendix\@input@{Chapters/#2}}}\fi
	\ifnum #1=2\gdef\printappendixfiletwo{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=3\def\printappendixfilethree{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=4\gdef\printappendixfilefour{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=5\gdef\printappendixfilefive{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=6\gdef\printappendixfilesix{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=7\gdef\printappendixfileseven{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=8\gdef\printappendixfileeight{\noexpand{\@input@{Chapters/#2}}}\fi
	\ifnum #1=9\gdef\printappendixfilenine{\noexpand{\@input@{Chapters/#2}}}\fi
}

\def\printappendixfileone{}
\def\printappendixfiletwo{}
\def\printappendixfilethree{}
\def\printappendixfilefour{}
\def\printappendixfilefive{}
\def\printappendixfilesix{}
\def\printappendixfileseven{}
\def\printappendixfileeight{}
\def\printappendixfilenine{}

\def\printappendixes{%
	\printappendixfileone
	\printappendixfiletwo
	\printappendixfilethree
	\printappendixfilefour
	\printappendixfilefive
	\printappendixfilesix
	\printappendixfileseven
	\printappendixfileeight
	\printappendixfilenine
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
	% \if\@language0   % Estamos a usar o Português
	% 	\def\lstlistlistingname{Listagens}
	% \fi
	\@printlistoflistings
}

\def\bibliographyfile#1{%
  \gdef\@bibliographyfile{#1}}
\def\@bibliographyfile{~bibliographyfile \@notdefined}

\def\printbibliography{%
	\if\@language0   % Bibliografia em Português
		\bibliographystyle{alpha-pt}
	\else\if\@language1   % Bibliography in English
		\bibliographystyle{alpha}
	\fi\fi
	\bibliography{./\@bibliographyfile}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Frontpage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\frontpage}{
\thispagestyle{empty}

\if\@degreetype0
	\def\@defcoverbg{\@thesiscovermsc}
	\newgeometry{tmargin=4cm,bmargin=2cm,lmargin=4.5cm,rmargin=3.5cm}
\else\if\@degreetype1
	\def\@defcoverbg{\@thesiscovermsc}
	\newgeometry{tmargin=4cm,bmargin=2cm,lmargin=4.5cm,rmargin=3.5cm}
\else\if\@degreetype2
	\def\@defcoverbg{\@thesiscovermsc}
	\newgeometry{tmargin=4cm,bmargin=2cm,lmargin=4.5cm,rmargin=3.5cm}
\else\if\@degreetype3
	\def\@defcoverbg{\@thesiscoverphd}
	\newgeometry{tmargin=4cm,bmargin=2cm,lmargin=5.5cm,rmargin=2.5cm}
\else\if\@degreetype4
	\def\@defcoverbg{\@thesiscoverphd}
	\newgeometry{tmargin=4cm,bmargin=2cm,lmargin=5.5cm,rmargin=2.5cm}
\else\if\@degreetype5
	\def\@defcoverbg{\@thesiscoverphd}
	\newgeometry{tmargin=4cm,bmargin=2cm,lmargin=5.5cm,rmargin=2.5cm}
\else
	\def\@defcoverbg{\@thesiscoverplain}
	\newgeometry{tmargin=4cm,bmargin=2cm,lmargin=5.5cm,rmargin=4.5cm}
\fi\fi\fi\fi\fi\fi
	
\AddToShipoutPicture*{\BackgroundPic{\@defcoverbg}}

\begin{center}
	\fontfamily{phv}

% Name of Candidate
	\fontsize{14}{17}
	\selectfont
	\textbf{\@author}
	
\vspace{0.5cm}	
% Academic qualifications
	\fontsize{11}{12}
	\selectfont
	\@authordegree

\vfill\vfill
% Title of Dissertation
	\fontsize{16}{19}
	\selectfont
	\textbf{\@title}\\[0.75cm]

\vspace{0.75cm}
% Academic qualifications
	\fontsize{11}{12}
	\selectfont
	\@presentationtext

\vfill
% Title of Dissertation
	\fontsize{12}{14}
	\selectfont
	\hfill\begin{tabularx}{0.9\linewidth}{rX}
	\printconditionaladv{adviser}{1}
	\printconditionaladv{adviser}{2}
	\printconditionaladv{adviser}{3}
	\printconditionaladv{adviser}{4}
	\printconditionaladv{adviser}{5}
	\printconditionaladv{adviser}{6}
	\printconditionaladv{adviser}{7}
	\printconditionaladv{adviser}{8}
	\printconditionaladv{adviser}{9}
	\printconditionaladv{coadviser}{1}
	\printconditionaladv{coadviser}{2}
	\printconditionaladv{coadviser}{3}
	\printconditionaladv{coadviser}{4}
	\printconditionaladv{coadviser}{5}
	\printconditionaladv{coadviser}{6}
	\printconditionaladv{coadviser}{7}
	\printconditionaladv{coadviser}{8}
	\printconditionaladv{coadviser}{9}
	\end{tabularx}
	

\vfill
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
% Title of Dissertation
	\fontsize{11}{12}
	\selectfont
	\textbf{\@themonth, \@theyear}
	
\end{center}
\restoregeometry
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

