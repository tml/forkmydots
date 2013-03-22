set nocompatible	" Set no compatible with vi mode
set showcmd		" Show (partial) command in status line.
set ignorecase		" Do case insensitive matching
set modeline
set bs=indent,eol,start

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
colorscheme elflord
set background=dark
set scrolloff=999
set statusline=%<%f%=\ [%1*%M%*%n%R%H]\ %-19(%3l,%02c%03V%)%O'%02b'
set laststatus=2

" instead, if the terminal has color support, enable syntax highlighting:
if &t_Co > 1 		
	syntax enable
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set showmatch		" Show matching brackets.
set textwidth=80
set fo=tcq
set cindent
set foldmethod=syntax

if has("autocmd")
  filetype plugin indent on
endif

"filetype plugin on
"set grepprg=grep\ -nH\ $*
"filetype indent on
"let g:tex_flavor='latex'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
let mapleader = "-"

" hakyll site previewer
nnoremap <leader>hg :!rm -rf /var/www/rainyday/* && hyde gen -d /var/www/rainyday<cr>
nnoremap <leader>hp :!./hakyll preview 9000<cr>
nnoremap <leader>hc :!./hakyll clean<cr>
nnoremap <leader>hb :!./hakyll rebuild && rm -rf /var/www/jumpshop/* && cp -r _site/* /var/www/jumpshop<cr>

nnoremap <leader>pp :! python %<CR>
nnoremap <leader>pd :! python manage.py runserver<CR>
nnoremap <leader>gac :! git add -p % && git commit <CR>

" vimrc quick edits
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" End Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('cscope')
	set cscopetag cscopeverbose

	if has('quickfix')
		"set cscopequickfix=s+,c+,d-,i-,t+,e-
	endif

	if filereadable("cscope.out")
		cs add cscope.out
	elseif $CSCOPE_DB != ""
		cs add $CSCOPE_DB
	endif
	set csverb
	
	map g<C-]> :cs find 3 <C-R>=expand("<cword>")<CR><CR>
	map g<C-\> :cs find 0 <C-R>=expand("<cword>")<CR><CR>
	
	nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

	" Using 'CTRL-spacebar' then a search type makes the vim window
	" split horizontally, with search result displayed in
	" the new window.

	nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>

	" Hitting CTRL-space *twice* before the search type does a vertical
	" split instead of a horizontal one

"	nmap <C-Space><C-Space>s
"		\:vert scs find s <C-R>=expand("<cword>")<CR><CR>
"	nmap <C-Space><C-Space>g
"		\:vert scs find g <C-R>=expand("<cword>")<CR><CR>
"	nmap <C-Space><C-Space>c
"		\:vert scs find c <C-R>=expand("<cword>")<CR><CR>
"	nmap <C-Space><C-Space>t
"		\:vert scs find t <C-R>=expand("<cword>")<CR><CR>
"	nmap <C-Space><C-Space>e
"		\:vert scs find e <C-R>=expand("<cword>")<CR><CR>
"	nmap <C-Space><C-Space>i
"		\:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"	nmap <C-Space><C-Space>d
"		\:vert scs find d <C-R>=expand("<cword>")<CR><CR>

endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" make various buffers available inside vim when an Xserver is running.

" if the system has 'xsel', use it!
"if has('xsel') 
	:com -range Cz :silent :<line1>,<line2>w !xsel -i -b
	:com -range Cx :silent :<line1>,<line2>w !xsel -i -p
	:com -range Cv :silent :<line1>,<line2>w !xsel -i -s
	
	:ca cv Cv
	:ca cz Cz
	:ca cx Cx
	
	:com-range Pz :silent :r !xsel -o -b
	:com-range Px :silent :r !xsel -o -p
	:com-range Pv :silent :r !xsel -o -s
	
	:ca pv Pv
	:ca pz Pz
	:ca px Px
"endif
