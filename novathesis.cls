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
%% Version 2024-11-03 [7.2.5]
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
%%          https://www.facebook.com/groups/novathesis
%%      or in the subreddit r/novathesis
%%          https://www.reddit.com/r/novathesis/
%%
%% AUTHOR @github:
%%      - joaomlourenco
%%
%% CONTRIBUTORS @github:
%%      https://github.com/joaomlourenco/novathesis/wiki#help-with-the-project-patches-and-new-features
%%
%% DONATIONS:
%%      If you think this template really helped you while writing your thesis, then
%%          1. Go to the project web page and giv it a star (on the top-right)
%%          2. Make a small donation using the URL below
%%                    https://www.paypal.com/donate/?hosted_button_id=8WA8FRVMB78W8
%%             We will keep a list thanking to all the identified donors that identify
%%             themselves in the “Add special instructions to the seller:” box.
%%
%% CITATION:
%%      If you use this template, please be kind and \cite{novathesis-manual} somewhere in your document.
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


\ProvidesClass{novathesis}[2024-11-03 novathesis template]
\NeedsTeXFormat{LaTeX2e}[2020-02-02]


%============================================================
% Save these definitions asap, to be used later in the “\annex” command,
% because "\@Roman" and "\Roman" were failing with pdflatex
% when loading the "greek" language (and LGR font encofing)
%============================================================
\let\oldRoman=\Roman
\let\old@Roman=\@Roman


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  MEMOIR CUSTOMIZATION AND LOADING
%%      Please open and edit the appropriate
%%       configuration file “Config/0_memoir.tex”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntmemoirsetup}[1]{\PassOptionsToClass{#1}{memoir}}
\input{Config/0_memoir}
\LoadClass{memoir}
\OnehalfSpacing% One-and-half spacing

\newcolumntype{L}{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}X}
\newcolumntype{C}{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}X}
\newcolumntype{R}{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}X}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SOME ESSENTIAL PACKAGES
%%    Others will be loaded later, in the file “packages.tex”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[table,svgnames]{xcolor}%
% \RequirePackage{tabularray}
% \UseTblrLibrary{booktabs}


\ifdefined\NewDocumentCommand\else\RequirePackage{xparse}\fi   % load xparse if necessary
\RequirePackage{xfor}
\RequirePackage{iftex}
\RequirePackage{etoolbox}
\RequirePackage{xstring}
\RequirePackage{varwidth}
\RequirePackage{NOVAthesisFiles/memory2}
\RequirePackage{NOVAthesisFiles/nt-version}


%%%%% Configure Graphics
\RequirePackage[nobeamer]{graphbox}% improved version of "graphicx"
\graphicspath{{Chapters/Figures/}}
\DeclareGraphicsExtensions{.pdf,.png,.tif,.jpg}
\providecommand*\appendtographicspath[1]{\xappto\Ginput@path{#1}}
\providecommand*\prependtographicspath[1]{\xpreto\Ginput@path{#1}}

%%%%% Options to sans serif fonts (will be loaded later)
\PassOptionsToPackage{scaled=0.95}{inter}
\PassOptionsToPackage{scaled=0.95}{helvet}
\PassOptionsToPackage{scaled=0.95}{gillius2}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with NOVATHESIS options and configuration files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{NOVAthesisFiles/options2}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PACKAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@nt@saveabstractorder{}
\newcommand{\@setabstractorder}{%
  % \typeout{SAVEABSORDER=[\@nt@saveabstractorder]}\SAVEABSORDER%
  \StrGobbleRight{\@nt@saveabstractorder}{1}[\@nt@saveabstractorder]%
  \@for\myi:=\@nt@saveabstractorder\do{%
    \StrCut{\myi}{=}\@nt@key\@nt@val%
    \IfStrEq{\@nt@val}{}{\edef\@nt@val{\@nt@key}\def\@nt@key{\@LANG@MAIN}}{}%
    % \typeout{SETABSORDER (\@nt@key):=[\@nt@val]}\SETABSORDER%
    \abstractorder(\@nt@key):={\@nt@val}%
  }%
}


% --------------------------------------------------------
% Search if a data/memory is defined and returns value
\def\datamatch#1#2(#3){%
  % #1 = macro to set
  % #2 = data@memory
  % #3 = list of values
  % Search and match first value from the list, error if no match is found
  \datamatchtf{#1}{#2}(#3){}{\ClassError{novathesis}{Could not find “#2” defined with any of “(#3)”!}{}}%
}

\def\datamatchtf#1#2(#3)#4#5{%
  % #1 = macro to set
  % #2 = data@memory
  % #3 = list of values
  % #4 = true branch
  % #5 = false branch
  % Search and match first value from the list, true (found) and not true (not found) branches
  % \typeout{#2(#3)}%
  % \ifdatadefinedor{\@match}{#2}(#3)%
  %   {\protect\gdef#1{\csuse{the#2}(\@match)}#4}%
  %   {\protect\gdef#1{}#5}%
  \ifdatadefinedor{\@match}{#2}(#3)%
    {\protect\xdef#1{\expanded{\csuse{the#2}(\@match)}}#4}%
    {\protect\xdef#1{}#5}%
}


\newdata{validprocessor}
\validprocessor(uminho):={lua,xe}
% \validprocessor(nova/itqb):={pdf,lua}
\validprocessor(other/esep):={xe,lua}
\newcommand{\@validate@ltx@processor}[3]{%
% 1 = UNIV
% 2 = SCHL
% 3 = DGR
  % \typeout{@validate@ltx@processor U=[#1] S=[#2] D=[#3]}\@VALIDATE@PROCESSOR
  \newif\ifvalidprocessor%
  \validprocessorfalse%
  \datamatchtf{\@ltxproc}{processor}({#1/#2/#3},{#1/#2},{#1}){% LISTED
    \@validate@ltx@processor@i(\@ltxproc)%
  }{% UNLISTED
    \validprocessortrue%
  }%
  % \ifdatadefined{processor}(#1/#2){\@validate@ltx@processor@i{\thevalidprocessor(#1/#2)}}{%
  % \ifdatadefined{processor}(#1){\@validate@ltx@processor@i{\thevalidprocessor(#1)}}{%
  %   \validprocessortrue%
  % }}%
  \ifvalidprocessor\else\ClassError{novathesis}{\pdfprocessor: Invalid processor for “#1/#2”.}{}\fi%
}
\newcommand{\@validate@ltx@processor@i}[1]{%
% 1 = list of acceptable processors
  \@for\myi:=\expanded{#1}\do{%
    % \typeout{@validate@ltx@processor@i 1=[\myi]}\@VALIDATE@PROCESSOR@I
    \IfStrEqCase{\myi}{%
      {pdf}{\ifpdftex\validprocessortrue\fi}%
      {lua}{\ifluatex\validprocessortrue\fi}%
      {xe}{\ifxetex\validprocessortrue\fi}%
    }[\ClassError{novathesis}{Invalid processor type “\myi”}{}]%
  }%
}
\newcommand{\pdfprocessor}{%
  \ifpdftex pdf(la)tex\fi%
  \ifluatex lua(la)tex\fi%
  \ifxetex xe(la)tex\fi%
}

\options{/novathesis/.new family,
  % DOCUMENT
  doctype/.new choice           = {phd, phdprop, phdplan, msc, mscplan, bsc, plain},
  docstatus/.new choice         = {unset, working, provisional, final}, % in not defined by user, unset will be replaced  “working”
  media/.new choice             = {screen, paper},
  spine/layout/.new choice      = {unset, no, full, trim},
  spine/width/.new length       = {0pt},
  % abstract/deforder/.new choice = {default={\@LANG@MAIN,en}, en={en,pt}},
  % abstract/theorder/.new list   = {unset},
  abstractorder/.new cmd        = {\appto\@nt@saveabstractorder{{#1},}},%
  % SCHOOL
  schoolgiven/.new value        = {},
  school/.new cmd               = {\optionsalso{/novathesis/schoolgiven=#1}%
                                   \StrCut{#1}{/}\@UNIV\@SCHL\StrCut{\@SCHL}{/}\@SCHL\@DEGREEACR%
                                   \@validate@ltx@processor{\@UNIV}{\@SCHL}{\@DEGREEACR}},
  school                        = nova/fct,
  % STYLES
  style/chapter/.new value      = bar,
  style/font/.new value         = newpx,
  style/url/.new cmd            = {\AfterPreamble{\urlstyle{#1}}},
  color/links/.new cmd          = {\@ifpackageloaded{hyperref}%
                                            {\hypersetup{allcolors=#1}}%
                                            {\PassOptionsToPackage{allcolors=#1}{hyperref}}},
  color/gls/.new cmd             = {\AtEndPreamble{%\textcolor{#1}{##1}
                                      \IfStrEq{#1}{None}{%
                                          \let\@glslink\glsplainhyperlink%
                                      }{%
                                          \renewcommand*{\glstextformat}[1]{\textcolor{#1}{##1}}%
                                      }%
                                   }},
  % LANGUAGES
  lang/extra/.new list           = {},
  lang/main/.new choice         = {en, pt, fr, it, de, es, gr},
  lang/cover/.new choice        = {en, pt, fr, it, de, es, gr},
  lang/copyright/.new choice    = {en, pt, fr, it, de, es, gr},
  lang/.new cmd                 = {\optionsalso{/novathesis/lang/main=#1,
                                                /novathesis/lang/cover=#1,
                                                /novathesis/lang/copyright=#1}},
  lang                          = en,
  % PRINT ON/OFF
  print/committee/.new toggle   = false,
  print/adviser/.new toggle     = true,     % fake option - adviser should always be printed
  print/frontmatter/.new toggle = true,
  print/secondcover/.new toggle = false,
  print/copyright/.new toggle   = true,
  print/timestamp/.new toggle   = true,
  print/index/.new toggle       = false,
  print/webography/.new value   = {},        % empty means do not make a separate webography
  print/statement/.new toggle   = false,
  % MISC
  countsecondcover/.new toggle  = false,
  numberallpages/.new toggle    = false,
  gnumberlist/.new toggle       = true,
  tocintoc/.new toggle          = false,
  % DEBUG
  debug/.new list               = {},         % cover, index
% SCHOOL specific customization
% NOVA/FCT
  nova/fct/company/logo/.new value              = {},
  nova/fct/company/name/.new value              = {},
% NOVA/IMS
  nova/ims/sdg/.new list                       = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17},
% NOVA/ITQB
  nova/itqb/cover/color/.new choice            = {gray, green},
% UMINHO
  uminho/copyrightmodifier/.new choice         = {by-nc-sa, by-sa, by, by-nc, by-nd, by-nc-nd},
  uminho/skipblankcovers/.new toggle           = false,
  uminho/signatureline/.new toggle             = true,
% ULISBOA/FMV
  ulisboa/fmv/scientificarea/.new choice       = {C, MF, PASA, SA},
  ulisboa/fmv/embargo/period/.new choice       = {I, 6, 12},
  ulisboa/fmv/embargo/justification/.new value = {Justification for the temporary embargo.},
  ulisboa/fmv/reproduction/.new choice         = {I, P, N},
% ULISBOA/IST
  ulisboa/ist/classification/.new value = {},
  ulisboa/ist/funding/.new value        = {},
}

\newcommand{\@splitdate}[4]{%
  % \typeout{PROCESSDATE 1=#1}\PROCESSDATE%
  \StrCut{#1}{-}#2\@daterest%
  \StrCut{\@daterest}{-}#3#4%
  % \typeout{PROCESSDATE 1=#1 Y=#2 M=#3 D=#4}\PROCESSDATEYMD%
}

\newcommand{\printmonth}[1]{%
  \IfInteger{#1}{\pgfcalendarmonthname{#1}}{#1}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\instring#1#2{TT\fi\begingroup
  \edef\x{\endgroup\noexpand\in@{#1}{#2}}\x\ifin@}

% --------------------------------------------------------
% The NOVAthesis logo
\def\novathesisimg{\includegraphics[height=1.1\fontcharht\font`A,vshift=-0.35pt]{NOVAthesisFiles/Images/novathesis-text}}
\def\novathesistxt{\textsl{novathesis}}
\ifdef{\iftutex}
    {\newcommand{\novathesis}{\novathesisimg}}
    {\newcommand{\novathesis}{\novathesistxt}}

% --------------------------------------------------------
% Define something (except counters) if undefined
\newcommand*{\defifundef}[2]{\ifundef{#1}{#2{#1}}{}}

% --------------------------------------------------------
% Variant of \@for with an optional final argument, that is
% executed iif the loop is not interrupted
\def\ntforbreak{\@endfortrue}
\long\def\ntfor#1:=#2\do#3{\@ifnextchar[{\ntfor@i#1:=#2\do#3}{\ntfor@i#1:=#2\do#3[]}}
\long\def\ntfor@i#1:=#2\do#3[#4]{%
  \@for#1:={#2}\do{\xdef#1{#1}#3}%
  \if@endfor\else#4\fi
}

% --------------------------------------------------------
% Print string between <...>
\newcommand*{\embrace}[1]{#1}
% \newcommand*{\embrace}[1]{$\langle$#1$\rangle$}

% --------------------------------------------------------
% Check if a font file exists
\newcommand*{\ntcheckfont}[2]{%
  \IfFileExists{NOVAthesisFiles/FontStyles/Fonts/#1}{}%
    {\ClassError{novathesis}{Missing font “#1”! Please download from: “#2” and copy it to “NOVAthesisFiles/FontStyles/Fonts/#1”}{Please download from: “#2” and copy it to “NOVAthesisFiles/FontStyles/Fonts/#1”}}%
}


% --------------------------------------------------------
% Load and Helvetica-like font as the default SF font
\newcommand*{\LoadHelveticaLikeFont}{%
  \IfFileExists{inter.sty}%
    {\RequirePackage{inter}}%
  {\IfFileExists{helvet.sty}%
    {\RequirePackage{helvet}}%
  {\IfFileExists{gillius2.sty}%
    {\RequirePackage{gillius2}}%
    {\ClassWarning{novathesis}{Could not find a suitable Sans Serif font… using the default!}}}}%
}

% --------------------------------------------------------
% Trim spaces around argument
\ExplSyntaxOn
\cs_new_eq:NN \trimspaces \tl_trim_spaces:n
\cs_new_eq:NN \MyUppercase \text_uppercase:n
\ExplSyntaxOff

% --------------------------------------------------------
% Change main font size on the fly
\newcommand{\setmemoirfontsize}[1]{\input{mem#1.clo}}

% --------------------------------------------------------
% Input the first file from the list (if any)
% #1 = file name
% #2 = list of directories
% #3 = code if succeed [OPTIONAL]
% #4 = code if fails [OPTIONAL]
\def\@nt@InputIfFileExists#1#2{%
  % \typeout{IIFE 1=[#1] 2=[#2]}\aaaa
  \@ifnextchar[{\@nt@InputIfFileExists@i{#1}#2}{\@nt@InputIfFileExists@i{#1}#2[]}%
}
\def\@nt@InputIfFileExists@i#1#2[#3]{%
  % \typeout{INPUTIFFILEEXISTS 1=[#1] 2=[#2] 3=[#3]}\INPUTIFFILEEXISTS
  \@ifnextchar[{\@nt@InputIfFileExists@ii{#1}#2[#3]}{\@nt@InputIfFileExists@ii{#1}#2[#3][]}%
}
\def\@nt@InputIfFileExists@ii#1#2[#3][#4]{
  % \typeout{IIFE 1=[#1] 2=[#2] 3=[#3] 4=[#4]}\aaaa
  \ntfor\dir:=#2\do{\IfFileExists{\dir#1}{\input{\dir#1}#3\ntforbreak}{}}[#4]%
}


\options{/@nt/.new family,
  lang/short/.new list={en, pt, fr, it, de, es, gr},
  % lang/current/.new choice={en, pt, fr, it, de, es, gr},
  lang/loaded/.new list={},
  % lang/shorttolong/.new choice={en=english, pt=portuguese, fr=french, it=italian, de=german, es=spanish, gr=greek},
  fontenc/.new choice={en=T1, pt=T1, fr=T1, it=T1, de=T1, es=T1, gr=LGR},
}

\newdata{langlong}
\langlong(en):={english}
\langlong(pt):={portuguese}
\langlong(fr):={french}
\langlong(it):={italian}
\langlong(de):={german}
\langlong(es):={spanish}
\langlong(gr):={greek}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE FOLDERS PER CLASS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/folders/.new choice={
  bib=Bibliography,
  copyright=.,
  statement=.,
  dedicatory=Chapters,
  acknowledgements=Chapters,
  quote=Chapters,
  abstract=Chapters,
  glossaries=Chapters,
  chapter=Chapters,
  appendix=Chapters,
  annex=Chapters,
  cover=Chapters,
}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE DOCUMENT CLASSES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/document/.cd,
   docclass/.new choice={phd=phd, phdprop=phd, phdplan=phd, msc=msc, mscplan=msc, bsc=bsc, plain=plain},
   docmain/.new list={phd, msc, bsc, plain},
}

% --------------------------------------------------------
% Check if the document is of a specific class, i.e., bsc, msc, phd or main
\newcommand{\ifdocclass}[1]{\ifoptionequal{/@nt/document/docclass}{#1}}
\newcommand{\ifmaindoc}{\ifoptioncontains{/@nt/document/docmain}{\@DOCTYPE}}
\newcommand{\ifphddoc}{\ifdocclass{phd}}
\newcommand{\ifmscdoc}{\ifdocclass{msc}}
\newcommand{\ifbscdoc}{\ifdocclass{bsc}}
\newcommand{\ifplaindoc}{\ifdocclass{plain}}

\newcommand{\ifdocstatus}[1]{\ifoptionequal{/novathesis/docstatus}{#1}}
\newcommand{\ifdocfinal}{\ifdocstatus{final}}
\newcommand{\ifdocprovisional}{\ifdocstatus{provisional}}
\newcommand{\ifdocworking}{\ifdocstatus{working}}
\newcommand{\ifdocunset}{\ifdocstatus{unset}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE PERSON LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ntaddperson#1(#2,#3)#4{%
  % syntax: \ntaddperson{class}[key,gender]{filename}
  % #1=adviser | committee
  % #2={a,c}            {c,r,a,m,g}
  %     a=adviser        c=chair
  %     c=coadviser      r=rapporteur/referee
  %                      a=adviser
  %                      ca=adviser
  %                      m=other members
  %                      g=guests
  % #3={m,f}
  % #4={person name, position, etc}
  % \typeout{NTADDPERSON 1=[#1] 2=[#2] 3=[#3] 4=[#4]}\NTADDPERSON%
  \noexpandarg
  \StrCut{#4}{,}\@nt@personname\@nt@dummy%was xStrCut
  \options{/@nt/#1/#2/name/.expanded/.newpush={\@nt@personname},
           /@nt/#1/#2/full/.expanded/.newpush={#4},
           /@nt/#1/#2/gender/.newpush={#3}}%
  % \typeout{NTADD [/@nt/#1/#2/name=\@nt@personname]}%
  \fullexpandarg
}

\def\ntresetperson#1(#2,#3){%
  % #1 = class
  \option@setnil{/@nt/#1/#2/name}%
  \option@setnil{/@nt/#1/#2/full}%
  \option@setnil{/@nt/#1/#2/gender}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE FILE LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntaddfile}[1]{%
  % syntax: \ntaddfile{class}[key]{filename}
  %         #1=file family (quote, abstract, chapter, etc)
  %         #2=[file lang] (OPTIONAL)
  %         #3=filename
  \@nt@addtolist{file}{#1}%
}

\newcommand*{\@nt@addtolist}[2]{%
  % syntax: \ntaddto{type}{class}[key]{filename}
  %         #1 ={file, person}
  %         #2=family {quote, abstract, chapter, etc} or {author, adviser, committee}
  %         #3=[file lang] (OPTIONAL)
  %         #4=filename
  \@ifnextchar[{\@nt@addtolist@iv[#1]#2}{\@nt@addtolist@iv[#1]#2[\option{/novathesis/doctype}]}%
}

\def\@nt@addtolist@iv[#1]#2[#3]#4{%
  % syntax: \@ntaddfile@iii{type}{class}[key]{filename}
  %         #1 ={file, person}
  %         #2=file family (quote, abstract, chapter, etc)
  %         #3=optional file lang
  %         #4=filename
  % \typeout{NT ADDTOLIST [#1] [#2] [#3] [#4]}%
  \StrLeft{#4}{1}[\@nt@firstchar]%
  \IfStrEqCase{\@nt@firstchar}{%
    {/}{\xdef\@nt@filewithpath{#4}}%
    {.}{\xdef\@nt@filewithpath{#4}}%
  }[%
    \options{/@nt/folders=#2}%
    \xdef\@nt@filewithpath{\option{/@nt/folders}/#4}%
  ]%
  \@for\myi:=\expanded{#3}\do{%
    % \typeout{NT ADDTOLIST [#1] [#2] [#3] [#4]}%
    \options{/@nt/#1/#2/\myi/.expanded/.newpush={\@nt@filewithpath}}%
  }%
}

\newcommand*{\@nt@foralllist}[3]{%
  % #1={file, person}
  % #2=file family (quote, abstract, chapter, etc)
  % #3=macro to be applied, which will receive the item from the list
  \optionlistdo{/@nt/#1/#2}{#3{##1}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Multilingual support
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntselectlang}[1]{%
  % #1=lang {pt, en, fr, it}
  \gdef\@LSHORT{#1}%
  \xdef\@LLONG{\thelanglong(#1)}%
  % \typeout{NTSELECTLANG [#1 / \@LLONG]}%
  \expandnext{\selectlanguage}{\@LLONG}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ASSOCARRAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\initmemory}[2][\embrace{\thenotdefined(\@LANG@COVER)}]{%
  \optionlistdo{/@nt/lang/short}{\csuse{#2}(##1):={#1}}}


% For PDF bookmakrs
\newdata{bkmstring}


\newdata{notdefined}
\newdata{keywordsenvpre}
\newdata{keywordsenvpost}
\newdata{keywordsblockpre}
\newdata{keywordsblockpost}
\newdata{keywordspre}
\newdata{keywordssep}
% \newdata{keywordsboxlen}
\newdata{keywordsstring}
\newdata{keywordsstringprefix}
\newdata{keywordsstringsuffix}
\newdata{keywordsstringfont}
\keywordsblockpre()={\bigskip\noindent}
\keywordsstringsuffix()={:\enspace}
\keywordsstringfont()={\bfseries}
% \keywordssep()={\ \textbf{\Large\textperiodcentered}\ }
\keywordssep()={, }
% \keywordsboxlen()={\textwidth-\widthof{\usebox{\keywordsstringbox}}}

\newdata{specializationstring}
\newdata{departmentofstring}
\newdata{sponsor}
\newdata{andstring}
\newdata{commastring}
\optionlistdo{/@nt/lang/short}{%
  \commastring(#1):={,\ }%
}


\newdata{degreestring}
\newdata{degreestringfont}

\newdata{degreename}
\newdata{degreenamefont}

\newdata{degreenameprefix}
\newdata{degreenameprefixfont}

\newdata{doctypestring}
\newdata{doctypestringfont}



\newdata{adviserstring}            % e.g., "Adviser", "Co-adviser"
\newdata{adviserstringfont}
\newdata{adviserstringpre}
\newdata{adviserstringpost}

\newdata{advisernamepre}
\newdata{advisernamepost}
\newdata{advisernamefont}

\newdata{adviserremainderpre}
\newdata{adviserremainderpost}
\newdata{adviserremainderfont}
\adviserremainderfont()={\itshape\scriptsize}

% Committee stuff
\newdata{adviserorder}         %e.g., "{a,c}"
\adviserorder():={a,c}  % By default print advisers and co-advisers
\newdata{committeeorder}         %e.g., "{c,r,a,m,g}"

\newdata{committeetitlestring}      %e.g., "Examinaiton Committee"
\newdata{committeetitlestringpre}
\newdata{committeetitlestringpost}
\newdata{committeetitlestringfont}

\newdata{committeestring}
\newdata{committeestringpre}
\newdata{committeestringpost}
\newdata{committeestringfont}

\newdata{committeenamepre}
\newdata{committeenamepost}
\newdata{committeenamefont}

\newdata{committeeremainderpre}
\newdata{committeeremainderpost}
\newdata{committeeremainderfont}
\committeeremainderfont()={\itshape\scriptsize}

\newdata{personpre}
\newdata{personpost}
\newdata{persongrouppre}
\newdata{persongrouppost}

\newdata{dissertationstring}
\newdata{dissertationstringfont}

\newdata{copyrighttextstring}
\newdata{acknowledgmentsstring}

\newdata{majorfield}
\newdata{minorfield}
\newdata{specialization}

\newdata{spine}
\newdata{thesiscover}
\newdata{margin}
\newdata{frontpageimage}

% \newcommand*{\@nt@newmemory}[1]{%
%   \newdata{#1}%
%   % \initmemory[\embrace{\MakeUppercase{#1}}]{#1}%
% }
% \forcsvlist{\@nt@newmemory}{university,school,department}
\newdata{university}
\newdata{school}
\newdata{department}

\newdata{doctitle}


% For each main language, list which abstracts shall be printed and in which order
% may have more than two (just be sure you include the languages above as well)
\newdata{abstractorder}





% --------------------------------------------------------
% PROCESSING CLASS OPTIONS
\options@ProcessOptions{/novathesis}
% --------------------------------------------------------
% NTSETUP2
\newcommand*{\ntsetup}[2][]{%
  % \typeout{NTSETUP [/novathesis/\@UNIV/\@SCHL/#1/#2]}\NTSETUP%
  \ntfor\arg:={#2}\do{%
    \StrCut{\arg}{=}{\@ntopt}{\@ntval}%
    % \typeout{NTSETUP2 [\@ntopt] = [\@ntval]}%
    \ifoptiondefined{/novathesis/\@UNIV/\@SCHL/#1/\@ntopt}%
                    {\options{/novathesis/\@UNIV/\@SCHL/#1/#2}}{%
    \ifoptiondefined{/novathesis/#1/\@ntopt}%
                    {\options{/novathesis/#1/#2}}{%
    \ifoptiondefined{/novathesis/\@UNIV/\@SCHL/\@ntopt}%
                     {\options{/novathesis/\@UNIV/\@SCHL/#2}}{%
    \ifoptiondefined{/novathesis/\@UNIV/\@ntopt}%
                     {\options{/novathesis/\@UNIV/#2}}{%
    \ifoptiondefined{/novathesis/\@ntopt}%
                    {\options{/novathesis/#2}}{%
    \ClassError{novathesis}{Invalid class option: \@ntopt}{}{}}}}}}}%
}

\newcommand*{\ntbibsetup}[1]{%
  \@ifpackageloaded{biblatex}{\ClassError{novathesis}{Please load biblatex options earlier.}{}}{\PassOptionsToPackage{#1}{biblatex}}%
}

\newcommand*{\NTAddToHook}[2]{\options{/@nt/hook/#1/.newpush={#2}}}

\newcommand*{\NTRunHook}[1]{\optionlistdo{/@nt/hook/#1}{##1}}

% \newcommand*{\NTIfHook}[1]{%
%   \ifoptiondefined{/@nt/hook/#1}%
% }


% --------------------------------------------------------
% Pass the remaining options to memoir
% \letoptionlist{/options/remaining}\nt@remaining
% \PassOptionsToClass{\nt@remaining}{memoir}





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING CUSTOMIZATION STUFF - part 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% Define DEFAULT corollaryUES for COVER and COPYRIGHT languages
%     and HYPERLINK color
\options{/novathesis/lang/cover = \option{/novathesis/lang/main},
         /novathesis/lang/copyright = \option{/novathesis/lang/main},
         /novathesis/color/links = DarkBlue,
         /novathesis/color/gls = None,
}


% \NTRunHook{memoir}

%============================================================
%  TEMPLATE CUSTOMIZATION / OPTIONS
%      Please open and edit the appropriate
%       configuration file “Config/1_novathesis.tex”
%============================================================
\input{Config/1_novathesis}
\def\@DOCTYPE{\option{/novathesis/doctype}}
\def\@DOCSTATUS{\option{/novathesis/docstatus}}

\options{/@nt/document/docclass=\@DOCTYPE}
\def\@DOCCLASS{\option{/@nt/document/docclass}}

\def\@LANG@COVER{\option{/novathesis/lang/cover}}
\def\@LANG@COPYRIGHT{\option{/novathesis/lang/copyright}}
\def\@LANG@MAIN{\option{/novathesis/lang/main}}
\def\@LANG@MAIN@LONG{\thelanglong(\@LANG@MAIN)}

\@ifmtarg{\@DEGREEACR}{\gdef\@DEGREEACR{\option{/novathesis/degreeacr/\@DOCCLASS}}}{}

\bkmstring(1-1)={\thebkmstring(cover,\@LANG@COVER)}
\bkmstring(2-1)={\thebkmstring(frontpage,\@LANG@COVER)}
\bkmstring(N-2)={\thebkmstring(backcover,\@LANG@COVER)}
\bkmstring(spine)={\thebkmstring(spine,\@LANG@COVER)}

\@setabstractorder
\ifdatadefined{abstractorder}(en){}{%
  \abstractorder(en):={en,pt}
}
\ifdatadefined{abstractorder}(\@LANG@MAIN){}{%
  \abstractorder(\@LANG@MAIN):={\@LANG@MAIN,en}
}


%============================================================
% BIBLATEX CUSTOMIZATION
%      Please open and edit the appropriate
%       configuration file “Config/2_biblatex.tex”
%============================================================
\input{Config/2_biblatex}
% \NTRunHook{biblatex}


%============================================================
% LOAD ADDITIONAL PACKAGES
%============================================================

% Load additional symbols
% \RequirePackage[full]{textcomp}

%%%%% Configure multilingual language support
\RequirePackage{csquotes}
\RequirePackage{url}
\RequirePackage{xstring}

\RequirePackage{colortbl}
\definecolor{darkblue}{rgb}{0.0,0.08,0.45}%


\iftoggle{/novathesis/print/index}{
  \AtEndPreamble{
    \ntaddtoprintorder{mainmatter}{index}
    \RequirePackage{imakeidx}
    % \makeindex[intoc,columns=2,options=-s myindexstyle]%
    \makeindex[intoc,columns=2,options=-s  NOVAthesisFiles/ntindexstyle]
  }
}{}

% Fixing autoref in yperref
\RequirePackage{NOVAthesisFiles/fix-hyperref}

%--------------------------------
% “biblatex” stuff
% \ntaddfile{bib}{./NOVAthesisFiles/fix-bib.bib}%
% \AtEndDocument{\nocite{novathesis-manual}}%
% \letoptionlist{/@nt/biblatex}\@nt@biblatex@opts%
% \RequirePackage[hyperref=auto,defernumbers=true]{biblatex}%

%--------------------------------
% “hyperref” stuff
\RequirePackage[%
  , bookmarksnumbered=true%
  , breaklinks=true%
  , colorlinks=true%
  , pdfdisplaydoctitle=true%
  , unicode=true%
]{hyperref}%
\@nt@fixhyperref%
% \pdfstringdefDisableCommands{%
%   \def\\{}%
%   \def\texttt#1{#1}%
% }%
\RequirePackage{bookmark}%
% \RequirePackage{memhfixc}%   Must be used on memoir document class after hyperref


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include strings for all the languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@LANG@LOADED{}
\def\@langs@loaded@sep{}
\newcommand*{\@nt@loadlang}[1]{%
      % \typeout{LL=#1}\LL
      \if\instring{,#1,}{,\@LANG@LOADED,}\else%
        \InputIfFileExists{NOVAthesisFiles/Strings/strings-#1.ldf}%
                        {\eappto{\@LANG@LOADED}{\@langs@loaded@sep#1}\def\@langs@loaded@sep{,}}%
                        {\ClassError{novathesis}{File not found: “NOVAthesisFiles/Strings/strings-#1.ldf” file!}%
                                                {Add a file with the translations for this language.}}%
      \fi%
}
\@for\myi:=\expanded{\@LANG@COVER,\@LANG@COPYRIGHT,\@LANG@MAIN,%
                     \theabstractorder(\@LANG@MAIN)}\do{\@nt@loadlang{\myi}}
\optionlistdo{/novathesis/lang/extra}{\@nt@loadlang{##1}}%

% \letoptionlist{/@nt/lang/loaded}\LANGLOADED
% \typeout{LANGLOADED=\@LANG@LOADED}\LLLLL
\options{/@nt/lang/loaded/.expanded=\@LANG@LOADED}
% \typeout{LANGLOADED=\@LANG@LOADED}\LANG@LOADED

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK IF USING LUALATEX OR XELATEX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\ifxeorlua}{\ifboolexpr{bool{luatex} or bool{xetex}}}
\newcommand{\ifxetexorluatex}{\iftutex}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifxetexorluatex  % xelatex or lualatex
  \RequirePackage[no-math]{fontspec}%
  \defaultfontfeatures{Ligatures=TeX}
\else% pdflatex
  \RequirePackage[T1]{fontenc}    % Use new T1 fonts
  % \RequirePackage[utf8]{inputenc}    % Format for the input file(s), see the "enc" option
\fi

% --------------------------------------------------------
% BABEL STUFF
% \options{/@nt/lang/shorttolong=\@LANG@MAIN}%
\PassOptionsToPackage{main=\@LANG@MAIN@LONG}{babel}
\@for\myi:=\expanded{\@LANG@LOADED}\do{%
  % \typeout{BABELLANG=\myi \thelanglong(\myi)}\BABELLANG%
  % \options{/@nt/lang/shorttolong=\myi}%
  \PassOptionsToPackage{\expanded{\thelanglong(\myi)}}{babel}%
  \PassOptionsToPackage{\expanded{\thelanglong(\myi)}}{translator}%
}%

% --------------------------------------------------------
% FIX BABEL TRANSLATION
\RequirePackage[english]{babel}      % Support for multilingual documents
\RequirePackage{translator} % Support month name translations for pgfcalendar


%--------------------------------
% “glossasries” stuff - after hyperref
\ifoptioncontains{/novathesis/lang/extra}{gr}{%
  \PassOptionsToPackage{xindy={language=\@LANG@MAIN@LONG}}{glossaries-extra}
}{}

\RequirePackage[%
  % , nonumberlist
  translate=babel,
  acronym,           % add acronyms listing
  symbols,           % add symbols listing
  % sanitizesort=false, % allow \gls inside descriptions
  % xindy={language=\@LANG@MAIN@LONG},
  nolong,
  nosuper,
  nolist,
  notree,
  nostyles,
  automake,
]{glossaries-extra}% To create glossaries
\RequirePackage{NOVAthesisFiles/glossary-xltabular}%
\setglossarystyle{xltabular}%
\setabbreviationstyle[acronym]{long-short}%
\GlsXtrEnablePreLocationTag{\emph{(\small p.~}}{\emph{(\small pp.~}}
\patchcmd{\@gls@automake@immediate}{-I xindy}{-q -I xindy}{}{}
% \renewcommand{\gls@automake@makegloss}{makeglossaries -q}%
\renewcommand{\GlsXtrFormatLocationList}[1]{\emph{\small#1)}}
\renewcommand{\glsnamefont}[1]{\textbf{#1}}%
\newcommand*{\glsplainhyperlink}[2]{%
    \begingroup%
      \hypersetup{hidelinks}%
      \hyperlink{#1}{#2}%
    \endgroup%
}%

%--------------------------------
% “Process gnumberlist” option - after glossaries
\iftoggle{/novathesis/gnumberlist}{}{\setupglossaries{nonumberlist}}%
\AtEndPreamble{\@loadglossaryfiles\makeglossaries}%

%--------------------------------
% TIKZ
\RequirePackage{tikz}
\usetikzlibrary{calc}

%%%%% Fine tuning of typesetting
\ifxeorlua{%
    \newcommand{\textls}[2][25]{{\addfontfeature{LetterSpace=\the\numexpr#1/9\relax}#2}}
}{% pdflatex
  \RequirePackage[%
    babel=true,
    activate={true,nocompatibility},  % activate={true,nocompatibility} - activate protrusion and expansion
    final,            % final - enable microtype; use "draft" to disable
    tracking=true,    % tracking=true - activate this technique
    kerning=true,     % kerning=true - activate this technique
    spacing=true,     % spacing=true - activate this technique
    factor=1100,      % factor=1100 - add 10% to the protrusion amount (default is 1000)
    stretch=10,       % stretch=10 - reduce stretchability (default is 20)
    shrink=10,        % shrink=10 - reduce shrinkability (default is 20)
  ]{microtype}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEFINITIONS FOR THE REMINDER OF CUSTOMIZATION STUFF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------
% Department
\def\ntdepartment{\@ifstar{\@ntdepartmentifundef}{\@ntdepartment}}
\def\@ntdepartmentifundef(#1)#2{\ifdatadefined{department}(#1){}{\@ntdepartment(#1){#2}}}
\def\@ntdepartment(#1)#2{\department(#1):={#2}}

% --------------------------------------------------------
% Degree
\def\ntmajorfield{\@ifstar{\@ntmajorfieldifundef}{\@ntmajorfield}}
  % #1 = lang
  % #2 = value
\def\@ntmajorfieldifundef(#1)#2{\ifdatadefined{majorfield}(#1){}{\@ntmajorfield(#1){#2}}}
\def\@ntmajorfield(#1)#2{\majorfield(#1):={#2}}

\def\ntdegreename{\@ifstar{\@ntdegreenameifundef}{\@ntdegreename}}
\def\@ntdegreenameifundef(#1)#2{\ifdatadefined{degreename}(#1){}{\@ntdegreename(#1){#2}}}
\def\@ntdegreename(#1)#2{%
  % #1 = lang
  % #2 = value
  \datamatch{\match}{degreenameprefix}(%
            {\@DOCTYPE,\@DEGREEACR,\@LANG@COVER},%
            {\@DOCCLASS,\@DEGREEACR,\@LANG@COVER},%
            {\@DEGREEACR,\@LANG@COVER},%
            {\@DOCTYPE,\@LANG@COVER},%
            {\@DOCCLASS,\@LANG@COVER},%
            {\@LANG@COVER}%
  )%
  \ifblank{\match}{\degreename(#1):={#2}}{\degreename(#1):={\match\ #2}}%
  \majorfield(#1):={#2}%
}
% --------------------------------------------------------
% Specialization
\def\ntminorfield{\@ifstar{\@ntminorfieldifundef}{\@ntminorfield}}
\def\@ntminorfieldifundef(#1)#2{\ifdatadefined{minorfield}(#1){}{\@ntminorfield(#1){#2}}}
\def\@ntminorfield(#1)#2{\minorfield(#1):={#2}}

\def\ntspecialization{\@ifstar{\@ntspecializationifundef}{\@ntspecialization}}
\def\@ntspecializationifundef(#1)#2{\ifdatadefined{minorfield}(#1){}{\@ntspecialization(#1){#2}}}
\def\@ntspecialization(#1)#2{%
  \datamatch{\specmatch}{specializationstring}(%
            {\@DOCTYPE,\@DEGREEACR,\@LANG@COVER},%
            {\@DOCCLASS,\@DEGREEACR,\@LANG@COVER}%
            {\@DEGREEACR,\@LANG@COVER},%
            {\@DOCTYPE,\@LANG@COVER},%
            {\@DOCCLASS,\@LANG@COVER},%
            {\@LANG@COVER}%
  )%
  \ifblank{\match}{\specialization(#1)={#2}}{\specialization(#1)={\specmatch\ #2}}%
  \minorfield(#1)={#2}%
}

% --------------------------------------------------------
% Sponsors
\def\ntsponsors(#1)#2{\sponsor(#1):={#2}}

% --------------------------------------------------------
% Title
\def\nttitle(#1,#2)#3{%
  % #1 = type (main, sub, spine) title
  % #2 = lang
  % #3 = value
  % \typeout{NT TITLE [#1] [#2] [#3]}%
  \noexpandarg
  \StrSubstitute{#3}{\\}{ }[\@nt@cleantitle]
  % \typeout{XXXX [\@nt@cleantitle]}\aaa
  \doctitle(#2,#1):={\@nt@cleantitle}%
  \doctitle(#2,#1,cover):={#3}%
  \IfStrEq{#1}{main}{\doctitle(#2,spine):=?{\@nt@cleantitle}}{}%
  % \doctitle(#2,#1):={\ntnolinebreak{#3}}%
  % \doctitle(#2,#1,cover):={#3}%
  % \IfStrEq{#1}{main}{\doctitle(#2,spine):={\ntnolinebreak{#3}}}{}%
  \fullexpandarg
}

% \newcommand{\ntnolinebreak}[1]{{\def\\{\ }#1}}
% --------------------------------------------------------



%============================================================
% Date and month
\newdata{ntdocdate}

\def\ntdate{%
  \@ifnextchar({\@ntdate@i}{\@ntdate@i(submission)}%
}

% \usepackage{pgfcalendar} % For converting month names

\newcommand{\monthtotext}[1][\month]{\csuse{month\romannumeral#1 name}}

\def\@ntdate@i(#1)#2{%
  \StrCut{#2}{-}\@NTDY\@NTDM%
  \StrCut{\@NTDM}{-}\@NTDM\@NTDD%
  % \typeout{NTD(#1) Y=[\@NTDY] M=[\@NTDM] D=[\@NTDD]}\NTDATE%
  \ntdocdate(#1):={#2}%
  \ntdocdate(#1,year):={\@NTDY}%
  \ntdocdate(#1,month):={\@NTDM}%
  \ntdocdate(#1,day):={\@NTDD}%
  \@for\myi:={year,month,day}\do{%
    \IfInteger{\thentdocdate(#1,\myi)}{}
              {\ClassError{The \myi in \string\ntdocdate(#1){#2} is not a number!}{}{}}%
  }%
  % \ntdocdate(#1,month,text):={\pgfcalendarmonthname{\thentdocdate(#1,month)}}%
  \ntdocdate(#1,month,text):={\monthtotext[\@NTDM]}%
}
\ntdocdate(default):={2000-09-01}
\ntdate(submission){\thentdocdate(default)}
\ntdate(exam){\thentdocdate(default)}


%============================================================
% Author identification
\newdata{docauthor}
\docauthor(name):={Author Name}
\docauthor(name,short):={Author Short Name}
\docauthor(gender):={Author Gender}
\docauthor(degree,\@LANG@COVER):={Author Previous Degree}

\def\ntauthorname(#1)#2#3{% [m|f]{Long name}{Short name}
  \docauthor(gender):={#1}%
  \docauthor(name):={#2}%
  \docauthor(name,short):={#3}}

\def\ntauthordegree(#1)#2{\docauthor(degree,#1):={#2}}

%============================================================
% Adding list_of
\newcommand*{\ntaddlistof}[2][]{%
  % \typeout{NTADDLISTOF 1=[#1] 2=[#2]}\NTADDLISTOF%
  \IfStrEqCase{#2}{%
    {tableofcontents}{\options{/@nt/list/listof/.newpush={%
            \iftoggle{/novathesis/tocintoc}{\tableofcontents}%
                  {\pdfbookmark{\contentsname}{toctarget}%
                  \hypertarget{toctarget}{\tableofcontents*}}}}}%
    {listoffigures*}{\options{/@nt/list/listof/.newpush={%
            \pdfbookmark{\listfigurename}{loftarget}%
            \hypertarget{loftarget}{\listoffigures*}}}}%
    {listoftables*}{\options{/@nt/list/listof/.newpush={%
            \pdfbookmark{\listtablename}{lottarget}%
            \hypertarget{lottarget}{\listoftables*}}}}%
    {listoflistings}{\options{/@nt/list/listof/.newpush={%
            \pdfbookmark{\listoflistingscaption}{loltarget}%
            \hypertarget{loltarget}{\listoflistings}}}}%
    {lstlistoflistings}{\options{/@nt/list/listof/.newpush={%
            \pdfbookmark{\lstlistlistingname}{loltarget}%
            \hypertarget{loltarget}{\lstlistoflistings}}}}%
    {listofalgorithms}{\options{/@nt/list/listof/.newpush = {%
            \listofalgorithms
            \ifdefined\listalgorithmname%
              \addcontentsline{toc}{chapter}{\listalgorithmname}%
            \else\ifdefined\listalgorithmcfname%
              \addcontentsline{toc}{chapter}{\listalgorithmcfname}%
            \else
              \ClassError{novathesis}{Can't make list of algorithms. Please report this problem in the “novathesis” github. Thanks!}{}%
            \fi\fi}}}%
  }[%
            \@ifmtarg{#1}%
              {\options{/@nt/list/listof/.newpush={\ifdefmacro{#2}{#2}{\csuse{#2}}}}}%
              {\options{/@nt/list/listof/.newpush={\ifdefmacro{#2}{#2[#1]}{\csuse{#2}[#1]}}}}%
   ]%
}

%============================================================
% Print document “parts/sections/regions”
\newcommand*{\ntprint}[1]{%
  \IfStrEqCase{#1}{%
    {frontmatter}{%
          % \iftoggle{/novathesis/print/secondcover}{}{\setcounter{page}{1}}%
          \thispagestyle{novathesis@frontmatter}%
          \pagestyle{novathesis@frontmatter}%
          \iftoggle{/novathesis/print/frontmatter}{\ntprintlist{/@nt/print/#1}}{}}%
    {mainmatter}{%
          \thispagestyle{novathesis@mainmatter}%
          \pagestyle{novathesis@mainmatter}%
          \ntprintlist{/@nt/print/#1}}%
  }[\ifdefmacro{#1}{#1}{\csuse{ntprint#1}}]%
  \relax%
}

\newcommand*{\ntprintlist}[1]{%
  \optionlistdo{#1}{%
    \ifdefmacro{##1}{##1}{%     ##1 is undefined
      \ifcsmacro{ntprint##1}{%  \ntprint#1 is defined
        \NTRunHook{ntprint##1/pre}\csuse{ntprint##1}\NTRunHook{ntprint##1/post}%
      }{%                       \ntprint#1 is undefined
        \ifcsmacro{##1}{%       \##1 is defined
          \NTRunHook{##1/pre}\csuse{##1}\NTRunHook{##1/post}%
        }{%                     nothing is defined
          \ClassError{novathesis}{Invalid contents for frontmatter or mainmatter: [##1]}{}%
        }%
      }%
    }%
    % \clearforchapter%
    \ignorespaces%
  }%
}

\newcommand*{\ntsetprintorder}[2]{%
  % #1 = frontmatter, mainmatter
  % #2 = list
  % \typeout{[#1] [#2]}
  \option@setlist[;]{/@nt/print/#1}{#2}%
}

\newcommand*{\ntaddtoprintorder}[2]{%
  % #1 = frontmatter, mainmatter
  % #2 = list
  % \typeout{[#1] [#2]}
  \options{/@nt/print/#1/.push=#2}%
}

% \newcommand*{\ntremovefromprintorder}[2]{%
% % #1 = frontmatter, mainmatter
% % #2 =single item to remove
%   \@for\@nt@item:=#2\do{\options{/@nt/print/#1/.remove = {\@nt@item}}}}

% --------------------------------------------------------
% DEFAULT VALUES FOR frontmatter AND mainmatter
\newdata{printorder}

\printorder(frontmatter,final):={%
  statement;       % The statement page
  copyright;       % (*) The copyright page
  dedicatory;      % (*) Print the dedicatory
  acknowledgements;% (*) Print the acknowledgments
  quote;           % (*) Print the quote
  abstracts;       % Print abstracts in multiple languages.
  alllistof;       % Print all the listof defined in “6_list_of.tex”
  printglossaries; % Print the Glossary, Acronyms, Symbols, etc…
}

\printorder(frontmatter,provisional):={%
  statement;       % The statement page
  copyright;       % (*) The copyright page
  dedicatory;      % (*) Print the dedicatory
  acknowledgements;% (*) Print the acknowledgments
  quote;           % (*) Print the quote
  abstracts;       % Print abstracts in multiple languages.
  alllistof;       % Print all the listof defined in “6_list_of.tex”
  printglossaries; % Print the Glossary, Acronyms, Symbols, etc…
}

\printorder(frontmatter,working):={%
  abstracts;       % Print abstracts in multiple languages.
  alllistof;       % Print all the listof defined in “6_list_of.tex”
  printglossaries; % Print the Glossary, Acronyms, Symbols, etc…
}

\ifoptionequal{/novathesis/print/webography}{}{%
  \ntsetprintorder{mainmatter}{
    chapters;        % Print document chapters
    bib;             % Print the bibliography.  Change to
     %    “bib[title=⟨title⟩]” to redefine the title!
    appendices;      % Print appendices; if any!
    annexes;         % Print annexes; if any!
  }%
}{%
  \ntsetprintorder{mainmatter}{
    chapters; % Print document chapters
    \printbibliography[nottype=online]; % Print the bibliography.
    \printbibliography[title=\option{/novathesis/print/webography},type=online]; % Print the bibliography.
    appendices; % Print appendices, if any!
    annexes; % Print annexes, if any!
  }%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COVER DEFINITION MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntresetcovers}{%
  \@for\arg:={1-1,1-2,2-1,2-2,N-1,N-2}\do{%
    \ntresetonecover{\arg}%
  }%
}

\newcommand*{\ntresetonecover}[1]{%
    \option@setnil{/@nt/cover/\@UNIV/\@SCHL/#1}%
}


\newcommand*{\ntaddtocover}[3][]{%
  % #1 = cover atrtibutes
  % #2 = list of covers where the code block should be applied
  % #3 = the block code
  % \typeout{NT ntaddtocover [/@nt/cover/\@UNIV/\@SCHL/element=#1]}%
  % \forcsvlist{\@ntaddtocover@iii{#1}{#3}}{#2}%
  \ntfor\arg:={#2}\do{\@ntaddtocover@iii{#1}{#3}{\arg}}%
}

\newcommand*{\@ntaddtocover@iii}[3]{%
  % \typeout{NT ntaddtocover #3}%
  % #1 = cover atrtibutes
  % #2 = the block code
  % #3 = covers where the code block should be applied
  \options{/@nt/cover/\@UNIV/\@SCHL/#3/.newpush={{#1}\@nil{#2}}}%
}

%==========================================
\NewDocumentCommand{\ntAddToCoverTikz}{d<>O{}r()O{}mm}{%
  % #1=Command
  % #2=Options
  % #3=Position
  % #4=Rest of command
  % #5=CIDLIST
  % #6=Code
  \ntfor\cvids:={#5}\do{\ntAddToOneCoverTikz{#1}{#2}{#3}{#4}{\cvids}{#6}}%
}

\NewDocumentCommand{\ntAddToOneCoverTikz}{mmmmmm}{%
  % #1=Command
  % #2=Options
  % #3=Position
  % #4=Rest of command
  % #5=CID
  % #6=Code
  \options{/@nt/coverTikz/\@UNIV/\@SCHL/#5/.newpush={{#1}\@nil{#2}\@nil{#3}\@nil{#4}\@nil{#6}}}%
}

\NewDocumentCommand{\printCoverTikz}{m}{%
  % #1 = cover ID (major-minor)
  % \typeout{@NTCOVERTEXT 1=[#1]}\@NTCOVERTEXT%
  \ifoptiondefined{/@nt/coverTikz/\@UNIV/\@SCHL/#1}{%
    \NTRunHook{coverTikz/#1/text/pre}%
    \begin{tikzpicture}[remember picture, overlay, yscale=-1, every node/.style={inner sep=0pt}]%
      \optionlistdo{/@nt/coverTikz/\@UNIV/\@SCHL/#1}{%
        \printCoverElementTikz#1\@nil##1%
      }%
    \end{tikzpicture}%
    \NTRunHook{coverTikz/#1/text/post}%
  }{}%
}

\def\printCoverElementTikz#1\@nil#2\@nil#3\@nil#4\@nil#5\@nil#6{%
  % #1=CID
  % #2=Command
  % #3=Options
  % #4=Position
  % #5=Rest of command
  % #6=Code
  % \node[inner sep=0,#2] at (#1) {Pos=[#1] Opt=[#2] CID=[#3] COD=[#4]};
  % \typeout{ CID=[#1] CMD=\string#2[#3] at (#4) --#5--}\TIKZCOVER
  \IfNoValueTF {#2} {\node[#3] at (#4) #5 {#6}} {#2[#3] (#4) #5};
}
%==========================================



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING SCHOOLS's “defaults.ldf”, including cover design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ntfor\match:={\@UNIV,\@UNIV/\@SCHL}\do{%
    \IfFileExists{NOVAthesisFiles/Schools/\match/Images/DO_NOT_REMOVE_THIS_FILE.txt}{%
            \prependtographicspath{{NOVAthesisFiles/Schools/\match/Images/},}}{}%
}


%============================================================
%  UNIVERSITY/SCHOOL SPECIFIC MATERIALS
%  configuration file “Config/9_<university>_<school>.tex”
%============================================================
\IfFileExists{Config/9_\@UNIV_\@SCHL.tex}
     {\def\@ntsetuplevel{\@UNIV/\@SCHL/}\input{Config/9_\@UNIV_\@SCHL.tex}}
     {\def\@ntsetuplevel{\@UNIV/}\InputIfFileExists{Config/9_\@UNIV.tex}{}{}}
\def\@ntsetuplevel{}

\InputIfFileExists{NOVAthesisFiles/Schools/\@UNIV/\@UNIV-defaults.ldf}{}
    {\PackageError{novathesis}{Missing file “NOVAthesisFiles/Schools/\@UNIV/\@UNIV-defaults.ldf”}{}}

\ntfor\match:={%
      \@UNIV-\@SCHL-\@DEGREEACR,%
      \@UNIV-\@SCHL%
  }\do{%
      \IfFileExists{NOVAthesisFiles/Schools/\@UNIV/\@SCHL/\match-defaults.ldf}
              {\input{NOVAthesisFiles/Schools/\@UNIV/\@SCHL/\match-defaults.ldf}\ntforbreak}{}%
  }
[\PackageError{novathesis}{Missing file “NOVAthesisFiles/Schools/\@UNIV/\@SCHL-defaults.ldf”}{}]

\RequirePackage[hyperref=auto,defernumbers=true]{biblatex}%


% --------------------------------------------------------
% Customize the pagestyle
\newcommand{\rightorleftmark}{%
  \setbox0=\hbox{\rightmark}
  \ifdim\wd0>0.1pt\relax
    \rightmark
  \else
    \leftmark
  \fi
}
\makepagestyle{novathesis@mainmatter}
\makeoddfoot{novathesis@mainmatter}{}{\thepage}{}
\makeevenfoot{novathesis@mainmatter}{}{\thepage}{}
\makeheadrule{novathesis@mainmatter}{\textwidth}{\normalrulethickness}
\makeevenhead{novathesis@mainmatter}{\small\textsc{\leftmark}}{}{}
\makeoddhead{novathesis@mainmatter}{}{}{\small\rightorleftmark}

\makepagestyle{novathesis@frontmatter}
\makeoddfoot{novathesis@frontmatter}{}{\thepage}{}
\makeevenfoot{novathesis@frontmatter}{}{\thepage}{}

\ifoptionequal{/novathesis/media}{paper}{\ntsetup{color/links=Black}}{}


% --------------------------------------------------------
% If option “debug={index}” option is active,
%     highlight index keywords in the main text
\providecommand*{\debugindexcolor}{red!50}
\ifoptioncontains{/novathesis/debug}{index}{%
  % \PassOptionsToPackage{inline}{showlabels}%
  \AtEndPreamble{\RequirePackage{showlabels}%
  \showlabels[\color{\debugindexcolor}]{index}}%
}{}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING CUSTOMIZATION STUFF - part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%============================================================
%  THESIS/DISSERTATION COVER DATA (title, author, etc)
%   Please open and edit the appropriate
%       configuration file “Config/3_cover.tex”
%============================================================
\input{Config/3_cover}
% \NTRunHook{cover}

% Patch month from number to string in the proper language
\ntselectlang{\@LANG@COVER}%

%============================================================
%  THESIS/DISSERTATION FILES
%   Please open and edit the appropriate
%       configuration file “Config/4_files.tex”
%============================================================
\input{Config/4_files}
\ntaddfile{bib}{./NOVAthesisFiles/fix-bib.bib}
% \NTRunHook{files}

%============================================================
% ADDITIONAL PACKAGES and MACROS
%      Please open and edit the appropriate
%       configuration file “Config/8_packages.tex”
%============================================================
% \newcommand{\BeforeHyperref}[1]{\NTAddToHook{packages/pre}{#1}}
% \newcommand{\AfterHyperref}[1]{\NTAddToHook{packages/post}{#1}}
% \NTRunHook{packages/pre}
\AtEndPreamble{\input{Config/5_packages}}
% \NTRunHook{packages/post}

%============================================================
%  WHICH LIST_OF TO PRINT
%   Please open and edit the appropriate
%       configuration file “Config/6_list_of.tex”
%============================================================
\AtEndPreamble{\makeatletter\NTRunHook{list_of/pre}\input{Config/6_list_of}\NTRunHook{list_of/post}}

\setcounter{biburlnumpenalty}{100}% Allow to break DOIs in bibliography
\optionlistdo{/@nt/file/bib/\@DOCTYPE}{%
  % \typeout{ADDBIB=#1}\ADDBIB
  \addbibresource{#1}%
}%

\ifdocunset{\ntsetup{docstatus=working}}{}

% \typeout{\theprintorder(frontmatter,\@DOCSTATUS)}
\ntsetprintorder{frontmatter}{\expanded{\theprintorder(frontmatter,\@DOCSTATUS)}}%

\ifoptionequal{/novathesis/spine/layout}{unset}
    {\ifdocworking{\ntsetup{spine/layout=no}}{\ifmaindoc{\ntsetup{spine/layout=trim}}{\ntsetup{spine/layout=no}}}}{}
\ifdocfinal{\ntsetup{print/committee=true}}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@nt@loadallfiles}[2]{\optionlistdo{/@nt/file/#2/#1}{\@ntloadfile@i{##1}}}

\newcommand{\@ntloadfile@i}[2][]{\IfFileExists{#2}{\input{#2}}{#1}}

\newcommand{\@ntloadfiles@ii}[2][\@DOCTYPE]{%
  % #1=KEY
  % #2=file class
  \iffileadded[#1]{#2}{\@nt@loadallfiles{#1}{#2}}{}%
}

\newcommand{\iffileadded}[2][\@DOCTYPE]{\ifoptiondefined{/@nt/file/#2/#1}}

% --------------------------------------------------------
% LOAD A DEFAULT COPYRIGHT PAGE DEFINITION
\newcommand{\@nt@AddFileIfExists}[1]{%
% #1 = class
% #2 = sub class [OPTIONAL]
% #3 = file name
% #4 = dir list
% #5 = action if not found [OPTIONAL]
  \@ifnextchar[{\@nt@AddFileIfExists@i{#1}}{\@nt@AddFileIfExists@i{#1}[\@DOCTYPE]}%
}

\def\@nt@AddFileIfExists@i#1[#2]#3#4{%
  \@ifnextchar[{\@nt@AddFileIfExists@ii{#1}[#2]{#3}#4}{\@nt@AddFileIfExists@ii{#1}[#2]{#3}#4[]}%
}

\long\def\@nt@AddFileIfExists@ii#1[#2]#3#4[#5]{%
  \ntfor\arg:=#4\do{\IfFileExists{\arg#3}{\ntaddfile{#1}[#2]{\arg#3}\ntforbreak}{}}[#5]%
}


% \newcommand{\@nt@AddFileIfExists}[4][]{%
% % #1 = OPTIONAL action if not found
% % #2 = class
% % #3 = file name
% % #4 = dir list
%   \ntfor\arg:=#4\do{\@nt@AddFileIfExists@i{#2}{#3}{\arg}}[#1]%
% }
%
% \newcommand{\@nt@AddFileIfExists@i}[3]{%
% % #1 = class
% % #2 = file name
% % #3 = dir list
%   \IfFileExists{#3#2}{\ntaddfile{#1}{#3#2}\ntforbreak}{}%
% }

\ifmaindoc{% only print if a main document
  \iftoggle{/novathesis/print/copyright}{% if copuyright toggle is on
    \@nt@AddFileIfExists{copyright}{copyright.ldf}{%
           {NOVAthesisFiles/Schools/\@UNIV/\@SCHL/}%
          ,{NOVAthesisFiles/Schools/\@UNIV/}%
          ,{NOVAthesisFiles/}%
    }%
    \@ntloadfiles@ii{copyright}%
  }{}%
}{}

\ifoptionequal{/novathesis/spine/layout}{no}{}{%
  \@nt@InputIfFileExists{spine.tex}{%
           {NOVAthesisFiles/Schools/\@UNIV/\@SCHL/}%
          ,{NOVAthesisFiles/Schools/\@UNIV/}%
          ,{NOVAthesisFiles/}%
  }[][\ClassError{novathesis}{No “spine” file found.}{}]%
  \AtEndDocument{\csuse{ntprintspine}}%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIX BABEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\input{NOVAthesisFiles/fix-babel.tex}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEBUG - print grid over covers and spine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\debuggrid}[1][orange]{%
  \begin{tikzpicture}[remember picture, semitransparent, overlay, shift=(current page.north west)]%
    \draw[step=1mm, line width=0.1mm, #1!30!white, yscale=-1] (\@MRGN@left, \@MRGN@top)
              grid (\paperwidth-\@MRGN@right, \paperheight-\@MRGN@bottom);
    \draw[step=5mm, line width=0.2mm, #1!40!white] (current page.north west)
              grid (current page.south east);
    \draw[step=1cm, line width=0.3mm, #1!90!white] (current page.north west)
              grid (current page.south east);
    \draw[step=5cm, line width=0.5mm, #1!50!white] (current page.north west)
              grid (current page.south east);
    \end{tikzpicture}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PRINT DOCUMENT PARTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ifcoverdefined}[3][1-1]{%
  % #1 = cover number
  % #2 = true branch
  % #3 = false branch
  % \edef\asd{/@nt/cover/\@UNIV/\@SCHL/#1}
  % \show\asd
  \ifoptiondefined{/@nt/cover/\@UNIV/\@SCHL/#1}{#2}{%
    \datamatchtf{\match}{thesiscover}(%
       {\@DOCTYPE,\@DEGREEACR,#1,bgcolor}%
      ,{\@DOCCLASS,\@DEGREEACR,#1,bgcolor}%
      ,{\@DEGREEACR,#1,bgcolor}%
      ,{\@DEGREEACR,bgcolor}%
      ,{\@DOCTYPE,\@DEGREEACR,#1,image}%
      ,{\@DOCCLASS,\@DEGREEACR,#1,image}%
      ,{\@DEGREEACR,#1,image}%
      ,{\@DEGREEACR,image}%
      ,{\@DOCTYPE,\@DEGREEACR,#1,bgcolor}%
      ,{\@DOCCLASS,\@DEGREEACR,#1,bgcolor}%
      ,{\@DEGREEACR,#1,bgcolor}%
      ,{\@DEGREEACR,bgcolor}%
      ,{\@DOCTYPE,\@DEGREEACR,#1,image}%
      ,{\@DOCCLASS,\@DEGREEACR,#1,image}%
      ,{\@DEGREEACR,#1,image}%
      ,{\@DEGREEACR,image}%
      ,{\@DOCTYPE,#1,bgcolor}%
      ,{\@DOCCLASS,#1,bgcolor}%
      ,{#1,bgcolor}%
      ,{bgcolor}%
      ,{\@DOCTYPE,#1,image}%
      ,{\@DOCCLASS,#1,image}%
      ,{#1,image}%
      ,{image}%
      ,{\@DOCTYPE,#1,bgcolor}%
      ,{\@DOCCLASS,#1,bgcolor}%
      ,{#1,bgcolor}%
      ,{bgcolor}%
      ,{\@DOCTYPE,#1,image}%
      ,{\@DOCCLASS,#1,image}%
      ,{#1,image}%
      ,{image}%
    ){#2}{#3}%
  }%
}

\newcommand{\ntprintspine}{%
  \pagenumbering{roman}%
  \setcounter{page}{0}
  \iffileadded[spine]{cover}{%
    \optionlistdo{/@nt/file/cover/spine}{%
      \bgroup\thispagestyle{empty}%
      \@ntloadfile@i[\ClassError{novathesis}{Invalid cover file: “##1”}{}]{##1}%
      \egroup\clearforchapter%
    }%
  }{\@ntprintspine\clearforchapter}%
}

\newcommand{\ntprintbackcover}{%
  \clearforchapter%
  \pagenumbering{roman}%
  \setcounter{page}{0}
  \ifcoverdefined[N-1]{\pdfbookmark[-1]{\thebkmstring(backmatter,\@LANG@COVER)}{bmbackmatter1}}{%
  \ifcoverdefined[N-2]{\pdfbookmark[-1]{\thebkmstring(backmatter,\@LANG@COVER)}{bmbackmatter2}}{}}%
  \ntprintcoverpair{N}%
}

\newcommand{\ntprintcovers}[1][1,2]{%
  \begingroup%
    \ntselectlang{\@LANG@COVER}%
    \NTRunHook{printcovers/pre}%
    \pdfbookmark[-1]{\thebkmstring(frontmatter,\@LANG@COVER)}{bmfrontmatter}%
    \NTAddToHook{mainmatter/pre}{\bookmarksetup{startatroot}}%
    % \forcsvlist{\ntprintcoverpair}{#1}%
    \ntfor\arg:={#1}\do{\ntprintcoverpair{\arg}}%
    \NTRunHook{printcovers/post}%
  \endgroup%
  \setcounter{page}{1}%
  \iftoggle{/novathesis/countsecondcover}{\stepcounter{page}}{}%
  \pagecolor{white}%
}

\newcommand{\ntprintcoverpair}[1]{%
  % #1 = major cover ID
  \iffileadded[1]{cover}{% Deal with user-defined cover page
    \iffileadded[#1]{cover}{%
      \optionlistdo{/@nt/file/cover/#1}{%
        \bgroup\thispagestyle{empty}%
        \@ntloadfile@i[\ClassError{novathesis}{Invalid cover file: “##1”}{}]{##1}%
        \egroup\clearpage%
      }%
      \ntprintcoversingle{2-1}%
    }{}%
  }{% Pre-defined cover page
    \IfStrEqCase{#1}{%
      {1}{\ntprintcoversingle{#1-1}\ntprintcoversingle{#1-2}}%
      {2}{\iftoggle{/novathesis/print/secondcover}
                   {\ntprintcoversingle{#1-1}\ntprintcoversingle{#1-2}}{}}%
      {N}{\ntprintcoversingle{#1-1}\ntprintcoversingle{#1-2}}%
    }[\ClassWarning{Invalid cover number: #1}{}]%
  }%
}

\gdef\@COVERNUM{}%
\newcommand{\ifcovernum}[2]{\IfStrEq{\@COVERNUM}{#1}{#2}}

\newcommand{\ntprintcoversingle}[1]{%
  % #1 = cover ID “major-minor”
  \gdef\@COVERNUM{#1}%
  \ifcoverdefined[#1]{\setcounter{page}{0}\@ntprintcover@i{#1}}{}%
}

\newcommand{\@ntprintcover@i}[1]{%
  % #1 = cover ID (major-minor)
  \begingroup%
    \NTRunHook{cover/pre}%
    \NTRunHook{cover/#1/pre}%
    \pdfbookmark[1]{\thebkmstring(#1)}{\thebkmstring(#1)}%
    \thispagestyle{empty}%
    \setCoverBgColor{#1}%
    \setCoverBgImage{#1}%
    \prrintCoverText{#1}%
    % \@ntmakeboxwithcover{#1}{\@fullcover@box}%
    \printCoverTikz{#1}%
    \NTRunHook{cover/#1/post}%
    \NTRunHook{cover/post}%
  \endgroup%
  \ifoptionequal{/novathesis/media}{paper}{\newpage ~\thispagestyle{empty}\newpage}{\clearforchapter}
}

\newcommand{\setCoverBgColor}[1]{
  \null%
  \NTRunHook{cover/#1/bgcolor/pre}%
  \datamatchtf{\match}{thesiscover}(%
    {\@DOCTYPE,\@DEGREEACR,#1,bgcolor}%
   ,{\@DOCCLASS,\@DEGREEACR,#1,bgcolor}%
   ,{\@DEGREEACR,#1,bgcolor}%
   ,{\@DEGREEACR,bgcolor}%
   ,{\@DOCTYPE,#1,bgcolor}%
   ,{\@DOCCLASS,#1,bgcolor}%
   ,{#1,bgcolor}%
   ,{bgcolor}%
  ){\pagecolor{\match}}{\pagecolor{white}}%
  \NTRunHook{cover/#1/bgcolor/post}%
}

\newcommand{\setCoverBgImage}[1]{
  \null%
  \NTRunHook{cover/#1/image/pre}%
  \datamatchtf{\match}{thesiscover}(%
    {\@DOCTYPE,\@DEGREEACR,#1,image}%
   ,{\@DOCCLASS,\@DEGREEACR,#1,image}%
   ,{\@DEGREEACR,#1,image}%
   ,{\@DEGREEACR,image}%
   ,{\@DOCTYPE,#1,image}%
   ,{\@DOCCLASS,#1,image}%
   ,{#1,image}%
   ,{image}%
  ){%
    \begin{tikzpicture}[remember picture, overlay]%
      \node[anchor=center] at (current page.center) 
              {\includegraphics[width=\paperwidth,height=\paperheight]{\match}};
    \end{tikzpicture}%
  }{}%
  \NTRunHook{cover/#1/image/post}%
}

\newcommand{\prrintCoverText}[1]{
  \null%
  \datamatchtf{\match}{thesiscover}(%
              {\@DOCTYPE,\@DEGREEACR,#1,textcolor}%
             ,{\@DOCCLASS,\@DEGREEACR,#1,textcolor}%
             ,{\@DEGREEACR,#1,textcolor}%
             ,{\@DEGREEACR,textcolor}%
             ,{\@DOCTYPE,#1,textcolor}%
             ,{\@DOCCLASS,#1,textcolor}%
             ,{#1,textcolor}%
             ,{textcolor}%
  ){\color{\match}}{}%
  \@for\myi:={top,bottom,left,right}\do{%
    \expandafter\datamatch\csname @MRGN@\myi\endcsname{margin}(%
      {cover,\@DOCTYPE,\@DEGREEACR,#1,\myi},%
      {cover,\@DOCCLASS,\@DEGREEACR,#1,\myi},%
      {cover,\@DEGREEACR,#1,\myi},%
      {cover,\@DOCTYPE,\@DEGREEACR,\myi},%
      {cover,\@DOCCLASS,\@DEGREEACR,\myi},%
      {cover,\@DEGREEACR,\myi},%
      {cover,\@DOCTYPE,#1,\myi},%
      {cover,\@DOCCLASS,#1,\myi},%
      {cover,#1,\myi},%
      {cover,\@DOCTYPE,\myi},%
      {cover,\@DOCCLASS,\myi},%
      {cover,\myi})%
  }%
  \newdimen{\covertextheight}%
  \newdimen{\covertextwidth}%
  \covertextheight=\dimexpr\paperheight-\@MRGN@top-\@MRGN@bottom\relax%
  \covertextwidth=\dimexpr\paperwidth-\@MRGN@left-\@MRGN@right\relax%
  \ifoptioncontains{/novathesis/debug}{cover}{%
    \NTRunHook{cover/#1/grid/pre}%
    \debuggrid%
    \NTRunHook{cover/#1/grid/post}%
  }{}%
  \begin{tikzpicture}[remember picture, overlay]%
    \node[anchor=north west,inner sep=0,xshift=\@MRGN@left, yshift=-\@MRGN@top] 
          at (current page.north west) {%
      \begin{minipage}[t][\covertextheight]%
                      [t]{\covertextwidth}%
        \@ntcovertext{#1}%
      \end{minipage}%
    };
    \expandafter\@ifmtarg\expandafter{\csname @covertikzlist#1\endcsname}{}{\csuse{@covertikzlist@#1}}%
  \end{tikzpicture}%
}

\newcommand{\@ntcovertext}[1]{%
  % #1 = cover ID (major-minor)
  % \typeout{@NTCOVERTEXT 1=[#1]}\@NTCOVERTEXT%
  \NTRunHook{cover/#1/text/pre}%
    \optionlistdo{/@nt/cover/\@UNIV/\@SCHL/#1}{\@ntcoverelement@iii{#1}##1}%
  \NTRunHook{cover/#1/text/post}%
}

\def\@ntcoverelement@iii#1#2\@nil#3{%
  % #1 = cover ID (major-minor)
  % #2 = cover element options
  % #3 = cover element code
  \ifblank{#3}{}{%
    \options{/@ntcoveropts, defaults, #2, alignmap=\option{/@ntcoveropts/halign}}%
    % \typeout{@ntcoverelement@iii 1=[#1] 2=[#2] tikz=\option{/@ntcoveropts/tikz}}\@NTCOVERELEMENT@III
    \defifundef{\ifmatchstatus}{\newif}%
    \defifundef{\ifmatchdegree}{\newif}%
    \matchstatustrue%
    \matchdegreetrue%
    \if&\option{/@ntcoveropts/status}&\relax%
    \else%
      \if\instring{,\@DOCSTATUS,}{,\option{/@ntcoveropts/status},}%
      \else%
        \matchstatusfalse%
      \fi%
    \fi%
    \if&\option{/@ntcoveropts/degree}&\relax%
    \else%
      \if\instring{/\@DOCTYPE/}{/\option{/@ntcoveropts/degree}/}%
      \else%
        \matchdegreefalse%
      \fi%
    \fi%
    \ifmatchstatus%
      \ifmatchdegree%
        \iftoggle{/@ntcoveropts/tikz}{%
          % \typeout{TIKZ ADD [@covertikzlist@#1]}\TIKZ%
          \expandafter\gappto\expandafter{\csname @covertikzlist@#1\endcsname}{#3}%
        }{%
          \@ntcoverelement@ii{#1}{#3}%
        }%
      \fi%
    \fi%
  }%
}

\options{/@ntcoveropts/.new family,
  % letter to macro for horizontal alignment
  alignmap/.new choice={c=\centering,l=\raggedright,r=\raggedleft,j=\null},
  % filters / conditional printing
  status/.new value,
  degree/.new value,
  % horizontal alighment and vertical alignments inside the box
  halign/.new choice={c, l, r, j},
  valign/.new choice={c, t, b},
  % height of the box (default = the natural height for the contents)
  height/.new value,
  % height of the box (default = the natural height for the contents)
  height/phd/.new value,
  % height of the box (default = the natural height for the contents)
  height/msc/.new value,
  % minheight of the box (default = the natural height for the contents)
  minheight/.new value,
  % width of the box (default = full width)
  width/.new value,
  % vertical spacing from precious box (default = 0ptcan also be an integer and,,
  % in this caseit means the weight of the vfill),
  vspace/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/phd/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/msc/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/1-1/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/2-1/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/phd/1-1/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/phd/2-1/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/msc/1-1/.new value,
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  vspace/msc/2-1/.new value,
  % horizontal spacing from the left margin (or last box in the same line) (default = 0pt)
  hspace/.new value,
  % is the last box in the line (default = true)
  newpar/.new toggle,
  % text color for the box (default = black)
  color/.new color,
  % background color for the box (default = transparent)
  bgcolor/.new color,
  % tikz cover elements
  tikz/.new toggle,
  % default values
  defaults/.new style*={,
                  vspace=0pt,
                  vspace/msc={}, vspace/phd={},
                  vspace/1-1={}, vspace/2-1={},
                  vspace/msc/1-1={}, vspace/msc/2-1={},
                  vspace/phd/1-1={}, vspace/phd/2-1={},
                  status={}, degree={}, halign=c, valign=c,
                  height={}, height/phd={}, height/msc={},
                  minheight=0pt, width={}, hspace=0pt,
                  newpar=true, color={}, bgcolor={},
                  tikz=false,
  }
}

\newcommand{\@ntcovervspace}[1]{%
  % \typeout{COVERSPACE [1=#1]}\COVERSPACE%
  \ifoptionvoid{/@ntcoveropts/#1}{%
    % \typeout{NT blank [#1=\option{/@ntcoveropts/#1}]}
  }{%
    \IfInteger{\option{/@ntcoveropts/#1}}% USE vspace
      {\vskip 0pt plus \option{/@ntcoveropts/#1}fill}%
      {\vspace*{\option{/@ntcoveropts/#1}}}%
    \ntforbreak%
  }%
}

\newcommand{\@ntcoverelement@ii}[2]{%
  % #1 = cover ID (major-minor)
  % #2 = code
  % If vspace is integer then replace by n*\vfill
  % otherwise it is absolute verstical space
  % \typeout{NT testblank [#1] =========}%
  \ntfor\match:={vspace/\@DOCTYPE/#1,vspace/\@DOCTYPE,vspace/\@DOCCLASS/#1,vspace/\@DOCCLASS,vspace/#1,vspace}%
        \do{\@ntcovervspace{\match}}%
  % Typeset contents in a box
  \@nt@makeboxwithcoverelement@iii{#1}{#2}{\@nt@coverelement}%
  \noindent%
  \hspace*{\option{/@ntcoveropts/hspace}}%
  \ifoptioncontains{/novathesis/debug}{cover}{% If in debug mode surround element in box
    \setlength{\fboxsep}{0pt}\setlength{\fboxrule}{0.5pt}%
    \vspace*{-\fboxrule}\hspace*{-\fboxrule}%
    \fbox{\usebox{\@nt@coverelement}}%
  }{\usebox{\@nt@coverelement}}%
  \iftoggle{/@ntcoveropts/newpar}{\expandafter\par}{}%
}

\newcommand{\@nt@makeboxwithcoverelement@iii}[3]{%
  % #1 = cover ID (major-minor)
  % #2 = code
  % #3 = boxname
  \defifundef{\@mkcvelemwidth}{\newlength}%
  \ifoptionblank{/@ntcoveropts/width}%
    {\setlength{\@mkcvelemwidth}{\dimexpr\linewidth-\option{/@ntcoveropts/hspace}\relax}}%
    {\option{/@ntcoveropts/width}}%
  \defifundef{\ifheightopt}{\newif}%
  \heightoptfalse%
  \ntfor\myh:={height/\@DOCTYPE,height/\@DOCCLASS,height}\do{%
    \ifoptionvoid{/@ntcoveropts/\myh}{}{%
      \edefoption{/@ntcoveropts/\myh}\@mkcvelemheight\heightopttrue\ntforbreak%
    }%
  }%
  % Create destination boxes if undefined and save to it
  \defifundef{#3}{\newsavebox}%
  \begin{lrbox}{#3}%
    \begin{minipage}[t][0pt][t]{0pt}%
      \color{white}\rule{0.000000000000001pt}{\option{/@ntcoveropts/minheight}}%
    \end{minipage}%
    % Minipage definition is different if element height is given or not
    \ifheightopt%
      \minipage[t][\@mkcvelemheight][\option{/@ntcoveropts/valign}]{\@mkcvelemwidth}%
    \else%
      \minipage[t][][\option{/@ntcoveropts/valign}]{\@mkcvelemwidth}%
    \fi%
        \ifoptionblank{/@ntcoveropts/color}{}{\color{\option{/@ntcoveropts/color}}}%
        \option{/@ntcoveropts/alignmap}%
        #2%
    \endminipage%
  \end{lrbox}%
  % Add a background color if needed
  \ifoptionblank{/@ntcoveropts/bgcolor}{}{%
    \savebox{#3}{\colorbox{\option{/@ntcoveropts/bgcolor}}{\usebox{#3}}}%
  }%
}

\newcommand{\@ntfixspacing}[2]{%
    \bgroup%
    \newdata{ntfixspacingstring}%
    \ntfixspacingstring()={The \href{https://github.com/joaomlourenco/novathesis}{NOVAthesis} template (v\novathesisversion)~\@ntcite{novathesis-manual}. (12cc90221730b8ba41bb3b1f8b517acd)}%md5
    \renewcommand*{\bibfont}{\hypersetup{allcolors=#1}\color{#1}%
     \sffamily\fontsize{#2}{#2}\selectfont}%
    \defbibheading{bibliography}[\bibname]{%
    \ \textbf{##1}\\[-20pt]}%
    \refsection%
    \begin{minipage}{\linewidth}%
    \bibfont%
    \thentfixspacingstring()\par%
    \printbibliography%
    \end{minipage}%
    \endrefsection%
    \egroup%
}

\newcommand{\ntfixspacing}{%
  \@ntfixspacing{white}{0.01}%
  % \@ntfixspacing{blue}{16}%
}

\newcommand*{\ntprintstatement}{%
  \ifdocworking{}{% ONly print statement if provisional or final
    \ifmaindoc{% Skip thesis plan and similar documents
      \iftoggle{/novathesis/print/statement}{% if statement toggle is on
        \NTRunHook{statement/pre}%
        \iffileadded{statement}{}{%ELSE
          \ntfor\match:={%
            \@SCHL/\@UNIV-\@SCHL-\@DEGREEACR-\@LANG@MAIN-statement,%
            \@SCHL/\@UNIV-\@SCHL-\@DEGREEACR-statement,%
            \@SCHL/\@UNIV-\@SCHL-\@LANG@MAIN-statement,%
            \@SCHL/\@UNIV-\@SCHL-statement,%
            \@UNIV-\@LANG@MAIN-statement,%
            \@UNIV-statement,%
          }\do{%
            \IfFileExists{NOVAthesisFiles/Schools/\@UNIV/\match.tex}{%
              \ntaddfile{statement}{NOVAthesisFiles/Schools/\@UNIV/\match.tex}%
              \ntforbreak%
            }{}%
          }[%
            \ClassError{novathesis}{No “statement.tex” found! Not defined with %
                                    \string\ntaddfile{statement}{filename} in folders %
                                    “NOVAthesisFiles/Schools/\@UNIV/\@SCHL” nor %
                                    “NOVAthesisFiles/Schools/\@UNIV”}{}
          ]%
        }{}%
        \pdfbookmark[1]{\thebkmstring(statement,\@LANG@MAIN)}{bmstatement}%
        \@ntloadfiles@ii{statement}%
        \NTRunHook{statement/post}%
      }{}%
    }{}%
  }%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print persons list {advisers | committee}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@check@instring}[4][,]{
% 1 = separator
% 2 = value
% 3 = list
% 4 = error
  \IfSubStr{#1#3#1}{#1#2#1}{}{\ClassError{novathesis}{#4: String “#1#2#1” not in “#1#3#1”}{}}%
}

\newcommand{\ntprintpersons}[2][full]{%
  % #1* = { full | name | list }
  % #2  = width in % of textwidth
  % #3* = positioning
  % #4  = number of columns
  % #5  = adviser | committee
  % #6  = {a,c} | {c,r,a,m,g}
  \@ifnextchar[{\@ntprintpersons{#1}{#2}}{\@ntprintpersons{#1}{#2}[l]}%
}

\newcommand*{\@setalignment}[1]{
  \IfStrEqCase{#1}{%
    {l}{\raggedright}%
    {c}{\centering}%
    {r}{\raggedleft}%
  }[\ClassError{novathesis}{Invalid alignment “#1”}{}]%
}

\def\@ntprintpersons#1#2[#3]#4#5#6{
  % #1 = { full | name | list }
  % #2 = width in % of textwidth
  % #3 = positioning
  % #4 = number of columns
  % #5 = adviser | committee
  % #6 = {a,c} | {c,r,a,m,g}
  % \typeout{NTPRINTPERSONS 1=[#1] 2=[#2] 3=[#3] 4=[#4] 5=[#5] 6=[#6]}\NTPRINTPERSONS
  \@check@instring{#1}{full,name,list}{@ntprintpersons}%
  \iftoggle{/novathesis/print/#5}{%
    \begin{minipage}[t]{\linewidth}%
      \setlength{\parindent}{0pt}%
      \@setalignment{#3}%
      \begin{varwidth}{#2\linewidth}%
        \IfStrEqCase{#4}{%
          {0}{\@ntprintpersonsaslist{#5}{#6}}%
          {1}{\@ntprintpersonsasonecolumn{#1}{#2}{#5}{#6}}%
          {2}{\@ntprintpersonsastwocolumns{#1}{#5}{#6}}%
        }[\ClassError{novathesis}{Ivalid argument [#4] to \string\ntprintpersons{#1}{#2}{#4}{#5}{#6}}{}]%
      \end{varwidth}%
    \end{minipage}%
  }{}%
}

%============================================================
% Print persons list {advisers | committee} as list
%============================================================
\newcommand{\@ntprintpersonsaslist}[2]{%
  % #1 = adviser | committee
  % #2 = {a,c} | {c,r,a,m,g}
  % Build list of names
  % \typeout{NTPRINTPERSONSASLIST 1=[#1] 2=[#2]}\NTPRINTPERSONSASLIST%
  \ifdatadefined{#1titlestring}(\@LANG@COVER){%
    \datadefault{#1titlestringpre}(\@LANG@COVER)%
    \datadefault{#1titlestringfont}(\@LANG@COVER)%
    \csuse{the#1titlestring}(\@LANG@COVER)%
    \datadefault{#1titlestringpost}(\@LANG@COVER)%
  }{}%
  \def\@nt@personlist{}%
  \def\@nt@listsep{}%
  \@for\myi:=\expanded{#2}\do{%
    \ifoptionvoid{/@nt/#1/\myi/name}{}{%
      \letoptionlist{/@nt/#1/\myi/name}\@nt@person@sublist%
      \eappto\@nt@personlist{\@nt@listsep\@nt@person@sublist}\def\@nt@listsep{,}%
    }%
  }%
  \raggedright%
  % \StrGobbleRight{\@nt@personlist}{1}%
  \datadefault{#1namefont}(#2)\@replacelastcomma{\@nt@personlist}%
}

\def\@replacelastcomma#1{%
  % \typeout{REP1 [#1]}%
  % \@replacelastcomma@i{}{}#1,\nil}
  \expandafter\@replacelastcomma@i\expandafter{\expandafter}\expandafter{\expandafter}#1,\nil}

\def\@replacelastcomma@i#1#2#3,#4\nil{%
  % \typeout{REP2 [#1] [#2] [#3] [#4]}%
  \if\relax\detokenize{#4}\relax
    #2\trimspaces{#3}%
  \else % #4 is not empty
    #1\trimspaces{#3}%
    \@replacelastcomma@i{\thecommastring(\@LSHORT)}%
        {\theandstring(\@LSHORT)}#4\nil%
  \fi
}

%============================================================
% Print persons list {advisers | committee} as one and two columns
%============================================================
\newcommand{\@ntgetmaxlen}[2]{%
  \defifundef{\stringlen}{\newdimen}%
  \defifundef{\maxlen}{\newdimen}%
  \setlength{\maxlen}{0pt}%
  \@for\myx:=\expanded{#1}\do{%
    \setlength{\stringlen}{\widthof{\@nt@printgrouptitle@text{#2}{\myx}~~}}%
    \ifdim\stringlen>\maxlen\relax\setlength{\maxlen}{\stringlen}\fi%
  }%
}
\newcommand{\@ntprintpersonsasonecolumn}[4]{%
  % #1 = { full | name }
  % #2 = width in % of textwidth
  % #3 = adviser | committee
  % #4 = {a,c} | {c,r,a,m,g}
  % \@check@instring{#1}{full,name}{@ntprintpersonsasonecolumn}%
  \csuse{#3stringpost}():=?{:\\[2pt]}%
  \csuse{#3namepost}():=?{{\\}}%
  \csuse{#3remainderpre}():=?{{\\[-2pt]}}%
  \personpost():=?{\\[2pt]}%
  \persongrouppost():=?{\\[7pt]}
  \committeetitlestringpost():=?{\\[5pt]}%
  \@ntgetmaxlen{#3}{#2}%
  \begin{tabularx}{#2\linewidth}[t]{@{}L@{}}%
    \ifdatadefined{#3titlestring}(\@LANG@COVER){%
      \datadefault{#3titlestringpre}()%
      \datadefault{#3titlestringfont}()%
      \csuse{the#3titlestring}(\@LANG@COVER)%
      \datadefault{#3titlestringpost}()%
    }{%
      \ifdatadefined{committeetitlestring}(\@LANG@COVER){%
        \datadefault{committeetitlestringpre}()%
        \datadefault{committeetitlestringfont}()%
        \strut%
        \datadefault{committeetitlestringpost}()%
      }{}%
    }%
    \expandnext{\forcsvlist{\@nt@ntprintpersongroup[#1]{1}{#3}}}{\expanded{#4}}%
    % \@for\arg:=\expanded{#4}\do{\@nt@ntprintpersongroup{#1}{1}{#3}{\arg}}
  \end{tabularx}%
}

\newcommand{\@ntprintpersonsastwocolumns}[3]{%
  % #1 = { full | name }
  % #2 = adviser | committee
  % #3 = {a,c} | {c,r,a,m,g}
  % \typeout{NTPRINTPERSONSASTWOCOLUMNS 1=[#1] 2=[#2] 3=[#3]}\NTPRINTPERSONSASTWOCOLUMNS
  % \@check@instring{#1}{full,name}{@ntprintpersonsasonecolumn}%
  \csuse{#2stringpost}():=?{:&}%
  \csuse{#2remainderpre}():=?{{\\[-2pt]}}%
  \personpost():=?{\\[2pt]}%
  \persongrouppost():=?{\\[14pt]}
  \committeetitlestringpre():=?{&}%
  \committeetitlestringpost():=?{\\[5pt]}%
  % \typeout{NTPRINTPERSONSASTWOCOLUMNS 1=[#1] 2=[#2] 3=[#3] #2stringpost=[\csuse{the#2stringpost}()]}\NTPRINTPERSONSASTWOCOLUMNS
  \@ntgetmaxlen{#3}{#2}%
  \begin{tabular}[t]{@{}r@{~~}l@{}}%
    \ifdatadefined{#2titlestring}(\@LANG@COVER){%
      \datadefault{#2titlestringpre}()%
      \datadefault{#2titlestringfont}()%
      \csuse{the#2titlestring}(\@LANG@COVER)%
      \datadefault{#2titlestringpost}()%
    }{}%
    \expandnext{\forcsvlist{\@nt@ntprintpersongroup[#1]{2}{#2}}}{\expanded{#3}}%
    % \@for\myx:={#3}\do{\@nt@ntprintpersongroup[#1]{2}{#2}{\myx}}%
  \end{tabular}%
}

\newcommand{\@nt@printgrouptitle@text}[2]{%
  % #1 = {adviser | committee}
  % #2 = {a,c} | {c,r,a,m,g}
  \ifoptiondefined{/@nt/#1/#2/full}{%
  \ifnum\value{\option{/@nt/#1/#2/full/@size}}>0\relax%
  % \typeout{/@nt/#1/#2/full=\arabic{\option{/@nt/#1/#2/full/@size}}}\AAAAA
    \@nt@reducegender{/@nt/#1/#2/gender}{\@nt@advgender}%
    \@nt@reducenumber{/@nt/#1/#2/full}{\@nt@advnumber}%
    \bgroup%
      \datadefault{#1stringfont}(#2)%
      \datadefault{#1string}(#2,\@nt@advnumber,\@nt@advgender,\@LANG@COVER)%
    \egroup%
  \fi%
  }{}%
}

\newcommand{\@nt@printgrouptitle}[2]{%
  % #1 = {adviser | committee}
  % #2 = {a,c} | {c,r,a,m,g}
  \ifnum\value{\option{/@nt/#1/#2/full/@size}}>0\relax%
  \@nt@reducegender{/@nt/#1/#2/gender}{\@nt@advgender}%
  \@nt@reducenumber{/@nt/#1/#2/full}{\@nt@advnumber}%
  \datadefault{#1stringpre}(#2)%
  \bgroup%
    \datadefault{#1stringfont}(#2)%
    \datadefault{#1string}(#2,\@nt@advnumber,\@nt@advgender,\@LANG@COVER)%
  \egroup%
  \datadefault{#1stringpost}(#2)%
  \fi%
}

\newcommand{\@nt@ntprintpersongroup}[4][full]{%
  % #1 = { full | name | list }
  % #2 = {1 | 2}
  % #3 = {adviser | committee}
  % #4 = {a,c} | {c,r,a,m,g}
  \ifoptiondefined{/@nt/#3/#4/full}{%
  \ifnum\value{\option{/@nt/#3/#4/full/@size}}>0\relax%
    % \typeout{NTPRINTPERSONGROUP 1=[#1] 2=[#2] 3=[#3] 4=[#4]}\NTPRINTPERSONGROUP
    \@nt@printgrouptitle{#3}{#4}%
    \begin{varwidth}[t]{\linewidth-\maxlen}%
      \raggedright%
      \IfStrEq{#1}{list}{%
        \@ntprintpersonsaslist{#3}{#4}%
      }{%
        \optionlistdo{/@nt/#3/#4/full}{\@nt@printonename{#1}{#3}{#4}{##1}}%
      }%
    \end{varwidth}%
    \thepersongrouppost()%
  \fi%
  }{}%
}


%============================================================
% Print person aux funcitons
%============================================================
\newcommand{\@nt@printonename}[4]{%
% #1 = { full | name }
% #2 = adviser | coadviser | committee
% #3 = {a,c} | {c,r,a,m,g}
% #4 = (co)adviser info
% \typeout{NTPRINTONENAME 1=[#1] 2=[#2] 3=[#4]}\NTPRINTONENAME
\datadefault{personpre}(#3)%
\begingroup
  \noexpandarg
  \raggedright%
  \datadefault{#2namepre}(#3)%
  \StrCut{#4}{,}\@nt@name\@nt@remainder% split name from remainder
  % \ignorespaces\parbox[b]{\linewidth}%
  %                        {\raggedright\datadefault{#2namefont}(#3)\@nt@name}%
  \datadefault{#2namefont}(#3)\@nt@name%
  \IfStrEq{#1}{full}{%
    \IfStrEq{\@nt@remainder}{}{}{%
      \datadefault{#2remainderpre}(#3)%
      \bgroup%
        \datadefault{#2remainderfont}(#3)%
        % \ignorespaces{\parbox[t]{\linewidth}%
        %                            {\raggedright\@nt@remainder}}%
        \@nt@remainder%
      \egroup%
      \datadefault{#2remainderpost}(#3)%
    }%
  }{}%
\endgroup
\datadefault{personpost}(#3)%
}

\newcommand*{\@nt@reducegender}[2]{%
    % #1=gender list
    % #2=result
    \gdef#2{f}%
    \optionlistdo{#1}{\if##1m\relax\gdef#2{m}\fi}%
}

\newcommand*{\@nt@reducenumber}[2]{%
    % #1=options list
    % #2=result (1|2)
    \ifnum\value{\option{#1/@size}}=1\gdef#2{1}\else\gdef#2{2}\fi
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtEndPreamble{\ntsetlayout}%

\newcommand*{\ntsetlayout}{%
    % \synctex=1% Use synctex
    \brokenpenalty=10000%
    \settypeoutlayoutunit{mm}%
    \setulmarginsandblock%
    {\themargin(\option{/novathesis/media},top)}%
    {\themargin(\option{/novathesis/media},bottom)}%
    {*}%
    \setlrmarginsandblock%
    {\themargin(\option{/novathesis/media},left)}%
    {\themargin(\option{/novathesis/media},right)}%
    {*}%
    \checkandfixthelayout%
    \ifoptionequal{/novathesis/media}{paper}{\openright}{}%
}

\newcommand*{\setpdftexpagesize}{%
  \@ifundefined{pdfpageheight}{}{\pdfpageheight=\the\stockheight}
  \@ifundefined{pdfpagewidth}{}{\pdfpagewidth=\the\stockwidth}
  \@ifundefined{pageheight}{}{\pageheight=\the\stockheight}
  \@ifundefined{pagewidth}{}{\pagewidth=\the\stockwidth}
  \@ifundefined{pdfvorigin}{}{\ifdim\pdfvorigin=0pt\pdfvorigin=1in\fi}
  \@ifundefined{pdfhorigin}{}{\ifdim\pdfhorigin=0pt\pdfhorigin=1in\fi}
  % \ifundef{\pdfpagewidth}{%
  %   \ifundef{\pagewidth}{}{\pagewidth=\paperwidth}%
  % }{\pdfpagewidth=\paperwidth}%
  % \ifundef{\pdfpageheight}{%
  %   \ifundef{\pageheight}{}{\pageheight=\paperheight}%
  % }{\pdfpageheight=\paperheight}%
}

\DeclareRobustCommand\nt@changelayout{%
  \setlength{\@colht}{\textheight}
  \setlength{\@colroom}{\textheight}%
  \setlength{\vsize}{\textheight}
  \setlength{\columnwidth}{\textwidth}%
  \if@twocolumn%
    \advance\columnwidth-\columnsep
    \divide\columnwidth\tw@%
    \@firstcolumntrue%
  \fi%
  \setlength{\hsize}{\columnwidth}%
  \setlength{\linewidth}{\hsize}%
}%

\newcommand\nt@savelength[2]{%
  \csappto{nt@restoregeometry@#1}{%
    \expandafter\csname
    #2\endcsname\expandafter=\expandafter\the\csname #2\endcsname\relax
  }%
}
\newcommand\nt@saveboolean[2]{%
  \csname if#2\endcsname
  \csappto{nt@restoregeometry@#1}{%
          \expandafter\noexpand\csname #1true\endcsname}%
  \else
  \csappto{nt@restoregeometry@#1\endcsname}{%
          \expandafter\noexpand\csname #1false\endcsname}%
  \fi
}%

\newcommand\nt@restoregeometry{%
  \csuse{nt@restoregeometryB@\the\c@pdfnewlytlevel}%
  \addtocounter{pdfnewlytlevel}{-1}%
}

\newcommand\nt@savegeometry{%
  \addtocounter{pdfnewlytlevel}{1}%
  \csgdef{nt@restoregeometryA@\the\c@pdfnewlytlevel}{}%
  \nt@savelength{\the\c@pdfnewlytlevel}{paperwidth}%
  \nt@savelength{\the\c@pdfnewlytlevel}{paperheight}%
  \nt@savelength{\the\c@pdfnewlytlevel}{textwidth}%
  \nt@savelength{\the\c@pdfnewlytlevel}{textheight}%
  \nt@savelength{\the\c@pdfnewlytlevel}{evensidemargin}%
  \nt@savelength{\the\c@pdfnewlytlevel}{oddsidemargin}%
  \nt@savelength{\the\c@pdfnewlytlevel}{topmargin}%
  \nt@savelength{\the\c@pdfnewlytlevel}{headheight}%
  \nt@savelength{\the\c@pdfnewlytlevel}{headsep}%
  \nt@savelength{\the\c@pdfnewlytlevel}{topskip}%
  \nt@savelength{\the\c@pdfnewlytlevel}{footskip}%
  \nt@savelength{\the\c@pdfnewlytlevel}{baselineskip}%
  \nt@savelength{\the\c@pdfnewlytlevel}{marginparwidth}%
  \nt@savelength{\the\c@pdfnewlytlevel}{marginparsep}%
  \nt@savelength{\the\c@pdfnewlytlevel}{columnsep}%
  \nt@savelength{\the\c@pdfnewlytlevel}{hoffset}%
  \nt@savelength{\the\c@pdfnewlytlevel}{voffset}
  \nt@saveboolean{\the\c@pdfnewlytlevel}{@twocolumn}%
  \nt@saveboolean{\the\c@pdfnewlytlevel}{@twoside}%
  \nt@saveboolean{\the\c@pdfnewlytlevel}{@mparswitch}%
  \nt@saveboolean{\the\c@pdfnewlytlevel}{@reversemargin}%
}

\newcounter{pdfnewlytlevel}
\RequirePackage{atbegshi}
\newenvironment{newpdflayout}[3][]{%
  % #1 = page height
  % #2 = page width
  % \typeout{textheight=\the\textheight}
  % \typeout{textwidth=\the\textwidth}
  % \AAAA
  \nt@savegeometry%
  \let\oldstockheight=\stockheight
  \let\oldstockwidth=\stockwidth
  \clearpage
  \begingroup
  \setstocksize{#2}{#3}
  \settrimmedsize{#2}{#3}{*}
  \paperwidth=\stockwidth
  \paperheight=\stockheight
  \setlrmarginsandblock%
    {\themargin(\option{/novathesis/media},left)}%
    {\themargin(\option{/novathesis/media},right)}%
    {*}%
  \setulmarginsandblock%
    {\themargin(\option{/novathesis/media},top)}%
    {\themargin(\option{/novathesis/media},bottom)}%
    {*}%
  #1%
  \checkandfixthelayout[fixed]
  \setpdftexpagesize
  % From geometry
  % \typeout{textheight=\the\textheight}
  % \typeout{textwidth=\the\textwidth}
  % \BBBB
  \nt@changelayout%
}{%
  \clearpage%
  \endgroup%
  \nt@restoregeometry
  % \setstocksize{\oldstockheight}{\oldstockwidth}
  % \settrimmedsize{\oldstockheight}{\oldstockwidth}{*}
  % \paperwidth=\stockwidth
  % \paperheight=\stockheight
  % \setlrmarginsandblock%
  %   {\themargin(\option{/novathesis/media},left)}%
  %   {\themargin(\option{/novathesis/media},right)}%
  %   {*}%
  % \setulmarginsandblock%
  %   {\themargin(\option{/novathesis/media},top)}%
  %   {\themargin(\option{/novathesis/media},bottom)}%
  %   {*}%
  \checkandfixthelayout[fixed]
  \setpdftexpagesize
  \nt@changelayout
  \clearpage%
  \addtocounter{page}{-1}%
  ~\AtBeginShipoutDiscard
  \clearpage
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Printing chapters and similars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@nt@printifmaindoc@i}[1]{%
  % \typeout{NT Attempt to load #1}%
  \ifmaindoc{% THEN it is a main document
    \NTRunHook{#1/pre}%
    \iffileadded{#1}{%
      \pdfbookmark[1]{\thebkmstring(#1,\@LANG@MAIN)}{bm#1}%
      \@ntloadfiles@ii{#1}%
    }{}%
    \NTRunHook{#1/post}%
    \clearforchapter%
  }{}% It is a plan or proposal type document
}

\newcommand{\ntprintdedicatory}{\@nt@printifmaindoc@i{dedicatory}}

\newcommand{\ntprintquote}{\@nt@printifmaindoc@i{quote}}

\newcommand{\ntprintacknowledgements}{\@nt@printifmaindoc@i{acknowledgements}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Abstract, Acronyms and Glossary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintabstracts}{%
  \NTRunHook{abstracts/pre}%
  \@for\myi:=\expanded{\theabstractorder(\@LANG@MAIN)}\do{\@ntprintabstract{\myi}}%
  \NTRunHook{abstracts/post}%
}

\newcommand{\@ntprintabstract}[1]{%
  % \typeout{NT PRINT ABSTRACT=[#1]}\NTPRINTABSTRACT@I%
  \iffileadded[#1]{abstract}{%
    % \typeout{NT PRINT ABSTRACT 2=[#1]}\NTPRINTABSTRACT@II
    \begingroup
      % \typeout{NT PRINT ABSTRACT #1}\bbbb
      \StrCut{#1}{-}\@ABS@LANG\@dummy%
      \ntselectlang{\@ABS@LANG}%
      % \typeout{NTL=\languagename [#1]}\bbbb
      \pdfbookmark[1]{\thebkmstring(abstract,#1)}{bmabstract#1}%
      \NTRunHook{abstract/pre}%
      \NTRunHook{abstract/#1/pre}%
      \printabstracttitle{#1}%
      \NTRunHook{abstract/#1/mid}%
      \NTRunHook{abstract/mid}%
      \@ntloadfiles@ii[#1]{abstract}%
      \NTRunHook{abstract/#1/post}%
      \NTRunHook{abstract/post}%
    \endgroup%
    \clearforchapter%
  }{}%
}

\newcommand{\ntprintindex}{%
  % \printglossary[type=index]%
  \printindex%
  \clearforchapter%
}

\newcommand*{\ntthesisfrontmatter}{%
  \NTRunHook{frontmatter/pre}%
  \frontmatter%
  \begingroup
  \pagestyle{novathesis@frontmatter}%
  \copypagestyle{chapter}{novathesis@frontmatter}
  % \ntselectlang{\@LANG@MAIN}%
  \pagenumbering{roman}%
  \NTRunHook{frontmatter/post}%
}

\newcommand*{\ntthesismainmatter}{%
  \endgroup
  \bookmarksetup{startatroot}%
  \NTRunHook{mainmatter/pre}%
  \ifbool{@openright}{}{% openany=true
    % Avoid cleardoublepage before "mainmatter"
    \let\oldcleardoublepage\cleardoublepage%
    \renewcommand{\cleardoublepage}{\clearforchapter}%
  }%
  \mainmatter%
  \ifbool{@openright}{}{% openany=true
    \let\cleardoublepage\oldcleardoublepage%
  }%
  \pagestyle{novathesis@mainmatter}%
  \ifxeorlua{}{\microtypesetup{protrusion=true}}%
  \NTRunHook{mainmatter/post}%
}

\newcommand{\ntindex}[2][]{%
  % \typeout{NTINDEX [#1] [#2]}
  \bgroup%
    \ifoptioncontains{/novathesis/debug}{index}{\showlabelsinline}{}%
    \StrRight{#1}{1}[\@nt@index]%
    \if\@nt@index!\relax
      \def\@nt@index{#1#2}%
    \else
      \def\@nt@index{#1}%
    \fi%
    \index{\@nt@index}#2%
  \egroup%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntprintchapters}{%
    \@nt@foralllist{file}{chapter}{\@ntloadfiles@ii{chapter}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Appendixes and Annexes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand*{\addappheadtotoc}{%
    \phantomsection\addtocontents{toc}%
    {\protect\contentsline{chapter}{\appendixtocname}{}{}}%
 }

\newcommand*{\ntprintappendices}{%
  \iffileadded{appendix}{%
    \renewcommand{\appendixtocname}{\appendixplname}%
    \appendix\addappheadtotoc%
    \@nt@foralllist{file}{appendix}{\@ntloadfiles@ii{appendix}}%
  }{}%
}

\newcommand*{\ntprintannexes}{%
  \iffileadded{annex}{%
    % \renewcommand{\appendixtocname}{\translate{Annexes}}%
    \renewcommand{\appendixtocname}{\annexplname}%
    \annex\addappheadtotoc%
    \@nt@foralllist{file}{annex}{\@ntloadfiles@ii{annex}}%
  }{}%
}

\ifdef{\annexcounter}{}{\def\annexcounter{\old@Roman}}
\newcommand*{\annex}{%
  \xdef\Hy@chapapp{annex}%
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\translate{annex}}%
  \gdef\thechapter{\annexcounter\c@chapter}%
}%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with optional lists in the frontmatter: listoftables, litoffigures, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntprintalllistof}{%
    \NTRunHook{listof/pre}%
    \optionlistdo{/@nt/list/listof}{\clearforchapter##1}%
    \NTRunHook{listof/post}%
}


% \def\option@listmatch@getval#1=#2{#2}
\newcommand*{\option@listmatch}[2]{
    % \typeout{NT LISTMATCH [#1] [#2]}%
    \StrCut{#2}{=}\option@listmatch@key\option@listmatch@value%was xStrCut
    % \typeout{K=\option@listmatch@key ~V=\option@listmatch@value}%
    \IfStrEq{#1}{\option@listmatch@key}{\listbreak}{}%
}%
\options{/handlers/getval/.new operation={%
    % \typeout{NT GETVAL [#1] [#2]}%
    \optionlistdo{#1}{\option@listmatch{#2}{##1}}%
    }%
}

\newcommand*{\@loadglossaryfiles}{%
  \@for\listitem:={glossary,acronym,symbols}\do{%
    \iffileadded[\listitem]{glossaries}{\@nt@loadallfiles{\listitem}{glossaries}}{}%
  }%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand*{\ntprintbib}[1][]{%
  \NTRunHook{printbib/pre}%
  \printbibliography[#1]%
  \ntfixspacing%
  \NTRunHook{printbib/post}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintacknowledgementsblock}[1][\scriptsize]{%
    \NTRunHook{acknowledgementsblock/pre}%
    \noindent\parbox{\linewidth}{%
    \vspace*{2.5ex}\footnoterule#1\theacknowledgmentsstring(\@LANG@MAIN)}
    \NTRunHook{acknowledgementsblock/post}%
}

\newcommand*{\ntprintcopyright}{%
  \iftoggle{/novathesis/print/copyright}{%
    \ifmaindoc{%
      \begingroup
        \ntselectlang{\@LANG@COPYRIGHT}%
        \pdfbookmark[1]{\thebkmstring(copyright,\@LANG@MAIN)}{bmcopyright}%
        \NTRunHook{copyright/pre}%
        \ntprintcopyrightpage%
        \NTRunHook{copyright/post}%
        \ntprintacknowledgementsblock%
        \clearforchapter%
      \endgroup
    }{}%
   }{}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quoting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\hugequote}{%
  \bgroup%
    \color{black!30}%
    \fontsize{75}{80}\selectfont%
    \fontfamily{ptm}\selectfont%
    \textit{\glqq}%
  \egroup%
}

\newcommand{\ntquoteauthor}[1]{{\\[1.25ex]\footnotesize\bfseries---~#1}}
\newcommand{\ntquotewhere}[1]{{\footnotesize, #1}}
\newcommand{\ntquoteprofession}[1]{{\footnotesize\\[-0.75ex](#1)}}
\newcommand{\ntquotetext}[1]{{\itshape#1}}
\newcommand{\ntquoteskip}{%
  \vphantom{%
    \begin{minipage}{\textwidth}%
      \chapter*{ASDF}%
      % \vspace*{\midchapskip}%
    \end{minipage}%
  }%
}

\NewDocumentEnvironment{ntquoting}{sO{10cm}O{}O{}O{}O{\@LANG@MAIN}+b}{%
% 1 [*] => print big quote
% 2 [o] => max width of citation box
% 3 [o] => author name
% 4 [o] => where/source
% 5 [o] => profession
% 6 [o] => lang
% 7 [b] => quotation
  % \typeout{
  %          1=[#1]
  %          2=[#2]
  %          3=[#3]
  %          4=[#4]
  %          5=[#5]
  %          6=[#6]
  %          7=[#7]
  % }\asdfg
  \iftoggle{/novathesis/numberallpages}%
    {\thispagestyle{novathesis@frontmatter}}%
    {\thispagestyle{empty}}%
  \defifundef{\ntqbox}{\newsavebox}%
  \savebox{\ntqbox}{#7}
  \ifdim\wd\ntqbox<\ifblank{#2}{\textwidth}{#2}\relax
  \@tempdima=\wd\ntqbox
  \else
  \@tempdima=#2
  \fi
  \ntquoteskip
  \begin{flushright}
    \NTRunHook{ntquote/pre}%
    \IfBooleanTF{#1}{\hugequote}{}
    \begin{minipage}[t]{\@tempdima}
      \raggedleft\normalsize
      % \options{/@nt/lang/shorttolong=#6}%
      \IfBooleanTF{#1}{%
        \foreigntextquote{\thelanglong(#6)}{\ntquotetext{#7}}%
      }{\ntquotetext#7}
      \ifblank{#3}{}{\ntquoteauthor{#3}}%
      \ifblank{#4}{}{\ntquotewhere{#4}}%
      \ifblank{#5}{}{\ntquoteprofession{#5}}%
    \end{minipage}%
    \NTRunHook{ntquote/post}%
  \end{flushright}
}{}

\ExplSyntaxOn
\cs_new:cpn {ntquote} {\ntquoting*}
\cs_new_eq:cN {endntquote} \endntquoting
\cs_new:cpn {ntdedicatory} {\ntquoting}
\cs_new_eq:cN {endntdedicatory} \endntquoting
\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{ntacknowledgements}{%
    \chapter*{\thebkmstring(acknowledgements,\@LANG@MAIN)}%
}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\printabstracttitle}[1]{%
  \chapter*{\thebkmstring(abstract,#1)}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand{\keywords}[1]{%
    \NTRunHook{keywords/pre}%
    % \NTRunHook{keywords/#1/pre}%
    \def\and{\unskip\datadefault{keywordssep}(\@LSHORT)}%
    % \def\and{{\textperiodcentered} }%
    \par\addvspace\baselineskip\noindent%
    \begingroup%
    \datadefault{keywordsstringprefix}(\@LSHORT)%
    \datadefault{keywordsstringfont}(\@LSHORT)%
    \csuse{thekeywordsstring}(\@LSHORT)%
    \datadefault{keywordsstringsuffix}(\@LSHORT)%
    \endgroup%
    % \enspace
    \ignorespaces#1%
    % \NTRunHook{keywords/#1/post}%
    \NTRunHook{keywords/post}%
}%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand\thepresentationtext{%
  \thedissertationstringfont()%
  \ifdatadefined{dissertationstring}(\@DOCTYPE,\@LANG@COVER){%
    \thedissertationstring(\@DOCTYPE,\@LANG@COVER)%
  }{%
    \thedissertationstring(\@DOCCLASS,\@LANG@COVER)%
  }%
}

\providecommand\thecopyrightstr{%
    \iftoggle{/novathesis/numberallpages}%
     {\thispagestyle{novathesis@frontmatter}}%
     {\thispagestyle{empty}}%
    \noindent%
    Copyright \textcopyright\ \thedocauthor(name), %
    \theschool(\@LANG@COPYRIGHT), \theuniversity(\@LANG@COPYRIGHT).\\%
    \thecopyrighttextstring(\@LANG@COPYRIGHT)%
    % \ntselectlang{\@LANG@MAIN}%
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
\renewcommand*{\@pnumwidth}{2.5em}% default is 1.55em

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Text style
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifcsdef{chs@\option{/novathesis/style/chapter}}{%
  \chapterstyle{\option{/novathesis/style/chapter}}%
}{%
  \InputIfFileExists{NOVAthesisFiles/ChapStyles/\option{/novathesis/style/chapter}.ldf}{}%
                    {\ClassError{novathesis}{Invalid Chapter Style: \option{/novathesis/style/chapter}}{}}%
}
\InputIfFileExists{NOVAthesisFiles/FontStyles/\option{/novathesis/style/font}.ldf}{}{%
  % else
  \IfFileExists{\option{/novathesis/style/font}.sty}%
    {\RequirePackage{\option{/novathesis/style/font}}}%
    {\ClassError{novathesis}{Invalid Font Style: \option{/novathesis/style/font}}{}}%
}

\ifxeorlua{\definecolor{nearlywhite}{gray}{0.999999}\colorlet{white}{nearlywhite}}{}

\AtBeginDocument{%
  \makeatletter%
  % \typeout{XXX [\thedocauthor(name)]}
  % \typeout{XXX [\thedoctitle(\@LANG@MAIN,main)]}
  % \typeout{XXX [\thedoctitle(\@LANG@MAIN,sub)]}
  \hypersetup{%
    pdfauthor={\thedocauthor(name)},
    pdftitle={\thedoctitle(\@LANG@MAIN,main)},
    pdfsubject={\thedoctitle(\@LANG@MAIN,sub)},
  }

  %--------------------------------
  % If subcaption is loaded, let it handle subfigures
  % otherwise use memoir subfigures
  \@ifpackageloaded{subcaption}{}{\newsubfloat{figure}}
  \newcommand{\@ntcite}[1]{\ifdef{\parencite}{\parencite{#1}}{\cite{#1}}}
  \makeatother
}

