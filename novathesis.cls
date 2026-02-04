%!TEX root=template.tex

%% ----------------------------------------------------------------------------
%%  NOVATHESIS — novathesis.cls
%% ----------------------------------------------------------------------------
%%
%% Version 7.10.0 (2026-02-04)
%% Copyright (C) 2004-26 by João M. Lourenço <joao.lourenco@fct.unl.pt>
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
%%      or in the subreddit r/novathesis
%%          https://www.reddit.com/r/novathesis/
%%
%% AUTHOR @github:
%%      - https://github.com/joaomlourenco (joaomlourenco)
%%
%% CONTRIBUTORS @github:
%%      - https://github.com/joaomlourenco/novathesis/wiki#help-with-the-project-patches-and-new-features
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
%%      If you use this template, please be kind and \cite{novathesis-manual}
%%      somewhere in your document.
%%
%% This work is licensed under the
%% The LaTeX project public license (LPPL), version 1.3c
%% To view a copy of this license, visit
%% https://www.latex-project.org/lppl/lppl-1-3c/
%%
%% ----------------------------------------------------------------------------
%%
%% ██████   ██       ███████   █████    █████   ███████
%% ██   ██  ██       ██       ██   ██  ██       ██
%% ██████   ██       █████    ███████   █████   █████
%% ██       ██       ██       ██   ██       ██  ██
%% ██       ███████  ███████  ██   ██  ██████   ███████
%%
%% █████     █████            ███    ██   █████   ███████
%% ██   ██  ██   ██           ████   ██  ██   ██     ██
%% ██   ██  ██   ██           ██ ██  ██  ██   ██     ██
%% ██   ██  ██   ██           ██  ██ ██  ██   ██     ██
%% █████     █████            ██   ████   █████      ██
%%
%%  █████   ██   ██   █████   ███    ██   █████   ███████
%% ██       ██   ██  ██   ██  ████   ██  ██       ██
%% ██       ███████  ███████  ██ ██  ██  ██  ███  █████
%% ██       ██   ██  ██   ██  ██  ██ ██  ██   ██  ██
%%  █████   ██   ██  ██   ██  ██   ████   █████   ███████
%%
%% ███████  ██   ██  ███    █████          ███████  ███   ██       ███████
%%    ██    ██   ██   ██   ██              ██        ██   ██       ██
%%    ██    ███████   ██    █████          █████     ██   ██       █████
%%    ██    ██   ██   ██        ██         ██        ██   ██       ██
%%    ██    ██   ██  ███   ██████          ██       ███   ███████  ███████
%% 
%% ----------------------------------------------------------------------------
%%
%% If you feel you need to change this file, you are doing something wrong!
%%
%% Please ask for help at GitHub Discussions page at
%%          https://github.com/joaomlourenco/novathesis/discussions
%%      or in the subreddit r/novathesis
%%          https://www.reddit.com/r/novathesis/

\ProvidesClass{novathesis}[Version 7.10.0 (2026-02-04) novathesis template class file]
\NeedsTeXFormat{LaTeX2e}[2024-06-01]

%% ----------------------------------------------------------------------------
% Save these definitions asap, to be used later in the “\annex” command,
% because "\@Roman" and "\Roman" were failing with pdflatex
% when loading the "greek" language (and LGR font encofing)
%% ----------------------------------------------------------------------------
\let\oldRoman=\Roman
\let\old@Roman=\@Roman


\newcommand*{\NTAddToHook}[2]{\options{/@nt/hook/#1/.newpush={#2}}}
\newcommand*{\NTRunHook}[1]{\optionlistdo{/@nt/hook/#1}{##1}}

%============================================================
\def\DIRCONFIG{0-Config}
\def\DIRFRONTMATTER{1-FrontMatter}
\def\DIRMAINMATTER{2-MainMatter}
\def\DIRBACKMATTER{3-BackMatter}
\def\DIRBIBLIOGRAPHY{4-Bibliography}
\def\DIRFIGURES{5-Figures}
\def\DIRNTFILES{./NOVAthesisFiles}
\def\DIRSTYFILES{\DIRNTFILES/StyFiles}
\def\DIRFONTSTYLES{\DIRNTFILES/FontStyles}
\def\DIRSCHOOLS{\DIRNTFILES/Schools}
\def\DIRSTRINGS{\DIRNTFILES/Strings}
\def\DIRCHAPSTYLES{\DIRNTFILES/ChapStyles}
\def\DIRIMAGES{\DIRNTFILES/Images}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  MEMOIR CUSTOMIZATION AND LOADING
%%      Please open and edit the appropriate
%%       configuration file “0-Config/0_memoir.tex”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntmemoirsetup}[1]{\PassOptionsToClass{#1}{memoir}}
\input{\DIRCONFIG/0_memoir}
\LoadClass{memoir}

\OnehalfSpacing% One-and-half spacing

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SOME ESSENTIAL PACKAGES
%%    Others will be loaded later, in the file “packages.tex”
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% `l3regex` is part of the LaTeX3 kernel (expl3) in modern TeX distributions.
% Some setups don't ship a separate `l3regex.sty` anymore, so only load it if present.
\IfFileExists{xparse.sty}{\RequirePackage{xparse}[2024-05-08]}{}
\IfFileExists{expl3.sty}{\RequirePackage{expl3}[2024-05-08]}{}
\IfFileExists{l3regex.sty}{\RequirePackage{l3regex}}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 1. KERNEL, UTILITIES & FLAGS (Must load early)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[table,svgnames]{xcolor} % First to avoid option clashes
\RequirePackage{iftex}
\RequirePackage{ifplatform}
\RequirePackage{xparse}
\RequirePackage{xfor}
\RequirePackage{etoolbox}
\RequirePackage{xstring}
\RequirePackage{catchfile}
\RequirePackage{varwidth}
\RequirePackage{calc}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2. TEMPLATE CORE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\xappto\input@path{{\DIRSTYFILES/}{\DIRSTRINGS/}}

\RequirePackage{options-ext}
\RequirePackage{nt-version}
\RequirePackage{memory2}
\RequirePackage{memstore}
\RequirePackage{stocksize}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 3. FONTS & ENCODINGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\iftutex
  \RequirePackage[no-math]{fontspec}
  \defaultfontfeatures{Ligatures=TeX}
\else
  \RequirePackage[T1]{fontenc}
\fi

\IfFileExists{inter.sty}
  {\RequirePackage[scaled=0.95]{inter}}
{\IfFileExists{helvet.sty}
  {\RequirePackage[scaled=0.95]{helvet}}
{\IfFileExists{gillius2.sty}
  {\RequirePackage[scaled=0.95]{gillius2}}
  {\ClassWarning{novathesis}{Could not find a suitable Sans Serif font… using the default!}}}}
% \IfFileExistsCase*
%   {
%     {inter.sty}    {\RequirePackage{inter}},
%     {helvet.sty}   {\RequirePackage{helvet}}
%     {gillius2.sty} {\RequirePackage{gillius2}}
%   }
%   {\ClassWarning{novathesis}{Could not find a suitable Sans Serif font… using the default!}}}}

% TODO Good to load after fonts
\RequirePackage{microtype} % Good to load after fonts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 4. LANGUAGE & LOCALIZATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage[english]{babel}
\AtBeginDocument{%
  \ifx\bbl@ensure@bcp\@undefined
    \newcommand{\bbl@ensure@bcp}[2]{#2}%
  \fi
  \ifx\bbl@ensure@english\@undefined
    \newcommand{\bbl@ensure@english}[1]{#1}%
  \fi
}

\RequirePackage{csquotes}  % MUST be loaded before biblatex

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5. GRAPHICS & TABLES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{tikz}
\RequirePackage[nobeamer]{graphbox} % Loads graphicx
\RequirePackage{colortbl}
\RequirePackage{xurl} % Loads 'url' with better breaking
\RequirePackage{url}  % (Technically redundant due to xurl, but kept as requested)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 6. BIBLIOGRAPHY & INDEXING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewDocumentCommand { \ntbibsetup } {m}
  {%
    \@ifpackageloaded{biblatex}
        {\ClassError{novathesis}{Please load biblatex options earlier.}{}}
        {\PassOptionsToPackage{#1}{biblatex}}%
  }

\input{\DIRCONFIG/2_biblatex}

\NTAddToHook{/afterloading/schoolconfig}{%
  % TODO defernumbers=true??
  \RequirePackage{biblatex}
  % TODO to be loaded only if option print/index=true
  \RequirePackage{imakeidx} % Should generally be loaded before hyperref
}

\AtEndPreamble{
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% 7. HYPERREF & INTERACTIVE ELEMENTS
  %% (Most packages go before here; specific ones go after)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    \PassOptionsToPackage{
      bookmarksnumbered=true,
      breaklinks=true,
      colorlinks=true,
      pdfdisplaydoctitle=true,
      unicode=true,
    }{hyperref}
    \RequirePackage{hyperref}
    \RequirePackage{fix-hyperref} % Patches hyperref immediately
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% 8. POST-HYPERREF DEPENDENCIES
  %% (These MUST be loaded after hyperref)
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  \RequirePackage{bookmark}           % Extends hyperref bookmarks
  \PassOptionsToPackage{
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
  }{glossaries-extra}
  \RequirePackage{glossaries-extra}   % Must be after hyperref
  \RequirePackage{glossary-xltabular} % Helper for glossaries

  %--------------------------------
  % “glossasries” stuff - after hyperref
  \ifoptioncontains{/novathesis/lang/extra}{gr}
    {\PassOptionsToPackage{xindy={language=\expanded{\@LANG@MAIN@LONG}}}
                          {glossaries-extra}}
    {}
  
  \setglossarystyle{xltabular}
  \setabbreviationstyle[acronym]{long-short}
  \GlsXtrEnablePreLocationTag{\emph{(\small p.~}}{\emph{(\small pp.~}}
  \patchcmd{\@gls@automake@immediate}{-I xindy}{-q -I xindy}{}{}
  % \renewcommand{\gls@automake@makegloss}{makeglossaries -q}%
  \renewcommand{\GlsXtrFormatLocationList}[1]{\emph{\small#1)}}
  \renewcommand{\glsnamefont}[1]{\textbf{#1}}
  \newcommand*{\glsplainhyperlink}[2]{%
      \begingroup
        \hypersetup{hidelinks}%
        \hyperlink{#1}{#2}%
      \endgroup
  }%
  \let\printglossaryORIG\printglossary
  \def\printglossary{%
    \bookmarksetupnext{level=1}%
    \printglossaryORIG%
  }
  
  %--------------------------------
  % “Process glossaries/list/reverse” option - after glossaries
  \iftoggle{/novathesis/glossaries/list/reverse}
           {}
           {\setupglossaries{nonumberlist}}
  \@loadglossaryfiles\makeglossaries
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 9. FINAL TOOLS & DEVELOPMENT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \ifoptioncontains{/novathesis/debug}{index}{%
%   % \PassOptionsToPackage{inline}{showlabels}%
%   \AtEndPreamble{\RequirePackage{showlabels}%
%   \showlabels[\color{\debugindexcolor}]{index}}%
% }{}
\AtEndPreamble{
  \RequirePackage[autobib=true,nocite=false]{aidisclose2}
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Configure Graphics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\expandafter\graphicspath\expandafter{\expandafter{\DIRFIGURES/}}
\DeclareGraphicsExtensions{.pdf,.png,.tif,.jpg}
\providecommand*\appendtographicspath[1]{\xappto\Ginput@path{#1}}
\providecommand*\prependtographicspath[1]{\xpreto\Ginput@path{#1}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UTILITIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\ifxeorlua}[2]{\iftutex#1\else#2\fi}

% --------------------------------------------------------
% Change main font size on the fly
% --------------------------------------------------------
\newcommand{\setmemoirfontsize}[1]{\input{mem#1.clo}}


% --------------------------------------------------------
% Date and month
% --------------------------------------------------------
% \babelmonthname{<1..12>} → localized month name (current babel language)
\newcommand{\babelmonthname}[1]{%
  \csname month\romannumeral\numexpr#1\relax name\endcsname
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Expl3 UTILITIES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ExplSyntaxOn

\NewExpandableDocumentCommand {\ToUppercase} { m }
  {
    \text_uppercase:n { #1 }
  }

%=======================================================================
% \IfBeginsWithAnyOf {text} {comma_sep_list_of_prefixes} {true} {false}
%=======================================================================

% 1. Create Variables
\int_new:N \l_check_len_int
\str_new:N \l_slice_str
\tl_new:N \l_clean_input_tl
\bool_new:N \l_match_found_bool

% 2. Generate the missing variant
%    This forces \str_range to accept an expanded ('e') first argument.
\cs_generate_variant:Nn \str_range:nnn { enn }

\NewDocumentCommand{\IfBeginsWithAnyOf}{ m m +m +m }
 {
  % Step A: Store and clean the input string
  \tl_set:Nn \l_clean_input_tl { #1 }
  \tl_trim_spaces:N \l_clean_input_tl
  
  \bool_set_false:N \l_match_found_bool
  
  % Step B: Iterate through prefixes
  \clist_map_inline:nn { #2 }
   {
    % Get length of the current prefix (##1)
    \int_set:Nn \l_check_len_int { \str_count:n { ##1 } }
    
    % Step C: Extract substring
    % We use the generated ':enn' variant to expand \l_clean_input_tl
    % into actual text (e.g., "Apple") BEFORE slicing.
    \str_set:Nx \l_slice_str 
      { 
        \str_range:enn { \l_clean_input_tl } { 1 } { \l_check_len_int } 
      }
    
    % Step D: Compare
    \exp_args:No \str_if_eq:nnTF \l_slice_str { ##1 }
     {
      \bool_set_true:N \l_match_found_bool
      \clist_map_break: 
     }
     { }
   }
   
  \bool_if:NTF \l_match_found_bool { #3 } { #4 }
 }




%=======================================================================
% \AddValidProcessor {univ[/school]} {comma_sep_list_of_processors}
% \ValidateLtxProcessor {univ} {school} {degree}
%=======================================================================

% ---------------------------------------------------------
% 1. Variables and Data Storage
% ---------------------------------------------------------

% Store the rules (Univ/School -> Allowed Engines)
\prop_new:N \g_novathesis_proc_rules_prop

% Store the current engine name (pdf, lua, or xe)
\str_new:N \g_novathesis_current_engine_str
\tl_new:N  \l_novathesis_found_rule_tl
\bool_new:N \l_novathesis_rule_found_bool

% Detect the current engine immediately
\sys_if_engine_pdftex:T { \str_gset:Nn \g_novathesis_current_engine_str {pdf} }
\sys_if_engine_luatex:T { \str_gset:Nn \g_novathesis_current_engine_str {lua} }
\sys_if_engine_xetex:T  { \str_gset:Nn \g_novathesis_current_engine_str {xe} }

% 3. Define the user-facing command
\NewDocumentCommand \NTengineName {}
  {
    % Use \str_use:N to retrieve the content of the variable
    \str_use:N \g_novathesis_current_engine_str \LaTeX{}
  }

% ---------------------------------------------------------
% 2. User Interface to Add Rules (Replament for \validprocessor)
% ---------------------------------------------------------

% Syntax: \AddValidProcessor{key}{list,of,engines}
\NewDocumentCommand{\AddValidProcessor}{ m m }
  {
    \prop_gput:Nnn \g_novathesis_proc_rules_prop { #1 } { #2 }
  }

% ---------------------------------------------------------
% 3. The Main Validator
% ---------------------------------------------------------

% Message definition for the error
\msg_new:nnnn { novathesis } { invalid-processor }
  { Invalid~processor~for~"#1". }
  { You~are~using~\g_novathesis_current_engine_str (la)tex,~but~"#1"~only~allows:~#2. }

\NewDocumentCommand{\ValidateLtxProcessor}{ m m m }
  {
    % #1 = Univ, #2 = School, #3 = Degree

    % Reset flags
    \bool_set_false:N \l_novathesis_rule_found_bool

    % -----------------------------------------------------
    % A. Hierarchy Lookup (Univ/Sch/Deg -> Univ/Sch -> Univ)
    % -----------------------------------------------------

    % 1. Check Univ/School/Degree
    \prop_get:NeNTF \g_novathesis_proc_rules_prop { #1/#2/#3 } \l_novathesis_found_rule_tl
      { \bool_set_true:N \l_novathesis_rule_found_bool }
      {
        % 2. Check Univ/School
        \prop_get:NeNTF \g_novathesis_proc_rules_prop { #1/#2 } \l_novathesis_found_rule_tl
          { \bool_set_true:N \l_novathesis_rule_found_bool }
          {
            % 3. Check Univ
            \prop_get:NnNTF \g_novathesis_proc_rules_prop { #1 } \l_novathesis_found_rule_tl
              { \bool_set_true:N \l_novathesis_rule_found_bool }
              {
                % No rule found: Do nothing (Implicitly Valid)
              }
          }
      }

    % -----------------------------------------------------
    % B. Validation Logic
    % -----------------------------------------------------

    \bool_if:NT \l_novathesis_rule_found_bool
      {
        % Check if the current engine is in the allowed list
        \clist_if_in:NVF \l_novathesis_found_rule_tl \g_novathesis_current_engine_str
          {
            % ERROR: Engine not found in allowed list
            \msg_error:nnxx { novathesis } { invalid-processor }
              { #1/#2/#3 }
              { \clist_use:Nn \l_novathesis_found_rule_tl { ,~ } }
          }
      }
  }

% ---------------------------------------------------------
% 4. Helper: Print current processor name (The \pdfprocessor equivalent)
% ---------------------------------------------------------
\NewDocumentCommand{\PrintProcessorName}{ }
  {
    \str_case:Vn \g_novathesis_current_engine_str
      {
        {pdf} { pdf(La)\TeX }
        {lua} { lua(La)\TeX }
        {xe}  { Xe(La)\TeX }
      }
  }




% =========================================================
% Process multiple files
% starred (*) processes all that exist
% non-starred stops on first sucess
% =========================================================


\bool_new:N \l_file_found_bool
\tl_new:N \l_file_action_tl


\NewDocumentCommand{\IfFileExistsInDirsTF}{ s O{} m m m m }
 {
  \group_begin:
    \tl_new:N \l_tmp_dir_tl
    \tl_new:N \l_tmp_path_tl
    \tl_new:N \l_tmp_last_char_tl
    
    \bool_gset_false:N \g_file_found_bool
    
    % Define an internal "action" function that takes one argument (#1)
    % This makes the user's code (#5) act like a function body.
    \cs_set:Npn \__file_user_action:n ##1 { #5 }
    
    \clist_map_inline:nn { #4 }
     {
      \tl_set:Nn \l_tmp_dir_tl { ##1 }
      \tl_trim_spaces:N \l_tmp_dir_tl
      
      % Smart Slash Logic
      \tl_if_empty:NF \l_tmp_dir_tl
       {
        \tl_set:Nx \l_tmp_last_char_tl { \tl_item:Nn \l_tmp_dir_tl { -1 } }
        \str_if_eq:VnF \l_tmp_last_char_tl { / }
         { \tl_put_right:Nn \l_tmp_dir_tl { / } }
       }
      
      % CONSTRUCT FULL PATH: Prefix + Dir + Filename
      \tl_set:Nx \l_tmp_path_tl { #2 \l_tmp_dir_tl #3 }
      
      \file_if_exist:nT { \l_tmp_path_tl }
       {
        \bool_gset_true:N \g_file_found_bool
        
        % EXECUTE: Pass the full path directly into the user action
        \__file_user_action:n { \l_tmp_path_tl }
        
        \IfBooleanF { #1 } { \clist_map_break: }
       }
     }
  \group_end:
  
  \bool_if:NF \g_file_found_bool { #6 }
 }


\NewDocumentCommand{\IfFileExistsCase}{ s O{} m m }
  {
    \bool_set_false:N \l_file_found_bool
    
    \clist_map_inline:nn { #3 }
      {
        % ##1 is {filepath}{action}
        \__filecase_split_pair:nnn { #1 } { #2 } ##1
      }
    
    % Else branch
    \bool_if:NF \l_file_found_bool { #4 }
  }

% #1: Starred status
% #2: Prefix
% #3: Filename
% #4: Action
\cs_new:Npn \__filecase_split_pair:nnn #1 #2 #3 #4
  {
    % 1. Construct the full path
    \tl_set:Nn \l_tmpa_tl { #2 #3 }
    
    \file_if_exist:nT { \l_tmpa_tl }
      {
        \bool_set_true:N \l_file_found_bool
        
        % 2. Create a copy and strip the extension
        \tl_set_eq:NN \l_tmpb_tl \l_tmpa_tl
        
        % Regex: Match a dot, followed by non-dots and non-slashes, until end of string.
        % This ensures we don't accidentally match a dot in a directory name (e.g. "ver.1/img").
        \regex_replace_once:nnN { \.[^./]* \Z } { } \l_tmpb_tl
        
        % 3. Define the internal action to accept TWO arguments:
        %    ##1 = Full Path (e.g., images/logo.png)
        %    ##2 = No Extension (e.g., images/logo)
        \cs_set:Npn \__filecase_do_action:nn ##1 ##2 { #4 }
        
        % 4. Execute with both variants
        \__filecase_do_action:nn { \l_tmpa_tl } { \l_tmpb_tl }
        
        % Break if not starred
        \bool_if:NF #1 { \clist_map_break: }
      }
  }



\NewDocumentCommand{\IfFontExistsCase}{ s m m }
  {
    \bool_set_false:N \l_tmpa_bool
    \clist_map_inline:nn { #2 }
      {
        % Check if the command \IfFontExistsTF exists (provided by fontspec)
        \cs_if_exist:cTF { IfFontExistsTF }
          {
            \IfFontExistsTF { ##1 }
              {
                \bool_set_true:N \l_tmpa_bool
                % Execute the code #3, passing the found font name (##1)
                #3 { ##1 }
                % If starred, break the loop after the first match
                \IfBooleanT { #1 } { \clist_map_break: }
              }
              { } % Do nothing if font doesn't exist
          }
          {
            % Fallback if fontspec isn't loaded or engine is pdfLaTeX
            \typeout{NOVAthesis:~fontspec~not~loaded.~Skipping~font~check~for~##1.}
          }
      }
    
    % Optional: warning if NO fonts from the list were found
    \bool_if:NF \l_tmpa_bool 
      { \typeout{NOVAthesis:~Warning:~No~fonts~from~the~list~{#2}~were~found.} }
  }


% --------------------------------------------------------
% Input the file from the first dir list (if any)
% #1 = file name
% #2 = list of directories
% #3 = code if succeed [OPTIONAL]
% #4 = code if fails [OPTIONAL]


% 1. Create variables
\tl_new:N \l_found_path_tl

\NewDocumentCommand{\InputIfFileExistsInDirsTF}{ m m +m +m }
  {
    \bool_set_false:N \l_file_found_bool

    % Iterate through directories (#2)
    \clist_map_inline:nn { #2 }
      {
        % Check if 'directory/filename' exists
        \file_if_exist:nTF { ##1 / #1 }
          {
            % A. Store the full path in the variable
            \tl_set:Nn \l_found_path_tl { ##1 / #1 }

            % B. Input the file
            \file_input:n { ##1 / #1 }

            % C. Execute Success Code (#3)
            #3

            % D. Mark found and break loop
            \bool_set_true:N \l_file_found_bool
            \clist_map_break:
          }
          {}
      }

    % Handle 'Not Found' case
    \bool_if:NF \l_file_found_bool
      { #4 }
  }




% 1. Define the internal logic (accepts the argument as-is)
\cs_new_protected:Nn \__user_chapter_logic:n
 {
  % Note: Inside ExplSyntaxOn, spaces are ignored, so we don't need % at EOL
  \clearforchapter
  
  % Create the anchor. 
  % #1 is now the fully expanded string (e.g., "Project Alpha").
  \hypertarget{bm#1}{}
  
  % Create the bookmark using the same ID
  \bookmark[dest=bm#1]{#1}
  
  % Reset spacing/formatting
  \noindent \ignorespaces
 }

% 2. Generate the variant that forces expansion ('e' = expand fully)
\cs_generate_variant:Nn \__user_chapter_logic:n { e }

% 3. User Interface
\NewDocumentCommand{\ChapterNoTitle}{ m }
 {
  % Call the expanded variant.
  % This turns \ChapterNoTitle{\myMacro} into \__user_chapter_logic:n {Expanded Value}
  \__user_chapter_logic:e { #1 }
 }


\NewDocumentCommand{\UniquifyList}{m o}
  {
    \clist_set:Ne \l_tmpa_clist {#1}
    \clist_remove_duplicates:N \l_tmpa_clist
    \IfValueTF{#2}
      {\tl_set:Ne #2 {\clist_use:Nn \l_tmpa_clist {,}}}
      {\clist_use:Nn \l_tmpa_clist {,}}
  }

\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PACKAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
\def\@nt@saveabstractorder{}
\newcommand{\@setabstractorder}{%
  % \typeout{SAVEABSORDER=[\@nt@saveabstractorder]}\SAVEABSORDER%
  \StrGobbleRight{\@nt@saveabstractorder}{1}[\@nt@saveabstractorder]%
  \@for\nt@tmpi:=\@nt@saveabstractorder\do{%
    \StrCut{\nt@tmpi}{=}\@nt@key\@nt@val%
    \IfStrEq{\@nt@val}{}{\edef\@nt@val{\@nt@key}\def\@nt@key{\@LANG@MAIN}}{}%
    % \typeout{SETABSORDER (\@nt@key):=[\@nt@val]}\SETABSORDER%
    \abstractorder(\@nt@key):={\@nt@val}%
  }%
}


% --------------------------------------------------------
% Search if a data/memory is defined and returns value
\ExplSyntaxOn

% Define a boolean to track if a match was found inside the loop
\bool_new:N \l__memory_match_found_bool

% Command: \datamatchtf
% Syntax:  \datamatchtf{\match}{MEMORYDATA}(list,of,keys){TRUE}{FALSE}
%
% #1: The macro to store the result (\match)
% #2: The memory data container name (MEMORYDATA)
% #3: The list of keys to search (in parentheses)
% #4: True branch code
% #5: False branch code

\NewDocumentCommand{\datamatchtf}{ s m m r() +m +m }
  {
    % Reset the found boolean to false at the start
    \bool_set_false:N \l__memory_match_found_bool

    % Iterate through the comma-separated list of keys (#4 now, due to argument shift).
    \exp_args:Ne \clist_map_inline:nn { #4 }
      {
        % Initialize #2 to empty
        \IfBooleanTF{#1}
          { 
            % STARRED: #2 is a NAME (e.g., "myVar"). 
            % Use \tl_set:cn to construct the csname from the string.
            \tl_set:ce { #2 } { } 
          }
          { 
            % NON-STARRED: #2 is a MACRO (e.g., \myVar). 
            % Use \tl_set:Nn to set it directly.
            \tl_set:Ne #2 { } 
          }
        
        % Construct the control sequence name: \@<MEMORYDATA>@<key>@memory
        % Note: Using #3 for the memory namespace ID
        \cs_if_exist:cT { @#3@ ##1 @memory }
          {
            % If the data slot exists:
            % 1. Set the user's variable (#2) to the content of that slot.
            
            \IfBooleanTF{#1}
              { 
                % STARRED: #2 is a NAME (e.g., "myVar"). 
                % Use \tl_set:cn to construct the csname from the string.
                \tl_set:ce { #2 } { \use:c { @#3@ ##1 @memory } } 
              }
              { 
                % NON-STARRED: #2 is a MACRO (e.g., \myVar). 
                % Use \tl_set:Nn to set it directly.
                \tl_set:Ne #2 { \use:c { @#3@ ##1 @memory } } 
              }

            % 2. Mark that we found a match
            \bool_set_true:N \l__memory_match_found_bool

            % 3. Break the loop immediately
            \clist_map_break:
          }
      }

    % Execute the appropriate branch based on whether a match was found
    % True branch is #5, False branch is #6
    \bool_if:NTF \l__memory_match_found_bool
      { #5 } % Match found
      { #6 } % No match found
  }

\NewDocumentCommand{\datamatch}{ s m m r() }
  {
    % Argument mapping:
    % #1 = Star (boolean)
    % #2 = Macro to set / Name of macro (if starred)
    % #3 = Data ID (memory context)
    % #4 = List of keys (inside parens)

    \IfBooleanTF{#1}
      { 
        % Starred version: call \datamatchtf*
        \datamatchtf* { #2 } { #3 } ( #4 ) 
      }
      { 
        % Non-starred version: call \datamatchtf
        \datamatchtf  { #2 } { #3 } ( #4 ) 
      }
      % --- True Branch (Match Found) ---
      { } 
      % --- False Branch (No Match) ---
      { 
        % Note: In expl3, spaces are ignored, so we use ~ for spaces in text.
        \ClassError{novathesis}
          { Could~not~find~“#3”~defined~with~any~of~“(#4)”! }
          { }
      }
  }

\ExplSyntaxOff


\options{/novathesis/.new family,
  % DOCUMENT
  doctype/.new choice           = {phd, phdprop, phdplan, msc, mscplan, bsc, plain},
  docstatus/.new choice         = {unset, working, provisional, final}, % in not defined by user, unset will be replaced  “working”
  media/.new choice             = {screen, paper},
  spine/layout/.new choice      = {unset, trim, false},
  spine/width/.new length       = {0pt},
  % abstract/deforder/.new choice = {default={\@LANG@MAIN,en}, en={en,pt}},
  % abstract/theorder/.new list   = {unset},
  abstractorder/.new cmd        = {\appto\@nt@saveabstractorder{{#1},}},%
  % SCHOOL
  schoolgiven/.new value        = {},
  school/.new cmd               = {\optionsalso{/novathesis/schoolgiven=#1}%
                                   % \typeout{XXX=#1}\XXXX
                                   \StrCut{#1}{/}\@UNIV\@SCHL\StrCut{\@SCHL}{/}\@SCHL\@DEGREEACR
                                   % \typeout{XXX=\@UNIV/\@SCHL/\@DEGREEACR}\XXXX
                                   \IfStrEq{\@DEGREEACR}{}{\def\@DEGREEACR{\option{/novathesis/doctype}}}{}
                                   % \typeout{XXX=\@UNIV/\@SCHL/\@DEGREEACR}\XXXX
                                  },
  school                        = nova/fct,
  % STYLES
  style/chapter/.new value      = bar,
  style/font/.new value         = newpx,
  style/font/attributes/.new value = {},
  style/url/.new cmd            = {\AfterPreamble{\urlstyle{#1}}},
  color/links/.new cmd          = {\@ifpackageloaded{hyperref}%
                                            {\hypersetup{allcolors=#1}}%
                                            {\PassOptionsToPackage{allcolors=#1}{hyperref}}},
  color/glossaries/gls/.new cmd             = {\AtEndPreamble{%\textcolor{#1}{##1}
                                      \IfStrEq{#1}{None}{%
                                          \let\@glslink\glsplainhyperlink%
                                      }{%
                                          \renewcommand*{\glstextformat}[1]{\textcolor{#1}{##1}}%
                                      }%
                                   }},
  % LANGUAGES
  lang/extra/.new list          = {},
  lang/all/.new list            = {cat,cz,de,dk,en,es,fr,gr,it,nl,pl,pt,sk,uk},
  lang/main/.copy choice        = {/novathesis/lang/all},
  lang/cover/.copy choice       = {/novathesis/lang/all},
  lang/copyright/.copy choice   = {/novathesis/lang/all},
  lang/.new cmd                 = {\optionsalso{/novathesis/lang/main=#1,
                                                /novathesis/lang/cover=#1,
                                                /novathesis/lang/copyright=#1}},
  lang                          = en,
  % PRINT ON/OFF
  print/aidisclosure/.new value  = aidisclose, % use '7-aidisclose.tex' + 'aidisclose' package
  print/committee/.new toggle   = false,
  print/adviser/.new toggle     = true,    % fake option - adviser should always be printed
  print/otherlists/.new value   = frontmatter,  % print other lists (lof, lof, lol, …) in the front matter
  print/glossaries/.new value   = frontmatter,  % print glossaries in the front matter
  print/frontpage/.new toggle   = false,
  print/copyright/.new toggle   = true,
  print/timestamp/.new toggle   = true,
  print/index/.new toggle       = false,
  print/webography/.new value   = {},      % empty means do not make a separate webography
  print/statement/.new toggle   = false,
  print/sdgs/list/.new list     = {},      % {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17}
  print/sgds/type/.new choice   = {inverted=i, normal=n, mono=m},   % any measure
  print/sdgs/size/.new dim      = {2cm},   % any measure
  print/sdgs/hspace/.new dim    = {5mm},   % any measure
  print/sdgs/vspace/.new dim    = {4mm},   % any measure
  % MISC
  glossaries/list/reverse/.new toggle    = true,
  glossaries/layout/.new value  = {lX},
  tocintoc/.new toggle          = true,
  % DEBUG
  debug/.new list               = {},         % cover, index
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GENERAL PURPOSE MACROS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% The NOVAthesis logo
% --------------------------------------------------------
% 1. Define the box register
\newsavebox{\novathesisbox}

% 2. Sane the image into the box (do this once)
% We calculate the height based on the current font at the time of definition
\sbox{\novathesisbox}{%
  \includegraphics[height=1.1\fontcharht\font`A, vshift=-0.35pt]{\DIRIMAGES/novathesis-text}%
}

% 3. Define the macros to use the box
\def\novathesisimg{\usebox{\novathesisbox}}
\def\novathesistxt{\textsl{novathesis}}

% 4. Select the output method
% Use \providebox or similar if needed, but \newcommand works here
\ifdef{\iftutex}
    {\newcommand{\novathesis}{\novathesisimg}}
    {\newcommand{\novathesis}{\novathesistxt}}


% --------------------------------------------------------
% Define something (except counters) if undefined
% --------------------------------------------------------
\newcommand*{\defifundef}[2]{\ifundef{#1}{#2{#1}}{}}

% --------------------------------------------------------
% Variant of \@for with an optional final argument, that is
% executed iif the loop is not interrupted
% --------------------------------------------------------
\def\ntforbreak{\@endfortrue}
\long\def\ntfor#1:=#2\do#3{\@ifnextchar[{\ntfor@i#1:=#2\do#3}{\ntfor@i#1:=#2\do#3[]}}
\long\def\ntfor@i#1:=#2\do#3[#4]{%
  \@for#1:={#2}\do{\xdef#1{#1}#3}%
  \if@endfor\else#4\fi
}


% --------------------------------------------------------
% Automatically download necessary fonts if using lualatex
% --------------------------------------------------------
\ExplSyntaxOn

\NewDocumentCommand{\ntcheckfonts}{
    O{ttf}
    m
    m
    O{https://raw.githubusercontent.com/joaomlourenco/novathesis-extras/main/Fonts}
    O{\DIRFONTSTYLES/Fonts} }
{
  % #1 = format (ttf)
  % #2 = font name (Calibri)
  % #3 = variants (Regular,Italic,Bold,BoldItalic)
  % #4 = base URL
  % #5 = target folder

  % Check if shell escape is enabled (compatible with all engines)
  \sys_if_shell_unrestricted:TF
  {
    \nt_check_fonts:nnnnn { #1 } { #2 } { #3 } { #4 } { #5 }
  }
  {
    \msg_error:nnnn { ntfonts } { shell-escape-required } { \c_sys_jobname_str } { \ntcheckfonts }
  }
}

\msg_new:nnn { ntfonts } { shell-escape-required }
{
  Font~download~requires~shell~escape.~\\
  Please~compile~with:~
  \token_to_str:N lualatex \c_space_tl \c_sys_jobname_str \c_space_tl -shell-escape
}

\seq_new:N \l__nt_variants_seq
\tl_new:N \l__nt_filename_tl
\tl_new:N \l__nt_remote_url_tl
\tl_new:N \l__nt_local_path_tl

\cs_new_protected:Npn \nt_check_fonts:nnnnn #1 #2 #3 #4 #5
{
  % Split variants by commas
  \seq_set_split:Nnn \l__nt_variants_seq { , } { #3 }

  % Create target directory if it doesn't exist
  \file_if_exist:nF { #5/DO_NOT_REMOVE_THIS_FILE.txt }
  {
    \sys_shell:n { mkdir~-p~#5 }
  }

  % Process each variant
  \seq_map_inline:Nn \l__nt_variants_seq
  {
    \tl_set:Nn \l__nt_filename_tl { #2-##1.#1 }
    \tl_set:Nn \l__nt_remote_url_tl { #4/#2/#2-##1.#1 }
    \tl_set:Nn \l__nt_local_path_tl { #5/#2-##1.#1 }

    % Check if file already exists
    \file_if_exist:nTF { \l__nt_local_path_tl }
    {
      \iow_term:x { Font~' \l__nt_filename_tl '~already~exists. }
    }
    {
      \iow_term:x { Downloading~font~' \l__nt_filename_tl '~
                    from~' \l__nt_remote_url_tl '~
                    to~' \l__nt_local_path_tl '}

      % Download the font
      \nt_download_font:nn { \l__nt_remote_url_tl } { \l__nt_local_path_tl }
    }
  }
}


\tl_new:N \l_nt_cmd_output_tl

\cs_new_protected:Npn \nt_download_font:nn #1 #2
{
  \bool_set_false:N \l_tmpa_bool

  % Check if shell escape us unrestricted
  \sys_if_shell_unrestricted:F
    {
      \msg_error:nn { ntfonts } { shell-escape-required }
      \bool_set_true:N \l_tmpa_bool
    }

  % Truy curl
  \bool_if:NF \l_tmpa_bool
    {
      \iow_term:x { Tyying:~'curl'... }
      \sys_get_shell:nnN  { curl ~ --version ~ 2> ~ /dev/null }
                          { \tl_trim_spaces:n }
                          \l_nt_cmd_output_tl
      \tl_if_blank:nF { \tl_use:N \l_nt_cmd_output_tl }
        { % curl is available
          \iow_term:x { Running: ~ curl ~ -L ~ -s ~ -o ~ #2 ~ #1... }
          \sys_shell_now:x { curl ~ -L ~ -s ~ -o ~ #2 ~ #1 }
          \bool_set_true:N \l_tmpa_bool
        }
    }

  % try wget
  \bool_if:NF \l_tmpa_bool
    {
      \iow_term:x { Trying: ~ 'wget'... }
      \sys_get_shell:nnN  { wget ~ --version ~ 2> ~ /dev/null }
                          { \tl_trim_spaces:n }
                          \l_nt_cmd_output_tl
      \tl_if_blank:nF { \tl_use:N \l_nt_cmd_output_tl }
        { % wget is available
          \iow_term:x { Running: ~ wget ~ -q ~ -O ~ #2 ~ #1... }
          \sys_shell_now:x { wget ~ -q ~ -O ~ #2 ~ #1 }
          \bool_set_true:N \l_tmpa_bool
        }
    }

  % try python3
  \bool_if:NF \l_tmpa_bool
    {
      \iow_term:x { Trying: ~ 'python3'... }
      \sys_get_shell:nnNT  { python3 ~ --version ~ > ~ /dev/null ~ 2>&1 }
                           { \tl_trim_spaces:n }
                           \l_nt_cmd_output_tl
      \tl_if_blank:nF { \tl_use:N \l_nt_cmd_output_tl }
        { % python3 is available
          \iow_term:x { Running: ~ python3 ~ -c ~ "import ~ urllib.request; ~ urllib.request.urlretrieve('#1', ~ '#2')" ~ 2>/dev/null ~ || ~ python ~ -c ~ "import ~ urllib.request; ~ urllib.request.urlretrieve('#1', ~ '#2')" ~ 2>/dev/null"... }
          \sys_shell_now:x { python3 ~ -c ~ "import ~ urllib.request; ~ urllib.request.urlretrieve('#1', ~ '#2')" ~ 2>/dev/null ~ || ~ python ~ -c ~ "import ~ urllib.request; ~ urllib.request.urlretrieve('#1', ~ '#2')" ~ 2>/dev/null ~ || ~ echo ~ "ªython3: ~ No ~ download ~ tool ~ available" }
          \bool_set_true:N \l_tmpa_bool
        }
    }

  % try python
  \bool_if:NF \l_tmpa_bool
    {
      \iow_term:x { Trying: ~ 'python'... }
      \sys_get_shell:nnNT  { python ~ --version ~ > ~ /dev/null ~ 2>&1 }
                           { \tl_trim_spaces:n }
                           \l_nt_cmd_output_tl
      \tl_if_blank:nF { \tl_use:N \l_nt_cmd_output_tl }
        { % python is available
          \iow_term:x { Running: ~ python ~ -c ~ "import ~ urllib.request; ~ urllib.request.urlretrieve('#1', ~ '#2')" ~ 2>/dev/null ~ || ~ python ~ -c ~ "import ~ urllib.request; ~ urllib.request.urlretrieve('#1', ~ '#2')" ~ 2>/dev/null"... }
          \sys_shell_now:x { python3 ~ -c ~ "import ~ urllib.request; ~ urllib.request.urlretrieve('#1', ~ '#2')" ~ 2>/dev/null ~ || ~ python ~ -c ~ "import ~ urllib.request; ~ urllib.request.urlretrieve('#1', ~ '#2')" ~ 2>/dev/null ~ || ~ echo ~ "Python: ~ No ~ download ~ tool ~ available" }
          \bool_set_true:N \l_tmpa_bool
        }
    }

  % Try windows/Unix specific approaches
 \bool_if:NF \l_tmpa_bool
  {
    \iow_term:x { Trying ~ a ~ platform ~ specific ~ strategy }
    % Platform-specific fallbacks
    \sys_if_platform_windows:T
      {
        % Windows - try PowerShell
        \iow_term:x { Trying: ~ 'powershell' }
        \sys_get_shell:nnNT  { powershell ~ /?" }
                           { \tl_trim_spaces:n }
                           \l_nt_cmd_output_tl
      \tl_if_blank:nF { \tl_use:N \l_nt_cmd_output_tl }
          { % powershell is available
            \iow_term:x ~ { ~ powershell ~ -Command ~ "Invoke-WebRequest ~ -Uri ~ '\l__nt_remote_url_tl' ~ -OutFile ~ '#1'" ~ }
            \sys_shell_now:x ~ { ~ powershell ~ -Command ~ "Invoke-WebRequest ~ -Uri ~ '\l__nt_remote_url_tl' ~ -OutFile ~ '#1'" ~ }
            \bool_set_true:N \l_tmpa_bool
          }
      }
  }

}


% --------------------------------------------------------
% Trim spaces around argument
\cs_new_eq:NN \trimspaces \tl_trim_spaces:e


\ExplSyntaxOff




\options{/@nt/.new family,
  lang/loaded/.new list={},
  % lang/shorttolong/.new choice={en=english, pt=portuguese, fr=french, it=italian, de=german, es=spanish, gr=greek},
  fontenc/.new choice={cat=T1, cz=T1, de=T1, dk=T1, en=T1, es=T1, fr=T1, gr=LGR, %
                       it=T1, nl=T1, pl=T1, pt=T1, sk=T1, uk=T2A, zhs=T1, zht=T1},
}


\NewMemStore{LangLong}
\SetLangLong(cat):={catalan}
\SetLangLong(cz):={czech}
\SetLangLong(de):={german}
\SetLangLong(dk):={danish}
\SetLangLong(en):={english}
\SetLangLong(es):={spanish}
\SetLangLong(fr):={french}
\SetLangLong(gr):={greek}
\SetLangLong(it):={italian}
\SetLangLong(nl):={dutch}
\SetLangLong(pl):={polish}
\SetLangLong(pt):={portuguese}
\SetLangLong(sk):={slovak}
\SetLangLong(uk):={ukrainian}
\SetLangLong(zhs):={zh-Hans}
\SetLangLong(zht):={zh-Hant}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE FOLDERS PER CLASS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/folders/.new choice={
  copyright=.,
  statement=\DIRFRONTMATTER,
  cover=\DIRFRONTMATTER,
  dedication=\DIRFRONTMATTER,
  acknowledgements=\DIRFRONTMATTER,
  quote=\DIRFRONTMATTER,
  abstract=\DIRFRONTMATTER,
  glossaries=\DIRFRONTMATTER,
  cover=\DIRFRONTMATTER,
  chapter=\DIRMAINMATTER,
  appendix=\DIRBACKMATTER,
  annex=\DIRBACKMATTER,
  bib=\DIRBIBLIOGRAPHY,
}}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MANAGE DOCUMENT CLASSES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\options{/@nt/document/.cd,
   docclass/.new choice={phd=phd, phdprop=phd, phdplan=phd,
                         msc=msc, mscplan=msc,
                         bsc=bsc,
                         plain=plain},
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
  % syntax: \ntaddperson{class}(key,gender){person name, position, etc}
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
  \options{
      /@nt/#1/#2/name/.expanded/.newpush={\@nt@personname},
      /@nt/#1/#2/full/.expanded/.newpush={#4},
      /@nt/#1/#2/gender/.newpush={#3},
      /@nt/#1/#2/pair/.expanded/.newpush={#3/\@nt@personname},
  }%
  % \typeout{NTADD [/@nt/#1/#2/name=\@nt@personname]}%
  \fullexpandarg
}

\def\ntresetperson#1(#2){%
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
  %         #2=[key] (OPTIONAL)
  %         #3=filename
  \@nt@addtolist{file}{#1}%
}

\options{/@nt/listtypes/.new list={}}
\NewDocumentCommand {\@nt@addtolist}
                    {m m O{\option{/novathesis/doctype}} m} {%
  % syntax: \ntaddto{type}{class}[key]{filename}
  %         #1 ={file, person}
  %         #2=family {quote, abstract, chapter, etc} or {author, adviser, committee}
  %         #3=[file-lang | sub-family | key] (OPTIONAL)
  %         #4=filename
  % \typeout{[#1] [#2] [#3] [#4]}\ADDTOLIST
  \ifoptioncontains{/@nt/listtypes}{#2}{}
      {\options{/@nt/listtypes/.newpush={#2}}}
  \IfBeginsWithAnyOf{#4}{/,.}
      {\ifstrequal{#2}{copyright}{\OPTi}{}\xdef\@nt@filewithpath{#4}}
      {\ifstrequal{#2}{copyright}{\OPTii}{}\options{/@nt/folders=#2}%
       \xdef\@nt@filewithpath{\option{/@nt/folders}/#4}}
  \ifstrequal{#1}{statement}{
    \typeout{STATEMENT [#1] [#2] [#3]}\AAAA
  }{}
  \@for\nt@tmpi:=\expanded{#3}\do{%
    % \typeout{NT ADDTOLIST [#1] [#2] [\nt@tmpi] [\@nt@filewithpath]}\ADDTILIST%
    \options{/@nt/#1/#2/\nt@tmpi/.expanded/.newpush={\@nt@filewithpath}}%
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
  \xdef\@LSHORT{#1}%
  \xdef\@LLONG{\GetLangLong(#1)}%
  \selectlanguage{\@LLONG}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ASSOCARRAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\initmemory}[2][\thenotdefined(\@LANG@COVER)]{%
  \optionlistdo{/novathesis/lang/all}{\csuse{#2}(##1):={#1}}}


% For PDF bookmakrs
\newdata{keywordsblockpre}
\newdata{keywordsblockpost}
\newdata{keywordssep}
% \newdata{keywordsboxlen}
\newdata{keywordsstringprefix}
\newdata{keywordsstringsuffix}
\newdata{keywordsstringfont}
\keywordsblockpre()={\bigskip\noindent}
\keywordsstringsuffix()={:\enspace}
\keywordsstringfont()={\bfseries}
% \keywordssep()={\ \textbf{\Large\textperiodcentered}\ }
\keywordssep()={ {\textperiodcentered} }
% \keywordsboxlen()={\textwidth-\widthof{\usebox{\keywordsstringbox}}}

\newdata{sponsor}

\newdata{commastring}
\optionlistdo{/novathesis/lang/all}{%
  \commastring(#1):={,\ }%
}



\newdata{degreestringfont}

\newdata{degreename}
\newdata{degreenamefont}

\newdata{degreenameprefixfont}

\newdata{doctypestringfont}


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
\NewMemStore{AdviserOrder}
\SetAdviserOrder()={a,c}  % By default print advisers and co-advisers

\newdata{committeeorder}         %e.g., "{c,r,a,m,g}"

\newdata{committeetitlestringpre}
\newdata{committeetitlestringpost}
\newdata{committeetitlestringfont}

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

\newdata{dissertationstringfont}


\newdata{majorfield}
\newdata{minorfield}
\newdata{specialization}

\newdata{spine}
\newdata{thesiscover}
\newdata{margin}
\newdata{frontpageimage}

\newdata{university}
\newdata{school}
% \newdata{department}

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
  % 1. Set the search list for the /novathesis/ family.
  % This tells the package: "If you don't find the key in the current 
  % family, check these families in order."
  \options{
    /novathesis/.search also = {
      /novathesis/\@UNIV/\@SCHL/#1/,
      /novathesis/#1/,
      /novathesis/\@UNIV/\@SCHL/,
      /novathesis/\@UNIV/,
      /novathesis/
    }
  }%
  % 2. Execute the options within the /novathesis/ context.
  % We use the slash prefix to indicate we are moving to the root-level family.
  \options{/novathesis,#2}%
}


\newcommand{\SpineSetup}[2][]{%
  \NTAddToHook{print/spine/pre}{%
    #1%
    \NTSetup[spine] {#2}%
  }%
}


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
\options{/novathesis/lang = \option{/novathesis/lang/main},
         /novathesis/color/links = DarkBlue,
         /novathesis/color/glossaries/gls = None,
}

% \NTRunHook{memoir}

%============================================================
%  TEMPLATE CUSTOMIZATION / OPTIONS
%      Please open and edit the appropriate
%       configuration file “0-Config/1_novathesis.tex”
%============================================================
\input{\DIRCONFIG/1_novathesis}
\def\@DOCTYPE{\option{/novathesis/doctype}}
\def\@DOCSTATUS{\option{/novathesis/docstatus}}

\options{/@nt/document/docclass=\@DOCTYPE}
\def\@DOCCLASS{\option{/@nt/document/docclass}}

\edef\@LANG@COVER{\option{/novathesis/lang/cover}}
\edef\@LANG@COPYRIGHT{\option{/novathesis/lang/copyright}}
\edef\@LANG@MAIN{\option{/novathesis/lang/main}}
\edef\@LANG@MAIN@LONG{\GetLangLong(\@LANG@MAIN)}

\@setabstractorder
\ifdatadefined{abstractorder}(en){}{%
  \abstractorder(en):={en,pt}
}
\ifdatadefined{abstractorder}(\@LANG@MAIN){}{%
  \abstractorder(\@LANG@MAIN):={\@LANG@MAIN,en}
}




%============================================================
% LOAD ADDITIONAL PACKAGES
%============================================================
%%%%% Configure multilingual language support
\definecolor{darkblue}{rgb}{0.0,0.08,0.45}%

%
% \iftoggle{/novathesis/print/index}{
%   \AtEndPreamble{
%     \ntaddtoprintorder{backmatter}{index}
%     \RequirePackage{imakeidx}
%     % \makeindex[intoc,columns=2,options=-s myindexstyle]%
%     \makeindex[intoc,columns=2,options=-s  \DIRNTFILES/ntindexstyle]
%   }
% }{}

\babeladjust{
  autoload.bcp47 = on
}

\babelprovide[main,import]{\expanded{\@LANG@MAIN@LONG}}

% --------------------------------------------------------
% FIX BABEL TRANSLATION
% \RequirePackage{babel}      % Support for multilingual documents
% \RequirePackage{translator} % Support month name translations for pgfcalendar
\ntselectlang{\@LANG@MAIN}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Create list of loaded languages
%% which will be loaded dynamically by Babel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\edef\@LANG@LOADED{\@LANG@COVER, \@LANG@COPYRIGHT, \@LANG@MAIN, \theabstractorder(\@LANG@MAIN)}
\UniquifyList{\@LANG@LOADED}[\@LANG@LOADED]

% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIX BABEL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\input{fix-babel.tex}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Include strings for all the languages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifoptiondefined{/@nt/lang/loaded}
  {\options{/@nt/lang/loaded = {}}}
  {\options{/@nt/lang/loaded/.new list}}%

\@for\mylang:=\@LANG@LOADED\do{%
  \InputIfFileExists{\DIRSTRINGS/strings-\mylang.ldf}%
      {\options{/@nt/lang/loaded/.expanded/.push={\mylang}}}%
      {\ClassError{novathesis}
                  {File not found: “\DIRSTRINGS/strings-\mylang.ldf” file!}%
                  {Add a file with the translations for this language.}}%
}%


\bkmstring(1-1)   = {\thebkmstring(cover,\@LANG@MAIN)}
\bkmstring(1-2)   = {\thebkmstring(incover,\@LANG@MAIN)}
\bkmstring(2-1)   = {\thebkmstring(frontpage,\@LANG@MAIN)}
\bkmstring(2-2)   = {\thebkmstring(infrontpage,\@LANG@MAIN)}
\bkmstring(N-1)   = {\thebkmstring(inbackcover,\@LANG@MAIN)}
\bkmstring(N-2)   = {\thebkmstring(backcover,\@LANG@MAIN)}
\bkmstring(spine) = {\thebkmstring(spine,\@LANG@MAIN)}



%--------------------------------
% TIKZ
\usetikzlibrary{calc}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DEFINITIONS FOR THE REMINDER OF CUSTOMIZATION STUFF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --------------------------------------------------------
% Department
%============================================================
\ExplSyntaxOn

\NewMemStore{Department}

% 1. The Public Command
% s = star (*)                 <= only define if undefined
% r() = required ID in parens  <= the lang code
% m = mandatory value          <= the name of the department
\NewDocumentCommand {\ntdepartment} { s r() m }
  {
    % We pass the star status (boolean) and expanded arguments to the internal logic
    \nova_process_department:nee { #1 } { #2 } { #3 }
  }

% 2. Internal Logic
\cs_new_protected:Npn \nova_process_department:nnn #1 #2 #3
  {
    % Handle the optional ID: if empty/NoValue, use 'default'
    \tl_set:Nn \l_tmpa_tl { #2 }
    % \quark_if_no_value:NT \l_tmpa_tl { \tl_set:Nn \l_tmpa_tl { default } }

    % Logic Branching
    \bool_if:nTF { #1 }
      {
        % Starred version: Only set if NOT already defined
        % We check if the 'department' data for this ID is empty/unset
        \__mem_if_unset:nnT { Department } { \l_tmpa_tl }
          { \MemSet { Department } { \l_tmpa_tl } { #3 } }
      }
      {
        % Unstarred version: Set/Overwrite regardless
        \MemSet { Department } { \l_tmpa_tl } { #3 }
      }
  }

% 3. Helper to check if data is undefined/empty
% (Adjust this if your \MemSet uses a different internal storage check)
% \prg_new_conditional:Npnn \nova_if_data_unset:nn #1 #2 { p, T, F, TF }
%   {
%     % We expand the result of \MemGet to check if it's empty
%     \tl_if_empty:eTF { \MemGet{#1}{#2} }
%       { \prg_return_true:  }
%       { \prg_return_false: }
%   }

% 4. Generate expansion variants
\cs_generate_variant:Nn \nova_process_department:nnn { nee }

\ExplSyntaxOff



%
%
%
% \def\ntdepartment{\@ifstar{\@ntdepartmentifundef}{\@ntdepartment}}
% \def\@ntdepartmentifundef(#1)#2{\ifdatadefined{department}(#1){}{\@ntdepartment(#1){#2}}}
% \def\@ntdepartment(#1)#2{\department(#1):={#2}}

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
\def\ntsponsors(#1,#2,#3)#4{\sponsor(#3,#1,#2):={#2}}

% --------------------------------------------------------
% Title
\def\nttitle(#1,#2)#3{%
  % #1 = type (main, sub, spine) title
  % #2 = lang
  % #3 = value
  % \typeout{NT TITLE [#1] [#2] [#3]}%
  \doctitle(#2,#1):={#3}%
  \NewlineToSpace{#3}[\tmp]%
  \doctitle(#2,#1,plain):={\tmp}% 
  \IfStrEq{#1}{main}{\doctitle(#2,spine):={\tmp}}{}%
}

\ExplSyntaxOn

% Define a temporary token list variable
\tl_new:N \l__memory_clean_tl

\NewDocumentCommand{\NewlineToSpace}{ m o }
  {
    % 1. Store the input (#1) into the variable
    \tl_set:Nn \l__memory_clean_tl { #1 }

    % 2. Perform the replacement.
    %    In expl3, ~ represents a space token (catcode 10).
    %    This replaces every occurrence of the token \\ with a space.
    \tl_replace_all:Nnn \l__memory_clean_tl { ~\\~ } { ~ }
    \tl_replace_all:Nnn \l__memory_clean_tl { ~\\ }  { ~ }
    \tl_replace_all:Nnn \l__memory_clean_tl { \\~ }  { ~ }
    \tl_replace_all:Nnn \l__memory_clean_tl { \\ }   { ~ }

    % 3. Check if the optional argument (#2) is provided
    \IfNoValueTF { #2 }
      {
        % If no optional arg: Output the result directly
        \tl_use:N \l__memory_clean_tl
      }
      {
        % If optional arg exists: Set the provided macro (#2) to the result
        \tl_set_eq:NN #2 \l__memory_clean_tl
      }
  }


% \PrintDateISO{2022-12-25} -> localized date, e.g., December 20, 2022; 20 de dezembro de 2022
% \PrintDateISO{2022-12}    -> e.g., December 20, 2022; Dezembro, 2022
% \PrintDateISO{2022}       -> e.g., 2022
\NewDocumentCommand{\PrintDateISO}{m}
 {
  \nt_print_iso_date:n {#1}
 }

% Sequential variables to store Y, M, D
\seq_new:N \l_nt_date_seq
% Generate the 'NnV' variant (N = seq, n = delimiter, V = value of variable)
\cs_generate_variant:Nn \seq_set_split:Nnn { Nne }

\cs_new_protected:Nn \nt_print_iso_date:n
 {
  % Split the input string by the hyphen (-)
  \seq_set_split:Nne \l_nt_date_seq { - } {#1}
  
  \int_case:nn { \seq_count:N \l_nt_date_seq }
   {
    % Case 1: Only Year (YYYY)
    { 1 } { \seq_item:Nn \l_nt_date_seq { 1 } }
    
    % Case 2: Year and Month (YYYY-MM)
    { 2 } { 
      \MakeTitlecase { \babelmonthname { \seq_item:Nn \l_nt_date_seq { 2 } } }
      ,~  % separator
      \seq_item:Nn \l_nt_date_seq { 1 }  % year
    }
    
    % Case 3: Full Date (YYYY-MM-DD)
    { 3 } { 
        \localedate { \seq_item:Nn \l_nt_date_seq { 1 } } 
                    { \seq_item:Nn \l_nt_date_seq { 2 } } 
                    { \seq_item:Nn \l_nt_date_seq { 3 } } 
    }
   }
 }





% Define the command with an optional d() argument and a mandatory m argument
\NewDocumentCommand{\SetDateISO}{ d() m }
 {
  \nt_set_iso_date:nn { #1 } { #2 }
 }

% Sequential variable to store the split parts
\seq_new:N \l_nt_parts_seq

\cs_new_protected:Nn \nt_set_iso_date:nn
 {
  % 1. Store the raw ISO string
  \MemSet { DocDate } { #1 } { #2 }
  
  % 2. Split the string by the hyphen
  \seq_set_split:Nnn \l_nt_parts_seq { - } { #2 }
  
  % 3. Process based on how many parts were found
  \int_case:nn { \seq_count:N \l_nt_parts_seq }
   {
    % Case: YYYY
    { 1 } 
     {
      \MemSet { DocDate } { #1, year } { \seq_item:Nn \l_nt_parts_seq { 1 } }
     }
    
    % Case: YYYY-MM
    { 2 }
     {
      \MemSet { DocDate } { #1, year }  { \seq_item:Nn \l_nt_parts_seq { 1 } }
      \MemSet { DocDate } { #1, month } { \seq_item:Nn \l_nt_parts_seq { 2 } }
      % Use Babel's \monthname to get the localized text
      \MemSet { DocDate } { #1, month, text } 
        { \monthname [ \seq_item:Nn \l_nt_parts_seq { 2 } ] }
     }
    
    % Case: YYYY-MM-DD
    { 3 }
     {
      \MemSet { DocDate } { #1, year }  { \seq_item:Nn \l_nt_parts_seq { 1 } }
      \MemSet { DocDate } { #1, month } { \seq_item:Nn \l_nt_parts_seq { 2 } }
      \MemSet { DocDate } { #1, month, text } 
        { \monthname [ \seq_item:Nn \l_nt_parts_seq { 2 } ] }
      \MemSet { DocDate } { #1, day }   { \seq_item:Nn \l_nt_parts_seq { 3 } }
     }
   }
 }


\ExplSyntaxOff



\NewMemStore{DocDate}

\let\ntdate\SetDateISO
\SetDateISO(submission){2000-01-31}
\SetDateISO(exam){2000-01-31}



%============================================================
% Author identification
%============================================================
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
% Setting cover defaults
%============================================================


% strings to be defined for each language
\nttitle(main,\@LANG@COVER){\thedefaultnttitle(\@LANG@COVER)}
\nttitle(sub,\@LANG@COVER){\thedefaultntsubtitle(\@LANG@COVER)}
\ntdepartment(\@LANG@COVER){\thedefaultntdepartment(\@LANG@COVER)}
\ntdegreename(\@LANG@COVER){\thedefaultntdegreename(\@LANG@COVER)}


%============================================================
% Adding list_of
\newcommand*{\ntaddlistof}[2][]{%
  % #1 = frontmatter, backmatter
  % #2 = the list of SOMETHING without the initial "\"
  \@ifmtarg{#1}{%
    \edef\@listofat{\option{/novathesis/print/otherlists}}%
  }{%
    \edef\@listofat{#1}%
  }
  % \typeout{\ISTOF 1=[\@listofat] 2=[#2]}\NTADDLISTOF%
  \IfStrEqCase{#2}{%
    {tableofcontents}{\options{/@nt/listof/\@listofat/.newpush={%
            \iftoggle{/novathesis/tocintoc}{\tableofcontents}%
                  {\hypertarget{toctarget}{\tableofcontents*}%
                   \bookmark[dest=toctarget]{\contentsname}}%
    }}}%
    {listoffigures*}{\options{/@nt/listof/\@listofat/.newpush={%
            \hypertarget{loftarget}{\listoffigures*}%
            \bookmark[dest=loftarget]{\listfigurename}%
    }}}%
    {listoffigures}{\options{/@nt/listof/\@listofat/.newpush={%
            \hypertarget{loftarget}{\listoffigures}%
            % \bookmark[dest=loftarget,level=1]{\listfigurename}%
    }}}%
    {listoftables*}{\options{/@nt/listof/\@listofat/.newpush={%
            \hypertarget{lottarget}{\listoftables*}%
            \bookmark[dest=lottarget]{\listtablename}%
    }}}%
    {listoftables}{\options{/@nt/listof/\@listofat/.newpush={%
            \hypertarget{lottarget}{\listoftables}%
            % \bookmark[dest=lottarget]{\listtablename}%
    }}}%
    {listoflistings}{\options{/@nt/listof/\@listofat/.newpush={%
            \hypertarget{loltarget}{\listoflistings}%
            \bookmark[dest=loltarget]{\listoflistingscaption}%
    }}}%
    {lstlistoflistings}{\options{/@nt/listof/\@listofat/.newpush={%
            \hypertarget{loltarget}{\lstlistoflistings}%
            % \bookmark[dest=loltarget]{\lstlistlistingname}%
    }}}%
    {listofalgorithms}{\options{/@nt/listof/\@listofat/.newpush = {%
            \listofalgorithms
            \ifdefined\listalgorithmname%
              \addcontentsline{toc}{chapter}{\listalgorithmname}%
            \else\ifdefined\listalgorithmcfname%
              \addcontentsline{toc}{chapter}{\listalgorithmcfname}%
            \else
              \ClassError{novathesis}{Can't make list of algorithms. Please report this problem in the “novathesis” github. Thanks!}{}%
            \fi\fi}}}%
  }[%
      \options{/@nt/listof/\@listofat/.newpush={\ifdefmacro{#2}{#2}{\csuse{#2}}}}%
   ]%
}

%============================================================
% Print document “parts/sections/regions”
\newcommand*{\ntprint}[1]{%
  \IfStrEqCase{#1}{%
    {frontcover}{%
          \thispagestyle{empty}%
          \pagestyle{empty}%
          \ntprintcovers%
    }%
    {frontmatter}{%
          \bookmarksetup{startatroot}
          \ntthesisfrontmatter% Before the main text (TOC, etc) — Roman page numbering
          \bookmarksetupnext{level=0}%
          \hypertarget{bmfrontmatter}{}%
          \bookmark[dest=bmfrontmatter]{\thebkmstring(frontmatter,\@LANG@MAIN)}%
          \bookmarksetupnext{rellevel=1}%
          \ntprintlist{/@nt/print/#1/\@DOCSTATUS}%
    }%
    {mainmatter}{%
          \bookmarksetup{startatroot}
          \ntthesismainmatter% Mainn text — Arabic page numbering
          \bookmarksetup{level=0}%
          \thispagestyle{novathesis@mainmatter}%
          \pagestyle{novathesis@mainmatter}%
          \ntprintlist{/@nt/print/#1}%
    }%
    {backmatter}{%
          \bookmarksetup{startatroot}
          \ntthesisbackmatter     % The back text — Arabic page numbering
          \bookmarksetupnext{level=-1}%
          \hypertarget{bmbackmatter}{}%
          \bookmark[dest=bmbackmatter]{\thebkmstring(backmatter,\@LANG@MAIN)}%
          \bookmarksetupnext{level=0}%
          \ntprintlist{/@nt/print/#1}%
    }%
    {backcover}{%
          \bookmarksetup{startatroot}
          \bookmarksetup{level=0}%
          \thispagestyle{empty}%
          \pagestyle{empty}%
          \ntprintbackcover%
    }%
  }[\ifdefmacro{#1}{#1}{\csuse{ntprint#1}}]%
}

\newcommand*{\ntprintlist}[1]{%
  \optionlistdo{#1}{%
    \begingroup
      \clearpage
      \ifdefmacro{##1}
        {##1}% ##1 is defined
        {%     ##1 is undefined
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
      % \unskip%
      \clearforchapter%
      \ignorespaces%
    \endgroup
  }%
}

\newcommand{\myprintglossaries}{%
  % ignore if no glossaries were defined
  \ifoptioncontains{/@nt/listtypes}{glossaries}{
    \ifoptionequal{/novathesis/print/glossaries}{false}
      {}{%
        \if@backmatter
          \def\@matter{backmatter}
        \else
          \def\@matter{frontmatter}
        \fi
        \IfStrEq{\option{/novathesis/print/glossaries}}{\@matter}{%
          \clearforchapter%
          \ntselectlang{\@LANG@MAIN}%
          \hypertarget{bmglossaries}{}%
          \bookmarksetupnext{level=0}%
          \bookmark[dest=bmglossaries]
                  {\thebkmstring(glossaries,\@LANG@MAIN)}%
          \printglossaries
        }{}%
      }%
  }{}%
}

% --------------------------------------------------------
% DEFAULT VALUES FOR frontmatter AND mainmatter

% \newcommand*{\ntaddtoprintorder}[2]{%
%   % #1 = frontmatter, mainmatter
%   % #2 = list
%   % \typeout{[#1] [#2]}
%   \options{/@nt/print/#1/.push=#2}%
% }
\options{/@nt/print/frontmatter/final/.new list = 
  {%
    statement,        % The statement page
    copyright,        % (*) The copyright page
    dedication,       % (*) Print the dedication
    acknowledgements, % (*) Print the acknowledgments
    quote,            % (*) Print the quote
    abstracts,        % Print abstracts in multiple languages.
    aidisclose,       % AI disclosure statement
    alllistof,        % Print all the listof defined in “6_list_of.tex”
    myprintglossaries, % Print the Glossary, Acronyms, Symbols, etc…
  }
}

\options{/@nt/print/frontmatter/provisional/.new list = 
  {
    statement,         % The statement page
    copyright,         % (*) The copyright page
    dedication,        % (*) Print the dedication
    acknowledgements,  % (*) Print the acknowledgments
    quote,             % (*) Print the quote
    abstracts,         % Print abstracts in multiple languages.
    aidisclose,        % AI disclosure statement
    alllistof,         % Print all the listof defined in “6_list_of.tex”
    myprintglossaries, % Print the Glossary, Acronyms, Symbols, etc…
  }
}

\options{/@nt/print/frontmatter/working/.new list = 
  {
    abstracts,       % Print abstracts in multiple languages.
    aidisclose,      % AI disclosure statement
    alllistof,       % Print all the listof defined in “6_list_of.tex”
    myprintglossaries, % Print the Glossary, Acronyms, Symbols, etc…
  }
}

\options{/@nt/print/mainmatter/.new list = 
  {
    chapters,        % Print document chapters
  }
}%

\ifoptionequal{/novathesis/print/webography}{}{%
  \options{/@nt/print/backmatter/.new list = 
    {
      bibsingle,            % Print the bibliography
      alllistof,            % Print all the listof defined in “6_list_of.tex”
      myprintglossaries,    % Print the Glossary, Acronyms, Symbols, etc…
      appendices,           % Print appendices, if any!
      annexes,              % Print annexes, if any!
    }
  }%
}{%
  \options{/@nt/print/backmatter/.new list = 
    {
      bibseparate,          % Print the web references separate from the remainder of the bibliography
      alllistof,            % Print all the listof defined in “6_list_of.tex”
      myprintglossaries,    % Print the Glossary, Acronyms, Symbols, etc…
      appendices,           % Print appendices, if any!
      annexes,              % Print annexes, if any!
    }
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
  % \typeout{Command=[#1]  Options=[#2]  Position=[#3]  Rest of command=[#4]  CIDLIST=[#5]  Code=[]}\NTADDTOCOVERTIKZ
  \ntfor\cvids:={#5}\do{\ntAddToOneCoverTikz{#1}{#2}{#3}{#4}{\cvids}{#6}}%
}

\NewDocumentCommand{\ntAddToOneCoverTikz}{mmmmmm}{%
  % #1=Command
  % #2=Options
  % #3=Position
  % #4=Rest of command
  % #5=CID
  % #6=Code
  % \typeout{Command=[#1]  Options=[#2]  Position=[#3]  Rest of command=[#4]  CIDLIST=[#5]  Code=[]}\NTADDTOONECOVERTIKZ
  \options{/@nt/coverTikz/\@UNIV/\@SCHL/#5/.newpush=
                {{#1}\@nil{#2}\@nil{#3}\@nil{#4}\@nil{#6}}}%
}

\NewDocumentCommand{\printCoverTikz}{m}{%
  % #1 = cover ID (major-minor)
  % \typeout{@NTCOVERTEXT 1=[#1]}\@NTCOVERTEXT%
  \ifoptiondefined{/@nt/coverTikz/\@UNIV/\@SCHL/#1}{%
    \NTRunHook{coverTikz/#1/text/pre}%
    \begin{tikzpicture}[remember picture, overlay, yscale=-1, every node/.style={inner sep=0pt}]%
      \optionlistdo{/@nt/coverTikz/\@UNIV/\@SCHL/#1}{%
        \printCoverElementTikz#1\@nil##1\@nil\@nil%
      }%
    \end{tikzpicture}%
    \NTRunHook{coverTikz/#1/text/post}%
  }{}%
}

\def\printCoverElementTikz#1\@nil#2\@nil#3\@nil#4\@nil#5\@nil#6\@nil{%
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
%% Update Schoold's images folder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ntfor\match:={\@UNIV,\@UNIV/\@SCHL}\do{%
    \IfFileExists{\DIRSCHOOLS/\match/Images/DO_NOT_REMOVE_THIS_FILE.txt}{%
            \prependtographicspath{{\DIRSCHOOLS/\match/Images/},}}{}%
}


%============================================================
%  UNIVERSITY/SCHOOL SPECIFIC MATERIALS
%  configuration file “0-Config/9_<university>_<school>.tex”
%============================================================
\InputIfFileExists{\DIRSCHOOLS/\@UNIV/\@UNIV-defaults.ldf}
    {}
    {\PackageError{novathesis}
                  {Missing file “\DIRSCHOOLS/\@UNIV/\@UNIV-defaults.ldf”}{}}

\ntfor\match:={%
      \@UNIV-\@SCHL-\@DEGREEACR,%
      \@UNIV-\@SCHL%
  }\do{%
      \IfFileExists{\DIRSCHOOLS/\@UNIV/\@SCHL/\match-defaults.ldf}
          {\input{\DIRSCHOOLS/\@UNIV/\@SCHL/\match-defaults.ldf}\ntforbreak}
          {}%
  }
[\PackageError{novathesis}
              {Missing file “\DIRSCHOOLS/\@UNIV/\@SCHL/\@UNIV-\@SCHL-defaults.ldf”}
              {}]

\ValidateLtxProcessor{\@UNIV}{\@SCHL}{\@DEGREEACR}

\IfFileExists{\DIRCONFIG/9_\@UNIV_\@SCHL.tex}
     {\def\@ntsetuplevel{\@UNIV/\@SCHL/}\input{\DIRCONFIG/9_\@UNIV_\@SCHL.tex}}
     {\def\@ntsetuplevel{\@UNIV/}\InputIfFileExists{\DIRCONFIG/9_\@UNIV.tex}{}{}}
\def\@ntsetuplevel{}

% Now we can load biblatx
\NTRunHook{/afterloading/schoolconfig}


% Prefer: DOI, else eprint, else URL
\renewbibmacro*{doi+eprint+url}{%
  \iffieldundef{doi}
    {%
      \iffieldundef{eprint}
        {\usebibmacro{url+urldate}}% no doi/eprint → URL (with date if available)
        {\usebibmacro{eprint}}% no doi, but eprint → eprint
    }%
    {\printfield{doi}}% doi present → DOI
}



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

\ifoptionequal{/novathesis/media}{paper}{
  \ntsetup{color/links=Black}
  \openright
}{
  \openany
}


% --------------------------------------------------------
% If option “debug={index}” option is active,
%     highlight index keywords in the main text
\providecommand*{\debugindexcolor}{red!50}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOADING CUSTOMIZATION STUFF - part 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%============================================================
%  THESIS/DISSERTATION COVER DATA (title, author, etc)
%   Please open and edit the appropriate
%       configuration file “0-Config/3_cover.tex”
%============================================================
\input{\DIRCONFIG/3_cover}
% \NTRunHook{cover}

\ntselectlang{\@LANG@COVER}%

%============================================================
%  THESIS/DISSERTATION FILES
%   Please open and edit the appropriate
%       configuration file “0-Config/4_files.tex”
%============================================================
\input{\DIRCONFIG/4_files}
\ntaddfile{bib}{\DIRSTYFILES/fix-bib.bib}
% \NTRunHook{files}

%============================================================
% ADDITIONAL PACKAGES and MACROS
%      Please open and edit the appropriate
%       configuration file “0-Config/8_packages.tex”
%============================================================
% \NTRunHook{packages/pre}
\AtEndPreamble{\input{\DIRCONFIG/5_packages}}
% \NTRunHook{packages/post}

%============================================================
%  WHICH LIST_OF TO PRINT
%   Please open and edit the appropriate
%       configuration file “0-Config/6_list_of.tex”
%============================================================
\AtEndPreamble{
% is only loaded after school's configuration
% can be changhed with "\ntsetup{print/other}"
  \makeatletter
  \NTRunHook{list_of/pre}
  \input{\DIRCONFIG/6_list_of}
  \NTRunHook{list_of/post}
}


%============================================================
% Deal with AI disclose declaration
%============================================================
\AtEndPreamble{
  \ifoptionequal{/novathesis/print/aidisclosure}{aidisclose}{
    \input{\DIRCONFIG/7-aidisclose}
  }{\gdef\aidversion{0.0.0}}
}


%============================================================
\setcounter{biburlnumpenalty}{100}% Allow to break DOIs in bibliography
\optionlistdo{/@nt/file/bib/\@DOCTYPE}{%
  % \typeout{ADDBIB=#1}\ADDBIB
  \addbibresource{#1}%
}%

\ifdocunset{\ntsetup{docstatus=working}}{}

\ifoptionequal{/novathesis/spine/layout}{unset}
    {\ifdocworking{\ntsetup{spine/layout=false}}
                  {\ifmaindoc{\ntsetup{spine/layout=trim}}
                             {\ntsetup{spine/layout=false}}}}
    {}
\ifdocfinal{\ntsetup{print/committee=true}}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@nt@loadallfiles}[2]{%
  \optionlistdo{/@nt/file/#2/#1}{\@ntloadfile@i{##1}}}

\newcommand{\@ntloadfile@i}[2][]{%
  \IfFileExists{#2}{\input{#2}}{#1}}

\newcommand{\PrintAddedFile}[2][\@DOCTYPE]{%
  % #1=KEY
  % #2=file class
  \iffileadded[#1]{#2}
      {\@nt@loadallfiles{#1}{#2}}
      {}%
}

\newcommand{\iffileadded}[2][\@DOCTYPE]{%
  \ifoptiondefined{/@nt/file/#2/#1}}

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


\ifoptionequal{/novathesis/spine/layout}{off}{}{% print the spine
  \InputIfFileExistsInDirsTF {novathesis-spine.sty}
    {%
      {\DIRSCHOOLS/\@UNIV/\@SCHL/},
      {\DIRSCHOOLS/\@UNIV/},
      {\DIRSTYFILES/},
    }
    {%
      \ifmaindoc{\AtEndDocument{\csuse{ntprintspine}}}{}%
    }
    {\ClassError{novathesis}{No “novathesis-spine” file found.}{}}%
}



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
  \NTRunHook{print/spine/pre}%
  \iffileadded[spine]{cover}{%
    \optionlistdo{/@nt/file/cover/spine}{%
      \bgroup\thispagestyle{empty}%
      \@ntloadfile@i[\ClassError{novathesis}{Invalid cover file: “##1”}{}]{##1}%
      \egroup\clearforchapter%
    }%
  }{\PrintBookSpine\clearforchapter}%
  \NTRunHook{print/spine/post}%
}

\newcommand{\ntprintbackcover}{%
  \clearforchapter%
  \pagenumbering{roman}%
  \setcounter{page}{0}
  \ntprintcoverpair{N}%
}

\newcommand{\ntprintcovers}[1][1,2]{%
  \begingroup%
    \ntselectlang{\@LANG@COVER}%
    \NTRunHook{printcovers/pre}%
    \ntfor\arg:={#1}\do{\ntprintcoverpair{\arg}}%
    \NTRunHook{printcovers/post}%
  \endgroup%
  \pagecolor{white}%
}

\newcommand{\ntprintcoverpair}[1]{%
  % #1 = major cover ID
  \iffileadded[1]{cover}{% Deal with user-defined cover page
    \iffileadded[#1]{cover}{%
      \optionlistdo{/@nt/file/cover/#1}{%
        \begingroup
        \thispagestyle{empty}%
        \NTRunHook{cover/pre}%
        \NTRunHook{cover/#1-1/pre}%
        \hypertarget{\thebkmstring(#1-1)}{}%
        \bookmark[dest=\thebkmstring(#1-1)]{\thebkmstring(#1-1)}%
        \bookmarksetupnext{rellevel=1}%
        \@ntloadfile@i[\ClassError{novathesis}{Invalid cover file: “##1”}{}]{##1}%
        \NTRunHook{cover/#1-1/post}%
        \NTRunHook{cover/post}%
        \endgroup
        \clearpage%
      }%
    }{}%
  }{% Pre-defined cover page  
    \IfStrEqCase{#1}{%
      {1}{\ntprintcoversingle{1}{1}\ntprintcoversingle{1}{2}}%
      {2}{\iftoggle{/novathesis/print/frontpage}
                   {\ntprintcoversingle{2}{1}\ntprintcoversingle{2}{2}}{}}%
      {N}{\ntprintcoversingle{N}{1}\ntprintcoversingle{N}{2}}%
    }[\ClassWarning{Invalid cover number: #1}{}]%
  }%
}

\gdef\@COVERNUM{}%
\newcommand{\ifcovernum}[2]{\IfStrEq{\@COVERNUM}{#1}{#2}}

\newcommand{\ntprintcoversingle}[2]{%
  % #1 = cover ID “major”
  % #2 = cover ID “minor”
  \ifcoverdefined[#1-#2]{%
    \gdef\@COVERNUM{#1-#2}%
    \setcounter{page}{0}\@ntprintcover@i{#1}{#2}
    \ifoptionequal{/novathesis/media}{paper}{
      \ifcoverdefined[#1-2]
        {\clearpage}
        {\clearforchapter}%
    }{%
      \clearpage%
    }
  }{}%
}

\newcommand{\@ntprintcover@i}[2]{%
  % #1 = cover ID “major”
  % #2 = cover ID “minor”
  \begingroup%
    \NTRunHook{cover/pre}%
    \NTRunHook{cover/#1-#2/pre}%
    \hypertarget{\thebkmstring(#1-#2)}{}%
    \bookmark[dest=\thebkmstring(#1-#2)]{\thebkmstring(#1-#2)}%
    \bookmarksetupnext{rellevel=1}%
    \thispagestyle{empty}%
    \setCoverBgColor{#1-#2}%
    \setCoverBgImage{#1-#2}%
    \prrintCoverText{#1-#2}%
    % \@ntmakeboxwithcover{#1-#2}{\@fullcover@box}%
    \printCoverTikz{#1-#2}%
    \NTRunHook{cover/#1-#2/post}%
    \NTRunHook{cover/post}%
  \endgroup%
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
  \@for\nt@tmpi:={top,bottom,left,right}\do{%
    \datamatch*{@MRGN@\nt@tmpi}{margin}(%
      {cover,\@DOCTYPE,\@DEGREEACR,#1,\nt@tmpi},%
      {cover,\@DOCCLASS,\@DEGREEACR,#1,\nt@tmpi},%
      {cover,\@DEGREEACR,#1,\nt@tmpi},%
      {cover,\@DOCTYPE,\@DEGREEACR,\nt@tmpi},%
      {cover,\@DOCCLASS,\@DEGREEACR,\nt@tmpi},%
      {cover,\@DEGREEACR,\nt@tmpi},%
      {cover,\@DOCTYPE,#1,\nt@tmpi},%
      {cover,\@DOCCLASS,#1,\nt@tmpi},%
      {cover,#1,\nt@tmpi},%
      {cover,\@DOCTYPE,\nt@tmpi},%
      {cover,\@DOCCLASS,\nt@tmpi},%
      {cover,\nt@tmpi})%
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

\newif\ifmatchstatus%
\newif\ifmatchdegree%
\def\@ntcoverelement@iii#1#2\@nil#3{%
  % #1 = cover ID (major-minor)
  % #2 = cover element options
  % #3 = cover element code
  \ifblank{#3}{}{%
    \options{/@ntcoveropts, defaults, #2, alignmap=\option{/@ntcoveropts/halign}}%
    % \typeout{@ntcoverelement@iii 1=[#1] 2=[#2] tikz=\option{/@ntcoveropts/tikz}}\@NTCOVERELEMENT@III
    \matchstatustrue%
    \matchdegreetrue%
    \if&\option{/@ntcoveropts/status}&\relax%
    \else%
      \IfSubStr{,\option{/@ntcoveropts/status},}{,\@DOCSTATUS,}
        {}
        {\matchstatusfalse}%
    \fi%
    \if&\option{/@ntcoveropts/degree}&\relax%
    \else%
      \IfSubStr{/\option{/@ntcoveropts/degree}/}{/\@DOCTYPE/}
        {}
        {\matchdegreefalse}%
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

\newcommand{\todayiso}{%
  \the\year-%
  \ifnum\month<10 0\fi\the\month-%
  \ifnum\day<10 0\fi\the\day%
}
\newcommand{\@ntfixspacing}[2]{%
    \bgroup%
    \newdata{ntfixspacingstring}%
    \noindent
    \ntfixspacingstring()={The \href{https://github.com/joaomlourenco/novathesis}{NOVAthesis} template (v\novathesisversion)~\@ntcite{novathesis-manual} @ \todayiso. (12cc90221730b8ba41bb3b1f8b517acd)}%md5
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
        \iffileadded[\@LSHORT]{statement}
          {\PrintAddedFile[\@LSHORT]{statement}}
          {\PrintAddedFile{statement}}%
        \NTRunHook{statement/post}%
      }{}%
    }{}%
  }%
}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Print persons list {advisers | committee}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcolumntype{L}{>{\raggedright\let\newline\\\arraybackslash\hspace{0pt}}X}
\newcolumntype{C}{>{\centering\let\newline\\\arraybackslash\hspace{0pt}}X}
\newcolumntype{R}{>{\raggedleft\let\newline\\\arraybackslash\hspace{0pt}}X}


\newcommand{\@check@instring}[4][,]{
% 1 = separator
% 2 = value
% 3 = list
% 4 = error
  \IfSubStr{#1#3#1}{#1#2#1}{}{\ClassError{novathesis}{#4: String “#1#2#1” not in “#1#3#1”}{}}%
}

\newcommand{\ntprintpersons}[2][full]{%
  % #1* = { full | name | list }
  % #2  = width in % of textwidth
  % #3* = positioning
  % #4  = number of columns
  % #5  = adviser | committee
  % #6  = {a,c} | {c,r,a,m,g}
  \@ifnextchar[{\@ntprintpersons{#1}{#2}}{\@ntprintpersons{#1}{#2}[l]}%
}

\newcommand*{\@setalignment}[1]{
  \IfStrEqCase{#1}{%
    {r}{\raggedleft}%
    {c}{\centering}%
    {l}{\raggedright}%
  }[\ClassError{novathesis}{Invalid alignment “#1”}{}]%
}

\def\@ntprintpersons#1#2[#3]#4#5#6{
  % #1 = { full | name | list }
  % #2 = width in % of textwidth
  % #3 = positioning
  % #4 = number of columns
  % #5 = adviser | committee
  % #6 = {a,c} | {c,r,a,m,g}
  % \typeout{NTPRINTPERSONS 1=[#1] 2=[#2] 3=[#3] 4=[#4] 5=[#5] 6=[#6]}\NTPRINTPERSONS
  \@check@instring{#1}{full,name,list}{@ntprintpersons}%
  \def\nt@tabularx@horz{}%
    \IfStrEq{#3}{c}{\def\nt@tabularx@horz{\centering\arraybackslash}}{}%
    \IfStrEq{#3}{r}{\def\nt@tabularx@horz{\raggedleft\arraybackslash}}{}%
    \IfStrEq{#3}{l}{\def\nt@tabularx@horz{\raggedright\arraybackslash}}{}%
  \iftoggle{/novathesis/print/#5}{%
    \begin{minipage}[t]{\linewidth}%
      \setlength{\parindent}{0pt}%
      \@setalignment{#3}%
      \begin{varwidth}{#2\linewidth}%
        \IfStrEqCase{#4}{%
          {0}{\GetPersonsAsList{#5}{#6}}%
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
\ExplSyntaxOn

% Define variables to hold the lists
\clist_new:N \l_nt_master_clist

% 1. Create variants to handle expansion correctly
% This ensures we can pass "expanded" arguments to these functions
\cs_generate_variant:Nn \clist_map_inline:nn { xn }
\cs_generate_variant:Nn \clist_put_right:Nn { Nx }

\NewDocumentCommand {\GetPersonsAsList} { m m o }
 {
  % % --- 1. Legacy Title Processing ---
  % \ifdatadefined{#1titlestring}(\@LANG@COVER)
  %  {
  %   \datadefault{#1titlestringpre}(\@LANG@COVER)
  %   \datadefault{#1titlestringfont}(\@LANG@COVER)
  %   \csuse{the#1titlestring}(\@LANG@COVER)
  %   \datadefault{#1titlestringpost}(\@LANG@COVER)
  %  }{}

  % --- 2. Build the Flat List ---
  \clist_clear:N \l_nt_master_clist

  % Map over the categories provided in #2 (e.g., a, c)
  \clist_map_inline:xn { #2 }
   {
    % Legacy check: if the list exists for this category
    \ifoptionvoid{/@nt/#1/##1/pair}
      { } 
      {
        % Retrieve the sub-list into the legacy macro \@advlist@i
        \letoptionlist{/@nt/#1/##1/pair}\@advlist@i
        
        % FIX: Use put_right:Nx instead of concat:NN
        % This expands \@advlist@i (e.g., "A, B") and appends A and B 
        % as separate items to the master list.
        \clist_put_right:Nx \l_nt_master_clist { \@advlist@i }
      }
   }

  % --- 3. Output or Storage ---
  \IfNoValueTF { #3 }
   {
     \raggedright
     \datadefault{#1namefont}(#2)
     % Convert clist back to comma-separated string for legacy formatter
     \cs_set:Npx \@advlist { \clist_use:Nn \l_nt_master_clist { , } }
     \FormatNamesAsList{\@advlist}
   }
   {
     % Store the result in the requested output macro
     \xdef #3 { \clist_use:Nn \l_nt_master_clist { , } }
   }
 }




\cs_generate_variant:Nn \seq_set_from_clist:Nn { Ne }
\cs_generate_variant:Nn \seq_use:Nnnn { Neee }
\NewDocumentCommand{\FormatNamesAsList}{ m
                                         O{ }
                                         O{ , ~ } 
                                         O{ ~ \theandstring(\@LANG@MAIN) ~ } 
                                         O{ , ~ \theandstring(\@LANG@MAIN) ~ } }
% {comma separated list of names} {name-prefix} {middle-sep} {pair-sep} {last-sep}
% example: {Maria, Rita, Filomena} {Professora} {,} {~e~} {~e~}
 {
  % 1. Convert the input string (comma list) into a sequence variable
  \seq_set_from_clist:Ne \l_tmpa_seq { #1 }

  % 2. Create a temporary sequence to hold the modified names
  \seq_clear:N \l_tmpb_seq

  % 3. Loop through the original names and prefix them with "de "
  \seq_map_inline:Nn \l_tmpa_seq
   {
    \seq_put_right:Nn \l_tmpb_seq { #2 ~ ##1 }
   }

  % 4. Output the sequence with custom separators
  % \seq_use:Nnnn <sequence> {middle-sep} {pair-sep} {last-sep}
  \seq_use:Neee \l_tmpb_seq { #2 } { #3 } { #4 }
 }

\ExplSyntaxOff


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
  \begin{tabularx}{#2\linewidth}[t]{@{}>{\nt@tabularx@horz}L@{}}%
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
  \end{tabular}%
}

\newcommand{\@nt@printgrouptitle@text}[2]{%
  % #1 = {adviser | committee}
  % #2 = {a,c} | {c,r,a,m,g}
  \ifoptiondefined{/@nt/#1/#2/full}{%
    \options{/@nt/#1/#2/full/.size = \mysize}%
    \ifnum\mysize>0\relax%
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
  \options{/@nt/#1/#2/full/.size = \mysize}%
  \ifnum\mysize>0\relax%
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
    \options{/@nt/#3/#4/full/.size = \mysize}%
    \ifnum\mysize>0\relax%
      % \typeout{NTPRINTPERSONGROUP 1=[#1] 2=[#2] 3=[#3] 4=[#4]}\NTPRINTPERSONGROUP
      \@nt@printgrouptitle{#3}{#4}%
      \begin{varwidth}[t]{\linewidth-\maxlen}%
        \raggedright%
        \IfStrEq{#1}{list}{%
          \GetPersonsAsList{#3}{#4}%
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

% --------------------------------------------------------
% Reduce Number Logic: Result = Max(Current, Min(Size, 2))
% --------------------------------------------------------
% #1: Current accumulated number (Optional, default 1)
% #2: Option path (e.g., /my/list). The code looks for #2/@size
% #3: The macro to store the result in (globally)
\newcommand*{\@nt@reducenumber}[3][1]{%
  % 1. Retrieve the size value from the option system
  %    \edefoption expands the option value into \opt@temp@size
  \options{#2/.size = \mysize}%
  %
  % 2. Calculate Min(\mysize, 2)
  %    We interpret the retrieved text as a number.
  \ifnum\mysize < 2
    \let\opt@temp@val\mysize
  \else
    \def\opt@temp@val{2}%
  \fi
  %
  % 3. Calculate Max(#1, \opt@temp@val) and \xdef to #3
  \ifnum#1 > \opt@temp@val
    \xdef#3{#1}%
  \else
    \xdef#3{\opt@temp@val}%
  \fi
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE LAYOUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\AtEndPreamble{\ntsetlayout}%

\newcommand*{\ntsetlayout}{%
    % \synctex=1% Use synctex
    \brokenpenalty=10000%
    \newgeometry{
        lmargin=\expanded{\themargin(\option{/novathesis/media},left)},
        rmargin=\expanded{\themargin(\option{/novathesis/media},right)},
        tmargin=\expanded{\themargin(\option{/novathesis/media},top)},
        bmargin=\expanded{\themargin(\option{/novathesis/media},bottom)},
    }%
    \ifoptionequal{/novathesis/media}{paper}{\openright}{\openany}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Printing chapters and similars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\@nt@printifmaindoc@i}[1]{%
  % \typeout{NT Attempt to load #1}%
  \ifmaindoc{% THEN it is a main document
    \NTRunHook{#1/pre}%
    \iffileadded{#1}{%
      \ChapterNoTitle{\thebkmstring(#1,\@LANG@COPYRIGHT)}
      \PrintAddedFile{#1}%
      \bookmarksetupnext{rellevel=0}%
    }{}%
    \NTRunHook{#1/post}%
    \clearforchapter%
  }{}% It is a plan or proposal type document
}

\newcommand{\ntprintdedication}
  {\@nt@printifmaindoc@i{dedication}}

\newcommand{\ntprintquote}
  {\@nt@printifmaindoc@i{quote}}

\newcommand{\ntprintacknowledgements}
  {\@nt@printifmaindoc@i{acknowledgements}}


\newcommand{\ntprintaidisclose}{%
  \ifoptionequal{/novathesis/print/aidisclosure}{aidisclose}{% use aidisclose
    \bookmarksetupnext{rellevel=0}%
    \AIDrenderDeclaration[ncols=3]{\thedocauthor(name)}%
  }{\ifoptionequal{/novathesis/print/aidisclosure}{false}
      {} % do not print AI Disclosure
      {\IfFileExists{\DIRFRONTMATTER/\option{/novathesis/print/aidisclosure}}
        {%
          \bookmarksetupnext{rellevel=0}%
          \input{\DIRFRONTMATTER/\option{/novathesis/print/aidisclosure}}%
        }
        {\ClassError{novathesis}
                    {AI Disclusre file not found: '\option{/novathesis/print/aidisclosure}'.}
                    {Please provide a valid AI Disclusre file name.}
        }%
      }%
  }%
}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Print Sustainable Development Goals (SDG)
%% To be called from \ntprintabstracts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcounter{sdgcnt}%
\newdimen{\sdgdim}%
\newcommand*{\ntprintsdgs}{
  \@tempdima=\option{/novathesis/print/sdgs/hspace}%
  \@tempdimb=\option{/novathesis/print/sdgs/vspace}%
  \setcounter{sdgcnt}{0}%
  \sdgdim=0pt%
  \ifoptionnil{/novathesis/print/sdgs/list}{}{%
      \vfill%
      \raggedright\noindent%
      \textbf{\thesdgstring(\@LSHORT):}\\[1ex]
      \edef\@sdgtype{\option{/novathesis/print/sgds/type}}
      \IfFileExists{\DIRIMAGES/sdg-\@LSHORT/1-\@sdgtype.pdf}
          {\def\@spnfolder{\DIRIMAGES/sdg-\@LSHORT}}
          {\def\@spnfolder{\DIRIMAGES/sdg-en}}
      \noindent%\linespread{1.5}\selectfont
      \optionlistdo{/novathesis/print/sdgs/list}{%
        \stepcounter{sdgcnt}%
        \setbox0=\hbox{%
          % \typeout{FILE=\DIRIMAGES/sdg-\@LSHORT/##1-\XPTO}
            \includegraphics[width=\option{/novathesis/print/sdgs/size}]
                            {\@spnfolder/##1-\@sdgtype}%
        }%
        \ifdim \dimexpr\sdgdim + \wd0\relax > \textwidth\relax%
            \\[\@tempdimb]
            \sdgdim=\wd0%
        \fi
        \usebox0\hspace{\@tempdima}%
      }%
  }%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Print Abstracts
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\ntprintabstracts}{%
  \NTRunHook{abstracts/pre}%
  \@for\nt@tmpi:=\expanded{\theabstractorder(\@LANG@MAIN)}\do{\@ntprintabstract{\nt@tmpi}}%
  \NTRunHook{abstracts/post}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Abstract, Acronyms and Glossary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifskipabstract
\newcommand{\@ntprintabstract}[1]{%
  \iffileadded[#1]{abstract}{%
    \skipabstractfalse
    % \typeout{NT PRINT ABSTRACT=[#1]}\NTPRINTABSTRACT@I%
    \ifPDFTeX
      \IfStrEq{#1}{zhs}{\skipabstracttrue}{}%
      \IfStrEq{#1}{zht}{\skipabstracttrue}{}%
    \fi
    \ifskipabstract
      \ClassWarning{novathesis}{Skipping abstract '#1' under pdfLaTeX (CJK Unicode). Use 'make xe' or 'make lua' to include Chinese abstracts.}%
    \else
      % \typeout{NT PRINT ABSTRACT 2=[#1]}\NTPRINTABSTRACT@II
      \begingroup
        % \typeout{NT PRINT ABSTRACT #1}\bbbb
        \StrCut{#1}{-}\@ABS@LANG\@dummy%
        \ntselectlang{\@ABS@LANG}%
        % \typeout{NTL=\languagename [#1]}\bbbb
        % \hypertarget{bmabstract#1}{}%
        % \bookmark[dest=bmabstract#1]{\thebkmstring(abstract,#1)}%
        \NTRunHook{abstract/pre}%
        \NTRunHook{abstract/#1/pre}%
        \printabstracttitle{#1}%
        \NTRunHook{abstract/mid}%
        \NTRunHook{abstract/#1/mid}%
        \PrintAddedFile[#1]{abstract}%
        \ntprintsdgs%
        \NTRunHook{abstract/#1/post}%
        \NTRunHook{abstract/post}%
      \endgroup%
      \clearforchapter%
    \fi
  }{}%
}

\newcommand{\ntprintindex}{%
  % \printglossary[type=index]%
  \printindex%
  \clearforchapter%
}

\newif\if@frontmatter
\newcommand*{\ntthesisfrontmatter}{%
  \NTRunHook{frontmatter/pre}%
  \begingroup
    \def\clearforchapter{}
    \def\cleardoublepage{}
    \def\clearepage{}
    \frontmatter%
  \endgroup
  \@frontmattertrue
  \begingroup
  \pagestyle{novathesis@frontmatter}%
  \copypagestyle{chapter}{novathesis@frontmatter}
  % \ntselectlang{\@LANG@MAIN}%
  \pagenumbering{roman}%
  \iftoggle{/novathesis/print/frontpage}
    {\setcounter{page}{2}}
    {\setcounter{page}{1}}
}

\newif\if@mainmatter
\newcommand*{\ntthesismainmatter}{%
  \@frontmatterfalse
  \endgroup
  \NTRunHook{frontmatter/post}%
  \bookmarksetup{startatroot}%
  \NTRunHook{mainmatter/pre}%
  \ifbool{@openright}{}{% openany=true
    % Avoid cleardoublepage before "mainmatter"
    \let\oldcleardoublepage\cleardoublepage%
    \renewcommand{\cleardoublepage}{\clearforchapter}%
  }%
  \NTRunHook{mainmatter/pre}%
  \mainmatter%
  \@mainmattertrue
  \ifbool{@openright}{}{% openany=true
    \let\cleardoublepage\oldcleardoublepage%
  }%
  \pagestyle{novathesis@mainmatter}%
}

\newif\if@backmatter
\newcommand*{\ntthesisbackmatter}{%
  \NTRunHook{mainmatter/post}%
  \@backmattertrue
  \NTRunHook{backmatter/pre}%
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
    \@nt@foralllist{file}{chapter}{\PrintAddedFile{chapter}}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Appendixes and Annexes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand*{\addappheadtotoc}{%
    \phantomsection\addtocontents{toc}%
    {\protect\contentsline{chapter}{\appendixtocname}{}{}}%
 }

\newcommand*{\ntprintappendices}{%
  \bookmarksetupnext{level=0}%
  \iffileadded{appendix}{%
    \renewcommand{\appendixtocname}{\appendixplname}%
    \appendix\addappheadtotoc%
    \@nt@foralllist{file}{appendix}{\PrintAddedFile{appendix}}%
  }{}%
}

\newcommand*{\ntprintannexes}{%
  \bookmarksetupnext{level=0}%
  \iffileadded{annex}{%
    % \renewcommand{\appendixtocname}{\translate{Annexes}}%
    \renewcommand{\appendixtocname}{\annexplname}%
    \annex\addappheadtotoc%
    \@nt@foralllist{file}{annex}{\bookmarksetupnext{rellevel=0}\PrintAddedFile{annex}}%
  }{}%
}

\ifdef{\annexcounter}{}{\def\annexcounter{\old@Roman}}
\newcommand*{\annex}{%
  \xdef\Hy@chapapp{annex}%
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  % \gdef\@chapapp{\translate{annex}}%
  \gdef\thechapter{\annexcounter\c@chapter}%
}%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Print statements utils
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{tightcenter}
  {\par\centering}
  {\par}%

\NewDocumentCommand { \TheCandiadteSignature } { m m }
  % #1 = place
  % #2 = ISO DATE
  {
    \begin{center}%
      \StatementOneSignature%
        {\expandafter\thecandidatestring\expandafter(\thedocauthor(gender),\@LANG@MAIN)}
        {\thedocauthor(name)}%
        {#2}
    \end{center}%
  }


\newcounter{nadv}
\NewDocumentCommand { \TheAdvisersSignatures } { O{20mm} m m m }
  % #2 = a (only advisers) | a,c (both advisers and co-advisers)
  % #3 = place
  % #4 = ISO DATE
  {
    \begin{tightcenter}
      \ifoptiondefined{/@nt/adviser/#2/pair}{%
        \optionlistdo{/@nt/adviser/#2/pair}{%
            % \ifnum\arabic{nadv}=2\relax
            %   ~\\[1ex]
            % \fi
            \stepcounter{nadv}
            \StrCut{##1}{/}\stgender\stname
            \StatementOneSignature 
              {\theadviserstring(pref,#2,1,\stgender,\@LANG@MAIN)} 
              {\stname}
              {#4}
        }%
      }{}%
    \end{tightcenter}
  }


\NewDocumentCommand { \StatementOneSignature } { O{20mm} m m m }
  % #1 = space to rule
  % #2 = text above
  % #3 = name
  % #4 = date
  {
    \begin{minipage}[t]{6cm}
      \medskip%
      \begin{center}  
        #2,\par
        \vspace*{#1}
        \rule{\linewidth}{0.75pt}\par
        \textit{#3}\\
        \PrintDateISO{#4}
      \end{center}
    \end{minipage}
  }



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Deal with optional lists in the frontmatter: listoftables, litoffigures, etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand*{\ntprintalllistof}{%
    \NTRunHook{listof/pre}%
    \if@backmatter
      \def\@matter{backmatter}
    \else
      \def\@matter{frontmatter}
    \fi
    \ifoptiondefined{/@nt/listof/\@matter}{
      \bookmarksetup{level=0}
      \options{/@nt/listof/\@matter/.size = \mysize}%
      \ifnum\mysize>1\relax
        \hypertarget{bmlistof\@matter}{}%
        \bookmark[dest=bmlistof\@matter]{\thebkmstring(listof,\@LANG@MAIN)}%
        \bookmarksetupnext{rellevel=1}%
      \fi
      % \typeout{PRINTALLLISTOF=\@matter}\PRINTALLLISTOF
      \optionlistdo{/@nt/listof/\@matter}{\clearforchapter##1\bookmarksetupnext{rellevel=0}}%
    }{}
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

\newcommand*{\ntprintbibsingle}[1][]{%
  \bookmarksetupnext{rellevel=1}%
  \NTRunHook{printbib/pre}%
  \printbibliography[#1]%
  \ntfixspacing%
  \NTRunHook{printbib/post}%
}

\newcommand*{\ntprintbibseparate}[1][]{%
  \bookmarksetupnext{rellevel=1}%
  \NTRunHook{printbib/pre}%
    \printbibliography[nottype=online] % Print the bibliography.
    \printbibliography[title=\option{/novathesis/print/webography},type=online] % Print the bibliography.
  \ntfixspacing%
  \NTRunHook{printbib/post}%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Copyright page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\printcompactbib}[1][]{%
  \begingroup
    \renewcommand*{\bibfont}{\tiny}% very small text
    \renewbibmacro*{pageref}{}% suppress backrefs
    % Remove vertical space before the list starts
    \setlength{\topsep}{0pt}
    \setlength{\partopsep}{0pt}
    % Remove vertical space between items (from your previous request)
    \setlength{\bibitemsep}{2pt}
    % fine tune label width
    \setlength{\labelnumberwidth}{10pt}%
    % Print the bibliography with no title, passing any extra options
    \defbibheading{ntlocalbib}{%
      {\par\vspace*{-1.25ex}}
      \textcolor{white}
                {\fontsize{0.01}{1}\selectfont\noindent\hspace*{-\labelnumberwidth}
                 \bibname~(12cc90221730b8ba41bb3b1f8b517acd)}%
      \vspace*{-\baselineskip-\parskip}
    }
    \newrefcontext[sorting=ynt]%
    \printbibliography[heading=ntlocalbib, #1]
  \endgroup
}

\newcommand{\ntprintacknowledgementsblock}[1][\scriptsize]{%
    \NTRunHook{acknowledgementsblock/pre}%
      \refsection%
      \renewcommand{\@ntcite}[1]{\cite{##1}}%
      \bigskip\footnoterule#1\smallskip\noindent\theacknowledgmentsstring(\@LANG@MAIN)%
      \printcompactbib%
      \endrefsection%
    \NTRunHook{acknowledgementsblock/post}%
}

\newcommand*{\ntprintcopyright}{%
  \ifmaindoc{%
    \iftoggle{/novathesis/print/copyright}{%
      \begingroup
        % \bookmarksetupnext{rellevel=1}
        \ntselectlang{\@LANG@COPYRIGHT}%
        \ChapterNoTitle{\thebkmstring(copyright,\@LANG@COPYRIGHT)}%
        \NTRunHook{copyright/pre}%
        \ntprintcopyrightpage%
        \NTRunHook{copyright/post}%
        \ntprintacknowledgementsblock%
      \endgroup
    }{}%
   }{}%
}


\newcommand*{\ntprintcopyrightpage}{%
  \ifmaindoc{% only print if a main document
    \iftoggle{/novathesis/print/copyright}{% if copuyright toggle is on
      \InputIfFileExistsInDirsTF {copyright.tex} 
        {
          {\DIRSCHOOLS/\@UNIV/\@SCHL},
          {\DIRSCHOOLS/\@UNIV},
          {\DIRSTYFILES},
        }
        {}
        {
          \ClassError{novathesis}
                     {No “copyright.tex” file was found!}{}
        }
    }{}%
  }{}
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
\providecommand{\ntchapskip}{%
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
  \thispagestyle{novathesis@frontmatter}%
  \defifundef{\ntqbox}{\newsavebox}%
  \savebox{\ntqbox}{#7}
  \ifdim\wd\ntqbox<\ifblank{#2}{\textwidth}{#2}\relax
  \@tempdima=\wd\ntqbox
  \else
  \@tempdima=#2
  \fi
  \ntchapskip
  \begin{flushright}
    \NTRunHook{ntquote/pre}%
    \IfBooleanTF{#1}{\hugequote}{}
    \begin{minipage}[t]{\@tempdima}
      \raggedleft\normalsize
      % \options{/@nt/lang/shorttolong=#6}%
      \IfBooleanTF{#1}{%
        \foreigntextquote{\GetLangLong(#6)}{\ntquotetext{#7}}%
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
\cs_new:cpn {ntdedication} {\ntquoting}
\cs_new_eq:cN {endntdedication} \endntquoting
\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Acknowledgements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{ntacknowledgements}{%
  % \bookmarksetupnext{level=1}%
  \chapter*{\thebkmstring(acknowledgements,\@LANG@MAIN)}%
}{}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Abstract
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\IfSubStr{,\@LANG@LOADED,}{,zhs,}{%
  \iftutex
    \ifcsname nt@cjkfontSC\endcsname\else
      \IfFontExistsTF{PingFang SC}
        {\newfontfamily\nt@cjkfontSC{PingFang SC}}
        {\IfFontExistsTF{Noto Sans CJK SC}
          {\newfontfamily\nt@cjkfontSC{Noto Sans CJK SC}}
          {\IfFontExistsTF{Heiti SC}
            {\newfontfamily\nt@cjkfontSC{Heiti SC}}
            {\newfontfamily\nt@cjkfontSC{Latin Modern Roman}}%
          }%
        }%
    \fi
  \fi
}{}
\IfSubStr{,\@LANG@LOADED,}{,zht,}{%
  \iftutex
    \ifcsname nt@cjkfontTC\endcsname\else
      \IfFontExistsTF{PingFang TC}
        {\newfontfamily\nt@cjkfontTC{PingFang TC}}
        {\IfFontExistsTF{Noto Sans CJK TC}
          {\newfontfamily\nt@cjkfontTC{Noto Sans CJK TC}}
          {\IfFontExistsTF{Heiti TC}
            {\newfontfamily\nt@cjkfontTC{Heiti TC}}
            {\newfontfamily\nt@cjkfontTC{Latin Modern Roman}}%
          }%
        }%
    \fi
  \fi
}{}

\newcommand*{\printabstracttitle}[1]{%
  \bookmarksetupnext{rellevel=0}
  \begingroup
    \def\nt@abstitlefont{}%
    \iftutex
      \IfStrEq{#1}{zhs}{\def\nt@abstitlefont{\nt@cjkfontSC}}{}%
      \IfStrEq{#1}{zht}{\def\nt@abstitlefont{\nt@cjkfontTC}}{}%
    \fi
    \chapter{\texorpdfstring{{\nt@abstitlefont\thebkmstring(abstract,#1)}}{\thebkmstring(abstract,#1)}}%
  \endgroup
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
     {\thispagestyle{novathesis@frontmatter}}%
     % {\thispagestyle{empty}}%
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

% ---------------------------------------------------------------------
% ToC Spacing Hack: Tighter spacing for Front Matter, normal for Main
% ---------------------------------------------------------------------

% 1. When Front Matter starts, write a command to the .toc file to REDUCE spacing
\appto\frontmatter{%
  \let\cftbeforechapterskipORIG\cftbeforechapterskip
  \addtocontents{toc}{\protect\setlength{\cftbeforechapterskip}{3pt}}%
}

% 2. When Main Matter starts, write a command to the .toc file to RESTORE spacing
% (Memoir default is usually 1.0em plus 1pt)
\appto\mainmatter{%
  \addtocontents{toc}{\protect\setlength{\cftbeforechapterskip}{1.0em plus 1pt}}%
}

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

% First try to load a local chapter-style definition
\InputIfFileExists{\DIRCHAPSTYLES/\option{/novathesis/style/chapter}.sty}
  {}{% otherwise, try a standard 'memoir' style
      \ifcsdef{chs@\option{/novathesis/style/chapter}}
          {\chapterstyle{\option{/novathesis/style/chapter}}}
          {\ClassError{novathesis}{Invalid Chapter Style: \option{/novathesis/style/chapter}}{}}%
}

\IfFileExistsCase
  {
    {\DIRFONTSTYLES/\option{/novathesis/style/font}.sty}
          {\input{#1}},
    {\option{/novathesis/style/font}.sty}
          {\RequirePackage{#2}},        
  }
  {
    \ifcsname IfFontExistsTF\endcsname
      \IfFontExistsTF{\option{/novathesis/style/font}}
        {\setmainfont{\option{/novathesis/style/font}}
                     [ \option{/novathesis/style/font/attributes} ]}
        {\ClassError{novathesis}{Could not find the font: \option{/novathesis/style/font}}{}}
    \else
      \ClassError{novathesis}
                 {Cann not load the font: \option{/novathesis/style/font}. Are you using XeLaTeX or LuaLaTeX?}{}
    \fi
  }


% force page color to white in xelatex and lualatex
\ifxeorlua{\definecolor{nearlywhite}{gray}{0.999999}\colorlet{white}{nearlywhite}}{}

\AtBeginDocument{%
  \makeatletter%
  % \typeout{XXX [\thedocauthor(name)]}
  % \typeout{XXX [\thedoctitle(\@LANG@MAIN,main,plain)]}
  % \typeout{XXX [\thedoctitle(\@LANG@MAIN,sub,plain)]}
  \hypersetup{%
    pdfauthor={\thedocauthor(name)},
    pdftitle={\thedoctitle(\@LANG@MAIN,main,plain)},
    pdfsubject={\thedoctitle(\@LANG@MAIN,sub,plain)},
  }

  %--------------------------------
  % If subcaption is loaded, let it handle subfigures
  % otherwise use memoir subfigures
  \@ifpackageloaded{subcaption}{}{\newsubfloat{figure}}
  \newcommand{\@ntcite}[1]{\ifdef{\parencite}{\parencite{#1}}{\cite{#1}}}
  \makeatother
}
