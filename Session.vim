let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Documents/TEX/novathesis
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 thesis_rui_almeida.toc
badd +300 thesis_rui_almeida.tex
badd +1 ~/.vim_runtime/my_configs.vim
badd +178 Chapters/1_introduction.tex
badd +19 ~/Documents/TEX/temp_thesis/Chapters/chapter1.tex
badd +1 Chapters/glossary.tex
badd +40 Chapters/acronyms.tex
badd +53 ~/Documents/TEX/temp_thesis/Chapters/chapter2.tex
badd +183 ~/Documents/TEX/temp_thesis/Chapters/chapter3.tex
badd +10 Chapters/quote.tex
badd +1 Chapters/dedicatory.tex
badd +862 Chapters/2_litreview.tex
badd +1 thesis_rui_almeida.bcf
badd +267 ~/Documents/TEX/thesis_project/Chapters/chapter3.tex
badd +1 ~/Documents/TEX/thesis_project/Chapters/chapter4.tex
badd +2953 bibliography.bib
badd +8 Chapters/3_methods.tex
badd +9 Chapters/4_conclusion.tex
badd +14 Chapters/appendix1.tex
badd +11 Chapters/appendix2.tex
badd +3 ~/.latexmkrc
badd +1 novathesis.cls
badd +79 novathesis-files/packages.clo
badd +4421 /usr/local/texlive/2019/texmf-dist/tex/latex/hyperref/hyperref.sty
badd +1 asd/conduction.tex
badd +87 asd/background.tex
argglobal
%argdel
edit Chapters/2_litreview.tex
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 883 - ((32 * winheight(0) + 30) / 61)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
883
normal! 0
tabnext 1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOFc
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
