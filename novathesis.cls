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
%% Version 2021-05-06 [6.4.1]
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
%%      If you use this template, please be kind and cite it in your bibliography:
%%           “João M. Lourenço, The NOVAthesis \LaTeX\ Template User’s Manual,
%%            NOVA University Lisbon, 2021,
%%            https://github.com/joaomlourenco/novathesis/raw/master/template.pdf.”
%%      The BibTeX entry is already in the exxample “bibliography.bib” file:
%%           @Manual{novathesis-manual,
%%              title       ={{The NOVAthesis \LaTeX\ Template User's Manual}},
%%              author      ={João M. Lourenço},
%%              organization={NOVA University Lisbon},
%%              year        ={2021},
%%              url         ={https://github.com/joaomlourenco/novathesis/raw/master/template.pdf},
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
\ProvidesClass{novathesis}[2021-05-06 novathesis template]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SOME ESSENTIAL PACKAGES
%%    Others will be loaded later, in the file “packages.tex”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{iftex}
\RequirePackage{etoolbox}
\RequirePackage{xifthen}
\RequirePackage{xstring}
\RequirePackage{NOVAthesisFiles/nt-options}
\RequirePackage{NOVAthesisFiles/assocarray}
\RequirePackage{NOVAthesisFiles/nt-version}
% \RequirePackage{nt-repeat}
% To process lists and other stuff

%%%%% Configure Graphics
\RequirePackage[nobeamer]{graphbox}% improved version of "graphicx"
\graphicspath{{Chapters/Figures/}}
\DeclareGraphicsExtensions{.pdf,.png,.jpg,.tif}
\providecommand*\appendtographicspath[1]{\gappto\Ginput@path{#1}}
\providecommand*\prependtographicspath[1]{\gpreto\Ginput@path{#1}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK IF USING LUALATEX OR XELATEX
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \newif\ifxetexorluatex
% \begingroup\catcode94=7 \catcode0=9% ASCII 94 is ^
% \def\empty{}\def\next{^^^^0000}\expandafter\endgroup
% \ifx\next\empty\xetexorluatextrue\else\xetexorluatexfalse\fi
%
% \newcommand{\ifxeorlua}[2]{\ifxetexorluatex#1\else#2\fi}

\newcommand{\ifxeorlua}{\ifthenelse{\boolean{luatex}\OR\boolean{xetex}}}
\newcommand{\ifxetexorluatex}{\iftutex}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand*{\defifundef}[2]{\ifundef{#1}{#2{#1}}{}}

% --------------------------------------------------------
% If necessary create, then initialize the counter
\newcommand*{\setnewcounter}[2]{%
  \ifcsname c@#1\endcsname\else\newcounter{#1}\fi%
  \setcounter{#1}{#2}%
}

% --------------------------------------------------------
% Print string between <...>
\newcommand*{\embrace}[1]{$\langle$#1$\rangle$}


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


% --------------------------------------------------------
% Check if a font file exists
\newcommand*{\ntcheckfont}[2]{%
  \IfFileExists{NOVAthesisFiles/FontStyles/Fonts/#1}{}%
               {\ClassError{novathesis}{Missing font “#1”! Please download from: “#2” and copy it to “NOVAthesisFiles/FontStyles/Fonts/#1”}{Please download from: “#2” and copy it to “NOVAthesisFiles/FontStyles/Fonts/#1”}}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INTERNAL KEY-VAL STUFF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/.new family
  , langsshort/.new list={en, pt, fr, it, de, es}
  , currentlang/.new choice={en, pt, fr, it, de, es}
  , langshorttolong/.new choice={en=english, pt=portuguese, fr=french, it=italian, de=german, es=spanish}
  , biblatex/.new list
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
\options{/@nt/document/.cd
  , fallback/.new list={phdprop=phd, phdplan=phd, mscplan=msc}
  , class/phd/.new list={phd, phdprop, phdplan}
  , class/msc/.new list={msc, mscplan}
  , class/bsc/.new list={bsc}
  , class/main/.new list={phd, msc, bsc}
}

\newcommand{\@ifdocclass@ii}[2]{%
  % #1=document type
  % %2=possible document calss 
  \ifoptioncontains{/@nt/document/class/#1}{#2}%
}

% --------------------------------------------------------
% Check if the document is of a specific class, i.e., bsc, msc, phd or main
\newcommand{\ifmaindoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{main}{#1}}
\newcommand{\ifphddoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{phd}{#1}}
\newcommand{\ifmscdoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{msc}{#1}}
\newcommand{\ifbscdoc}[1][\option{/novathesis/docdegree}]{\@ifdocclass@ii{bsc}{#1}}

\newcommand{\ifdocfinal}{\ifoptionequal{/novathesis/docstatus}{final}}
\newcommand{\ifdocprovisional}{\ifoptionequal{/novathesis/docstatus}{provisional}}
\newcommand{\ifdocdraft}{\ifoptionequal{/novathesis/docstatus}{draft}}
\newcommand{\ifdocworking}{\ifoptionequal{/novathesis/docstatus}{working}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE PERSON LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ntaddperson#1[#2]{%
  % syntax: \ntaddperson{class}[key]{name}
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
  \options{/@nt/currentlang=#1}
  \options{/@nt/langshorttolong=#1}%
  % \edef\@nt@tmp{\option{/@nt/langshorttolong}}%
  % \typeout{'NT SWITCHING LANG TO='\nt@tmp}%
  \expandafter\selectlanguage\expandafter{\expanded{\option{/@nt/langshorttolong}}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ASSOCARRAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\@nt@undefined}[1][]{\embrace{#1 \thenotdefined(\option{/novathesis/mainlang})}}

\newcommand*{\initassocarray}[2][\embrace{\thenotdefined(\option{/novathesis/coverlang})}]{
  \optionlistdo{/@nt/langsshort}{%
    \csuse{#2}(##1):={#1}%
  }%
}

\assocarray{frontmatterstring}
\assocarray{backmatterstring}
\assocarray{spinestring}
\assocarray{coverstring}
\assocarray{coversheetstring}
\assocarray{backcoverstring}
\assocarray{copyrightstring}
\assocarray{statementstring}
\assocarray{dedicatorystring}
\assocarray{acknowledgementsstring}
\assocarray{quotestring}
\assocarray{abstractstring}
\assocarray{keywordsstring}
\assocarray{notdefined}
\assocarray{specializationstr}
\assocarray{departmentofstr}
\assocarray{sponsorsstr}
\assocarray{andstring}
\assocarray{commastring}
% \initassocarray{,}{commastring}
\optionlistdo{/@nt/langsshort}{
  \commastring(#1):={,}%
}

\assocarray{adviserstr}
\providecommand*{\theadviserstrfont}{}
\assocarray{coadviserstr}
\providecommand*{\thecoadviserstrfont}{}
\assocarray{degreestr}
\providecommand*{\thedegreestrfont}{}
\providecommand*{\theadvisernamefont}{}
\providecommand*{\theadviserremainderfont}{\\[-0.5ex]\itshape\scriptsize}

\assocarray{degreename}

\assocarray{docdegreestr}

\assocarray{committeeorder}
\assocarray{committeetitlestr}
\providecommand*{\thecommitteetitlestrfont}{}
\assocarray{committeememberstr}
\providecommand*{\thecommitteememberstrfont}{}
\providecommand*{\thecommitteenamefont}{}
\providecommand*{\thecommitteeremainderfont}{\\[-0.5ex]\itshape\scriptsize}

\assocarray{dissertationstr}
\providecommand*{\thedissertationstrfont}{}
\assocarray{copyrighttextstr}
\assocarray{acknowledgmentsstr}

\assocarray{majorfield}
\assocarray{specialization}

\assocarray{spine}
\assocarray{thesiscover}
\assocarray{margin}
\assocarray{frontpageimage}

\newcommand*{\@nt@newassocarray}[1]{%
  \assocarray{#1}%
  \initassocarray[\embrace{\MakeUppercase{#1}}]{#1}%
}
\forcsvlist{\@nt@newassocarray}{university,school,department}

\assocarray{doctitle}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING ADDITINAL FILES BEFORE LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% SOME PRELIMINARY LANGUAGE DEFINITIONS
% \input{NOVAthesisFiles/lang-conf.tex}

% For each main language, list which abstracts shall be printed and in which order
% may have more than two (just be sure you include the languages above as well)
\assocarray{abstractorder}
\abstractorder(pt):={pt,en}
\abstractorder(en):={en,pt}
\abstractorder(fr):={fr,en}
\abstractorder(it):={it,en}
\abstractorder(es):={es,en}
\abstractorder(de):={de,en}

% --------------------------------------------------------
% PROCESS PACKAGE OPTIONS
% \input{NOVAthesisFiles/options.tex}
\def\@nt@schooloption@i#1/#2\@nil{\gdef\@nt@univ{#1}\gdef\@nt@schl{#2}}

\options{/novathesis/.new family
  , docdegree/.new choice = {phd, phdprop, phdplan, msc, mscplan, bsc, plain},
  , school/.new cmd = {         \typeout{NT school [#1]}%
                                \@nt@schooloption@i#1\@nil%
    }
  , school = {nova/fct}
  , langsused/.new list = {en,pt}
  , docstatus/.new choice = {final, provisional, draft, working},
  , chapstyle/.new choice = {bar, bianchi, bluebox, default, elegant, 
                             ell, hansen, ist, lyhne, madsen,
                            pedersen, section, southall, veelo,
                            vz34, vz43, compact}
  , chapstyle=bar        % set "bar" chapter style as the default
  , fontstyle/.new choice = {kpfonts, bookman, erewhon, libertine, scholax,
                             calibri, kieranhealy, newsgott}
  , fontstyle=kpfonts        % set kpfonts as the default
  , coverlang/.new choice = {en, pt, fr, it, de, es}
  , copyrightlang/.new choice = {en, pt, fr, it, de, es}
  , lang/.new style = {/novathesis/mainlang=#1,/novathesis/copyrightlang=#1,
                       /novathesis/coverlang=#1}
  , mainlang/.new choice = {en, pt, fr, it, de, es}
  , printfrontmatter/.new toggle = true
  , printcommittee/.new toggle = false
  , printcopyright/.new toggle = true
  , secondcover/.new toggle = false
  , statement/.new toggle = false
  , gnumberlist/.new toggle = true
  , tocintoc/.new toggle = false
  , urlstyle/.new cmd = {%
            \AfterPreamble{\urlstyle{#1}}%
  }
  , debugcover/.new toggle = false
  , spine/.new toggle = false%
  , cdcover/.new toggle = false%
  , media/.new choice = {screen, paper}
  , glsxindy/.new toggle = false
  , linkscolor/.new cmd = {%
            \@ifpackageloaded{hyperref}%
              {\hypersetup{allcolors=#1}}%
              {\PassOptionsToPackage{allcolors=#1}{hyperref}}%
  }
}



% --------------------------------------------------------
% PROCESSING CLASS OPTIONS
\options@ProcessOptions{/novathesis}%

% --------------------------------------------------------
% NTSETUP
\newcommand*{\ntsetup}[1]{%
    % \ntgetkeyval{#1}\@nt@opt\@nt@value%
    % \options{/novathesis/\@nt@opt = {\@nt@value}}%
    \options{/novathesis/#1}%
    % \option{/@nt/handler/\@nt@opt}%
}

\newcommand*{\ntbibsetup}[1]{%
  \@ifpackageloaded{biblatex}%
    {\bibsetup{#1}}%
    {\options{/@nt/biblatex/.push={#1}}}%
}

\newcommand*{\ntmemoirsetup}[1]{%
  \PassOptionsToClass{#1}{memoir}%
}

\newcommand*{\NTAddToHook}[2]{
  \options{/@nt/hook/#1/.cpush={#2}}%
}

\newcommand*{\NTRunHook}[1]{
  \optionlistdo{/@nt/hook/#1}{##1}%
}


% --------------------------------------------------------
% BABEL STUFF
\edef\nt@alllangs{}
\optionlistdo{/novathesis/langsused}{%
% \optionlistdo{/@nt/langsshort}{%
  \options{/@nt/langshorttolong=#1}%
  \ifoptionequal{/novathesis/mainlang}{#1}%
    {\eappto{\nt@alllangs}{,main=\option{/@nt/langshorttolong}}}%
    {\eappto{\nt@alllangs}{,\option{/@nt/langshorttolong}}}%
}
% \typeout{'NT PASSING TO BABEL = '\nt@alllangs}
\PassOptionsToPackage{\nt@alllangs}{babel}%

% --------------------------------------------------------
% Define DEFAULT VALUES for COVER and COPYRIGHT languages
%     and HYPERLINK color
\options{/novathesis/.cd%
  , coverlang = \option{/novathesis/mainlang}
  , copyrightlang = \option{/novathesis/mainlang}
  , linkscolor = DarkBlue
}



% --------------------------------------------------------
% Pass the remaining options to memoir
\letoptionlist{/options/remaining}\nt@remaining
% \typeout{'NT PASSING TO MEMOIR='\nt@remaining}
\PassOptionsToClass{\nt@remaining}{memoir}



%% If options for printing book spine and/or cd cover are active
%% load the correspondig file by order: @school, @university, @default
\AtEndDocument{%
  \iftoggle{/novathesis/spine}{%
    \InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/spine.tex}%
          {}%
          {\InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/spine.tex}%
              {}%
              {\InputIfFileExists{NOVAthesisFiles/spine.tex}{}{}}}%
    \csuse{ntprintspine}%
  }{}%
  \iftoggle{/novathesis/cdcover}{%
    \InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/cdcover.tex}%
          {}%
          {\InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/cdcover.tex}%
              {}%
              {\InputIfFileExists{NOVAthesisFiles/cdcover.tex}{}{}}}%
    \csuse{ntprintcdcover}%
    \ntprintcdcover%  
    \ntprintcdinlay%
  }{}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include strings for all the languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\optionlistdo{/novathesis/langsused}{%
  \InputIfFileExists{NOVAthesisFiles/Strings/strings-#1.ldf}%
    {}%
    {\ClassError{novathesis}{Missing “strings-#1” file!}{Add a file with the translations for this language.}}%
}%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING CUSTOMIZATION STUFF - part 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%============================================================
%  MEMOIR CUSTOMIZATION / OPTIONS
%      Please open and edit the appropriate
%       configuration file “Config/0_memoir.tex”
%============================================================
\input{Config/0_memoir}
% \NTRunHook{memoir}

  
%============================================================
%  TEMPLATE CUSTOMIZATION / OPTIONS
%      Please open and edit the appropriate
%       configuration file “Config/1_novathesis.tex”
%============================================================
\input{Config/1_novathesis}
% \NTRunHook{novathesis}

%============================================================
% BIBLATEX CUSTOMIZATION
%      Please open and edit the appropriate
%       configuration file “Config/2_biblatex.tex”
%============================================================
\input{Config/2_biblatex}
% \NTRunHook{biblatex}

%============================================================
% DEGREE CUSTOMIZATION
%   Please open and edit the appropriate
%       configuration file “Config/3a_degree_phd.tex”
%       or “Config/3b_degree_msc.tex”
%       or “Config/3c_degree_other.tex”
%============================================================
\ifphddoc{% Standard names for PhD programs
  \input{Config/3a_degree_phd}%
}{\ifmscdoc{% Standard names for MSc programs
  \input{Config/3b_degree_msc}%
}{% Customizable name for other programm (not PhD nor MSc)
  \input{Config/3c_degree_other}%
}}
% \NTRunHook{degree}


%============================================================
% DEPARTMENT CUSTOMIZATION
%   Please open and edit the appropriate
%       configuration file “Config/4_department.tex”
%============================================================
\input{Config/4_department}
% \NTRunHook{department}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEFINITIONS FOR THE REMINDER OF CUSTOMIZATION STUFF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%============================================================
% Title
\newcommand*{\nttitle}[2][\option{/novathesis/coverlang}]{%
  % #1 = lang
  % #2 = value
  \@nttitle{#1}{main}{#2}%
}

\newcommand*{\ntsubtitle}[2][\option{/novathesis/coverlang}]{%
  % #1 = lang
  % #2 = value
  \@nttitle{#1}{sub}{#2}%
}


\newcommand{\removelinebreaks}[1]{%
      \def\\{\relax}#1%
}
      
\newcommand*{\@nttitle}[3]{
  % #1 = type (main, sub) title
  % #2 = lang
  % #3 = value
  % \typeout{NT @nttitle [#1] [#2] [#3]}%
  \doctitle(#1,#2):={\removelinebreaks{#3}}%
  \doctitle(#1,#2,caps):={\removelinebreaks{\expandafter\MakeUppercase\expandafter{#3}}}%
  \doctitle(#1,#2,cover):={#3}%
  \doctitle(#1,#2,cover,caps):={\expandafter\MakeUppercase\expandafter{#3}}%
}



%============================================================
% Date and month
\newcommand*{\thentdatemonth}{\@nt@undefined[Month]}
\newcommand*{\thentdateyear}{\@nt@undefined[Year]}

\newcommand*{\ntdatemonth}[1]{\renewcommand*{\thentdatemonth}{#1}}
\newcommand*{\ntdateyear}[1]{\renewcommand*{\thentdateyear}{#1}}

%============================================================
% Author identification
\newcommand*{\theauthorname}{\@nt@undefined[Author Name]}
\newcommand*{\theauthorshortname}{\@nt@undefined[Author Short Name]}
\newcommand*{\theauthorgender}{\@nt@undefined[Author Gender]}
\newcommand*{\theauthordegree}{\@nt@undefined[Author Degree]}

\newcommand{\ntauthorname}[3][m]{% [m|f]{Long name}{Short name}
  \renewcommand*{\theauthorgender}{#1}%
  \renewcommand*{\theauthorname}{#2}%
  \renewcommand*{\theauthorshortname}{#3}%
  \AtBeginDocument{\hypersetup{pdfauthor={#2}}}
}

\newcommand*{\ntauthordegree}[1]{%
  \renewcommand*{\theauthordegree}{#1}%
}

%============================================================
% Adding list_of
\newcommand*{\netaddlistof}[1]{%
  \IfStrEqCase{#1}{%
      {tableofcontents}{\options{/@nt/list/listof/.cpush={%
                            \iftoggle{/novathesis/tocintoc}{%
                                \tableofcontents%
                            }{%
                                \phantomsection\pdfbookmark[1]{\contentsname}{toctarget}%
                                \hypertarget{toctarget}{\tableofcontents*}%
                            }%
                        }}}%
      {listofalgorithms}{\options{/@nt/list/listof/.cpush = {%
                                \addcontentsline{toc}{chapter}{List of Algorithms}%
                                %  Add space between chapters #170
                                \appto{\insertchapterspace}{\addtocontents{loa}{\protect\addvspace{10pt}}}%
                                % Numbering algorithms as chapter.number #169
                                \renewcommand\thealgorithm{\thechapter.\arabic{algorithm}}%
                                \@addtoreset{algorithm}{chapter}%
                        }}}
      {listsofglossaries}{\options{/@nt/list/listof/.cpush={%
                              \iftoggle{/novathesis/glsxindy}%
                                  {\printglossaries}%
                                  {\printnoidxglossaries}%
                          }}}%
  }[\options{/@nt/list/listof/.cpush={\csuse{#1}}}]%
}

%============================================================
% Print document “regions”
\newcommand*{\ntprint}[1]{%
  \IfStrEqCase{#1}{%
    {frontmatter}{\iftoggle{/novathesis/printfrontmatter}{\ntprintlist{/@nt/doc#1}}{}}%
    {mainmatter}{\ntprintlist{/@nt/doc#1}}%
  }[\csuse{ntprint#1}]%
  \ignorespaces%
}

\newcommand*{\ntprintlist}[1]{%
  \optionlistdo{#1}{\csuse{ntprint##1}\clearforchapter}%
}

\newcommand*{\ntsetprintorder}[2]{%
% #1 = frontmatter, mainmatter
% #2 = list
  \option@setlist{/@nt/doc#1}{#2}%
}

% --------------------------------------------------------
% DEFAULT VALUES FOR frontmatter AND mainmatter
\ntsetprintorder{frontmatter}{
  statement,       % The statement page
  copyright,       % (*) The copyright page
  dedicatory,      % (*) Print the dedicatory
  acknowledgements,% (*) Print the acknowledgments
  quote,           % (*) Print the quote
  abstracts,       % Print abstracts in multiple languages.
  alllistof,       % Print all the listof defined in “8_list_of.tex”
}

\ntsetprintorder{mainmatter}{
  chapters,        % Print document chapters
  bib,             % Print the bibliography.  Change to
                   %    “bib[title=⟨title⟩]” to redefine the title!
  appendices,      % Print appendices, if any!
  annexes,         % Print annexes, if any!
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COVER DEFINITION MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntaddtocover}[3][]{%
  % #1 = cover atrtibutes
  % #2 = list of covers where the code block should be applied
  % #3 = the block code
  % \typeout{NT ntaddtocover [/@nt/cover/\@nt@univ/\@nt@schl/element=#1]}
  \forcsvlist{\@ntaddtocover@iii{#1}{#3}}{#2}%
}

\newcommand*{\@ntaddtocover@iii}[3]{%
  % \typeout{NT ntaddtocover #3}%
  % #1 = cover atrtibutes
  % #2 = the block code
  % #3 = covers where the code block should be applied
  \options{/@nt/cover/\@nt@univ/\@nt@schl/#3/.cpush={{#1}=*={#2}}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING SCHOOLS's “defaults.ldf”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\IfFileExists{NOVAthesisFiles/Schools/\@nt@univ/Images/DO_NOT_REMOVE_THIS_FILE.txt}{%
    \prependtographicspath{{NOVAthesisFiles/Schools/\@nt@univ/Images/}}%
}{}%

\IfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/Images/DO_NOT_REMOVE_THIS_FILE.txt}{%
    \prependtographicspath{{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/Images/}}%
}{}%

\InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/univ-defaults.ldf}{}%
    {\PackageWarning{novathesis}{Missing file “univ-defaults.ldf” for ”\@nt@univ”}}%
\InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/schl-defaults.ldf}{}%
    {\PackageWarning{novathesis}{Missing file “schl-defaults.ldf” for ”\@nt@univ/\@nt@schl”}}%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------
% LOAD MAIN CLASS AND ADDITIONAL PACKAGES
\LoadClass{memoir}
\OnehalfSpacing% One-and-half spacing


% --------------------------------------------------------
% Customize the pagestyle
\makepagestyle{novathesis@myvf} 
\makeoddfoot{novathesis@myvf}{}{\thepage}{} 
\makeevenfoot{novathesis@myvf}{}{\thepage}{} 
\makeheadrule{novathesis@myvf}{\textwidth}{\normalrulethickness} 
\makeevenhead{novathesis@myvf}{\small\textsc{\leftmark}}{}{} 
\makeoddhead{novathesis@myvf}{}{}{\small\textsc{\rightmark}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING CUSTOMIZATION STUFF - part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%============================================================
%  THESIS/DISSERTATION COVER DATA (title, author, etc)
%   Please open and edit the appropriate
%       configuration file “Config/5_cover.tex”
%============================================================
\input{Config/5_cover}
% \NTRunHook{cover}

%============================================================
%  THESIS/DISSERTATION FILES
%   Please open and edit the appropriate
%       configuration file “Config/6_files.tex”
%============================================================
\input{Config/6_files}
% \NTRunHook{files}

%============================================================
% ADDITIONAL PACKAGES and MACROS
%      Please open and edit the appropriate
%       configuration file “Config/8_packages.tex”
%============================================================
\AtEndPreamble{\input{Config/7_packages}}
% \NTRunHook{packages}

%============================================================
%  WHICH LIST_OF TO PRINT
%   Please open and edit the appropriate
%       configuration file “Config/8_list_of.tex”
%============================================================
\AtEndPreamble{\makeatletter\input{Config/8_list_of}}
% \NTRunHook{list_of}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING ADDITINAL FILES AFTER LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% LOAD ADDITIONAL PACKAGES
\input{NOVAthesisFiles/packages.tex}

% --------------------------------------------------------
% FIX BABEL TRANSLATION
\input{NOVAthesisFiles/fix-babel.tex}

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

\newcommand{\ntprintbackcover}{%
  \phantomsection\pdfbookmark[0]{\thebackmatterstring(\option{/novathesis/coverlang})}{bmbackmatter}%
  \ntprintcoverpair{N}%
}

\newcommand{\ntprintcovers}[1][1,2]{%
  \phantomsection\pdfbookmark[0]{\thefrontmatterstring(\option{/novathesis/coverlang})}{bmfrontmatter}%
  \forcsvlist{\ntprintcoverpair}{#1}%
}

\newcommand{\ntprintcoverpair}[1]{%
  \IfStrEq{#1}{2}{%
    \iftoggle{/novathesis/secondcover}{%
      \ntprintcoversingle{#1}{1}%
      \ntprintcoversingle{#1}{2}%
    }{}%
  }{%
    \ntprintcoversingle{#1}{1}%
    \ntprintcoversingle{#1}{2}%
  }
  \clearforchapter%
}

\newcommand{\ntprintcoversingle}[2]{%
  % #1 = major cover ID
  \IfStrEq{#2}{2}{%
    \ifbool{@openright}{\def\@nt@newpage{\thispagestyle{empty}\null\newpage}}{\def\@nt@newpage{}}%
  }{\def\@nt@newpage{}}%
  \ifoptiondefined{/@nt/cover/\@nt@univ/\@nt@schl/#1-#2}{\@nt@newpage\@ntprintcover@i{#1-#2}}%
  {\ifaadefined{thesiscover}(\option{/novathesis/docdegree},#1-#2,bgcolor){\@nt@newpage\@ntprintcover@i{#1-#2}}%
  {\ifaadefined{thesiscover}(\option{/novathesis/docdegree},#1-#2,image){\@nt@newpage\@ntprintcover@i{#1-#2}}%
  {}}}%
}

\newcommand{\@ntprintcover@i}[1]{%
  % #1 = cover ID (major-minor)
  \bgroup
    \def\@nt@covernumber{#1}%
    \ifaadefined{thesiscover}(\option{/novathesis/docdegree},#1,textcolor)%
        {\color{\thethesiscover(\option{/novathesis/docdegree},#1,textcolor)}}{}
    \ntselectlang{\option{/novathesis/coverlang}}%
    \options{/@ntcoveropts/bookmark=#1}%
    \phantomsection\pdfbookmark[1]{\option{/@ntcoveropts/bookmark}}{\option{/@ntcoveropts/bookmark}}%
    \@ntmakeboxwithcover{#1}{\@fullcover@box}%
    % \@nt@flushcoverbox{#1}{\@fullcover@box}%
    \newpage%
  \egroup%
}

\newcommand{\@ntmakeboxwithcover}[2]{%
  % #1 = cover ID (major-minor)
  % #2 = box name
  \defifundef{#2}{\newsavebox}%
  \@ntmakecoverbgcolor{#1}{\@cover@bgcolor@box}%
  \@ntmakecoverimage{#1}{\@cover@image@box}%
  \@ntmakecovertext{#1}{\@cover@text@box}%
  \thispagestyle{empty}%
  % \begin{lrbox}{#2}%
    \begin{tikzpicture}[remember picture, overlay]
      \node[inner sep=0, anchor=north]  at (current page.north)  {\usebox{\@cover@bgcolor@box}};
      \node[inner sep=0, anchor=north]  at (current page.north)  {\usebox{\@cover@image@box}};
      \node[inner sep=0
            , anchor=north west
            , xshift=\expanded{\themargin(\option{/novathesis/docdegree},left)}
            , yshift=-\expanded{\themargin(\option{/novathesis/docdegree},top)}]  
                      at (current page.north west)  {\usebox{\@cover@text@box}};
    \end{tikzpicture}%
  % \end{lrbox}%
  \iftoggle{/novathesis/debugcover}{%
    \NTRunHook{cover/#1/pregrid}%
    \debuggrid%
    \NTRunHook{cover/#1/postgrid}%
  }{}%
}

% \newcommand*{\@nt@flushcoverbox}[2]{%
%   % #1 = cover ID (major-minor)
%   % #2 Cover box anme
%   \thispagestyle{empty}%
%   \begin{tikzpicture}[remember picture, overlay]
%     \node[inner sep=0,anchor=north]  at (current page.north)  {\usebox{#2}};
%   \end{tikzpicture}%
%   \iftoggle{/novathesis/debugcover}{%
%     \NTRunHook{cover/#1/pregrid}%
%     \debuggrid%
%     \NTRunHook{cover/#1/postgrid}%
%   }{}%
% }

\newcommand*{\@ntmakecoverbgcolor}[2]{%
  % #1 = cover ID (major-minor)
  % #2 = box name
  \defifundef{#2}{\newsavebox}%
  \ifaadefined{thesiscover}(\option{/novathesis/docdegree},#1,bgcolor)%
      {\savebox{#2}{\@ntcoverbgcolor{#1}}}{}
}

\newcommand*{\@ntcoverbgcolor}[1]{%
  % #1 = cover ID (major-minor)
  \NTRunHook{cover/#1/prebgcolor}%
  \begingroup%
    \color{\thethesiscover(\option{/novathesis/docdegree},#1,bgcolor)}%
    \rule{\paperwidth}{\paperheight}%
  \endgroup%
  \NTRunHook{cover/#1/postgcolor}%
}

\newcommand*{\@ntmakecoverimage}[2]{%
  % #1 = cover ID (major-minor)
  % #2 = box name
  \defifundef{#2}{\newsavebox}%
  \ifaadefined{thesiscover}(\option{/novathesis/docdegree},#1,image)%
      {\savebox{#2}{\@ntcoverimage{#1}}}{}
}

\newcommand*{\@ntcoverimage}[1]{%
  % #1 = cover ID (major-minor)
  \NTRunHook{cover/#1/preimage}%
  \includegraphics[width=\paperwidth,height=\paperheight]%
                  {\thethesiscover(\option{/novathesis/docdegree},#1,image)}%
  \NTRunHook{cover/#1/postimage}%
}

\newcommand{\@ntmakecovertext}[2]{%
  % #1 = cover ID (major-minor)
  % #2 = box name
  \defifundef{#2}{\newsavebox}%
  \ifoptiondefined{/@nt/cover/\@nt@univ/\@nt@schl/#1}{%
    \ifaadefined{margin}(\option{/novathesis/docdegree},top){%
      \begin{lrbox}{#2}%
        \begin{minipage}[l]
                        [\dimexpr\paperheight
                                      -\themargin(\option{/novathesis/docdegree},top)%
                                      -\themargin(\option{/novathesis/docdegree},bottom)%
                        ]
                        {\dimexpr\paperwidth
                                      -\themargin(\option{/novathesis/docdegree},left)%
                                      -\themargin(\option{/novathesis/docdegree},right)%
                        }%
          \@ntcovertext{#1}%
        \end{minipage}%
      \end{lrbox}%
    }{%
      \ClassError{novathesis}{Margins for cover of type “\option{/novathesis/docdegree}” undefined! Please define the margins in the School's definition file!}{}%
    }
  }{}
}

\newcommand{\@ntcovertext}[1]{%
  % #1 = cover ID (major-minor)
  \NTRunHook{cover/#1/pretext}%
  \optionlistdo{/@nt/cover/\@nt@univ/\@nt@schl/#1}{\@ntcoverelement@iii{#1}##1}%
  \NTRunHook{cover/#1/posttext}%
}

\def\@ntcoverelement@iii#1#2=*=#3{%
  % #1 = cover ID (major-minor)
  % #2 = cover element options
  % #3 = cover element code
  \ifblank{#3}{}{%
    \options{/@ntcoveropts,defaults}%.
    \options{/@ntcoveropts,#2}%
    \options{/@ntcoveropts,alignmap=\option{/@ntcoveropts/align}}%
    \StrCount{\option{/@ntcoveropts/status}}{\option{/novathesis/docstatus}}[\@nt@instatus]%
    \StrCount{\option{/@ntcoveropts/degree}}{\option{/novathesis/docdegree}}[\@nt@indegree]%
    \ifthenelse{%
              \(\equal{\option{/@ntcoveropts/status}}{}\OR\@nt@instatus>0\)\AND
              \(\equal{\option{/@ntcoveropts/degree}}{}\OR\@nt@indegree>0\)}
      {\@ntcoverelement@ii{#1}{#3}}%
      {}%
  }%
}

\options{/@ntcoveropts/.new family
  % titles for PDF bookmark / list of contents
  , bookmark/.new choice = {1-1=\thecoverstring(\option{/novathesis/coverlang})
                          , 1-2={}
                          , 2-1=\thecoversheetstring(\option{/novathesis/coverlang})
                          . 2-2={}
                          , N-1={}
                          , N-2=\thebackcoverstring(\option{/novathesis/coverlang})
                          , spine=\thespinestring(\option{/novathesis/coverlang})}
  % letter to macro for horizontal alignment
  , alignmap/.new choice={c=\centering,l=\raggedright,r=\raggedleft}
  % filters / conditional printing
  , status/.new value
  , degree/.new value
  % horizontal alighment and vertical alignments inside the box
  , align/.new choice={c, l, r}
  , inalign/.new choice={c, t, b}
  % height of the box (default = the natural height for the contents)
  , height/.new value
  % width of the box (default = full width)
  , width/.new value
  % vertical spacing from precious box (default = 0pt, can also be an integer and,
  % in this case, it means the weight of the vfill)
  , vspace/.new value
  % horizontal spacing from the left margin (or last box in the same line) (default = 0pt)
  , hspace/.new value
  % is the last box in the line (default = true)
  , newpar/.new toggle
  % text color for the box (default = black)
  , color/.new color
  % background color for the box (default = transparent)
  , bgcolor/.new color
  % default values
  , defaults/.new style*={status={}, degree={}, align=c, inalign=c, height={}, width={}, 
                          vspace=0pt, hspace=0pt, newpar=true, color={}, bgcolor={}}
  % set defaults
  , defaults
}

\newcommand{\@ntcoverelement@ii}[2]{%
  % #1 = cover ID (major-minor)
  % #2 = code
  % If vspace is integer then replace by n*\vfill
  % otherwise it is absolute verstical space
  \IfInteger{\option{/@ntcoveropts/vspace}}%
    {\vskip 0pt plus \option{/@ntcoveropts/vspace}fill}%
    {\vspace*{\option{/@ntcoveropts/vspace}}}%
  %
  % Typeset contents in a box
  \@nt@makeboxwithcoverelement@iii{#1}{#2}{\@nt@coverelement}%
  \noindent%
  \hspace*{\option{/@ntcoveropts/hspace}}%
  \iftoggle{/novathesis/debugcover}{% If in debug mode surround element in box
    \setlength{\fboxsep}{0pt}\hspace*{-\fboxrule}\vspace*{-\fboxrule}%
    \fbox{\usebox{\@nt@coverelement}}%
  }{\usebox{\@nt@coverelement}}%
  \iftoggle{/@ntcoveropts/newpar}{\expandafter\par}{}%
}

\newcommand{\@nt@makeboxwithcoverelement@iii}[3]{%
  % #1 = code
  % #2 = boxname
  % Create temp box if undefined
  \defifundef{\@mkcvelemwidth}{\newlength}%
  \ifoptionblank{/@ntcoveropts/width}%
    {\setlength{\@mkcvelemwidth}{\dimexpr\linewidth-\option{/@ntcoveropts/hspace}\relax}}%
    {\option{/@ntcoveropts/width}}%
  \ifoptionblank{/@ntcoveropts/height}%
    {}%
    {\edefoption{/@ntcoveropts/height}\@mkcvelemheight}%
  % Create destination boxes if undefined and save to it
  \defifundef{#3}{\newsavebox}%
  \begin{lrbox}{#3}%
    % Minipage definition is different if element height is given or not
      % \begin{minipage}[t][\@mkcvelemheight][\option{/@ntcoveropts/inalign}]{\@mkcvelemwidth}%
      \ifoptionblank{/@ntcoveropts/height}%
          {\minipage[t][][\option{/@ntcoveropts/inalign}]{\@mkcvelemwidth}}%
          {\minipage[t][\@mkcvelemheight][\option{/@ntcoveropts/inalign}]{\@mkcvelemwidth}}%
              \option{/@ntcoveropts/alignmap}%
              #2%
          \endminipage%
  \end{lrbox}
  \begin{lrbox}{#3}%
    % Add  round color if necessary
    \ifoptionblank{/@ntcoveropts/bgcolor}%
      {\usebox{#3}}%
      {\colorbox{\option{/@ntcoveropts/bgcolor}}{\usebox{#2}}}%
  \end{lrbox}%
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
  \refsection%
    \begin{minipage}{\linewidth}%
      \bibfont%
      \theacknowledgmentsstr(\option{/novathesis/coverlang})%
      \vspace*{-20ex}
      \printbibliography[heading=none]%
    \end{minipage}%
  \endrefsection%
}
\newcommand{\ntfixspacing}{%
  \@ntfixspacing{white}{0.01}%
}


\newcommand*{\ntprintstatement}{%
  \NTRunHook{statement/pre}%
  \iftoggle{/novathesis/statement}{% if statement toggle is on
  	\ifmaindoc{% if it is a main document
      \ntselectlang{\option{/novathesis/mainlang}}%
      \phantomsection\pdfbookmark[1]{\csuse{thestatementstring}(\option{/novathesis/mainlang})}{bmstatement}
      \ifoptiondefined{/@nt/file/statement/VAL}{% if the user defined their own statement file
        \@ntloadfiles@ii{statement}%
        \clearforchapter%
      }{%No statement file defined... try a school defined one
          \InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/statement.tex}%
              {}%
              {\InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/statement.tex}{}
                  {\ClassError{novathesis}{No “statement.tex” found! Not defined with \string\ntaddfile{statement}{filename} nor in folders “NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl” or “NOVAthesisFiles/Schools/\@nt@univ”}{}}}%
        \clearforchapter%
      }%
    }{%
      % It is a plan or proposal type document
    }%
  }{%
    % statement toggle is off
  }%
  \NTRunHook{statement/post}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand\thepresentationtext{%
	\thedissertationstrfont\thedissertationstr(\option{/novathesis/docdegree},\option{/novathesis/coverlang})%
}

\providecommand\thecopyrightstr{%
  \thispagestyle{empty}%
  \ntselectlang{\option{/novathesis/copyrightlang}}%
  \phantomsection\pdfbookmark[1]{Copyright}{bmcopyright}
  \noindent%
  Copyright \textcopyright\ \theauthorname, %
  \theschool(\option{/novathesis/copyrightlang}), \theuniversity(\option{/novathesis/copyrightlang}).\\%
  \thecopyrighttextstr(\option{/novathesis/copyrightlang})%
  \ntselectlang{\option{/novathesis/mainlang}}
}



 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print advisers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%============================================================
% Print advisers as list
%============================================================
\newcommand{\ntprintadvisersaslist}[1][adviser,coadviser]{%
  \def\@nt@addviserslist{}%
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
    {\normalfont\ \theandstring(\option{/novathesis/coverlang}) }%
  \else\ifnum\value{@nt@advisern}>1%
    {\normalfont\thecommastring(\option{/novathesis/coverlang}) }%
  \fi\fi%
  #1%
}

%============================================================
% Print advisers as list
%============================================================
\newcommand{\ntprintadvisers}[1][0.90]{%
  % \begin{minipage}{#1\textwidth}
  % #1=Percentage of \textwidth used by the advisers list
  \begin{tabularx}{#1\textwidth}{@{}rX@{}}%
  \forcsvlist{\@nt@printadvisergroup}{adviser,coadviser}%
  \end{tabularx}%
  % \end{minipage}
}

\newcommand{\ntprintadvisersgroup}[2][0.90]{%
  % #1=width
  % %2={adviser,coadviser}
  \ifoptiondefined{/@nt/#2//name}{%
    {\csuse{the#2strfont}%
    \csuse{the#2str}(\option{/novathesis/coverlang})}\\[1ex]%
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

\newcommand{\ntprintoneadviser}[1]{%
  \ntprintonename{adviser}{#1}%
}

\newcommand{\ntprintonename}[2]{%
  \StrCut{#2}{,}\@nt@name\@nt@remainder%
  {\csuse{the#1namefont}\ignorespaces\@nt@name}%
  {\csuse{the#1remainderfont}\ignorespaces\@nt@remainder}%
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
      \optionlistdo{/@nt/#1//name}{\ntprintoneadviser{##1}\\[0.4ex]}%
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
    % \begin{minipage}{#1\textwidth}%
    % #1=Percentage of \textwidth used by the committee list
    \begin{tabularx}{#1\textwidth}{@{}rX@{}}%
    \@ntprintcommitteetitlestr\\[1ex]%
    \forcsvlist{\@ntprintcommitteegroup}{c,r,a,m,g}%
    \end{tabularx}%
    % \end{minipage}
  }{}%% NO PRINT COMMITTEE
}

\newcommand*{\@ntprintcommitteetitlestr}{%
  % \ifx\@nt@tmp\@empty%
  \expandnext{\ifx}{\thecommitteetitlestr(\option{/novathesis/coverlang})}\@empty%
    % committeetitlestr[…] is empty
  \else%
    % \multicolumn{2}{c}{{%%
            & \thecommitteetitlestrfont%
            \thecommitteetitlestr(\option{/novathesis/coverlang}):%}%
          % }%
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
    \optionlistdo{/@nt/committee/#1/name}{\ntprintonename{committee}{##1}\\[0.3ex]}%
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

\newcommand*{\@nt@reducenumber}[2]{%
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
% \InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/defaults.ldf}{}{}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtEndPreamble{\typeout{NT AtEndPreamble ntsetlayout}\ntsetlayout}

\newcommand*{\ntsetlayout}{%
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
  \ifoptionequal{/novathesis/media}{paper}{\openright}{}
}

%% For debugging the page layout
% \newcommand*{\@nt@typetwolengths}[4]{%
%   % #1=text before
%   % #2=first length
%   % #3=text between
%   % #4=second length
%   \setlength\@tempdimc{\mem@tl@unitperpt #2}%
%   \edef\l@first{\strip@pt\@tempdimc}%
%   \setlength\@tempdimc{\mem@tl@unitperpt #4}%
%   \edef\l@second{\strip@pt\@tempdimc}%
%   #1: \l@first\mem@tl@unit\space#3\space\l@second\mem@tl@unit%
% }
%
% \newcommand*{\@nt@typeonelength}[2]{%
%   % #1=text before
%   % #2=first length
%   \setlength\@tempdimc{\mem@tl@unitperpt #2}%
%   \edef\l@first{\strip@pt\@tempdimc}%
%   #1: \l@first\mem@tl@unit%
% }
%
% \newcommand*{\typelayout}{%
%   \hrule%
%   \@nt@typetwolengths{Stock height and width}{\stockheight}{by}{\stockwidth}\\%
%   \@nt@typetwolengths{Top and edge trims}{\trimtop}{and}{\trimedge}\\%
%   \@nt@typetwolengths{Page height and width}{\paperheight}{by}{\paperwidth}\\%
%   \@nt@typetwolengths{Text height and width}{\textheight}{by}{\textwidth}\\%
%   \@nt@typetwolengths{Spine and edge margins}{\spinemargin}{and}{\foremargin}\\%
%   \@nt@typetwolengths{Upper and lower margins}{\uppermargin}{and}{\lowermargin}\\%
%   \@nt@typetwolengths{Headheight and headsep}{\headheight}{and}{\headsep}\\%
%   \@nt@typeonelength{Footskip}{\footskip}\\%
%   \@nt@typetwolengths{Columnsep and columnseprule}{\columnsep}{and}{\columnseprule}\\%
%   \@nt@typetwolengths{Marginparsep and marginparwidth}{\marginparsep}{and}{\marginparwidth}\\%
%   \@nt@typetwolengths{Sidecapsep and sidecapwidth}{\sidecapsep}{and}{\sidecapwidth}\\%
%   \@nt@typetwolengths{Sidebarhsep and sidebarwidth}{\sidebarhsep}{and}{\sidebarwidth}\\%
%   \@nt@typetwolengths{Sidebarvsep and sidebartopsep}{\sidebarvsep}{and}{\sidebartopsep}\\%
%   \@nt@typeonelength{Sidebarheight}{\dimen\sideins}\\%
%   \@nt@typetwolengths{Sidefoothsep and sidefootwidth}{\sidefoothsep}{and}{\sidefootwidth}\\%
%   \@nt@typetwolengths{Sidefootvsep and sidefootheight}{\sidefootvsep}{and}{\sidefootheight}\\%
%   \hrule%
% }




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Fonts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\quotefont}{\normalfont\normalsize}
\newcommand*{\quotefonti}{\itshape\normalsize}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Printing chapters and similars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@ntloadfile@i}[1]{%
    % \typeout{NT TRYING TO LOAD #1}%
    \IfFileExists{#1}{%
        \input{#1}%
        \clearforchapter%
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

\newcommand{\@nt@printifmaindoc@i}[1]{%
  % \typeout{NT Attempt to load #1}%
  \NTRunHook{#1/pre}%
	\ifmaindoc{% THEN it is a main document
    \ifoptiondefined{/@nt/file/#1/VAL}{%
      \ntselectlang{\option{/novathesis/mainlang}}%
      \phantomsection\pdfbookmark[1]{\csuse{the#1string}(\option{/novathesis/mainlang})}{bm#1}
      \@ntloadfiles@ii{#1}%
    }{\typeout{NT LOAD #1 undefined}}%
	}{% ELSE
    % It is a plan or proposal type document
	}%  
  \NTRunHook{#1/post}%
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
  \ntselectlang{\option{/novathesis/mainlang}}%  
}

\newcommand{\@ntprintabstract}[1]{%
  % \typeout{NT PRINT ABSTRACT #1}%
  \setabstractlang{#1}%
  \phantomsection\pdfbookmark[1]{\theabstractstring(#1)}{bmabstract#1}
  \NTRunHook{abstract/pre}%
  \NTRunHook{abstract/#1/pre}%
  \printabstracttitle{#1}%
  \NTRunHook{abstract/mid}%
  \@ntloadfiles@ii[#1]{abstract}%
  \NTRunHook{abstract/#1/post}%
  \NTRunHook{abstract/post}%
}


\newcommand*{\ntthesisfrontmatter}{%
  \NTRunHook{frontmatter/pre}%
  \frontmatter%
  \pagestyle{novathesis@myvf}%
  \ntselectlang{\option{/novathesis/mainlang}}%
  \pagenumbering{roman}%
  % \setlength{\headheight}{15pt}%
  \NTRunHook{frontmatter/post}%
}

\newcommand*{\ntthesismainmatter}{%
  \NTRunHook{mainmatter/pre}%
  % enables protrusion locally for the remainder of the document
	\mainmatter%
  \pagestyle{novathesis@myvf}%
  \ifxeorlua{}{\microtypesetup{protrusion=true}}%
  % \pagenumbering{arabic}%
  % \setlength{\headheight}{15pt}%
  \NTRunHook{mainmatter/post}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntchapterfile}[1]{\listgadd{\@nt@chapter@list}{#1}}


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
  \renewcommand{\appendixtocname}{\appendixnamepl}%
  \appendix\addappheadtotoc%
  \@nt@foralllist{file}{appendix}{\@ntloadfiles@ii{appendix}}%
}

\newcommand*{\ntprintannexes}{%
  \renewcommand{\appendixtocname}{\annexnamepl}%
  \annex\addappheadtotoc%
  \@nt@foralllist{file}{annex}{\@ntloadfiles@ii{annex}}%
}

\ifdef{\annexcounter}{}{\def\annexcounter{\@Roman}}
\newcommand*{\annex}{
  \xdef\Hy@chapapp{annex}%
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\annexname}%
  \gdef\thechapter{\annexcounter\c@chapter}%
  }



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with optional lists in the frontmatter: listoftables, litoffigures, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntprintalllistof}{%
  \NTRunHook{listof/pre}%
  \optionlistdo{/@nt/list/listof}{##1\clearforchapter}%
  \NTRunHook{listof/post}%
}


% \def\option@listmatch@getval#1=#2{#2}
\newcommand*{\option@listmatch}[2]{
  % \typeout{NT LISTMATCH [#1] [#2]}%
  \StrCut{#2}{=}\option@listmatch@key\option@listmatch@value%
  % \typeout{K=\option@listmatch@key ~V=\option@listmatch@value}
  \IfStrEq{#1}{\option@listmatch@key}{\listbreak}{}%
}%
\options{/handlers/getval/.new operation={%
  % \typeout{NT GETVAL [#1] [#2]}%
    \optionlistdo{#1}{\option@listmatch{#2}{##1}}%
  }%
}

\newcommand*{\@loadglossaryfiles}{%
  \ifoptiondefined{/@nt/file/glossaries/glossary}%
    {\optionlistdo{/@nt/file/glossaries/glossary}{\@ntloadfile@i{##1}}}{}%
  \ifoptiondefined{/@nt/file/glossaries/acronyms}%
  {\optionlistdo{/@nt/file/glossaries/acronyms}{\@ntloadfile@i{##1}}}{}%
  \ifoptiondefined{/@nt/file/glossaries/symbols}%
  {\optionlistdo{/@nt/file/glossaries/symbols}{\@ntloadfile@i{##1}}}{}%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Bibliography
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand*{\ntprintbib}[1][]{%
  \printbibliography[#1]%
  \ntfixspacing%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntprintcopyright}{%
  \NTRunHook{copyright/pre}%
	\ifmaindoc{% THEN
    \iftoggle{/novathesis/printcopyright}%
      {\ntprintcopyrightpage}%
      {}%
	}{}%
  \NTRunHook{copyright/post}%
}

\newcommand*{\ntprintcopyrightpage}{%
    \null\vfill%
    \noindent%
    \textbf{\large\thedoctitle(\option{/novathesis/coverlang},main)}\par%
    \bigskip%
    \thecopyrightstr\par%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dedicatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{ntdedicatory}{%
  \thispagestyle{empty}%
  ~\\[2cm]%
  \minipage{\linewidth}%
    \raggedleft%
    \minipage{100mm}%
      \raggedleft%
      \quotefonti%
}{%
      \normalfont%
    \endminipage%
  \endminipage%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quote
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{ntquote}{%
  \thispagestyle{empty}%
  ~\\[2cm]%
  \minipage{\linewidth}%
    \raggedleft%
    \minipage{100mm}%
      \raggedleft%
      \quotefonti%
}{%
      \normalfont%
    \endminipage%
  \endminipage%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{ntacknowledgements}{%
  \chapter*{\theacknowledgementsstring(\option{/novathesis/mainlang})}%
}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\@nt@keywordsstr}{}
\newcommand*{\setabstractlang}[1]{%
	\ntselectlang{#1}%
  \renewcommand*{\@nt@keywordsstr}{\thekeywordsstring(#1)}%
}
\newcommand*{\printabstracttitle}[1]{%
	\chapter*{\theabstractstring(#1)}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{keywords}[1][\option{/@nt/langshorttolong}]{%
  \defifundef{\ntkwbox}{\newsavebox}%
  \begin{lrbox}{\ntkwbox}%
}{%
  \end{lrbox}%
  \ifoptionequal{/@nt/currentlang}{\option{/novathesis/mainlang}}%
      {\hypersetup{pdfkeywords={\usebox{\ntkwbox}}}}%
      {}%
  \par\vskip\baselineskip\noindent{\bfseries\@nt@keywordsstr: }%
  \usebox{\ntkwbox}%
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

\InputIfFileExists{NOVAthesisFiles/ChapStyles/\option{/novathesis/chapstyle}.ldf}{}{}%
\InputIfFileExists{NOVAthesisFiles/FontStyles/\option{/novathesis/fontstyle}.ldf}{}{}%

