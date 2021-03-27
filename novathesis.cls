%!TEX root=template.tex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% novathesis.cls
%% NOVA thesis document class
%%
%% This work is licensed under the
%% The LaTeX project public license (LPPL), version 1.3c
%% To view a copy of this license, visit
%% https://www.latex-project.org/lppl/lppl-1-3c/
%%
%% Version 2021-03-27 [6.0.2]
%% Departamento de Informática (www.di.fct.unl.pt)
%% Faculdade de Ciências e Tecnologia (www.fct.unl.pt)
%% Universidade NOVA de Lisboa (www.unl.pt)
%%
%% BUGS and SUGGESTIONS: please submit an issue at the project web page
%%      at: https://github.com/joaomlourenco/novathesis/
%%
%% HELP: please DO NOT SEND ME EMAILS about LaTeX or the NOVAthesis template
%%       please ask for help at GitHub Discussions page at
%%          https://github.com/joaomlourenco/novathesis/discussions
%%      or at the NOVAthesis facebook group at
%%            
%%
%% AUTHOR @github:
%%      - joaomlourenco
%%
%% CONTRIBUTORS @github:
%%      - bcandeias, flaviomartins, tmonteiro2344, jsaramago, 
%%        microlina, riclas, pedrovieira
%%
%% DONATIONS:
%%     If you think this template really helped you while writing your thesis,
%%     think about making a small donation. Just access the website
%%     https://paypal.me/novathesis
%%     and click in the “Donation” link.  We will keep a list thanking to all 
%%     the identified donors that identify themselves in the “Add special 
%%     instructions to the seller:” box.
%%
%% CITATION:
%%     If you use this template, please be kind and cite it in your bibliography:
%%           “João M. Lourenço, \emph{The NOVAthesis \LaTeX\ Template User’s Manual},
%%            NOVA School of Science and Technology, NOVA University Lisbon, 2021,
%%            \url{https://github.com/joaomlourenco/novathesis/raw/master/template.pdf}.”
%%    The BibTeX entry is:
%%           @Manual{novathesis-manual,
%%            title       ={{The NOVAthesis \LaTeX\ Template User's Manual}},
%%            author      ={João M. Lourenço},
%%            organization={NOVA University Lisbon},
%%            year        ={2021},
%%            url         ={https://github.com/joaomlourenco/novathesis/raw/master/template.pdf},
%%           }
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
\ProvidesClass{novathesis}[2021-03-27 novathesis template]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOOK FOR PACKAGES ALSO IN "NOVAthesisFiles" folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \providecommand*{\input@path}{}
% \g@addto@macro\input@path{{./}{NOVAthesisFiles/}}% subfolder path


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SOME ESSENTIAL PACKAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{NOVAthesisFiles/nt-options}
\RequirePackage{xifthen}
\RequirePackage{xstring}
% \RequirePackage{nt-repeat}
\RequirePackage{NOVAthesisFiles/assocarray}
\RequirePackage{NOVAthesisFiles/nt-version}
% To process lists and other stuff
\RequirePackage{etoolbox}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK IF USING LUALATEX OR XELATEX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\ifxetexorluatex
\begingroup\catcode94=7 \catcode0=9% ASCII 94 is ^
\def\empty{}\def\next{^^^^0000}\expandafter\endgroup
\ifx\next\empty\xetexorluatextrue\else\xetexorluatexfalse\fi

\newcommand*{\ifxeorlua}[2]{\ifxetexorluatex#1\else#2\fi}

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% If necessary create, then initialize the counter
\newcommand*{\setnewcounter}[2]{%
  \ifcsname c@#1\endcsname\else\newcounter{#1}\fi%
  \setcounter{#1}{#2}%
}

% --------------------------------------------------------
% Print string between <...>
\newcommand{\embrace}[1]{\texorpdfstring{$\langle$}{<}#1\texorpdfstring{$\rangle$}{>}}

% --------------------------------------------------------
% Split a string by a character
\newcommand*{\ntgetkeyval}[4][=]{%
  % #1=character to look for
  % #2=string to split
  % #3=macro to receive the left part
  % #4=macro to receive the right part
  \StrCut{#2}{#1}#3#4%
}


% --------------------------------------------------------
% Alias for consistency in template.tex
\def\ntdepartment(#1)#2{\department(#1):={#2}}
\def\ntmajorfield(#1)#2{\majorfield(#1):={#2}}
\def\ntdegreename(#1)#2{%
  \degreename(#1):={#2}%
  \majorfield(#1):={#2}%
}
\def\ntspecialization(#1)#2{\specialization(#1):={#2}}
\def\ntsponsors(#1)#2{\sponsorsstr(#1):={#2}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INTERNAL KEY-VAL STUFF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/.new family
  % languages
  , langsshort/.new list={en, pt, fr, it, de, es}
  , langslong/.new list={english, portuguese, french, italian, german, spanish}
  , langshorttolong/.new choice={en=english, pt=portuguese, fr=french, it=italian, de=german, es=spanish}
  , maplang/.new cmd={%
            \options{/@nt/langshorttolong=#1}%
            \option{/@nt/langshorttolong}%
  }  
  % %novathesis@opt@biblatex
  , biblatex/.new list
  , handler/chapstyle/.new cmd={%
    \InputIfFileExists{NOVAthesisFiles/ChapStyles/#1.ldf}{}%
      {\PackageWarining{novathesis}{Invalid Chapter Style: #1}}%
  }
  , handler/fontstyle/.new cmd={%
    \InputIfFileExists{NOVAthesisFiles/FontStyles/#1.ldf}{}%
      {\PackageWarining{novathesis}{Invalid Font Style: #1}}%
  }
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE FOLDERS PER CLASS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/folders/.new choice={
  bib=Bibliography, 
  dedicatory=Chapters, 
  acknowledgements=Chapters, 
  quote=Chapters, 
  abstract=Chapters, 
  glossaries=Chapters, 
  chapter=Chapters, 
  appendix=Chapters, 
  annex=Chapters}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE DOCUMENT CLASSES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/.cd
  , document/fallback/.new list={phdprop=phd, phdplan=phd, mscplan=msc}
  , document/class/phd/.new list={phd, phdprop, phdplan}
  , document/class/msc/.new list={msc, mscplan}
  , document/class/bsc/.new list={bsc}
  , document/class/main/.new list={phd, msc, bsc}
}

\newcommand{\@ifdocclass@ii}[2]{%
  % #1=document type
  % %2=possible document calss 
  \ifoptioncontains{/@nt/document/class/#2}{#1}
}

% --------------------------------------------------------
% Check if the document is of a specific class, i.e., bsc, msc, phd or main
\newcommand{\ifmaindoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{#1}{main}}
\newcommand{\ifphddoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{#1}{phd}}
\newcommand{\ifmscdoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{#1}{msc}}
\newcommand{\ifbscdoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{#1}{bsc}}

\newcommand{\ifdocfinal}{\ifoptionequal{/novathesis/docstatus}{final}}
\newcommand{\ifdocprovisional}{\ifoptionequal{/novathesis/docstatus}{provisional}}
\newcommand{\ifdocdraft}{\ifoptionequal{/novathesis/docstatus}{draft}}
\newcommand{\ifdocworking}{\ifoptionequal{/novathesis/docstatus}{working}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FRONTEND FOR MANAGING PERSON LISTS - nunsued for now
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ntcommittee[#1,#2]#3{%
  \ntaddperson{committee}[#1,#2]{#3}%
}

\def\ntauthor[#1,#2]#3{%
  \ntaddperson{author}[#1,#2]{#3}%
}

\def\ntadviser[#1,#2]#3{%
  \ntaddperson{adviser}[#1,#2]{#3}%
}

\def\ntcoadviser[#1,#2]#3{%
  \ntaddperson{coadviser}[#1,#2]{#3}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE PERSON LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ntaddperson#1[#2]{%
  % syntax: \ntaddperson{class}[key]{filename}
  % See "\@ntaddperson@iv" below
  \IfSubStr{#2}{,}%
    {\@ntaddperson@iv{#1}[#2]}%
    {\@ntaddperson@iv{#1}[,#2]}%
}

\def\@ntaddperson@iv#1[#2,#3]#4{%
  % syntax: \ntaddperson{class}[key,gender]{filename}
  % #1={author, adviser, committee, …}
  % #2={c,r,a,m,g}
  %     c=chair
  %     r=rapporteur/referee
  %     a=adviser
  %     m=other members
  %     g=guests
  % #3={m,f}
  % #4={committee member name, position, etc}
  \options{/@nt/#1/#2/gender/.cpush={#3}}%
  \options{/@nt/#1/#2/name/.cpush={#4}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE FILE LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntaddfile}[1]{%
  % syntax: \ntaddfile{class}[key]{filename}
  %         #1=file family (quote, abstract, chapter, etc)
  %         #2=[file lang] (OPTIONAL)
  %         #3=filename
  % \typeout{NT ntaddfile [#1]}
  \@nt@addtolist{file}{#1}%
}

\newcommand*{\@nt@addtolist}[2]{%
  % syntax: \ntaddto{type}{class}[key]{filename}
  %         #1 ={file, person}
  %         #2=family {quote, abstract, chapter, etc} or {author, adviser, committee}
  %         #3=[file lang] (OPTIONAL)
  %         #4=filename
  \@ifnextchar[{\@nt@addtolist@iv[#1]#2}{\@nt@addtolist@iv[#1]#2[VAL]}%
}

\def\@nt@addtolist@iv[#1]#2[#3]#4{%
  % syntax: \@ntaddfile@iii{type}{class}[key]{filename}
  %         #1 ={file, person}
  %         #2=file family (quote, abstract, chapter, etc)
  %         #3=optional file lang
  %         #4=filename
  % \typeout{NT addtolist [#1] [#2] [#3] [#4]}%
  \IfSubStr{#4}{/}{%
    \def\@nt@filewithpath{#4}
  }{%
    \options{/@nt/folders=#2}%
    \def\@nt@filewithpath{\expanded{\option{/@nt/folders}/#4}}%
  }%
  % \typeout{NT ntload ADDFILE [#1] [#2] [#3] [\@nt@filewithpath]}%
  \expanded{\options{/@nt/#1/#2/#3/.cpush={\@nt@filewithpath}}}%
  \typeout{NT ADDED FILE [/@nt/#1/#2/#3=\@nt@filewithpath]}%
  % \@nt@addtolist@iii{#1}{#2}{#3=\@nt@filewithpath}%
}

\newcommand*{\@nt@addtolist@iii}[3]{%
  % #1={file, person}
  % #2=file family (quote, abstract, chapter, etc)
  % #3=filename OR key=filename
  % \typeout{NT FILE ADD /@nt/#1/#1=#2}%
  % \options{/@nt/#1/#2/.cpush={#3}}%
}

\newcommand{\@nt@foralllist}[3]{%
  % #1={file, person}
  % #2=file family (quote, abstract, chapter, etc)
  % #3=macro to be applied, which will receive the item from the list
  \optionlistdo{/@nt/#1/#2}{#3{##1}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multilingual support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\@nt@select@lang}[1]{%
  % #1=lang {pt, en, fr, it}
  \options{/@nt/langshorttolong=#1}%
  % \edef\@nt@tmp{\option{/@nt/langshorttolong}}%
  % \typeout{'NT SWITCHING LANG TO='\nt@tmp}%
  \expandafter\selectlanguage\expandafter{\expanded{\option{/@nt/langshorttolong}}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING ADDITINAL FILES BEFORE LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% SOME PRELIMINARY LANGUAGE DEFINITIONS
\assocarray{abstractorder}
\input{NOVAthesisFiles/lang-conf.tex}

% --------------------------------------------------------
% PROCESS PACKAGE OPTIONS
\input{NOVAthesisFiles/options.tex}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%============================================================
%%  MEMOIR CUSTOMIZATION / OPTIONS
%%      Please open and edit the appropriate
%       configuration file “Config/0_memoir.tex”
%%============================================================
\input{Config/0_memoir}
\NTRunHook{memoir}

% --------------------------------------------------------
% LOAD MAIN CLASS AND ADDITIONAL PACKAGES
\LoadClass{memoir}
\OnehalfSpacing% One-and-half spacing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include strings for all the languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NTAddToHook{novathesis}{%
  \optionlistdo{/novathesis/langsused}{%
    \InputIfFileExists{NOVAthesisFiles/Strings/strings-#1.ldf}%
      {}%
      {}%
  }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING ADDITINAL FILES AFTER LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% LOAD ADDITIONAL PACKAGES
\input{NOVAthesisFiles/packages.tex}

% --------------------------------------------------------
% FIX BABEL TRANSLATION
\input{NOVAthesisFiles/fix-babel.tex}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COVER DEFINITION MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\@ntaddtocover@iii}[3]{%
  % \typeout{NT ntaddtocover #3}%
  \options{/@nt/cover/\option{/novathesis/school}/#3/.cpush={{#1}=*={#2}}}%
}

\newcommand*{\ntaddtocover}[3][]{%
  % #1=cover atrtibutes
  % #2=the code
  % \typeout{NT ntaddtocover [/@nt/cover/\option{/novathesis/school}/element=#1]}
  % \options{/@nt/cover/\option{/novathesis/school}/element/.cpush={{#1}=*={#2}}}
  \forcsvlist{\@ntaddtocover@iii{#1}{#3}}{#2}%
}

\newlength{\mpwidth}%
\newlength{\mpheight}%
\newsavebox{\@nt@coverbox}%

\newcommand*{\ntprintcovers}{%
  \bgroup%
    \AtCoverExecute{1}{begin}%
    \@nt@select@lang{\option{/novathesis/coverlang}}%
    \pdfbookmark{\thefrontmatterstring(\option{/novathesis/coverlang})}{bmfrontmatter}
    \subpdfbookmark{\thecoverstring(\option{/novathesis/coverlang})}{bmcover}
    \@nt@printthecover{1}%
    \AtCoverExecute{1}{end}%
    \iftoggle{/novathesis/secondcover}%
      {% SECOND COVER TRUE
            %If cover 2 is defined use its definition
            \AtCoverExecute{2}{begin}%
            \@nt@printthecover{2}%
            \AtCoverExecute{2}{end}
      }%
      {}% NO SECOND COVER
  \egroup%
}

\newcommand\AtCoverExecute[2]{
  \optionlistdo{/@nt/atcover/#1/#2}{##1}
}

\newcommand\AtBeginCover[2][1]{
  \options{/@nt/atcover/#1/begin/.cpush={#2}}%
}
\newcommand\AtEndCover[2][1]{
  \options{/@nt/atcover/#1/end/.cpush={#2}}%
}

\newcommand{\debuggrid}[1][orange]{%
  \begin{tikzpicture}[remember picture, semitransparent, overlay, shift=(current page.north west)]%
        \draw[step=1mm, line width=0.1mm, #1!30!white] 
            (\expanded{\themargin(\option{/novathesis/docdegree},left)}
            ,-\expanded{\themargin(\option{/novathesis/docdegree},top)})
            grid 
            (\paperwidth-\expanded{\themargin(\option{/novathesis/docdegree},right)}
            ,-\paperheight+\expanded{\themargin(\option{/novathesis/docdegree},bottom)});
        \draw[step=5mm, line width=0.2mm, #1!40!white] (current page.north west)
            grid (current page.south east);
        \draw[step=1cm, line width=0.3mm, #1!90!white] (current page.north west)
            grid (current page.south east);
        \draw[step=5cm, line width=0.5mm, #1!50!white] (current page.north west)
            grid (current page.south east);
  \end{tikzpicture}%
}

\newcommand{\ntcovertext}[1][1]{%
  \edef\mpwidth{\paperwidth
                -\expanded{\themargin(\option{/novathesis/docdegree},left)}
                -\expanded{\themargin(\option{/novathesis/docdegree},right)}}
  \edef\mpheight{\paperheight
                -\expanded{\themargin(\option{/novathesis/docdegree},top)}
                -\expanded{\themargin(\option{/novathesis/docdegree},bottom)}}
  \sbox{\@nt@coverbox}{%
    \begin{minipage}[t][\mpheight][t]{\mpwidth}%
      \@nt@printcovergroup{#1}%
    \end{minipage}%
  }%
  \pgfmathsetmacro\@nt@xshift{0.5*\mpwidth}
  \begin{tikzpicture}[remember picture, overlay,, shift=(current page.north west)]
                      % shift=(\expanded{\themargin(\option{/novathesis/docdegree},left)},
                      %       \paperheight-\expanded{\themargin(\option{/novathesis/docdegree},top)})]
    \node[inner sep=0,anchor=north west] 
            at (\expanded{\themargin(\option{/novathesis/docdegree},left)},-\expanded{\themargin(\option{/novathesis/docdegree},top)})
            {\usebox{\@nt@coverbox}};
  \end{tikzpicture}
}

\newcommand*{\@nt@printthecover}[1]{%
  % #1=cover number {1, 2}    (1 is the default)
  \ifoptiondefined{/@nt/cover/\option{/novathesis/school}/#1}{%
    % \typeout{NT printthecover #1}
    \thispagestyle{empty}%
    \ntcoverbackground[#1]%
    \ntcovertext[#1]%
    \iftoggle{/novathesis/debugcover}{\debuggrid}{}%
    \clearforchapter%
  }{\typeout{NT printthecover #1 undefined}}%
}

\newcommand*{\@nt@printcovergroup}[1]{%
  % #1=cover number {1, 2}    (1 is the default)
  \optionlistdo{/@nt/cover/\option{/novathesis/school}/#1}{%
    % \typeout{NT printcovergroup [##1]}
    % \typeout{NT printcovergroup #1}
    \@nt@printcoverelement@iv[#1]##1%
  }%
}

\options{/@ntcoveropts/.new family
  , status/.new value={},
  , degree/.new value={},
  , align/.new choice={c, l, r}
  , inalign/.new choice={c, t, b}
  , height/.new value={}
  , vspace/.new value={}
  , hspace/.new value={}
  , color/.new color={}
  , defaults/.new style*={align=c, inalign=c, status={}, degree={}, 
                            height={}, hspace=0pt, vspace=0pt, color={black}}
  , defaults
}

\def\@nt@printcoverelement@iv[#1]#2=*=#3{%
  % #1=cover number {1, 2}    (1 is the default)
  % #2=conve element options
  % #3=cover element code
  \ifthenelse{\equal{#3}{}}{}{%
    \options{/@ntcoveropts,defaults}%.
    \options{/@ntcoveropts,#2}%
    \color{\option{/@ntcoveropts/color}}% 
    % \StrCount{\option{/@ntcoveropts/cover}}{#1}[\@nt@incover]%
    \StrCount{\option{/@ntcoveropts/status}}{\option{/novathesis/docstatus}}[\@nt@instatus]%
    \StrCount{\option{/@ntcoveropts/degree}}{\option{/novathesis/docdegree}}[\@nt@indegree]%
    \ifthenelse{%
              \(\equal{\option{/@ntcoveropts/status}}{}\OR\@nt@instatus>0\)\AND
              \(\equal{\option{/@ntcoveropts/degree}}{}\OR\@nt@indegree>0\)}
      {\@nt@printcoverelement@i{#3}}%
      {}%
  }%
}

\newsavebox{\@nt@coverelement}
\newcommand{\@nt@printcoverelement@i}[1]{%
  % #1=code
  %
  % If vspace is integer then replace by \vfill
  % otherwise is absolute verstical space
  \IfInteger{\option{/@ntcoveropts/vspace}}%
    % {\ntrepeat\to{\option{/@ntcoveropts/vspace}}\do{\vfill}}%
    {\vskip 0pt plus \option{/@ntcoveropts/vspace}fill}
    {\vspace*{\option{/@ntcoveropts/vspace}}}%
  %
  % Typeset contents in a box
  \begin{lrbox}{\@nt@coverelement}
    \IfStrEq{\option{/@ntcoveropts/height}}{}%
      {\minipage[t]{\dimexpr\linewidth-\option{/@ntcoveropts/hspace}}}%
      {\minipage[t][\option{/@ntcoveropts/height}][\option{/@ntcoveropts/inalign}]{\dimexpr\linewidth-\option{/@ntcoveropts/hspace}}}%
        \IfStrEqCase{\option{/@ntcoveropts/align}}{%
          {l}{\raggedright}%
          {c}{\centering}%
          {r}{\raggedleft}%
        }%
        #1%
    \endminipage%
  \end{lrbox}
  \noindent%
  \hspace*{\option{/@ntcoveropts/hspace}}%
  \iftoggle{/novathesis/debugcover}{% IF in debug mode surround element in box
    \setlength{\fboxsep}{0pt}%
    \fbox{\usebox{\@nt@coverelement}}%
  }{\usebox{\@nt@coverelement}}%
  \par%
}

\newenvironment{tinywhite}[1][white]
  {%
    \begin{Spacing}{1}%
      \sffamily%
      \fontsize{10.01}{10.01}\selectfont%
      \hypersetup{allcolors=#1}%
      \color{#1}%
  }%
  {%
    \end{Spacing}\ignorespacesafterend%
  }

\newcommand{\@ntfixspacing}[2]{%
  \renewcommand*{\bibfont}{\hypersetup{allcolors=#1}\color{#1}%
                           \sffamily\fontsize{#2}{#2}\selectfont}
  \newrefsection%
    \begin{minipage}{\linewidth}%
      \bibfont%
      \theacknowledgmentsstr(\option{/novathesis/coverlang})%
      \vspace*{-20ex}
      \printbibliography[heading=none]%
    \end{minipage}%
  \newrefsection%
}
\newcommand{\ntfixspacing}{%
  \@ntfixspacing{white}{0.01}%
}

\newcommand*{\ntprintbackcover}{%
  \newtoggle{@nt@backcover}%
  \togglefalse{@nt@backcover}%
  \clearforchapter%
  \def\@nt@arg{back}%
  \ifaadefined{thesiscover}(\option{/novathesis/docdegree},back)%
    {\toggletrue{@nt@backcover}}{}%
  \ifoptiondefined{/@nt/cover/\option{/novathesis/school}/back}%
    {\toggletrue{@nt@backcover}}{}%
  \iftoggle{@nt@backcover}{%
    \thispagestyle{empty}%
    \newpage% \the back cover goes on the even page
    \bgroup%
      \ntaddtocover{back}{}%
      \AtCoverExecute{back}{begin}%
      \@nt@select@lang{\option{/novathesis/coverlang}}%
      \@nt@printthecover{back}%
      \AtCoverExecute{back}{end}%
    \egroup%
  }{}%
}

\newcommand{\ntcoverbackground}[1][1]{%
  \IfEq{#1}{1}{\def\@nt@arg{front}}{\def\@nt@arg{#1}}%
  \edef\@nt@img{\expanded{\thethesiscover(\option{/novathesis/docdegree},\@nt@arg)}}%
  \IfStrEq{\@nt@img}{}{}{%ELSE
    \begin{tikzpicture}[remember picture, overlay]
      \node[inner sep=0] at (current page.center)
              {\includegraphics[width=\paperwidth,height=\paperheight]{\@nt@img}};
    \end{tikzpicture}%
  }%

}

\newcommand*{\ntprintaftercover}{%
  \@nt@select@lang{\option{/novathesis/mainlang}}%
  \iftoggle{/novathesis/aftercover}%
  {%
    \InputIfFileExists{Chapters/\@nt@aftercover@file}%
      {\clearforchapter}%
      {}%
	}%
  {}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definition of associative arrays
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\@nt@undefined[1][]{\embrace{#1 \thenotdefined(\option{/novathesis/mainlang})}}

\assocarray{frontmatterstring}
\assocarray{coverstring}
\assocarray{backcoverstring}
\assocarray{copyrightstring}
\assocarray{dedicatorystring}
\assocarray{acknowledgementsstring}
\assocarray{quotestring}
\assocarray{abstractstring}
\assocarray{keywordsstring}
\assocarray{notdefined}
\assocarray{specializationstr}
\assocarray{departmentofstr}
\assocarray{sponsorsstr}

\assocarray{adviserstr}
\providecommand*{\theadviserstrfont}{}
\assocarray{coadviserstr}
\providecommand*{\thecoadviserstrfont}{}
\assocarray{degreestr}
\providecommand*{\thedegreestrfont}{}

\assocarray{degreename}

\assocarray{docdegreestr}

\assocarray{committeeorder}
\assocarray{committeetitlestr}
\providecommand*{\thecommitteetitlestrfont}{}
\assocarray{committeememberstr}
\providecommand*{\thecommitteememberstrfont}{}

\assocarray{dissertationstr}
\providecommand*{\thedissertationstrfont}{}
\assocarray{copyrighttextstr}
\assocarray{acknowledgmentsstr}

\assocarray{majorfield}
\assocarray{specialization}

\newcommand{\initassocarray}[2][\embrace{\notdefined(\option{/novathesis/coverlang})}]{
  \optionlistdo{/@nt/langsshort}{%
    \csuse{#2}(##1):={#1}%
  }%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defaults for uniersity, faculty, degree, etc…
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\assocarray{spine}
\assocarray{thesiscover}
\assocarray{margin}
\assocarray{frontpageimage}


\newcommand{\@nt@newassocarray}[1]{%
  \assocarray{#1}%
  \initassocarray[\embrace{\MakeUppercase{#1}}]{#1}%
}
\forcsvlist{\@nt@newassocarray}{university,school,department}

% --------------------------------------------------------
% Add school specific Images folder to the graphics path
% \prependtographicspath{{NOVAthesisFiles/Schools/\option{/novathesis/school}/Images/}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\gdef\thepresentationtext{%
	\thedissertationstrfont\thedissertationstr(\option{/novathesis/docdegree},\option{/novathesis/coverlang})%
}

\gdef\thecopyrightstr{%
  \thispagestyle{empty}%
  \@nt@select@lang{\option{/novathesis/copyrightlang}}%
  \currentpdfbookmark{Copyright}{bmcopyright}
  \noindent%
  Copyright \textcopyright\ \theauthorname, %
  \theschool(\option{/novathesis/copyrightlang}), \theuniversity(\option{/novathesis/copyrightlang}).\\%
  \thecopyrighttextstr(\option{/novathesis/copyrightlang})%
  \@nt@select@lang{\option{/novathesis/mainlang}}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDENTIFICATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Date and month
\newcommand{\thentdatemonth}{\@nt@undefined[Month]}
\newcommand{\thentdateyear}{\@nt@undefined[Year]}

\newcommand{\ntdatemonth}[1]{\renewcommand{\thentdatemonth}{#1}}
\newcommand{\ntdateyear}[1]{\renewcommand{\thentdateyear}{#1}}

%% Author identification
\newcommand{\theauthorname}{\@nt@undefined[Author Name]}
\newcommand{\theauthorshortname}{\@nt@undefined[Author Short Name]}
\newcommand{\theauthorgender}{\@nt@undefined[Author Gender]}
\newcommand{\theauthordegree}{\@nt@undefined[Author Degree]}

\newcommand{\ntauthorname}[3][m]{% [m|f]{Long name}{Short name}
  \renewcommand{\theauthorgender}{#1}%
  \renewcommand{\theauthorname}{#2}%
  \renewcommand{\theauthorshortname}{#3}%
  \AtBeginDocument{\hypersetup{pdfauthor={#2}}}
}

\newcommand{\ntauthordegree}[1]{%
  \renewcommand{\theauthordegree}{#1}%
}

 
%% Work identification
\newcommand{\thecovertitle}[1][]{%
  % \typeout{NT thecovertitle [#1]}
  \ifstrempty{#1}%
    {\thedoccovertitle(\option{/novathesis/coverlang})}%
    {\thedoccovertitlecaps(\option{/novathesis/coverlang})}
}

\newcommand{\thetitle}[1][\option{/novathesis/coverlang}]{%
  \thedoctitle(#1)%
}


\newcommand{\thecoversubtitle}[1][]{%
  % \typeout{NT thecovertitle [#1]}
  \ifstrempty{#1}%
    {\thedoccoversubtitle(\option{/novathesis/coverlang})}%
    {\thedoccoversubtitlecaps(\option{/novathesis/coverlang})}
}

\newcommand{\thesubtitle}[1][\option{/novathesis/coverlang}]{%
  \thedocsubtitle(#1)%
}

\assocarray{doctitle}
\assocarray{doccovertitle}
\assocarray{doccovertitlecaps}
\assocarray{docsubtitle}
\assocarray{doccoversubtitle}
\assocarray{doccoversubtitlecaps}

\def\@thetitle{}
\newcommand{\nttitle}[2][\option{/novathesis/coverlang}]{%
  % \typeout{NT nttitle [#1] [#2]}
    \saveexpandmode\noexpandarg% set \noexpandarg locally
      \StrSubstitute[0]{#2}{\\}{ }[\@thetitle]%
      \def\@thrtitleincaps{\expandafter\MakeUppercase\expandafter{#2}}%
      \StrSubstitute[0]{\@thrtitleincaps}{\\}{\newline}[\@thetitleii]%
    \restoreexpandmode% restore the previous mode
    \doccovertitle(#1):={#2}%
    \doccovertitlecaps(#1):={\@thetitleii}%
    \doctitle(#1):=\@thetitle%
    \ifoptionequal{/novathesis/coverlang}{#1}{%
      \AtBeginDocument{%
        \hypersetup{pdftitle={\@thetitle}}%
        \hypersetup{pdfsubject={\thepresentationtext}}
      }%
    }{}%
  % \typeout{NT TITLE=[#2][\@thetitle]}
}

\def\@thesubtitle{}
\newcommand{\ntsubtitle}[2][\option{/novathesis/coverlang}]{%
  % \typeout{NT nttitle [#1] [#2]}
    \saveexpandmode\noexpandarg% set \noexpandarg locally
      \StrSubstitute[0]{#2}{\\}{ }[\@thesubtitle]%
      \StrSubstitute[0]{#2}{\\}{\newline}[\@thesubtitleii]%
    \restoreexpandmode% restore the previous mode
    \doccoversubtitle(#1):={#2}%
    \doccoversubtitlecaps(#1):={\expandafter\MakeUppercase\expandafter{\@thesubtitleii}}%
    \docsubtitle(#1):=\@thesubtitle%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print option list as a comma separated list
%%% with "and" prefixing the last element
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \newcommand{\printoptionlist}[3]{%
%   % #1=options list
%   % #2=separator (e.g, ",")
%   % #3=last separator (e.g., "and")
%   \letoptionlist{#1}\@nt@list
%   \StrCount{\@nt@list}{,}[\@nt@count]
%   \ifcase\@nt@count
%     % case 0
%     #1
%   \or
%     % case 1
%     \StrSubstitute{\@nt@list}{,}{ and }
%   \else
%     % other
%     \StrSubstitute[\the\numexpr \@nt@count-1]{\@nt@list}{,}{|}[\@nt@list@i]
%     \StrSubstitute{\@nt@list@i}{,}{ #3 }[\@nt@list@ii]
%     \StrSubstitute{\@nt@list@ii}{|}{#2}
%   \fi
% }

%%%% Alternative hand-made implementation
% \newcommand{\@nt@printoptionlist}[3]{%
  % #1=options list
  % #2=separator (e.g, ",")
  % #3=last separator (e.g., "and")
%   \@nt@newcounter[1]{@ntprintoptionlist@cnt}
%   \def\@nt@comma{}%
%   \optionlistdo{#1}{%
%     \StrCut{##1}{,}\@nt@name\@nt@rest%
%     \@nt@comma\@nt@name%
%     \stepcounter{@ntprintoptionlist@cnt}%
%     \ifnum\value{\option{#1/@size}}=\value{@ntprintoptionlist@cnt}%
%       \def\@nt@comma{#3}%
%     \else%
%       \def\@nt@comma{#2}%
%     \fi%
%   }%
% }

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print advisers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintadvisersaslist}[1][adviser,coadviser]{%
  % \printoptionlist{/@nt/#1//name}{, }{ and }
  \gdef\@nt@addviserslist{}%
  \setnewcounter{@nt@advisertotal}{0}%
  \forcsvlist\@nt@getadvisername{#1}%
  \setnewcounter{@nt@advisern}{0}%
  \expandnext{\forcsvlist\@nt@printadvisersaslist}{\@nt@addviserslist}%
}

\newcommand{\@nt@getadvisername}[1]{%
  \optionlistdo{/@nt/#1//name}{%
    \StrCut{##1}{,}\@nt@tmpl\@nt@tmpr%
    \xdef\@nt@addviserslist{\@nt@addviserslist,\@nt@tmpl}%
    \stepcounter{@nt@advisertotal}%
  }%
}

\newcommand{\@nt@printadvisersaslist}[1]{%
  \stepcounter{@nt@advisern}%
  \ifnum\value{@nt@advisern}=\value{@nt@advisertotal}%
    { and }%
  \else\ifnum\value{@nt@advisern}>1%
    {, }%
  \fi\fi%
  #1%
}

\newcommand{\ntprintadvisersgroup}[2][0.90]{%
  % #1=width
  % %2={adviser,coadviser}
  \ifoptiondefined{/@nt/#2//name}{%
    \csuse{the#2strfont}%
    \csuse{the#2str}(\option{/novathesis/coverlang})\\[1ex]%
    \begin{minipage}[t]{#1\linewidth}%
      \centering
      \optionlistdo{/@nt/#2//name}{\@nt@printadvisersgroup##1,\@nil}%
    \end{minipage}%
  }%
  {}%
}

\def\@nt@printadvisersgroup#1,#2\@nil{%
  \mbox{}#1\\
  \IfStrEq{#2}{}{\medskip}{\@nt@printadvisersgroup#2\@nil}%
}

\newcommand{\ntprintadvisers}[1][0.90]{%
  \begin{minipage}{#1\textwidth}
  % #1=Percentage of \textwidth used by the advisers list
  \begin{tabularx}{\linewidth}{@{}rX@{}}%
  \forcsvlist{\@nt@printadvisergroup}{adviser,coadviser}
  \end{tabularx}%
  \end{minipage}
}

\newcommand{\@nt@printadvisergroup}[1]{%
  % #1={adviser,coadviser}
    \ifoptiondefined{/@nt/#1//name}{%
      \@nt@reducegender{/@nt/#1//gender}{\mygender}%
      \@nt@reducenumber{/@nt/#1//name}{\mynumber}%
      \medskip%
      \csuse{the#1strfont}%
      \csuse{the#1str}(\mynumber,\mygender,\option{/novathesis/coverlang}): & %
      \begin{minipage}[t]{\linewidth}\raggedright%
      \optionlistdo{/@nt/#1//name}{##1\\[0.3ex]}%
      \end{minipage}\\%
    }%
    {}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print committee
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintcommittee}[1][0.75]{\ifmaindoc{\@nt@printcommittee@i{#1}}{}}

\newcommand{\@nt@printcommittee@i}[1]{%
  \iftoggle{/novathesis/printcommittee}{% TRUE
    \begin{minipage}{#1\textwidth}%
    % #1=Percentage of \textwidth used by the committee list
    \begin{tabularx}{\linewidth}{@{}rX@{}}%
    \@ntprintcommitteetitlestr\\[1ex]%
    \forcsvlist{\@ntprintcommitteegroup}{c,r,a,m,g}%
    \end{tabularx}%
    \end{minipage}
  }%
  {%% FASLE
  }%
}

\newcommand*{\@ntprintcommitteetitlestr}{%
  % \ifx\@nt@tmp\@empty%
  \expandnext{\ifx}{\thecommitteetitlestr(\option{/novathesis/coverlang})}\@empty%
    % committeetitlestr[…] is empty
  \else%
    \multicolumn{2}{c}{{%%
            \thecommitteetitlestrfont%
            \thecommitteetitlestr(\option{/novathesis/coverlang}):}%
          }%
  \fi%
}

\newcommand{\@ntprintcommitteegroup}[1]{%
  % #1={c,r,a,m,g}
  \ifoptiondefined{/@nt/committee/#1/name}{%
    \@nt@reducegender{/@nt/committee/#1/gender}{\mygender}%
    \@nt@reducenumber{/@nt/committee/#1/name}{\mynumber}%
    \medskip%
    \thecommitteememberstrfont%
    \thecommitteememberstr(#1,\mynumber,\mygender,\option{/novathesis/coverlang}): & %
    \begin{minipage}[t]{\linewidth}\raggedright%
    \optionlistdo{/@nt/committee/#1/name}{##1\\[0.3ex]}%
    \end{minipage}\\%
  }%
  {}%
}

\newcommand*{\@nt@reducegender}[2]{%
  % #1=gender list
  % #2=result
  \gdef#2{f}%
  \optionlistdo{#1}{\if##1m\relax\gdef#2{m}\fi}%
}

\newcommand{\@nt@reducenumber}[2]{%
  % #1=number
  % #2=result
  \ifnum\value{\option{#1/@size}}=1%
    \gdef#2{1}%.
  \else%
    \gdef#2{2}%
  \fi%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include the School's defaults
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \InputIfFileExists{NOVAthesisFiles/Schools/\option{/novathesis/school}/defaults.ldf}{}{}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtEndPreamble{\typeout{NT AtEndPreamble ntsetlayout}\ntsetlayout}

\newcommand{\ntsetlayout}{%
  % \synctex=1% Use synctex
  \brokenpenalty=10000
  \settypeoutlayoutunit{mm}
  \setulmarginsandblock%
    {\themargin(\option{/novathesis/media},top)}%
    {\themargin(\option{/novathesis/media},bottom)}%
    {*}%
  \setlrmarginsandblock%
    {\themargin(\option{/novathesis/media},left)}%
    {\themargin(\option{/novathesis/media},right)}%
    {*}%
  \checkandfixthelayout%
}

%% For debugging the page layout
\newcommand\@nt@typetwolengths[4]{%
  % #1=text before
  % #2=first length
  % #3=text between
  % #4=second length
  \setlength\@tempdimc{\mem@tl@unitperpt #2}%
  \edef\l@first{\strip@pt\@tempdimc}%
  \setlength\@tempdimc{\mem@tl@unitperpt #4}%
  \edef\l@second{\strip@pt\@tempdimc}%
  #1: \l@first\mem@tl@unit\space#3\space\l@second\mem@tl@unit%
}

\newcommand\@nt@typeonelength[2]{%
  % #1=text before
  % #2=first length
  \setlength\@tempdimc{\mem@tl@unitperpt #2}%
  \edef\l@first{\strip@pt\@tempdimc}%
  #1: \l@first\mem@tl@unit%
}

\newcommand*{\typelayout}{%
  \hrule%
  \@nt@typetwolengths{Stock height and width}{\stockheight}{by}{\stockwidth}\\%
  \@nt@typetwolengths{Top and edge trims}{\trimtop}{and}{\trimedge}\\%
  \@nt@typetwolengths{Page height and width}{\paperheight}{by}{\paperwidth}\\%
  \@nt@typetwolengths{Text height and width}{\textheight}{by}{\textwidth}\\%
  \@nt@typetwolengths{Spine and edge margins}{\spinemargin}{and}{\foremargin}\\%
  \@nt@typetwolengths{Upper and lower margins}{\uppermargin}{and}{\lowermargin}\\%
  \@nt@typetwolengths{Headheight and headsep}{\headheight}{and}{\headsep}\\%
  \@nt@typeonelength{Footskip}{\footskip}\\%
  \@nt@typetwolengths{Columnsep and columnseprule}{\columnsep}{and}{\columnseprule}\\%
  \@nt@typetwolengths{Marginparsep and marginparwidth}{\marginparsep}{and}{\marginparwidth}\\%
  \@nt@typetwolengths{Sidecapsep and sidecapwidth}{\sidecapsep}{and}{\sidecapwidth}\\%
  \@nt@typetwolengths{Sidebarhsep and sidebarwidth}{\sidebarhsep}{and}{\sidebarwidth}\\%
  \@nt@typetwolengths{Sidebarvsep and sidebartopsep}{\sidebarvsep}{and}{\sidebartopsep}\\%
  \@nt@typeonelength{Sidebarheight}{\dimen\sideins}\\%
  \@nt@typetwolengths{Sidefoothsep and sidefootwidth}{\sidefoothsep}{and}{\sidefootwidth}\\%
  \@nt@typetwolengths{Sidefootvsep and sidefootheight}{\sidefootvsep}{and}{\sidefootheight}\\%
  \hrule%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fonts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\quotefont{\normalfont\normalsize}
\newcommand\quotefonti{\itshape\normalsize}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Printing chapters and similars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@ntloadfile@i}[1]{%
  % \IfFileExists{\option@listmatch@value}{%
  %   \input{\option@listmatch@value}%
  %   \typeout{NT LOADING "\option@listmatch@value" succeeded}%
  % }{%
  %   \typeout{NT LOADING "\option@listmatch@value\space" failed}%
  % }%
  % \typeout{NT TRYING TO LOAD #1}%
  \InputIfFileExists{#1}{%
    \typeout{NT LOADING “#1” succeeded}%
    % \externaldocument{#1}% from package 'xr'
  }{%
    \typeout{NT LOADING “#1” failed}%
  }
}

\newcommand{\@ntloadfiles@ii}[2][VAL]{%
  % #1=KEY
  % #2=file class
  % \options{/@nt/folders=#2}%
  % \typeout{NT ntloadfiles [#2] [#1] [/@nt/file/#2/#1]}% [\expanded{\option{/@nt/folders}}]}
  \ifoptiondefined{/@nt/file/#2/#1}%
    {\optionlistdo{/@nt/file/#2/#1}{\@ntloadfile@i{##1}}}%
    {}
}



\def\lowc{\expandafter\lowercaseA\expandafter{\iffalse}\fi}
\long\def\lowercaseA#1{\lowercase{#1}\egroup}
\def\upc{\expandafter\uppercaseA\expandafter{\iffalse}\fi}
\long\def\uppercaseA#1{\uppercase{#1}\egroup}

\newcommand{\@nt@printifmaindoc@i}[1]{%
  % \typeout{NT Attempt to load #1}%
	\ifmaindoc{% THEN it is a main document
    \ifoptiondefined{/@nt/file/#1/VAL}{%
      \@nt@select@lang{\option{/novathesis/mainlang}}%
      \currentpdfbookmark{\csuse{the#1string}(\option{/novathesis/mainlang})}{bm#1}
      \@ntloadfiles@ii{#1}%
      \clearforchapter%
    }{\typeout{NT LOAD #1 undefined}}%
	}{% ELSE
    % It is a plan or proposal type document
	}%  
}

\newcommand{\ntprintdedicatory}{\@nt@printifmaindoc@i{dedicatory}}

\newcommand{\ntprintquote}{\@nt@printifmaindoc@i{quote}}

\newcommand{\ntprintacknowledgements}{\@nt@printifmaindoc@i{acknowledgements}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Abstract, Acronyms and Glossary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintabstracts}{%
  \xdef\@nt@tmp{\theabstractorder(\option{/novathesis/mainlang})}%
  \expandnext{\forcsvlist{\@ntprintabstract}}{\@nt@tmp}%
  \@nt@select@lang{\option{/novathesis/mainlang}}%  
}

\newcommand{\@ntprintabstract}[1]{%
  % \typeout{NT PRINT ABSTRACT #1}%
  \setabstractlang{#1}%
  \currentpdfbookmark{\theabstractstring(#1)}{bmabstract#1}
  \printabstracttitle{#1}%
  \NTRunHook{abstract/pre}%
  \@ntloadfiles@ii[#1]{abstract}%
  \NTRunHook{abstract/post}%
  \clearforchapter%
}


\newcommand{\thesisfrontmatter}{%
  \frontmatter%
  \@nt@select@lang{\option{/novathesis/mainlang}}%
  \pagenumbering{roman}%
  % \setlength{\headheight}{15pt}%
}

\newcommand{\ntthesismainmatter}{%
  % enables protrusion locally for the remainder of the document
  \ifxeorlua{}{\microtypesetup{protrusion=true}}%
	\mainmatter%
	\pagenumbering{arabic}%
	\setlength{\headheight}{15pt}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntchapterfile}[1]{\listgadd{\@nt@chapter@list}{#1}}


\newcommand{\ntprintchapters}{%
    \@nt@foralllist{file}{chapter}{\@ntloadfiles@ii{chapter}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Appendixes and Annexes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\addappheadtotoc}{%
  \phantomsection
  \addtocontents{toc}%
    {\protect\contentsline{chapter}{\appendixtocname}{}{}}%
 }

\newcommand{\ntprintappendixes}{%
  \renewcommand{\appendixtocname}{\appendixnamepl}%
  \clearforchapter\appendix\addappheadtotoc%
  \@nt@foralllist{file}{appendix}{\@ntloadfiles@ii{appendix}}%
}

\newcommand{\ntprintannexes}{%
  \renewcommand{\appendixtocname}{\annexnamepl}%
  \clearforchapter\annex\addappheadtotoc%
  \@nt@foralllist{file}{annex}{\@ntloadfiles@ii{annex}}%
}


\newcommand{\annex}{
  \xdef\Hy@chapapp{annex}%
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\annexname}%
  \gdef\thechapter{\@Roman\c@chapter}%
  }



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with optional lists in the frontmatter: listoftables, litoffigures, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \newlistof{lstlistoflistings}{lol}{\lstlistlistingname}


\newcommand{\ntaddindex}[1]{%
  \ifthenelse{\equal{#1}{tableofcontents}}{\options{/@nt/list/indexes/.cpush={%
        \clearforchapter%
        \iftoggle{/novathesis/tocintoc}{%
            \tableofcontents%
        }{%
            \phantomsection%
            \pdfbookmark{\contentsname}{toctarget}%
            \hypertarget{toctarget}{\tableofcontents*}
        }%
  }}}{%
    \ifthenelse{\equal{#1}{listsofglossaries}}{\options{/@nt/list/indexes/.cpush={%
            \clearforchapter\printnoidxglossaries\clearforchapter%
    }}}{%
      \options{/@nt/list/indexes/.cpush={\clearforchapter\csuse{#1}}}
    }%
  }%
}

\newcommand{\ntprintallindexes}{\optionlistdo{/@nt/list/indexes}{##1}}


% \def\option@listmatch@getval#1=#2{#2}
\newcommand*{\option@listmatch}[2]{
  % \typeout{NT LISTMATCH [#1] [#2]}%
  \StrCut{#2}{=}\option@listmatch@key\option@listmatch@value%
  % \typeout{K=\option@listmatch@key ~V=\option@listmatch@value}
  \ifthenelse{\equal{\option@listmatch@key}{#1}}{\listbreak}{}%
}%
\options{/handlers/getval/.new operation={%
  % \typeout{NT GETVAL [#1] [#2]}%
    \optionlistdo{#1}{\option@listmatch{#2}{##1}}%
  }%
}

\newcommand{\@loadglossaryfiles}{%
  \optionlistdo{/@nt/file/glossaries/glossary}{\@ntloadfile@i{##1}}%
  \optionlistdo{/@nt/file/glossaries/acronyms}{\@ntloadfile@i{##1}}%
  \optionlistdo{/@nt/file/glossaries/symbols}{\@ntloadfile@i{##1}}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\ntprintbib}[1][]{%
  \printbibliography[#1]%
  \ntfixspacing%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintcopyright}{%
	\ifmaindoc{% THEN
    \iftoggle{/novathesis/printcopyright}%
      {\ntprintcopyrightpage\clearforchapter}%
      {}%
	}{}%
}

\newcommand{\ntprintcopyrightpage}{%
	\clearforchapter%
	\null\vfill%
  \noindent%
  \textbf{\large\thetitle}\par%
  \bigskip%
  \thecopyrightstr\par%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dedicatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewEnviron{ntdedicatory}{
  \thispagestyle{empty}%
  ~\\[2cm]%
  \begin{minipage}{\linewidth}%
    \raggedleft%
    \begin{minipage}{100mm}%
      \raggedleft%
      \quotefonti%
      \BODY
      \normalfont%
    \end{minipage}%
  \end{minipage}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quote
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewEnviron{ntquote}{%%
  \thispagestyle{empty}%
  ~\\[2cm]%
  \begin{minipage}{\linewidth}%
    \raggedleft%
    \begin{minipage}{100mm}%
      \raggedleft
      \quotefonti%
      \BODY%
      \normalfont%
    \end{minipage}%
  \end{minipage}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewEnviron{ntacknowledgements}{%
  \chapter*{\theacknowledgementsstring(\option{/novathesis/mainlang})}%
  \BODY
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@nt@keywordsstr}{}
\newcommand{\setabstractlang}[1]{%
	\@nt@select@lang{#1}%
  \renewcommand{\@nt@keywordsstr}{\thekeywordsstring(#1)}%
}
\newcommand{\printabstracttitle}[1]{%
	\chapter*{\theabstractstring(#1)}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newtoggle{@nt@keywords@defined}
\togglefalse{@nt@keywords@defined}
\NewEnviron{keywords}[1][\option{/@nt/langshorttolong}]{%
  \csdef{@nt@keywords@#1}{\BODY}
  \iftoggle{@nt@keywords@defined}%
    {}%
    {\hypersetup{pdfkeywords={\BODY}}}
  \par\vskip\baselineskip\noindent{\bfseries\@nt@keywordsstr: }%
  \BODY%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Table of contents
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setcounter{tocdepth}{2}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sectioning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\maxsecnumdepth{subsubsection}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fixes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fix spacing for pages with roman numerals in ToC
\renewcommand{\@pnumwidth}{2.5em}% default is 1.55em


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Text style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% \AtEndPreamble{%
  % \typeout{NT AtEndPreamble loading chapstyle and fontstyle}
\InputIfFileExists{NOVAthesisFiles/ChapStyles/\option{/novathesis/chapstyle}.ldf}{}{}%
\InputIfFileExists{NOVAthesisFiles/FontStyles/\option{/novathesis/fontstyle}.ldf}{}{}%
% }


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compatibility with legacy “template.tex”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Title
\renewcommand{\title}[2][]{\ifthenelse{\isempty{#1}}{\nttitle{#2}}{\nttitle{#1}}}
\newcommand{\authorname}{\ntauthorname}
\newcommand{\authordegree}{\ntauthordegree}
\newcommand{\datemonth}{\ntdatemonth}
\newcommand{\dateyear}{\ntdateyear}
\newcommand{\adviser}[4][m]{\ntaddperson{adviser}[#1]{#2, #3}}
\newcommand{\coadviser}[4][m]{\ntaddperson{coadviser}[#1]{#2, #3}}
\newcommand{\committee}[2][m]{\ntaddperson{committee}[#1]{#2}}
\newcommand{\dedicatoryfile}[1]{\ntaddfile{dedicatory}{#1}}
\newcommand{\acknowledgementsfile}[1]{\ntaddfile{acknowledgements}{#1}}
\newcommand{\quotefile}[1]{\ntaddfile{quote}{#1}}
\newcommand{\aftercoverfile}[1]{\ntaddfile{aftercover}{#1}}
\newcommand{\abstractfile}[2][pt]{\ntaddfile{abstract}[#1]{#2}}
\newcommand{\chapterfile}[1]{\ntaddfile{chapter}{#1}}
\newcommand{\addbibfile}[1]{\ntaddfile{bib}{#1}}
\newcommand{\glossaryfile}[1]{\ntaddfile{glossaries}[glossary]{#1}}
\newcommand{\acronymsfile}[1]{\ntaddfile{glossaries}[acronyms]{#1}}
\newcommand{\symbolsfile}[1]{\ntaddfile{glossaries}[symbols]{#1}}

