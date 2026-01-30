let SessionLoad = 1
if &cp | set nocp | endif
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/zig-experiments/zig-fundamentals
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +40 build.zig.zon
badd +0 build.zig
badd +10 src/main.zig
badd +0 ~/.vimrc
argglobal
%argdel
$argadd build.zig.zon
edit build.zig
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 51 + 78) / 156)
exe '2resize ' . ((&lines * 20 + 22) / 44)
exe 'vert 2resize ' . ((&columns * 51 + 78) / 156)
exe '3resize ' . ((&lines * 20 + 22) / 44)
exe 'vert 3resize ' . ((&columns * 52 + 78) / 156)
exe '4resize ' . ((&lines * 20 + 22) / 44)
exe 'vert 4resize ' . ((&columns * 104 + 78) / 156)
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
let &fdl = &fdl
let s:l = 89 - ((13 * winheight(0) + 20) / 41)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 89
normal! 046|
lcd ~/zig-experiments/zig-fundamentals
wincmd w
argglobal
if bufexists(fnamemodify("~/zig-experiments/zig-fundamentals/src/main.zig", ":p")) | buffer ~/zig-experiments/zig-fundamentals/src/main.zig | else | edit ~/zig-experiments/zig-fundamentals/src/main.zig | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 10 - ((9 * winheight(0) + 10) / 20)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 10
normal! 032|
lcd ~/zig-experiments/zig-fundamentals
wincmd w
argglobal
if bufexists(fnamemodify("~/.vimrc", ":p")) | buffer ~/.vimrc | else | edit ~/.vimrc | endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 20 - ((13 * winheight(0) + 10) / 20)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 20
normal! 0
lcd ~/zig-experiments/zig-fundamentals
wincmd w
argglobal
terminal ++curwin ++cols=78 ++rows=20 
let s:term_buf_9 = bufnr()
balt ~/zig-experiments/zig-fundamentals/src/main.zig
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
let s:l = 605 - ((1 * winheight(0) + 10) / 20)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 605
normal! 058|
lcd ~/zig-experiments/zig-fundamentals
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 51 + 78) / 156)
exe '2resize ' . ((&lines * 20 + 22) / 44)
exe 'vert 2resize ' . ((&columns * 51 + 78) / 156)
exe '3resize ' . ((&lines * 20 + 22) / 44)
exe 'vert 3resize ' . ((&columns * 52 + 78) / 156)
exe '4resize ' . ((&lines * 20 + 22) / 44)
exe 'vert 4resize ' . ((&columns * 104 + 78) / 156)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
