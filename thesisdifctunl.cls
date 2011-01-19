%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% thesisdifctunl.cls
%%% DI/FCT/UNL Dissertation document class
%%% http://code.google.com/p/thesisdifctunl
%%%
%%% Version 2.1 (March 2010)
%%% By João Lourenço (joao.lourenco@di.fct.unl.pt)
%%%
%%% This template is vaguely based on a template from the
%%%     University of Pernambuco
%%%
%%% BUGS and SUGGETSIONS:
%%%     Please report in the project web page at
%%%     http://code.google.com/p/thesisdifctunl/issues/list
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesisdifctunl}[2010/03/10]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OPTIONS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% == Language ===
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

% == Font Size ===
\PassOptionsToClass{11pt}{book} % Default point size

\DeclareOption{11pt}{%
	\PassOptionsToClass{11pt}{book}}

\DeclareOption{12pt}{%
	\PassOptionsToClass{12pt}{book}}

% == Unused for now ===
\DeclareOption{singlecover}{%
  \let\@singlecover=1}

% == Text Encoding ===
\let\@utf=1

\DeclareOption{latin1}{%
  \let\@utf=0}

\DeclareOption{utf8}{%
  \let\@utf=1}

% == Type of Document ===
\DeclareOption{bsc}{%
  \let\@degreetype=0}

\DeclareOption{prepmsc}{%
  \let\@degreetype=1}
  
\DeclareOption{msc}{%
  \let\@degreetype=2}

\DeclareOption{propphd}{%
  \let\@degreetype=3}
  
\DeclareOption{prepphd}{%
  \let\@degreetype=4}

\DeclareOption{phd}{%
  \let\@degreetype=5}
 
% == Default Options ===
\ExecuteOptions{en,prepmsc}
\ProcessOptions

\LoadClass[a4paper]{book}


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


% \RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}

% \RequirePackage{amsmath,amsfonts,amssymb,amsthm}

\RequirePackage{babel}

%\RequirePackage{calc}
%\RequirePackage{ifthen}
%\RequirePackage{textcase}
%\RequirePackage{textcomp}
%\RequirePackage{url}
%\RequirePackage{xspace}
%\RequirePackage{boolexpr}
\usepackage{titlesec}           % To format the headings
\usepackage{textfit}            % To scale fonts
\usepackage{fancyhdr}           % Headings configuration
% \usepackage{booktabs}           % Nice tables
% \usepackage[sort]{cite}         % Sort citations
% \usepackage{listings}           % Nice source code
\usepackage{setspace}           % One-and-half spacing
\onehalfspacing

\RequirePackage{mathptmx}
\RequirePackage[scaled=0.9]{helvet}
\RequirePackage{courier}
\RequirePackage{palatino}

\RequirePackage[pdftex]{graphicx}
\RequirePackage[pdftex,usenames]{color}
% \definecolor{myblue}{rgb}{0.39,0.69,1}
% \definecolor{myyellow}{rgb}{0.95,0.93,0.78}
\definecolor{mydarkblue}{rgb}{0.0,0.08,0.45}
\RequirePackage[pdftex,breaklinks,colorlinks,pdfdisplaydoctitle,citecolor=mydarkblue,linkcolor=mydarkblue,urlcolor=mydarkblue]{hyperref}

\RequirePackage[top=3cm,bottom=3cm,inner=3cm,outer=2cm]{geometry}


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

\gdef\@maleadvisertitle{Orientador}
\gdef\@femaleadvisertitle{Orientadora}
\gdef\@malecoadvisertitle{Co-orientador}
\gdef\@femalecoadvisertitle{Co-orientadora}
\gdef\@bachelordissertation{Trabalho de Licenciatura}
\gdef\@mastersdissertation{Dissertação de Mestrado}
\gdef\@mastersqualifying{Preparação da Dissertação}
\gdef\@phdqualifying{Preparação da Tese}
\gdef\@phdproposal{Proposta de Tese de Doutoramento}
\gdef\@phdthesis{Tese de Doutoramento}
\gdef\@bachelordegree{Licenciado}
\gdef\@mastersdegree{Mestre}
\gdef\@phddegree{Doutor}
\gdef\@presentationtext{%
Trabalho apresentado no âmbito d\if\@degreetype0a\else o\fi
\@program, como requisito parcial para obtenção do
grau de\@degree\ em\@majorfield.}
\gdef\resumoname{Resumo}
\gdef\abstrname{Abstract}
\gdef\keywordsnamePT{Palavras-chave}
\gdef\keywordsnameEN{Keywords}

\gdef\@programbsc{Licenciatura em \@enginformatica}
\gdef\@programmsc{Mestrado em \@enginformatica}
\gdef\@programphd{Doutoramento em \@informatica}

\gdef\@enginformatica{Engenharia Informática}
\gdef\@informatica{Informática}

\gdef\@programbscbox{20.5em}
\gdef\@programmscbox{20em}
\gdef\@programphdbox{21em}

%% Language Dependent

% Portuguese
\if\@language0
  \gdef\@notdefined{NÃO DEFINIDO}
  \gdef\acknowledgementsname{Agradecimentos}
% English
\else\if\@language1
  \gdef\@notdefined{UNDEFINED}
  \gdef\acknowledgementsname{Acknowledgements}
\fi\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\universitylogo#1{%
  \gdef\@universitylogo{#1}}
\def\@universitylogo{~universitylogo \@notdefined}

\def\universitylogowidth#1{%
  \gdef\@universitylogowidth{#1}}
\def\@universitylogowidth{2cm}

\def\university#1{%
  \gdef\@university{#1}}
\def\@university{~university \@notdefined}

\def\faculty#1{%
  \gdef\@faculty{#1}}
\def\@faculty{~faculty\@notdefined}

\def\department#1{%
  \gdef\@department{#1}}
\def\@department{~department \@notdefined}

\def\program#1{%
  \gdef\@program{#1}}
\def\@program{~program \@notdefined}

\def\programbox#1{%
  \gdef\@programbox{#1}}
\def\@programbox{21em}

\def\majorfield#1{%
  \gdef\@majorfield{#1}}
\def\@majorfield{~majorfield \@notdefined}

\def\address#1{%
  \gdef\@address{#1}}
\def\@address{Lisboa}

\@input@{defaults}


%% Authors identification

\def\author#1{%
  \gdef\@author{#1}
  \hypersetup{pdfauthor={\@author}}}
\def\@author{~author \@notdefined}

\def\authornumber#1{%
  \gdef\@authornumber{#1}}
\def\@authornumber{~authornumber \@notdefined}

\def\adviser{%
  \@ifnextchar [%
    {\@padviser}%
    {\@padviser[\@empty]}}
\def\@padviser[#1]#2{%
  \ifx#1\@empty
    \gdef\@advisertitle{\@maleadvisertitle}
  \else\if#1f
    \gdef\@advisertitle{\@femaleadvisertitle}
  \else
    \gdef\@advisertitle{\@maleadvisertitle}
  \fi\fi
  \gdef\@adviser{#2}}
\def\@adviser{~adviser \@notdefined}

\let\@showcoadviser=0
\def\coadviser{%
  \@ifnextchar [%
    {\@pcoadviser}%
    {\@pcoadviser[\@empty]}}
\def\@pcoadviser[#1]#2{%
  \let\@showcoadviser=1
  \ifx#1\@empty
    \gdef\@coadvisertitle{\@malecoadvisertitle}
  \else\if#1f
    \gdef\@coadvisertitle{\@femalecoadvisertitle}
  \else
    \gdef\@coadvisertitle{\@malecoadvisertitle}
  \fi\fi
  \gdef\@coadviser{#2}}

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

\def\@program{%
  \if\@degreetype0
    \@programbsc
  \else\if\@degreetype1
    \@programmsc
  \else\if\@degreetype2
    \@programmsc
  \else\if\@degreetype3
    \@programphd
  \else\if\@degreetype4
    \@programphd
   \else\if\@degreetype5
    \@programphd
  \fi\fi\fi\fi\fi\fi}

\def\@programbox{%
  \if\@degreetype0
    \@programbscbox
  \else\if\@degreetype1
    \@programmscbox
  \else\if\@degreetype2
    \@programmscbox
  \else\if\@degreetype3
    \@programphdbox
  \else\if\@degreetype4
    \@programphdbox
   \else\if\@degreetype5
    \@programphdbox
  \fi\fi\fi\fi\fi\fi}

\def\@majorfield{%
  \if\@degreetype0
    \@enginformatica
  \else\if\@degreetype1
    \@enginformatica
  \else\if\@degreetype2
    \@enginformatica
  \else\if\@degreetype3
    \@informatica
  \else\if\@degreetype4
    \@informatica
   \else\if\@degreetype5
    \@informatica
  \fi\fi\fi\fi\fi\fi}

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
\def\@dedicatoryfile{~dedicatoryfile \@notdefined}

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
}

\def\endthesismainmatter{%
	\fancyhead{}
	\lhead{\nouppercase{\textsc{\leftmark}}}
	\rhead{}
}

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
	\if\@language0   % Estamos a usar o Português
		\def\lstlistlistingname{Listagens}
	\fi
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
	\bibliography{Chapters/\@bibliographyfile}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Frontpage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\frontpage{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \thispagestyle{empty}
  \begin{center}
  \begin{minipage}[c]{\@universitylogowidth}
    \includegraphics[width=\@universitylogowidth]{\@universitylogo}
  \end{minipage}\hspace{2mm}
  \begin{minipage}[c]{7cm}
  \textbf{\@university}\\
  \@faculty\\
  \textsl{\@department}
  \end{minipage}
  \vskip 3.0cm
  \begin{minipage}{16cm}
    \Large\centering
    \@texttype
    \vskip1.2\baselineskip
    {\itshape\@program}
  \end{minipage}
  \vskip 3.0cm
  \begin{minipage}{15.8cm}
    \Huge\centering\bfseries
    \@title
  \end{minipage}
  \vskip 2cm
  {\Large\centering
    \@author
    \hskip 1ex
    (\@authornumber)}
  \vfill
  \@address\\
  (\@date)
  \end{center}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Presentation page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\presentationpage{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \thispagestyle{empty}
  \begin{center}
  \begin{minipage}[c]{\@universitylogowidth}
    \includegraphics[width=\@universitylogowidth]{\@universitylogo}
  \end{minipage}\hspace{2mm}
  \begin{minipage}[c]{7cm}
  \textbf{\@university}\\
  \@faculty\\
  \textsl{\@department}
  \end{minipage}
  \vskip 3.0cm
  \begin{minipage}{16cm}
    \Large\centering
    \@texttype
    % \vskip1.2\baselineskip
    % {\ }
  \end{minipage}
  \vskip 3.0cm
  \begin{minipage}{15.8cm}
    \Huge\centering\bfseries
    \@title
  \end{minipage}
  \vskip 2cm
  {\Large\centering
    \@author
    \hskip 1ex
    (\@authornumber)}
  \vskip 2\baselineskip
  \begin{minipage}{15.5cm}
    \begin{center}
      \begin{tabular}{rl}
        {\quotefont\@advisertitle:}&\@adviser\\
        \if\@showcoadviser1{\quotefont\@coadvisertitle:}&\@coadviser\\\fi
      \end{tabular}
    \end{center}
  \end{minipage}
  \vskip 3.0cm
  \hfill\begin{minipage}{\@programbox}
    \quotefonti %
    \@presentationtext
  \end{minipage}
  \vfill
  \@address\\
  (\@date)
  \end{center}
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
\def\resumo{%
  \selectlanguage{portuguese}
  \gdef\@keywordsname{\keywordsnamePT}
  \chapter*{\resumoname}
   \rule{\textwidth}{0.2mm} ~\\
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\abstract{%
  \selectlanguage{english}
  \gdef\@keywordsname{\keywordsnameEN}
  \chapter*{\abstrname}
  \rule{\textwidth}{0.2mm} ~\\
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
{\hfill\colorbox{backGrayColor}{\scaletoheight{1in}{\textcolor{white}{\thechapter}}}} % label
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

