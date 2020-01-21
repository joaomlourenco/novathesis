let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/Documents/TEX/novathesis
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +149 ~/.vim_runtime/my_configs.vim
badd +329 Chapters/1_introduction.tex
badd +19 ~/Documents/TEX/temp_thesis/Chapters/chapter1.tex
badd +264 thesis_rui_almeida.tex
badd +1 Chapters/glossary.tex
badd +38 Chapters/acronyms.tex
badd +53 ~/Documents/TEX/temp_thesis/Chapters/chapter2.tex
badd +694 ~/Documents/TEX/temp_thesis/Chapters/chapter3.tex
badd +10 Chapters/quote.tex
badd +1 Chapters/dedicatory.tex
badd +106 Chapters/2_litreview.tex
badd +1 thesis_rui_almeida.bcf
badd +267 ~/Documents/TEX/thesis_project/Chapters/chapter3.tex
badd +1 ~/Documents/TEX/thesis_project/Chapters/chapter4.tex
argglobal
silent! argdel *
edit Chapters/1_introduction.tex
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 92 + 92) / 185)
exe 'vert 2resize ' . ((&columns * 92 + 92) / 185)
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
let s:l = 382 - ((26 * winheight(0) + 22) / 45)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
382
normal! 038|
wincmd w
argglobal
if bufexists('~/Documents/TEX/temp_thesis/Chapters/chapter3.tex') | buffer ~/Documents/TEX/temp_thesis/Chapters/chapter3.tex | else | edit ~/Documents/TEX/temp_thesis/Chapters/chapter3.tex | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 825 - ((29 * winheight(0) + 22) / 45)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
825
normal! 010|
wincmd w
exe 'vert 1resize ' . ((&columns * 92 + 92) / 185)
exe 'vert 2resize ' . ((&columns * 92 + 92) / 185)
tabedit thesis_rui_almeida.tex
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
let s:l = 297 - ((22 * winheight(0) + 22) / 45)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
297
normal! 0
tabnext 1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToOFc
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
