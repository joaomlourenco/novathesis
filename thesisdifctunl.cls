%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% thesisdifctunl.cls
%%% DI/FCT/UNL Dissertation document class
%%%
%%% Version 2.0 (February 2010)
%%% By João Lourenço (joao.lourenco@di.fct.unl.pt)
%%%
%%% This template is vaguely based on a template from the
%%%      University of Pernambuco
%%%
%%% BUGS and SUGGETSIONS: please send email to "joao.lourenco@di.fct.unl.pt"
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesisdifctunl}[2007/12/30]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% OPTIONS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\DeclareOption{pt}{%
  \let\@language=0%
  \PassOptionsToPackage{portuguese,english}{babel}}

\DeclareOption{en}{%
  \let\@language=1%
  \PassOptionsToPackage{portuguese,english}{babel}}

\DeclareOption{oneside}{%
  \PassOptionsToClass{oneside}{book}}

\DeclareOption{twoside}{%
  \PassOptionsToClass{twoside}{book}}

\PassOptionsToClass{11pt}{book} % Default point size

\DeclareOption{11pt}{%
	\PassOptionsToClass{11pt}{book}}

\DeclareOption{12pt}{%
	\PassOptionsToClass{12pt}{book}}

\DeclareOption{singlecover}{%
  \let\@singlecover=1}

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
 
% Default options
\ExecuteOptions{pt,twoside,prepmsc}
\ProcessOptions

\LoadClass[a4paper]{book}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PACKAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{amsmath,amsfonts,amssymb,amsthm}
\RequirePackage{babel}
\RequirePackage{calc}
\RequirePackage{ifthen}
\RequirePackage[utf8x]{inputenc}
\RequirePackage{textcase}
\RequirePackage{textcomp}
\RequirePackage{url}
\RequirePackage{xspace}
\RequirePackage{boolexpr}

\usepackage{titlesec}           % To format the headings
\usepackage{textfit}            % To scale fonts
\usepackage{fancyhdr}           % Headings configuration
% \usepackage{booktabs}           % Nice tables
% \usepackage[sort]{cite}         % Sort citations
% \usepackage{listings}           % Nice source code
\usepackage{setspace}           % One-and-half spacing
\onehalfspacing


\RequirePackage[T1]{fontenc}
\RequirePackage{mathptmx}
\RequirePackage[scaled=0.9]{helvet}
\RequirePackage{courier}
\RequirePackage{palatino}

\RequirePackage[pdftex]{graphicx}
\RequirePackage[pdftex,usenames]{color}
\definecolor{myblue}{rgb}{0.39,0.69,1}
\definecolor{myyellow}{rgb}{0.95,0.93,0.78}
\definecolor{mydarkblue}{rgb}{0.0,0.08,0.45}
\RequirePackage[pdftex,breaklinks,colorlinks,pdfdisplaydoctitle,citecolor=mydarkblue,linkcolor=mydarkblue]{hyperref}

\RequirePackage[top=3cm,bottom=3cm,inner=3cm,outer=2cm,twoside]{geometry}


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
  % \gdef\@axiomname{Axioma}
  % \gdef\@conjecturename{Conjectura}
  % \gdef\@defname{Definição}
  % \gdef\@lemmaname{Lema}
  % \gdef\@theoname{Teorema}
  % \gdef\@propname{Proposição}
  % \gdef\@corname{Corolário}
  % \gdef\@proofname{Prova}
  % \gdef\@figurename{Figura}
  % \gdef\@tablename{Tabela}
  % \gdef\@equationame{equação}
  % \gdef\@chaptername{Capítulo}
  % \gdef\@sectionname{Secção}
  % \gdef\@appendixname{Apêndice}
  % \gdef\@pagename{página}
% English
\else\if\@language1
  \gdef\@notdefined{UNDEFINED}
  % \gdef\acknowledgementsname{Acknowledgements}
  %   \gdef\@axiomname{Axiom}
  %   \gdef\@conjecturename{Conjecture}
  %   \gdef\@defname{Definition}
  %   \gdef\@lemmaname{Lemma}
  %   \gdef\@theoname{Theorem}
  %   \gdef\@propname{Proposition}
  %   \gdef\@corname{Corollary}
  %   \gdef\@proofname{Proof}
  %   \gdef\@figurename{Figure}
  %   \gdef\@tablename{Table}
  %   \gdef\@equationame{equation}
  %   \gdef\@chaptername{Chapter}
  %   \gdef\@sectionname{Section}
  %   \gdef\@appendixname{Appendix}
  %   \gdef\@pagename{page}
\fi\fi


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% School identification

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
  \if#1\@empty
    \gdef\@advisertitle{\@maleadvisertitle}
  \else
    \gdef\@advisertitle{\@femaleadvisertitle}
  \fi
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
  \else
    \gdef\@coadvisertitle{\@femalecoadvisertitle}
  \fi
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

\synctex=1 % Uase synctex

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \setlength{\topmargin}{1cm}
% \setlength{\headheight}{1cm}
% \setlength{\headsep}{0.5cm}
% 
% \setlength{\textheight}{21cm}
% \setlength{\topskip}{0.5cm}
% \setlength{\textwidth}{16cm}
% \setlength{\footskip}{0.5cm}
% 
% \setlength{\oddsidemargin}{0cm}
% \setlength{\evensidemargin}{0cm}
% 
% \setlength{\marginparwidth}{10mm}
% \setlength{\marginparsep}{10mm}

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
		\@input@{User/\@dedicatoryfile}\global\let\@dedicatoryfile\@empty
	\else\if\@degreetype1
	\else\if\@degreetype2
		\@input@{User/\@dedicatoryfile}\global\let\@dedicatoryfile\@empty
	\else\if\@degreetype3
	\else\if\@degreetype4
	\else\if\@degreetype5
		\@input@{User/\@dedicatoryfile}\global\let\@dedicatoryfile\@empty
	\fi\fi\fi\fi\fi\fi
}

\def\acknowledgementsfile#1{%
  \gdef\@acknowledgementsfile{#1}}
\def\@acknowledgementsfile{~acknowledgementsfile \@notdefined}

\def\printacknowledgements{
	\if\@degreetype0
		\@input@{User/\@acknowledgementsfile}\global\let\@acknowledgementsfile\@empty
	\else\if\@degreetype1
	\else\if\@degreetype2
		\@input@{User/\@acknowledgementsfile}\global\let\@acknowledgementsfile\@empty
	\else\if\@degreetype3
	\else\if\@degreetype4
	\else\if\@degreetype5
		\@input@{User/\@acknowledgementsfile}\global\let\@acknowledgementsfile\@empty
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
		\@input@{User/\@ptabstractfile}\global\let\@ptabstractfile\@empty
		\selectlanguage{english}
		\@input@{User/\@enabstractfile}\global\let\@enabstractfile\@empty
		\selectlanguage{portuguese}
	\else\if\@language1   % Abstract-EN + Sumário-PT for thesis in English
		\selectlanguage{english}
		\@input@{User/\@enabstractfile}\global\let\@enabstractfile\@empty
		\selectlanguage{portuguese}
		\@input@{User/\@ptabstractfile}\global\let\@ptabstractfile\@empty
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
	\ifnum #1=1\gdef\printchapterfileone{\thesismainmatter\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=2\gdef\printchapterfiletwo{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=3\def\printchapterfilethree{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=4\gdef\printchapterfilefour{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=5\gdef\printchapterfilefive{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=6\gdef\printchapterfilesix{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=7\gdef\printchapterfileseven{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=8\gdef\printchapterfileeight{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=9\gdef\printchapterfilenine{\noexpand{\@input@{User/#2}}}\fi
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
	\ifnum #1=1\gdef\printappendixfileone{\noexpand{\appendix\@input@{User/#2}}}\fi
	\ifnum #1=2\gdef\printappendixfiletwo{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=3\def\printappendixfilethree{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=4\gdef\printappendixfilefour{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=5\gdef\printappendixfilefive{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=6\gdef\printappendixfilesix{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=7\gdef\printappendixfileseven{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=8\gdef\printappendixfileeight{\noexpand{\@input@{User/#2}}}\fi
	\ifnum #1=9\gdef\printappendixfilenine{\noexpand{\@input@{User/#2}}}\fi
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
	\bibliography{User/\@bibliographyfile}
}


% \def\acknowledgementsfile#1{%
%   \gdef\@acknowledgementsfile{#1}}
% \def\@acknowledgementsfile{\@notdefined}
% 
% \def\printacknowledgements{
% 	\if\@degreetype0
% 		\@input@{\@acknowledgementsfile}\global\let\@acknowledgementsfile\@empty
% 	\else\if\@degreetype1
% 	\else\if\@degreetype2
% 		\@input@{\@acknowledgementsfile}\global\let\@acknowledgementsfile\@empty
% 	\else\if\@degreetype3
% 	\else\if\@degreetype4
% 	\else\if\@degreetype5
% 		\@input@{\@acknowledgementsfile}\global\let\@acknowledgementsfile\@empty
% 	\fi\fi\fi\fi\fi\fi
% }


% \newcounter{\chapcounter}
% \setcounter{\chapcounter}{0}
% \def\chapterfile#1{%
% 	\if\@chapcounter0
% 		\mainmatter
% 		\pagestyle{fancy}
% 		\fancyhead{}
% 		\setlength{\headheight}{15pt}
% 		\fancyhead[RO,LE]{\leftmark\hfill\rightmark}
% 		\renewcommand{\chaptermark}[1]{%
% 			\markboth{\fontfamily{phv}\selectfont\footnotesize\thechapter.\ \textsc{#1}}{}}
% 		\renewcommand{\sectionmark}[1]{%
% 			\markright{\fontfamily{phv}\selectfont\footnotesize\thesection.\ #1}}
% 	\fi
% 	\gdef\csname{\@enabstractfile\chapcounter}{#1}}
% 	\def\csname{\@enabstractfile\chapcounter}{\@notdefined}
% }


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
	\end{flushright}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\acknowledgements{%
  \chapter*{\acknowledgementsname}}


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

% \def\epigraph{%
%   \if@openright\cleardoublepage\else\clearpage\fi
%   \thispagestyle{empty}
%   ~\\\vfill
%   \begin{quotation}}
% \def\endepigraph{\end{quotation}}
% 
% \def\quotation{%
%   \@ifnextchar [%
%     {\begin{pquot@tion}}%
%     {\begin{pquot@tion}[\@empty]}}
% \def\endquotation{\end{pquot@tion}\@afterindentfalse\@afterheading}
% 
% \def\pquot@tion[#1]#2{%
%   \def\@qauthor{#2}
%   \def\@qnote{#1}
%   \begin{flushright}
%     \begin{minipage}{0.8\textwidth}
%       \begin{flushright}\quotefonti}
% \def\endpquot@tion{%
%         \vskip.2\baselineskip%
%         \quotefont---\MakeTextUppercase{\@qauthor}
%         \if\@qnote\@empty
%           \relax
%         \else
%           \space(\@qnote)
%         \fi
%       \end{flushright}
%     \end{minipage}
%   \end{flushright}
%   \normalfont\vskip2\baselineskip}

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Table of contents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \def\@plaintocline#1#2#3#4#5{%
%   \ifnum #1>\c@tocdepth \else
%     \vskip \z@ \@plus.2\p@
%     {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
%      \parindent #2\relax\@afterindenttrue
%      \interlinepenalty\@M
%      \leavevmode
%      \@tempdima #3\relax
%      \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
%      {#4}\nobreak
%      \leaders\hbox{$\m@th
%         \mkern \@dotsep mu\hbox{}\mkern \@dotsep
%         mu$}\hfill
%      \nobreak
%      \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
%      \par}%
%   \fi}
% 
%  \renewcommand\tableofcontents{%
%    \chapter*{\contentsname}
%    \@starttoc{toc}}
%  
% 
% \def\l@chapter#1#2{%
%   \ifnum \c@tocdepth >\m@ne
%     \addpenalty{-\@highpenalty}%
%     \vskip .75em \@plus\p@
%     \setlength\@tempdima{1.5em}%
%     \begingroup
%       \parindent \z@ \rightskip \@pnumwidth
%       \parfillskip -\@pnumwidth
%       \leavevmode \bfseries
%       \advance\leftskip\@tempdima
%       \hskip -\leftskip
%       #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
%       \penalty\@highpenalty
%     \endgroup 
%   \fi}
% 
% \let\@dottedtocline\@plaintocline

\setcounter{tocdepth}{3}

% 
% \renewcommand\listoffigures{%
%    \chapter*{\listfigurename}
%    \@starttoc{lof}}
% 
% \renewcommand\listoftables{%
%    \chapter*{\listtablename}
%    \@starttoc{lot}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sectioning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setcounter{secnumdepth}{3}

% \def\part{%
% \if@openright\cleardoublepage\else\clearpage\fi
%   \thispagestyle{empty}%
%   \secdef\@part\@spart}
% \def\@part[#1]#2{%
%     \ifnum \c@secnumdepth >-2\relax
%       \refstepcounter{part}%
%       \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
%     \else
%       \addcontentsline{toc}{part}{#1}%
%     \fi
%     \markboth{}{}%
%     {\centering
%      \interlinepenalty \@M
%      \normalfont
%      \null\vfil
%      \ifnum \c@secnumdepth >-2\relax
%        {\sc\Large\partname\nobreakspace\thepart}
%        \par
%        \vskip 20\p@
%      \fi
%      {\huge\bfseries #2\par}}
%      \vfil}
% \def\@spart#1{%
%     {\centering
%      \interlinepenalty \@M
%      \normalfont
%      \null\vfil
%      {\huge\bfseries #1\par}}
%      \vfil}


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
	
% \def\chapter{\if@openright\cleardoublepage\else\clearpage\fi
%              \thispagestyle{plain}%
%              \global\@topnum\z@
%              \@afterindentfalse
%              \secdef\@chapter \@schapter
%              }
% 
% \def\@chapter[#1]#2{
%    \refstepcounter{chapter}%
%    \addcontentsline{toc}{chapter}{\protect\numberline{\thechapter}#1}%
%    \chaptermark{#1}%
%    \addtocontents{lof}{\protect\addvspace{10\p@}}%
%    \addtocontents{lot}{\protect\addvspace{10\p@}}%
%    \@lopcchapterspace%
%     \@makechapterhead{#2}%
%    \@afterheading}

% \def\@makechapterhead#1{
%   \relax
%   \begingroup
%   \Large\bfseries
%      %\chaptername
%      {\LARGE \thechapter}~.\hspace{0.3cm}~#1\par \endgroup
%   \skip@3pc \advance\skip@-\normalbaselineskip
%   \vskip\skip@ }  
%   
% \def\@schapter#1{%
%   \schaptermark{#1}%
%   \@makeschapterhead{#1}%
%   \@afterheading}
% 
% \def\@makeschapterhead#1{
% \relax
%   \begingroup
%   \Large \bfseries
%   #1\par \endgroup
%   \skip@3pc \advance\skip@-\normalbaselineskip
%   \vskip\skip@ }

% \def\appendix{%
%    \setcounter{chapter}{0}%
%    \renewcommand{\thechapter}{\Alph{chapter}}%
%    \renewcommand{\chaptername}{\appendixname}}

% \def\@startsection#1#2#3#4#5#6{%
%  \if@noskipsec \leavevmode \fi
%  \par \@tempskipa #4\relax
%  \@afterindentfalse
%  \ifdim \@tempskipa <\z@ \@tempskipa -\@tempskipa \@afterindentfalse\fi
%  \if@nobreak \everypar{}\else
%      \addpenalty\@secpenalty\addvspace\@tempskipa\fi
%  \@ifstar{\@dblarg{\@sect{#1}{\@m}{#3}{#4}{#5}{#6}}}%
%          {\@dblarg{\@sect{#1}{#2}{#3}{#4}{#5}{#6}}}%
% }
% 
% \def\section{%
%   \@startsection{section}{1}{0mm}{1.5\baselineskip}
%     {\baselineskip}{\large\bfseries}}
% 
% \def\subsection{%
%   \@startsection{subsection}{2}{0mm}{1.2\baselineskip}
%     {.6\baselineskip}{\bfseries}}
% 
% \def\subsubsection{%
%   \@startsection{subsubsection}{3}{0mm}{\baselineskip}
%    {.6\baselineskip}{\normalfont}}
% 
% \def\paragraph{%
%   \@startsection{paragraph}{4}{0mm}{\baselineskip}
%    {-1em}{\itshape}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Headers & footers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \def\@evenhead{\rlap{\thepage}\hfill{\leftmark}\hfill}%
% \def\@oddhead{\hfill{\rightmark}\hfill\llap{\thepage}}%

%% TO DO IN THE FUTURE
% \def\chaptermark#1%
% {\markboth{}{}}
% 
% \def\schaptermark#1%
% {\markboth{}{}}
% 
% \def\sectionmark#1%
% {\markboth{}{}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \global\renewenvironment{thebibliography}[1]
%      {\chapter*{\bibname}%
%       \list{\@biblabel{\@arabic\c@enumiv}}%
%            {\settowidth\labelwidth{\@biblabel{#1}}%
%             \leftmargin\labelwidth
%             \advance\leftmargin\labelsep
%             \@openbib@code
%             \usecounter{enumiv}%
%             \let\p@enumiv\@empty
%             \renewcommand\theenumiv{\@arabic\c@enumiv}}%
%       \sloppy
%       \clubpenalty4000
%       \@clubpenalty \clubpenalty
%       \widowpenalty4000%
%       \sfcode`\.\@m}
%      {\def\@noitemerr
%        {\@latex@warning{Empty `thebibliography' environment}}%
%       \endlist}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tables and figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \long\def\@makecaption#1#2{%
%   \vskip\abovecaptionskip
%   \sbox\@tempboxa{\small\bf #1\rm\enskip #2}%
%   \ifdim \wd\@tempboxa >\hsize
%     {\small\bf#1\rm\enskip #2\par}
%   \else
%     \global \@minipagefalse
%     \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
%   \fi
%   \vskip\belowcaptionskip}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Mathematics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Equation numbering
% \renewcommand{\theequation}{\rm\thechapter.\arabic{equation}}

% Theorem-like environments
% \newtheoremstyle{theo}%
% {\topsep}{\topsep}% Space above and below
% {\slshape}% Body style
% {0pt}% Heading indent amount
% {\bfseries}{.}% Heading font and punctuation after it
% {1ex plus 0pt minus .2ex}% Space after heading 
% {}% Head spec (empty = same as ëplainí style
% \theoremstyle{definition}
% \newtheorem{Def}{\@defname}[chapter]
% \theoremstyle{theo}
% \newtheorem{Axi}{\@axiomname}[chapter]
% \newtheorem{Conj}{\@conjecturename}[chapter]
% \newtheorem{Lem}{\@lemmaname}[chapter]
% \newtheorem{Theo}{\@theoname}[chapter]
% \newtheorem{Prop}{\@propname}[chapter]
% \newtheorem{Cor}{\@corname}[chapter]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference macros
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \newcommand{\figref}[2][]{\@figurename~\ref{#2}#1\xspace}
% \newcommand{\tabref}[1]{\@tablename~\ref{#1}\xspace}
% \newcommand{\eqnref}[1]{\@equationame~\eqref{#1}\xspace}
% \newcommand{\chapref}[1]{\@chaptername~\ref{#1}\xspace}
% \newcommand{\secref}[1]{\@sectionname~\ref{#1}\xspace}
% \newcommand{\appref}[1]{\@appendixname~\ref{#1}\xspace}
% \newcommand{\axiref}[1]{\@axiomname~\ref{#1}\xspace}
% \newcommand{\conjref}[1]{\@conjname~\ref{#1}\xspace}
% \newcommand{\defref}[1]{\@defname~\ref{#1}\xspace}
% \newcommand{\lemref}[1]{\@lemmaname~\ref{#1}\xspace}
% \newcommand{\theoref}[1]{\@theoname~\ref{#1}\xspace}
% \newcommand{\corref}[1]{\@corname~\ref{#1}\xspace}
% \newcommand{\propref}[1]{\@propname~\ref{#1}\xspace}
% \newcommand{\pgref}[1]{\@pagename~\pageref{#1}\xspace}

