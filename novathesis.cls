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
%% Version 2021-12-13 [6.8.2]
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
\ProvidesClass{novathesis}[2021-11-14 novathesis template]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SOME ESSENTIAL PACKAGES
%%    Others will be loaded later, in the file “packages.tex”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{iftex}
\RequirePackage{etoolbox}
\RequirePackage{xifthen}
\RequirePackage{xstring}
\RequirePackage{NOVAthesisFiles/options2}
\RequirePackage{NOVAthesisFiles/memory2}
\RequirePackage{NOVAthesisFiles/nt-version}

%%%%% Configure Graphics
\RequirePackage[nobeamer]{graphbox}% improved version of "graphicx"
\graphicspath{{Chapters/Figures/}}
\DeclareGraphicsExtensions{.pdf,.png,.jpg,.tif}
\providecommand*\appendtographicspath[1]{\xappto\Ginput@path{#1}}
\providecommand*\prependtographicspath[1]{\xpreto\Ginput@path{#1}}

% \newif\ifgraphicexist
% \catcode`\*=11
% \newcommand\@nt@imagetest[1]{%
%  \begingroup
%  \global\graphicexisttrue
%    \let\input@path\Ginput@path
%   \filename@parse{#1}%
%   \ifx\filename@ext\relax
%     \@for\Gin@temp:=\Gin@extensions\do{%
%       \ifx\Gin@ext\relax
%         \Gin@getbase\Gin@temp
%       \fi}%
%   \else
%     \Gin@getbase{\Gin@sepdefault\filename@ext}%
%     \ifx\Gin@ext\relax
%        \global\graphicexistfalse
%        \def\Gin@base{\filename@area\filename@base}%
%        \edef\Gin@ext{\Gin@sepdefault\filename@ext}%
%     \fi
%   \fi
%   \ifx\Gin@ext\relax
%          \global\graphicexistfalse
%     \else
%        \@ifundefined{Gin@rule@\Gin@ext}%
%          {\global\graphicexistfalse}%
%          {}%
%     \fi
%   \ifx\Gin@ext\relax
%    \gdef\imageextension{unknown}%
%   \else
%    \xdef\imageextension{\Gin@ext}%
%   \fi
%  \endgroup
%  \ifgraphicexist
%   \expandafter \@firstoftwo
%  \else
%   \expandafter \@secondoftwo
%  \fi
%  }
% \catcode`\*=12
%
% \newcommand\@nt@includegraphics[2][]{%
%   \@nt@imagetest{#2}{\includegraphics[#1]{#2}}{\missingfigure{\detokenize{#2}}}%
% }


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
\newcommand*{\csdefifundef}[2]{\ifcsname#1\endcsname\else\expandafter\def\csname#2\endcsname{#1}\fi}

% \newcommand{\xforcsvlist}{\expandafter\forcsvlist\expandafter\@firstoftwo\expandafter\@secondoftwo}
\newcommand{\xforcsvlist}[2]{%
    \@for\@nt@item:={#2}\do%
      {\xdef\@nt@item{\@nt@item}#1{\@nt@item}}%
}

\newif\ifntbre@k
\def\ntforbreak{\ntbre@kfalse}
\long\def\@ntfor#1:=#2\do#3{%
  \ntbre@ktrue
  \@for#1:=#2\do{\ifntbre@k#3\fi}%
}


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
  \degreename(#1):={\csuse{the\option{/novathesis/docdegree}string}(\option{/novathesis/coverlang}) #2}%
  \majorfield(#1):={#2}%
}
\def\ntspecialization(#1)#2{\specialization(#1):={#2}}
\def\ntsponsors(#1)#2{\sponsorsstring(#1):={#2}}


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
    {\usepackage[scaled=1]{inter}}%
    {\IfFileExists{helvet.sty}%
      {\usepackage[scaled=0.95]{helvet}}%
      {\IfFileExists{gillius2.sty}%
        {\usepackage{gillius2}}%
        {\ClassWarning{novathesis}{Could not find a suitable Sans Serif font… using the default!}}%
      }%
  }%
}

\options{/@nt/.new family
  , langsshort/.new list={en, pt, fr, it, de, es}
  , currentlang/.new choice={en, pt, fr, it, de, es}
  , langshorttolong/.new choice={en=english, pt=portuguese, fr=french, it=italian, de=german, es=spanish}
  , biblatex/.new list
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% xstring StrCut replacement
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ifdefined\NewDocumentCommand
\else
  \RequirePackage{xparse}  % load xparse if necessary
\fi
\ExplSyntaxOn
\NewExpandableDocumentCommand{\compareStrings}{mm}
 {
  \str_if_eq:eeTF { \str_lower_case:f { #1 } } { \str_lower_case:f { #2 } }
   { \equalStrings{#1}{#2} }
   { \differentStrings{#1}{#2} }
}
\NewDocumentCommand{\xStrCut}{smmmm}
 {
  % #1 = optional *
  % #2 = tokens
  % #3 = separator where to split at
  % #4 = macro where to store the first part
  % #5 = macro where to store the second part
  \IfBooleanTF{#1}
   {
    \joao_xstrcut:VnNN #2 { #3 } #4 #5
   }
   {
    \joao_xstrcut:nnNN { #2 } { #3 } #4 #5
   }
 }

\seq_new:N \l_joao_strcut_parts_seq
\tl_new:N \l_joao_strcut_head_tl
\tl_new:N \l_joao_strcut_tail_tl

\cs_new_protected:Nn \joao_xstrcut:nnNN
 {
  \tl_if_exist:NF #3 { \tl_new:N #3 }
  \tl_if_exist:NF #4 { \tl_new:N #4 }
  \seq_set_split:Nnn \l_joao_strcut_parts_seq { #2 } { #1 }
  \seq_pop_left:NN \l_joao_strcut_parts_seq #3
  \tl_set:Nx #4 { \seq_use:Nn \l_joao_strcut_parts_seq { #2 } }
 }
\cs_generate_variant:Nn \joao_xstrcut:nnNN { V }
\ExplSyntaxOff

% \newcommand{\myStrCut}[4]{\@myStrCut#1\@nil#3#4}
%
% \def\@myStrCut#1,#2\@nil#3#4{%
%   \def#3{#1}%
%   \def#4{#2}%
% }



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
\newcommand{\ifdocworking}{\ifoptionequal{/novathesis/docstatus}{working}}
\newcommand{\ifdocunset}{\ifoptionequal{/novathesis/docstatus}{unset}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE PERSON LISTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\ntaddperson#1[#2]{%
  % syntax: \ntaddperson{class}[key]{name}
  % See "\@ntaddperson@iv" below
  \StrCount{#2}{,}[\@nt@ncommas]%
  \IfStrEq{\@nt@ncommas}{1}{}{%
    \ClassError{novathesis}{Invalid role or gender in \string\ntaddperson{#2}}%
                           {Please see file “3_cover.tex” for the correct syntax.}%
  }%
  \@ntaddperson@iv{#1}[#2]%
}

\def\@ntaddperson@iv#1[#2,#3]#4{%
  % syntax: \ntaddperson{class}[key,gender]{filename}
  % #1=adviser | committee
  % #2={a,c}            {c,r,a,m,g}
  %     a=adviser        c=chair
  %     c=coadviser      r=rapporteur/referee
  %                      a=adviser
  %                      m=other members
  %                      g=guests
  % #3={m,f}
  % #4={person name, position, etc}
  \xStrCut{#4}{,}\@nt@personname\@nt@dummy%
  \options{/@nt/#1/#2/name/.expanded/.cpush={\@nt@personname}}%
  \options{/@nt/#1/#2/full/.expanded/.cpush={#4}}%
  \options{/@nt/#1/#2/gender/.expanded/.cpush={#3}}%
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
  \@ifnextchar[{\@nt@addtolist@iv[#1]#2}{\@nt@addtolist@iv[#1]#2[VAL]}%
}

\def\@nt@addtolist@iv[#1]#2[#3]#4{%
  % syntax: \@ntaddfile@iii{type}{class}[key]{filename}
  %         #1 ={file, person}
  %         #2=file family (quote, abstract, chapter, etc)
  %         #3=optional file lang
  %         #4=filename
  % \typeout{NT addtolist [#1] [#2] [#3] [#4]}%
  \StrLeft{#4}{1}[\@nt@firstchar]%
  \IfStrEqCase{\@nt@firstchar}{%
    {/}{\xdef\@nt@filewithpath{#4}}%
    {.}{\xdef\@nt@filewithpath{#4}}%
  }[%
    \options{/@nt/folders=#2}%
    \xdef\@nt@filewithpath{\option{/@nt/folders}/#4}%
  ]%
  \options{/@nt/#1/#2/#3/.expanded/.cpush={\@nt@filewithpath}}%
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
  \options{/@nt/currentlang=#1}%
  \options{/@nt/langshorttolong=#1}%
  \expandafter\selectlanguage\expandafter{\expanded{\option{/@nt/langshorttolong}}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ASSOCARRAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\@nt@undefined}[1][]{\embrace{#1 \thenotdefined(\option{/novathesis/mainlang})}}

\newcommand*{\initmemory}[2][\embrace{\thenotdefined(\option{/novathesis/coverlang})}]{%
  \optionlistdo{/@nt/langsshort}{%
    \csuse{#2}(##1):={#1}%
  }%
}

% For PDF bookmakrs
\newdata{coverbkmstring}
\newdata{frontpagebkmstring}
\newdata{copyrightbkmstring}
\newdata{statementbkmstring}
\newdata{dedicatorybkmstring}
\newdata{acknowledgementsbkmstring}
\newdata{quotebkmstring}
\newdata{abstractbkmstring}
\newdata{frontmatterbkmstring}
\newdata{backmatterbkmstring}
\newdata{spinebkmstring}
\newdata{backcoverbkmstring}


\newdata{notdefined}
\newdata{keywordsstring}
\newdata{specializationstring}
\newdata{departmentofstring}
\newdata{sponsorsstring}
\newdata{andstring}
\newdata{commastring}
\optionlistdo{/@nt/langsshort}{%
  \commastring(#1):={,\ }%
}


\newdata{degreestring}
\newdata{degreestringfont}

\newdata{degreename}
\newdata{degreenamefont}

\newdata{mscstring}
\newdata{mscstringfont}

\newdata{phdstring}
\newdata{phdstringfont}

\newdata{docdegreestring}
\newdata{docdegreestringfont}



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

\newdata{personpost}
\newdata{persongrouppost}

\newdata{dissertationstring}
\newdata{dissertationstringfont}

\newdata{copyrighttextstring}
\newdata{acknowledgmentsstring}

\newdata{majorfield}
\newdata{specialization}

\newdata{spine}
\newdata{thesiscover}
\newdata{margin}
\newdata{frontpageimage}

\newcommand*{\@nt@newmemory}[1]{%
  \newdata{#1}%
  \initmemory[\embrace{\MakeUppercase{#1}}]{#1}%
}
\forcsvlist{\@nt@newmemory}{university,school,department}

\newdata{doctitle}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING ADDITINAL FILES BEFORE LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% SOME PRELIMINARY LANGUAGE DEFINITIONS
% \input{NOVAthesisFiles/lang-conf.tex}

% For each main language, list which abstracts shall be printed and in which order
% may have more than two (just be sure you include the languages above as well)
\newdata{abstractorder}
\abstractorder(pt):={pt,en}
\abstractorder(en):={en,pt}
\abstractorder(fr):={fr,en}
\abstractorder(it):={it,en}
\abstractorder(es):={es,en}
\abstractorder(de):={de,en}

% --------------------------------------------------------
% PROCESS PACKAGE OPTIONS
% \input{NOVAthesisFiles/options.tex}
% \assocarray{@ntschool}
% \def\@nt@schooloption@i#1/#2\@nil{%
%   \@ntschool(univ):={#1}%
%   \@ntschool(schl){#2}%
% }
\def\@nt@schooloption@i#1/#2\@nil{\gdef\@nt@univ{#1}\gdef\@nt@schl{#2}}

\options{/novathesis/.new family
  , docdegree/.new choice         = {phd, phdprop, phdplan, msc, mscplan, bsc, plain},
  , school/.new cmd               = {\@nt@schooloption@i#1\@nil}
  , school                        = {nova/fct}
  , degreeacr/.new value          = {},
  , docstatus/.new choice         = {unset, working, provisional, final}, % in not defined by user, unset will be replaced  “working”
  , chapstyle/.new value          = {bar}        % use "bar" chapter style by default
  , fontstyle/.new value          = {kpfonts}    % use “kpfonts” by default
  , langsused/.new list           = {en,pt}
  , coverlang/.new choice         = {en, pt, fr, it, de, es}
  , copyrightlang/.new choice         = {en, pt, fr, it, de, es}
  , lang/.new style               = {/novathesis/mainlang=#1, /novathesis/copyrightlang=#1,
                                     /novathesis/coverlang=#1}
  , mainlang/.new choice          = {en, pt, fr, it, de, es}
  , copyrightmodifier/.new choice = {by-nc-sa, by-sa, by, by-nc, by-nd, by-nc-nd}
  , numberallpages/.new toggle    = false
  , printfrontmatter/.new toggle  = true
  , printadviser/.new toggle      = true     % fake option - adviser should always be printed
  , printcommittee/.new toggle    = false
  , printackblock/.new toggle     = true    % print the acknowledgments block at the bottom of the copyright page
  , printcopyright/.new toggle    = true
  , secondcover/.new toggle       = false
  , statement/.new toggle         = false
  , gnumberlist/.new toggle       = true
  , tocintoc/.new toggle          = false
  , urlstyle/.new cmd             = {\AfterPreamble{\urlstyle{#1}}}
  , debugcover/.new toggle        = false
  , spine/.new toggle             = false%
  , media/.new choice             = {screen, paper}
  , glsxindy/.new toggle          = false
  , linkscolor/.new cmd           = {\@ifpackageloaded{hyperref}%
                                       {\hypersetup{allcolors=#1}}%
                                       {\PassOptionsToPackage{allcolors=#1}{hyperref}}}
}



% --------------------------------------------------------
% PROCESSING CLASS OPTIONS
\options@ProcessOptions{/novathesis}
% --------------------------------------------------------
% NTSETUP
\newcommand*{\ntsetup}[1]{%
    \options{/novathesis/#1}%
}

\newcommand*{\ntbibsetup}[1]{%
  \@ifpackageloaded{biblatex}%
    {\bibsetup{#1}}%
    {\options{/@nt/biblatex/.push={#1}}}%
}

\newcommand*{\ntmemoirsetup}[1]{%
  \PassOptionsToClass{#1}{memoir}%
}

\newcommand*{\NTAddToHook}[2]{%
  \options{/@nt/hook/#1/.cpush={#2}}%
}

\newcommand*{\NTRunHook}[1]{%
  \optionlistdo{/@nt/hook/#1}{##1}%
}

\newcommand*{\NTIfHook}[1]{%
  \ifoptiondefined{/@nt/hook/#1}%
}


% --------------------------------------------------------
% BABEL STUFF
\edef\nt@alllangs{}
\optionlistdo{/novathesis/langsused}{%
  \options{/@nt/langshorttolong=#1}%
  \ifoptionequal{/novathesis/mainlang}{#1}%
    {\eappto\nt@alllangs{,main=\option{/@nt/langshorttolong}}}%
    {\eappto\nt@alllangs{,\option{/@nt/langshorttolong}}}%
}
% \typeout{'NT PASSING TO BABEL = '\nt@alllangs}%
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
% \typeout{'NT PASSING TO MEMOIR='\nt@remaining}%
\PassOptionsToClass{\nt@remaining}{memoir}


% \options{/@nt/path/.cd,
%       tex/.new list={
%          {NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl}
%         ,{NOVAthesisFiles/Schools/\@nt@univ}
%         ,{NOVAthesisFiles}
%       },
%       graphics/.new list={%
%          {Chapters/Figures/}
%          {NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/spine.tex}
%         ,{NOVAthesisFiles/Schools/\@nt@univ/spine.tex}
%       }
% }

%% If options for printing book spine and/or cd cover are active
%% load the correspondig file by order: @school, @university, @default
\newcommand{\@nt@InputIfFileExists}[2]{%
  \expandnext{\forcsvlist{\@nt@InputIfFileExists@i{#1}}}{#2}%
}

\newcommand{\@nt@InputIfFileExists@i}[2]{\IfFileExists{#2#1}{\input{#2#1}\listbreak}{}}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include strings for all the languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\optionlistdo{/novathesis/langsused}{%
  \InputIfFileExists{NOVAthesisFiles/Strings/strings-#1.ldf}%
    {}%
    {\ClassError{novathesis}{File not found: “NOVAthesisFiles/Strings/strings-#1.ldf” file!}%
                {Add a file with the translations for this language.}}%
}




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

% \newcommand{\removelinebreaks}[1]{%
%       \def\\{\relax}#1%
% }

\newcommand{\replacelinebreakwithspace}[1]{%
      \def\\{\ }#1%
}
      
\newcommand*{\@nttitle}[3]{%
  % #1 = type (main, sub) title
  % #2 = lang
  % #3 = value
  % \typeout{NT @nttitle [#1] [#2] [#3]}%
  \doctitle(#1,#2):={\replacelinebreakwithspace{#3}}%
  \doctitle(#1,#2,caps):={\replacelinebreakwithspace{\expandafter\MakeUppercase\expandafter{#3}}}%
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
\newdata{docauthor}
\docauthor(name):={\@nt@undefined[Author Name]}
\docauthor(name,short):={\@nt@undefined[Author Short Name]}
\docauthor(gender):={\@nt@undefined[Author Gender]}
\docauthor(degree):={\@nt@undefined[Author Previous Degree]}

\newcommand{\ntauthorname}[3][m]{% [m|f]{Long name}{Short name}
  \docauthor(gender):={#1}%
  \docauthor(name):={#2}%
  \docauthor(name,short):={#3}%
  \AtBeginDocument{\hypersetup{pdfauthor={#2}}}%
}

\newcommand*{\ntauthordegree}[1]{%
  \docauthor(degree):={#1}%
}

%============================================================
% Adding list_of
\newcommand*{\ntaddlistof}[1]{%
  \IfStrEqCase{#1}{%
      {tableofcontents}{\options{/@nt/list/listof/.cpush={%
                            \iftoggle{/novathesis/tocintoc}{%
                                \tableofcontents%
                            }{%
                                \phantomsection\pdfbookmark[1]{\contentsname}{toctarget}%
                                \hypertarget{toctarget}{\tableofcontents*}%
                            }%
                        }}}%
      {listoffigures*}{\options{/@nt/list/listof/.cpush={%
                                \phantomsection\pdfbookmark{\listfigurename}{loftarget}%
                                \hypertarget{loftarget}{\listoffigures*}%
                        }}}%
      {listoftables*}{\options{/@nt/list/listof/.cpush={%
                                \phantomsection\pdfbookmark{\listtablename}{lottarget}%
                                \hypertarget{lottarget}{\listoftables*}%
                        }}}%
      {listoflistings}{\options{/@nt/list/listof/.cpush={%
                                \phantomsection\pdfbookmark{\listoflistingscaption}{loltarget}%
                                \hypertarget{loltarget}{\listoflistings}%
                        }}}%
      {listofalgorithms}{\options{/@nt/list/listof/.cpush = {%
                                \phantomsection\pdfbookmark{\listalgorithmcfname}{loatarget}%
                                \hypertarget{loatarget}{\listofalgorithms}%
                        }}}%
      {listsofglossaries}{\options{/@nt/list/listof/.cpush={%
                              \glstoctrue%
                              \iftoggle{/novathesis/glsxindy}%
                                  {\printglossaries}%
                                  {\printnoidxglossaries}%
                          }}}%
      {listsofglossaries*}{\options{/@nt/list/listof/.cpush={%
                              \glstocfalse%
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
    {frontmatter}{%
      \iftoggle{/novathesis/secondcover}{}{\setcounter{page}{1}}%
      \iftoggle{/novathesis/printfrontmatter}{\ntprintlist{/@nt/print/#1}}{}%
    }%
    {mainmatter}{\ntprintlist{/@nt/print/#1}}%
  }[\csuse{ntprint#1}]%
  \ignorespaces%
}

\newcommand*{\ntprintlist}[1]{%
  \optionlistdo{#1}{\ifdefmacro{##1}{##1}{\csuse{ntprint##1}}\clearforchapter}%
}

\newcommand*{\ntsetprintorder}[2]{%
% #1 = frontmatter, mainmatter
% #2 = list
  \option@setlist[;]{/@nt/print/#1}{#2}%
}

\newcommand*{\ntremovefromprintorder}[2]{%
% #1 = frontmatter, mainmatter
% #2 =single item to remove
  \@for\@nt@item:=#2\do{\options{/@nt/print/#1/.remove = {\@nt@item}}}%
}

% --------------------------------------------------------
% DEFAULT VALUES FOR frontmatter AND mainmatter
\ntsetprintorder{frontmatter}{
  statement;       % The statement page
  copyright;       % (*) The copyright page
  dedicatory;      % (*) Print the dedicatory
  acknowledgements;% (*) Print the acknowledgments
  quote;           % (*) Print the quote
  abstracts;       % Print abstracts in multiple languages.
  alllistof;       % Print all the listof defined in “6_list_of.tex”
}

\ntsetprintorder{mainmatter}{
  chapters;        % Print document chapters
  bib;             % Print the bibliography.  Change to
                   %    “bib[title=⟨title⟩]” to redefine the title!
  appendices;      % Print appendices; if any!
  annexes;         % Print annexes; if any!
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COVER DEFINITION MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntaddtocover}[3][]{%
  % #1 = cover atrtibutes
  % #2 = list of covers where the code block should be applied
  % #3 = the block code
  % \typeout{NT ntaddtocover [/@nt/cover/\@nt@univ/\@nt@schl/element=#1]}%
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
}{}

\IfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/Images/DO_NOT_REMOVE_THIS_FILE.txt}{%
    \prependtographicspath{{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/Images/}}%
}{}

\InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@univ-defaults.ldf}{}%
    {\PackageWarning{novathesis}{Missing file “\@nt@univ-defaults.ldf” for ”\@nt@univ”}}

\InputIfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/\@nt@univ-\@nt@schl-defaults.ldf}{}%
    {\PackageWarning{novathesis}{Missing file “\@nt@univ-\@nt@schl-defaults.ldf” for ”\@nt@univ/\@nt@schl”}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------
% LOAD MAIN CLASS AND ADDITIONAL PACKAGES
\LoadClass{memoir}
\OnehalfSpacing% One-and-half spacing


% --------------------------------------------------------
% Customize the pagestyle
\makepagestyle{novathesis@mainmatter} 
\makeoddfoot{novathesis@mainmatter}{}{\thepage}{} 
\makeevenfoot{novathesis@mainmatter}{}{\thepage}{} 
\makeheadrule{novathesis@mainmatter}{\textwidth}{\normalrulethickness} 
\makeevenhead{novathesis@mainmatter}{\small\textsc{\leftmark}}{}{} 
\makeoddhead{novathesis@mainmatter}{}{}{\small\textsc{\rightmark}}

\makepagestyle{novathesis@frontmatter} 
\makeoddfoot{novathesis@frontmatter}{}{\thepage}{} 
\makeevenfoot{novathesis@frontmatter}{}{\thepage}{} 
% \makeheadrule{novathesis@almostempty}{\textwidth}{\normalrulethickness}
% \makeevenhead{novathesis@almostempty}{\small\textsc{\leftmark}}{}{}
% \makeoddhead{novathesis@almostempty}{}{}{\small\textsc{\rightmark}}

\ifoptionequal{/novathesis/media}{paper}{\ntsetup{linkscolor=Black}}{}


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

%============================================================
%  THESIS/DISSERTATION FILES
%   Please open and edit the appropriate
%       configuration file “Config/4_files.tex”
%============================================================
\input{Config/4_files}
% \NTRunHook{files}

%============================================================
% ADDITIONAL PACKAGES and MACROS
%      Please open and edit the appropriate
%       configuration file “Config/8_packages.tex”
%============================================================
\AtEndPreamble{\input{Config/5_packages}}
% \NTRunHook{packages}

%============================================================
%  WHICH LIST_OF TO PRINT
%   Please open and edit the appropriate
%       configuration file “Config/6_list_of.tex”
%============================================================
\AtEndPreamble{\makeatletter\input{Config/6_list_of}}
% \NTRunHook{list_of}

%============================================================
%  UNIVERSITY/SCHOOL SPECIFIC MATERIALS
%   Please open and edit the appropriate
%       configuration file “Config/9_<university>_<school>.tex”
%============================================================
\IfFileExists{Config/9_\@nt@univ_\@nt@schl.tex}{\input{Config/9_\@nt@univ_\@nt@schl.tex}}
    {\InputIfFileExists{Config/9_\@nt@univ.tex}{}{}}
% \NTRunHook{list_of}

\ifdocunset{\ntsetup{docstatus=working}}{}
\ifdocfinal{\ntsetup{printcommittee=true}}{}
\ifdocworking{\ntremovefromprintorder{frontmatter}{statement,copyright,dedicatory,acknowledgements,quote}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING ADDITINAL FILES AFTER LOADING MEMOIR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@ntloadfile@i}[1]{\IfFileExists{#1}{\input{#1}}{}}

\newcommand{\@ntloadfiles@ii}[2][VAL]{%
    % #1=KEY
    % #2=file class
    % \options{/@nt/folders=#2}%
    % \typeout{NT ntloadfiles [#2] [#1] [/@nt/file/#2/#1]}% [\expanded{\option{/@nt/folders}}]}%
    \ifoptiondefined{/@nt/file/#2/#1}%
        {\optionlistdo{/@nt/file/#2/#1}{\@ntloadfile@i{##1}\clearforchapter}}%
        {}%
}

% --------------------------------------------------------
% LOAD ADDITIONAL PACKAGES
\input{NOVAthesisFiles/packages.tex}

% --------------------------------------------------------
% FIX BABEL TRANSLATION
\input{NOVAthesisFiles/fix-babel.tex}

% --------------------------------------------------------
% LOAD A DEFAULT COPYRIGHT PAGE DEFINITION
\newcommand{\@nt@AddFileIfExists}[3]{%
  \expandnext{\forcsvlist{\@nt@AddFileIfExists@i{#1}{#2}}}{#3}%
}

\newcommand{\@nt@AddFileIfExists@i}[3]{\IfFileExists{#3#2}{\ntaddfile{#1}{#3#2}\listbreak}{}}

\ifmaindoc{% only print if a main document
  \iftoggle{/novathesis/printcopyright}{% if copuyright toggle is on
    \@nt@AddFileIfExists{copyright}{copyright.ldf}{%
       {NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/}%
      ,{NOVAthesisFiles/Schools/\@nt@univ/}%
      ,{NOVAthesisFiles/}%
    }%
    \@ntloadfiles@ii{copyright}%
  }{}%
}{}


\iftoggle{/novathesis/spine}{%
  % \RequirePackage{fp,anyfontsize}
  \@nt@InputIfFileExists{spine.tex}{%
       {NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/}%
      ,{NOVAthesisFiles/Schools/\@nt@univ/}%
      ,{NOVAthesisFiles/}%
  }%
  \AtEndDocument{%
    \csuse{ntprintspine}%
  }
}{}%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PRINT DOCUMENT PARTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

\newcommand*{\ifocverdefined}[3][1]{%
  % #1 = cover number
  % #2 = true branch
  % #3 = false branch
  \defifundef{\ifcoverdefined}{\newif}
  \coverdefinedfalse%
  \ifoptiondefined{/@nt/cover/\@nt@univ/\@nt@schl/#1}{\def\@coverdefined{true}}%
  {\ifdatadefined{thesiscover}(\option{/novathesis/docdegree},#1,bgcolor){\coverdefinedtrue}%
  {\ifdatadefined{thesiscover}(\option{/novathesis/docdegree},#1,image){\coverdefinedtrue}%
  {}}}%
  \ifcoverdefined#2\else#3\fi%
}

\newcommand{\ntprintbackcover}{%
  \ifocverdefined[N-1]{%
    \phantomsection\pdfbookmark[-1]{\thebackmatterbkmstring(\option{/novathesis/coverlang})}{bmbackmatter}%
  }{%
    \ifocverdefined[N-2]{%
      \phantomsection\pdfbookmark[-1]{\thebackmatterbkmstring(\option{/novathesis/coverlang})}{bmbackmatter}%
    }{}%
  }%
  \ntprintcoverpair{N}%
}

\newcommand{\ntprintcovers}[1][1,2]{%
  \phantomsection\pdfbookmark[-1]{\thefrontmatterbkmstring(\option{/novathesis/coverlang})}{bmfrontmatter}%
  \NTAddToHook{mainmatter/pre}{\bookmarksetup{startatroot}}%
  % \vspace*{-1.75pt}%
  \forcsvlist{\ntprintcoverpair}{#1}%
}

\newcommand{\ntprintcoverpair}[1]{%
  % #1 = major cover ID
  \IfStrEq{#1}{2}{%
    \iftoggle{/novathesis/secondcover}{%
      \ntprintcoversingle{#1}{1}%
      \ntprintcoversingle{#1}{2}%
    }{}%
  }{%
    \ntprintcoversingle{#1}{1}%
    \ntprintcoversingle{#1}{2}%
  }%
  \clearforchapter%
}

\newcommand{\ntprintcoversingle}[2]{%
  % #1 = major cover ID
  % #2 = minor cover ID
  \def\@nt@newpage{}%
  \gdef\@covernumber{#1-#2}%
  \IfStrEq{#2}{2}{%
    % \ifbool{@openright}{\def\@nt@newpage{\thispagestyle{empty}\null\newpage}}{\def\@nt@newpage{}}%
    \ifbool{@openright}{\def\@nt@newpage{\thispagestyle{cleared}\cleartoevenpage}}{\clearpage}%
  }{}%
  \IfStrEq{#1-#2}{2-1}{\setcounter{page}{1}}{}%
  \ifoptiondefined{/@nt/cover/\@nt@univ/\@nt@schl/#1-#2}{\@nt@newpage\@ntprintcover@i{#1-#2}}%
  {\ifdatadefined{thesiscover}(\option{/novathesis/docdegree},#1-#2,bgcolor){\@nt@newpage\@ntprintcover@i{#1-#2}}%
  {\ifdatadefined{thesiscover}(\option{/novathesis/docdegree},#1-#2,image){\@nt@newpage\@ntprintcover@i{#1-#2}}%
  {}}}%
}

\newcommand{\@ntprintcover@i}[1]{%
  % #1 = cover ID (major-minor)
  \NTRunHook{cover/#1/pre}
  \bgroup%
    \ifdatadefined{thesiscover}(\option{/novathesis/docdegree},#1,textcolor)%
        {\color{\thethesiscover(\option{/novathesis/docdegree},#1,textcolor)}}{}%
    \ntselectlang{\option{/novathesis/coverlang}}%
    \options{/@ntcoveropts/bookmark=#1}%
    \ifoptionequal{/@ntcoveropts/bookmark}{}{}{%
      \phantomsection\pdfbookmark[1]{\option{/@ntcoveropts/bookmark}}{\option{/@ntcoveropts/bookmark}}%
    }%
    \@ntmakeboxwithcover{#1}{\@fullcover@box}%
    \newpage%
  \egroup%
  \NTRunHook{cover/#1/post}
}

\newcommand{\@ntmakeboxwithcover}[2]{%
  % #1 = cover ID (major-minor)
  % #2 = box name
    \gdef\@nt@margin@top{}%
    \gdef\@nt@margin@bottom{}%
    \gdef\@nt@margin@left{}%
    \gdef\@nt@margin@right{}%
    \ifdatadefined{margin}(\option{/novathesis/docdegree},#1,top){%
      \edef\@nt@margin@top{\themargin(\option{/novathesis/docdegree},#1,top)}%
      \edef\@nt@margin@bottom{\themargin(\option{/novathesis/docdegree},#1,bottom)}%
      \edef\@nt@margin@left{\themargin(\option{/novathesis/docdegree},#1,left)}%
      \edef\@nt@margin@right{\themargin(\option{/novathesis/docdegree},#1,right)}%
    }{\ifdatadefined{margin}(\option{/novathesis/docdegree},top){%
      \def\@nt@margin@top{\themargin(\option{/novathesis/docdegree},top)}%
      \def\@nt@margin@bottom{\themargin(\option{/novathesis/docdegree},bottom)}%
      \def\@nt@margin@left{\themargin(\option{/novathesis/docdegree},left)}%
      \edef\@nt@margin@right{\themargin(\option{/novathesis/docdegree},right)}%
    }{%
      \ClassError{novathesis}{Margins for cover of type “\option{/novathesis/docdegree}” undefined! Please define the margins in the School's definition file!}{}%
    }}%
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
            , xshift=\expanded{\@nt@margin@left}
            , yshift=-\expanded{\@nt@margin@top}]  
                      at (current page.north west)  {\usebox{\@cover@text@box}};
    \end{tikzpicture}%
  % \end{lrbox}%
  \iftoggle{/novathesis/debugcover}{%
    \NTRunHook{cover/#1/pregrid}%
    \debuggrid%
    \NTRunHook{cover/#1/postgrid}%
  }{}%
}

\newcommand*{\@ntmakecoverbgcolor}[2]{%
  % #1 = cover ID (major-minor)
  % #2 = box name
  \defifundef{#2}{\newsavebox}%
  \ifdatadefined{thesiscover}(\option{/novathesis/docdegree},#1,bgcolor)%
      {\savebox{#2}{\@ntcoverbgcolor{#1}}}{}%
}

\newcommand*{\@ntcoverbgcolor}[1]{%
  % #1 = cover ID (major-minor)
  \NTRunHook{cover/#1/prebgcolor}%
  % \begin{tikzpicture}[remember picture, overlay]
  %   \node[inner sep=0, anchor=center,
  %         rectangle, minimum width=\paperwidth, minimum height=\paperheight,
  %         fill=\expanded{\thethesiscover(\option{/novathesis/docdegree},#1,bgcolor)}]
  %        at (current page.center)
  %           {};
  % \end{tikzpicture}
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
  \ifdatadefined{thesiscover}(\option{/novathesis/docdegree},#1,image)%
      {\savebox{#2}{\@ntcoverimage{#1}}}{}%
}

% \newif\ifgraphicexist
\newcommand*{\@ntcoverimage}[1]{%
  % #1 = cover ID (major-minor)
  \NTRunHook{cover/#1/preimage}%
  % \begin{tikzpicture}[remember picture, overlay]
  %   \node[inner sep=0, anchor=center]
  %        at (current page.center)
  %           {%
  %               \ifdatadefined{thesiscover}(\option{/novathesis/docdegree},\option{/novathesis/degreeacr},#1,image){%
  %                 \includegraphics[width=\paperwidth,height=\paperheight]%
  %                                 {\thethesiscover(\option{/novathesis/docdegree},\option{/novathesis/degreeacr},#1,image)}%
  %               }{\ifdatadefined{thesiscover}(\option{/novathesis/docdegree},#1,image){%
  %                   \includegraphics[width=\paperwidth,height=\paperheight]%
  %                                   {\thethesiscover(\option{/novathesis/docdegree},#1,image)}%
  %               }{}}%
  %           };
  % \end{tikzpicture}
  \ifdatadefined{thesiscover}(\option{/novathesis/docdegree},\option{/novathesis/degreeacr},#1,image){%
    \includegraphics[width=\paperwidth,height=\paperheight]%
                    {\thethesiscover(\option{/novathesis/docdegree},\option{/novathesis/degreeacr},#1,image)}%
  }{\ifdatadefined{thesiscover}(\option{/novathesis/docdegree},#1,image){%
      \includegraphics[width=\paperwidth,height=\paperheight]%
                      {\thethesiscover(\option{/novathesis/docdegree},#1,image)}%
  }{}}%
  \NTRunHook{cover/#1/postimage}%
}

\newcommand{\@ntmakecovertext}[2]{%
  % #1 = cover ID (major-minor)
  % #2 = box name
  \defifundef{#2}{\newsavebox}%
  \ifoptiondefined{/@nt/cover/\@nt@univ/\@nt@schl/#1}{%
      \begin{lrbox}{#2}%
        \begin{minipage}[l]%
                        [\dimexpr\paperheight-\@nt@margin@top-\@nt@margin@bottom]%
                        {\dimexpr\paperwidth-\@nt@margin@left-\@nt@margin@right}%
          \@ntcovertext{#1}%
        \end{minipage}%
      \end{lrbox}%
  }{}%
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
              \(\equal{\option{/@ntcoveropts/status}}{}\OR\@nt@instatus>0\)\AND%
              \(\equal{\option{/@ntcoveropts/degree}}{}\OR\@nt@indegree>0\)}%
      {\@ntcoverelement@ii{#1}{#3}}%
      {}%
  }%
}

\options{/@ntcoveropts/.new family
  % titles for PDF bookmark / list of contents
  , bookmark/.new choice = {1-1=\thecoverbkmstring(\option{/novathesis/coverlang})
                          , 1-2={}
                          , 2-1=\thefrontpagebkmstring(\option{/novathesis/coverlang})
                          , 2-2={}
                          , N-1={}
                          , N-2=\thebackcoverbkmstring(\option{/novathesis/coverlang})
                          , spine=\thespinebkmstring(\option{/novathesis/coverlang})}
  % letter to macro for horizontal alignment
  , alignmap/.new choice={c=\centering,l=\raggedright,r=\raggedleft,j=\null}
  % filters / conditional printing
  , status/.new value
  , degree/.new value
  % horizontal alighment and vertical alignments inside the box
  , align/.new choice={c, l, r, j}
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
  \end{lrbox}%
  \begin{lrbox}{#3}%
    % Add  round color if necessary
    \ifoptionblank{/@ntcoveropts/bgcolor}%
      {\usebox{#3}}%
      {\colorbox{\option{/@ntcoveropts/bgcolor}}{\usebox{#2}}}%
  \end{lrbox}%
}

\newenvironment{tinywhite}[1][white]{%
  \begin{Spacing}{1}%
    \sffamily%
    \fontsize{10.01}{10.01}\selectfont%
    \hypersetup{allcolors=#1}%
    \color{#1}%
}{%
  \end{Spacing}\ignorespacesafterend%
}

\newcommand{\@ntfixspacing}[2]{%
  \renewcommand*{\bibfont}{\hypersetup{allcolors=#1}\color{#1}%
                           \sffamily\fontsize{#2}{#2}\selectfont}%
  \refsection%
    \begin{minipage}{\linewidth}%
      \bibfont%
      \theacknowledgmentsstring(\option{/novathesis/coverlang})%
      \vspace*{-20ex}%
      \printbibliography[heading=none]%
    \end{minipage}%
  \endrefsection%
}

\newcommand{\ntfixspacing}{%
  \@ntfixspacing{white}{0.01}%
}

\newcommand*{\ntprintstatement}{%
  \iftoggle{/novathesis/statement}{% if statement toggle is on
    \ifmaindoc{%
      \NTRunHook{statement/pre}%
      \ifoptiondefined{/@nt/file/statement/VAL}{}{%ELSE
        \IfFileExists{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/statement.tex}%
          {\ntaddfile{statement}{NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl/statement.tex}}%
          {\IfFileExists{NOVAthesisFiles/Schools/\@nt@univ/statement.tex}%
            {\ntaddfile{statement}{NOVAthesisFiles/Schools/\@nt@univ/statement.tex}}%
            {\ClassError{novathesis}{No “statement.tex” found! Not defined with  \string\ntaddfile{statement}{filename} nor in folders “NOVAthesisFiles/Schools/\@nt@univ/\@nt@schl” or “NOVAthesisFiles/Schools/\@nt@univ”}{}}%
          }%
      }%
      \ntselectlang{\option{/novathesis/mainlang}}%
      \phantomsection\pdfbookmark[1]{\csuse{thestatementbkmstring}(\option{/novathesis/mainlang})}{bmstatement}%
      \@ntloadfiles@ii{statement}%
      \NTRunHook{statement/post}%
      \clearforchapter%
    }{}%
  }{}%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LABELS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\providecommand\thepresentationtext{%
	\thedissertationstringfont()\thedissertationstring(\option{/novathesis/docdegree},\option{/novathesis/coverlang})%
}

\providecommand\thecopyrightstr{%
  \iftoggle{/novathesis/numberallpages}{\thispagestyle{novathesis@frontmatter}}{\thispagestyle{empty}}%
  \noindent%
  Copyright \textcopyright\ \thedocauthor(name), %
  \theschool(\option{/novathesis/copyrightlang}), \theuniversity(\option{/novathesis/copyrightlang}).\\%
  \thecopyrighttextstring(\option{/novathesis/copyrightlang})%
  \ntselectlang{\option{/novathesis/mainlang}}%
}



 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print persons list {advisers | committee}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintpersons}[5][full]{%
  % #1 = { name | full}
  % #2 = width in % of textwidth
  % #3 = number of columns
  % #4 = adviser | committee
  % #5 = {a,c} | {c,r,a,m,g}
  \iftoggle{/novathesis/print#4}{%
    \IfStrEqCase{#3}{%
      {0}{\@ntprintpersonsaslist{#4}{\expanded{#5}}}%
      {1}{\@ntprintpersonsasonecolumn[#1]{#2}{#4}{\expanded{#5}}}%
      {2}{\@ntprintpersonsastwocolumns[#1]{#2}{#4}{\expanded{#5}}}%
    }[\ClassError{novathesis}{Ivalid argument [#3] to \string\ntprintpersons{0.9}{#2}{#3}{#4}{#5}}{}]%
  }{}%
}

%============================================================
% Print persons list {advisers | committee} as list
%============================================================
\newcommand{\@ntprintpersonsaslist}[2]{%
  % #1 = adviser | committee
  % #2 = {a,c} | {c,r,a,m,g}
  \def\@nt@personlist{}%
  \xforcsvlist{\@nt@addtopersonlist{#1}}{#2}%
  \StrSubstitute{\@nt@personlist}{,}{\thecommastring(\option{/novathesis/coverlang})}[\@nt@personlist]%
  \StrCount{\@nt@personlist}{\thecommastring(\option{/novathesis/coverlang})}[\@nt@personlist@last]%
  % Replace last comma with "and"
  \IfStrEq{0}{\@nt@personlist@last}{}{%
    \StrCut[\@nt@personlist@last]{\@nt@personlist}{\thecommastring(\option{/novathesis/coverlang})}%
                                     \@nt@listleft\@nt@listright%
    \def\@nt@personlist{\@nt@listleft\theandstring(\option{/novathesis/coverlang})\@nt@listright}%
  }%
  \@nt@personlist%
}

\newcommand{\@nt@addtopersonlist}[2]{%
  % #1 = adviser | committee
  % #2 = {a,c} | {c,r,a,m,g}
  \ifoptiondefined{/@nt/#1/#2/name}{%
    \letoptionlist{/@nt/#1/#2/name}\@nt@list%
    \IfStrEq{\@nt@personlist}{}{\def\@nt@comma{}}{\def\@nt@comma{,}}%
    \xappto\@nt@personlist{\@nt@comma\@nt@list}%
  }{}%
}



%============================================================
% Print persons list {advisers | committee} as one and two columns
%============================================================
\newcommand{\@ntprintpersonsasonecolumn}[4][full]{%
  % #1 = { name | full}
  % #2 = width in % of textwidth
  % #3 = adviser | committee
  % #4 = {a,c} | {c,r,a,m,g}
  \csuse{#3stringpost}():={:\\[0pt]}%
  % \csuse{#3stringpre}(c):={\\[-3ex]}%
  \csuse{#3namepost}():={\\[-0.5ex]}%
  \csuse{#3remainderpost}():={\vspace{1pt}}%
  \personpost():={~\\}%
  \persongrouppost():={~\\[12pt]}
  \begin{tabularx}{#2\linewidth}[t]{@{}X@{}}%
    % \ifdatadefined{#3titlestringpre}(\options{/novathesis/coverlang}){%
    %   \aadefault{#3titlestringpre}(#4)%
    %   \aadefault{#3titlestringfont}(#4)%
    %   \aadefault{#3titlestring}()%
    %   \aadefault{#3titlestringpost}(#4)%
    % }{}%
    \expandnext{\forcsvlist{\@nt@ntprintpersongroup[#1]{1}{#3}}}{\expanded{#4}}%
  \end{tabularx}%
}

\newcommand{\@ntprintpersonsastwocolumns}[4][full]{%
  % #1 = { name | full}
  % #2 = width in % of textwidth
  % #3 = adviser | committee
  % #4 = {a,c} | {c,r,a,m,g}
  \csuse{#3stringpre}():={\\[-1.5ex]}%
  \csuse{#3stringpost}():={:}%
  \csuse{#3namepost}():={\\[-0.5ex]}%
  \csuse{#3remainderpost}():={\\[1pt]}%
  \adviserstringpre(a):={}%
  \committeestringpre(c):={}%
  \committeetitlestringpre():={&}%
  \committeetitlestringpost():={\\[0.5ex]}%
  \persongrouppost():={~\\}
  \begin{tabularx}{#2\linewidth}[t]{@{}r@{~~}X@{}}%
    \ifdatadefined{#3titlestring}(\option{/novathesis/coverlang}){%
      \datadefault{#3titlestringpre}()%
      \datadefault{#3titlestringfont}()%
      \csuse{the#3titlestring}(\option{/novathesis/coverlang})%
      \datadefault{#3titlestringpost}()%
    }{}%
    \xforcsvlist{\@nt@ntprintpersongroup[#1]{2}{#3}}{#4}%
    % \@for\@nt@item:={#4}\do
    %   {\xdef\@nt@item{\@nt@item}\@nt@ntprintpersongroup[#1]{2}{#3}{\@nt@item}}
  \end{tabularx}%
}

\newcommand{\@nt@ntprintpersongroup}[4][full]{%
  % #1 = { name | full}
  % #2 = {1 | 2}
  % #3 = {adviser | committee}
  % #4 = {a,c} | {c,r,a,m,g}
  % [#2][#3][#4]\\%[#4]\\
  \ifoptiondefined{/@nt/#3/#4/full}{%
    \@nt@reducegender{/@nt/#3/#4/gender}{\@nt@advgender}%
    \@nt@reducenumber{/@nt/#3/#4/full}{\@nt@advnumber}%
    \datadefault{#3stringpre}(#4)%
    \bgroup%
      \datadefault{#3stringfont}(#4)%
      \datadefault{#3string}(#4,\@nt@advnumber,\@nt@advgender,\option{/novathesis/coverlang})%
    \egroup%
    \datadefault{#3stringpost}(#4)%
    \IfStrEq{#2}{2}{&}{}%
    \IfStrEq{#1}{full}{%
      \begin{minipage}[t]{\linewidth}%
          \optionlistdo{/@nt/#3/#4/full}{\@nt@printonename[#1]{#3}{##1}}%
      \end{minipage}%
    }{%
      \@ntprintpersonsaslist{#3}{#4}%
    }%
    \thepersongrouppost()%
  }{}%
}

%============================================================
% Print person aux funcitons
%============================================================
\newcommand{\@nt@printonename}[3][full]{%
  % #1 = { name | full}
  % #2 = adviser | coadviser | committee
  % #3 = (co)adviser info
  \raggedright%
  \StrCut{#3}{,}\@nt@name\@nt@remainder% split name from remainder
  \csuse{the#2namepre}()%
  \bgroup%
    \csuse{the#2namefont}()%
    \ignorespaces\@nt@name%
  \egroup%
  \csuse{the#2namepost}()%
  \IfStrEq{#1}{full}{%
    \csuse{the#2remainderpre}()%
    \bgroup%
      \csuse{the#2remainderfont}()%
      \ignorespaces\@nt@remainder%
    \egroup%
    \csuse{the#2remainderpost}()%
  }{}%
  \thepersonpost()%
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
    \gdef#2{1}%
  \else%
    \gdef#2{2}%
  \fi%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtEndPreamble{\typeout{NT AtEndPreamble ntsetlayout}\ntsetlayout}%

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
\newcommand{\@nt@printifmaindoc@i}[1]{%
  % \typeout{NT Attempt to load #1}%
  \NTRunHook{#1/pre}%
	\ifmaindoc{% THEN it is a main document
    \ifoptiondefined{/@nt/file/#1/VAL}{%
      \ntselectlang{\option{/novathesis/mainlang}}%
      \phantomsection\pdfbookmark[1]{\csuse{the#1bkmstring}(\option{/novathesis/mainlang})}{bm#1}%
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
  \xforcsvlist\@ntprintabstract{\@nt@tmp}%
  \ntselectlang{\option{/novathesis/mainlang}}%
}

\newcommand{\@ntprintabstract}[1]{%
  % \typeout{NT PRINT ABSTRACT #1}%
  \ifoptiondefined{/@nt/file/abstract/#1}{%
    \setabstractlang{#1}%
    \phantomsection\pdfbookmark[1]{\theabstractbkmstring(#1)}{bmabstract#1}%
    \NTRunHook{abstract/pre}%
    \NTRunHook{abstract/#1/pre}%
    \printabstracttitle{#1}%
    \NTRunHook{abstract/mid}%
    \@ntloadfiles@ii[#1]{abstract}%
    \NTRunHook{abstract/#1/post}%
    \NTRunHook{abstract/post}%
  }{}%
}


\newcommand*{\ntthesisfrontmatter}{%
  \NTRunHook{frontmatter/pre}%
  \frontmatter%
  \pagestyle{novathesis@frontmatter}%
  \ntselectlang{\option{/novathesis/mainlang}}%
  \pagenumbering{roman}%
  % \setlength{\headheight}{15pt}%
  \NTRunHook{frontmatter/post}%
}

\newcommand*{\ntthesismainmatter}{%
  \NTRunHook{mainmatter/pre}%
  % enables protrusion locally for the remainder of the document
  \ifbool{@openright}{}{% openany=true
    \let\oldcleardoublepage\cleardoublepage%
    \renewcommand{\cleardoublepage}{\clearpage}%
  }%
  \mainmatter%
  \ifbool{@openright}{}{% openany=true
    \let\cleardoublepage\oldcleardoublepage%
  }%
  \pagestyle{novathesis@mainmatter}%
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
  \ifoptiondefined{/@nt/file/appendix/VAL}{%
    \renewcommand{\appendixtocname}{\appendixnamepl}%
    \appendix\addappheadtotoc%
    \@nt@foralllist{file}{appendix}{\@ntloadfiles@ii{appendix}}%
  }{}%
}

\newcommand*{\ntprintannexes}{%
  \ifoptiondefined{/@nt/file/annex/VAL}{%
    \renewcommand{\appendixtocname}{\annexnamepl}%
    \annex\addappheadtotoc%
    \@nt@foralllist{file}{annex}{\@ntloadfiles@ii{annex}}%
  }{}%
}

\ifdef{\annexcounter}{}{\def\annexcounter{\@Roman}}
\newcommand*{\annex}{%
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
  \xStrCut{#2}{=}\option@listmatch@key\option@listmatch@value%
  % \typeout{K=\option@listmatch@key ~V=\option@listmatch@value}%
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
\newcommand{\ntprintacknowledgementsblock}[1][\scriptsize]{%
  \noindent\parbox{\linewidth}{\vspace*{2.5ex}\footnoterule#1\theacknowledgmentsstring(\option{/novathesis/mainlang})}
}

\newcommand*{\ntprintcopyright}{%
  \iftoggle{/novathesis/printcopyright}{%
    \ifmaindoc{%
      \ntselectlang{\option{/novathesis/copyrightlang}}%
      \phantomsection\pdfbookmark[1]{\csuse{thecopyrightbkmstring}(\option{/novathesis/mainlang})}{bmcopyright}%
      \NTRunHook{copyright/pre}%
      \ntprintcopyrightpage%
      \NTRunHook{copyright/post}%
      \ntprintacknowledgementsblock%
    }{}%
  }{}%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Dedicatory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{ntdedicatory}{%
  \iftoggle{/novathesis/numberallpages}{\thispagestyle{novathesis@frontmatter}}{\thispagestyle{empty}}%
  \NTRunHook{dedicatory/pre}%
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
  \NTRunHook{dedicatory/post}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Quote
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{ntquote}{%
  \iftoggle{/novathesis/numberallpages}{\thispagestyle{novathesis@frontmatter}}{\thispagestyle{empty}}%
  \NTRunHook{quote/pre}%
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
  \NTRunHook{quote/post}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{ntacknowledgements}{%
  \chapter*{\theacknowledgementsbkmstring(\option{/novathesis/mainlang})}%
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
	\chapter*{\theabstractbkmstring(#1)}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Keywords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{keywords}[1][\option{/@nt/langshorttolong}]{%
  \defifundef{\ntkwbox}{\newsavebox}%
  \begin{lrbox}{\ntkwbox}%
    \minipage[t]{\linewidth}%
      \par\vskip\baselineskip\noindent{\bfseries\@nt@keywordsstr: }%
}{%
    \endminipage%
  \end{lrbox}%
  \ifoptionequal{/@nt/currentlang}{\option{/novathesis/mainlang}}%
      {\hypersetup{pdfkeywords={\usebox{\ntkwbox}}}}%
      {}%
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

\InputIfFileExists{NOVAthesisFiles/ChapStyles/\option{/novathesis/chapstyle}.ldf}{}{%
  \ClassError{novathesis}{Invalid Chapter Style: \option{/novathesis/chapstyle}}{}%
}%
\InputIfFileExists{NOVAthesisFiles/FontStyles/\option{/novathesis/fontstyle}.ldf}{}{%
  \ClassError{novathesis}{Invalid Chapter Style: \option{/novathesis/fontstyle}}{}%
}%

