let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Documents/TEX/novathesis
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +5 Scripts/Makefile
badd +5 .gitignore
badd +1 thesis_rui_almeida.toc
badd +299 thesis_rui_almeida.tex
badd +150 ~/.vim_runtime/my_configs.vim
badd +178 Chapters/1_introduction.tex
badd +19 ~/Documents/TEX/temp_thesis/Chapters/chapter1.tex
badd +1 Chapters/glossary.tex
badd +64 Chapters/acronyms.tex
badd +53 ~/Documents/TEX/temp_thesis/Chapters/chapter2.tex
badd +480 ~/Documents/TEX/temp_thesis/Chapters/chapter3.tex
badd +10 Chapters/quote.tex
badd +1 Chapters/dedicatory.tex
badd +6 Chapters/2_litreview.tex
badd +1 thesis_rui_almeida.bcf
badd +267 ~/Documents/TEX/thesis_project/Chapters/chapter3.tex
badd +1 ~/Documents/TEX/thesis_project/Chapters/chapter4.tex
badd +2953 bibliography.bib
badd +17 Chapters/3_methods.tex
badd +9 Chapters/4_conclusion.tex
badd +8 Chapters/appendix1.tex
badd +11 Chapters/appendix2.tex
badd +3 ~/.latexmkrc
badd +1 novathesis.cls
badd +79 novathesis-files/packages.clo
badd +4421 /usr/local/texlive/2019/texmf-dist/tex/latex/hyperref/hyperref.sty
badd +14 asd/conduction.tex
badd +87 asd/background.tex
badd +1 thesis_rui_almeida.pdf
badd +3 Chapters/app1_slr.tex
badd +5 img/eps/results_distribution.eps
badd +163 asd/methods.tex
badd +1 Scripts/latexmk
badd +1 asd/methods.fls
argglobal
%argdel
edit Chapters/3_methods.tex
set splitbelow splitright
wincmd _ | wincmd |
split
wincmd _ | wincmd |
split
2wincmd k
wincmd w
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 30 + 28) / 56)
exe '2resize ' . ((&lines * 10 + 28) / 56)
exe '3resize ' . ((&lines * 10 + 28) / 56)
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
let s:l = 17 - ((11 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
17
normal! 07|
wincmd w
argglobal
enew
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
wincmd w
argglobal
enew
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
wincmd w
exe '1resize ' . ((&lines * 30 + 28) / 56)
exe '2resize ' . ((&lines * 10 + 28) / 56)
exe '3resize ' . ((&lines * 10 + 28) / 56)
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
