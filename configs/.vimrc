scriptencoding utf-8
set encoding=utf-8

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible        " Use Vim defaults (much better!)
set bs=indent,eol,start " allow backspacing over everything in insert mode
"set ai                 " always set autoindenting on
"set backup             " keep a backup file
set viminfo='20,\"50    " read/write a .viminfo file, don't store more than 50 lines of registers
set history=50		    " keep 50 lines of command line history
set ruler               " show the cursor position all the time

set cursorline          " higlight current line.
set laststatus=2
set grepprg=~/.vim/grepnowhine.sh

set listchars=eol:↲,space:·,tab:»\ 
set list

set textwidth=0
set shiftwidth=4
set tabstop=4
set autoindent
set scrolloff=12
set undofile
set undodir=~/.vim/undo

set foldmethod=manual

set nowrap
set sidescroll=1
set sidescrolloff=16

" Tab completion for :
set wildmode=longest,list

" Code completion.
set completeopt=menu,longest,preview

set titlestring=%t
set title

" Make sure ctrlp uses case matching.
set smartcase
set noshowmatch

let g:loaded_matchparen=1

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
"  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
	" Switch syntax highlighting on, when the terminal has colors
	" Also switch on highlighting the last used search pattern.
	if &t_Co > 2 || has("gui_running")
		syntax on
		set hlsearch
		set incsearch

		colorscheme wooter
		highlight Folded ctermfg=100
		highlight Folded ctermbg=233
		set colorcolumn=80
		highlight ColorColumn ctermbg=233
		highlight CursorLine ctermbg=234

		highlight SpecialKey ctermfg=235
		highlight NonText ctermfg=235

		:highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
		:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
	" Show trailing whitespace and spaces before a tab:
		:match ExtraWhitespace /\s\+$\| \+\ze\t/
	" " :Show trailing whitepace and spaces before a tab:
		:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
	endif

	filetype plugin on
	au BufNewFile,BufRead *.sah set filetype=javascript

	autocmd FileType qf wincmd J
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

if &term=="xterm"
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

" Set block cursor for cygwin.
if has("win32unix")
	let &t_ti.="\e[1 q"
	let &t_SI.="\e[5 q"
	let &t_EI.="\e[1 q"
	let &t_te.="\e[0 q"
endif

if (has('mouse'))
	set mouse=a
endif
if has('mouse_sgr')
	set ttymouse=sgr
endif

call pathogen#infect()


"Remove trailing whitespaces
 fun! <SID>StripTrailingWhitespaces()
     let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
 endfun



function! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\S'
    return "\<tab>"
  else
    return "\<c-x>\<c-o>"
  endif
endfunction
inoremap <expr><tab> InsertTabWrapper()
inoremap <expr><s-tab> pumvisible()?"\<c-p>":"\<c-d>"




" Custom key mappings
let mapleader = "\<Space>"

noremap <leader>p <Esc>:FZF<Cr>

map <F3> <Esc>:EnableFastPHPFolds<Cr>
map <F4> <Esc>:foldclose<Cr>

map <F11> <Esc>:EnablePHPFolds<Cr>
map <F12> <Esc>:DisablePHPFolds<Cr>

noremap <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

map <C-/> :<C-u>nohlsearch<Cr>

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Prevent starting ex mode in dvorak mode
noremap Q <nop>

set switchbuf=useopen,usetab,vsplit
au! Filetype php call SetPhpOptions()
function! SetPhpOptions()
	set omnifunc=phpcomplete#CompletePHP

	" Error fixing shananigans.
	map <buffer> <leader>e <Esc>:cgete system('tail -n100 cache/error_log')\|cw<Cr>
	map <buffer> <leader>u <Esc>:cgete system('phpunit test')\|cw<Cr>
	map <buffer> <leader>i <Esc>:cgete system('php ' . expand('%'))\|cw<Cr>
	map <buffer> <leader>d <Esc>:!php %<Cr>
	set efm=%.%#PHP\ %m\ %f:%l,%.%#PHP\ %m\ in\ %f\ on\ line\ %l,%.%#]\ %m\ %f\ @\ %l%.%#,%.%#]\ PHP\ %m\ %f:%l,%E%n)\ %m,%Z%f:%l,%C%m,%C,%-G%.%#

	let @e = "oIerror_log(__METHOD__ . \" =line('i�kb.'): \");^"
endfunction

au! FileType rust call SetRustOptions()
function! SetRustOptions()
set omnifunc=ale#completion#OmniFunc
	let g:ale_linters = {'rust': ['rls','cargo','rustc']}
	let g:ale_fixers = {'rust': ['rustfmt']}
	let g:ale_completion_enabled = 1
	let g:ale_rust_rls_toolchain = 'nightly'

	compiler cargo
"	map <buffer> <leader>e <Esc>:make build\|cw<Cr>
"	map <buffer> <leader>u <Esc>:make test\|cw<Cr>
	map <buffer> <leader>b <Esc>:!cargo build<Cr>
	map <buffer> <leader>r <Esc>:!cargo run<Cr>
	ConqueGdbExe rust-gdb

" Ale
	nmap <leader>gt :ALEGoToTypeDefinitionInVSplit<cr>
	nmap <leader>gd :ALEGoToDefinitionInVSplit<cr>
	nmap <leader>cd :lcd %:p:h<cr>:ALELint<cr>
	nmap <leader>f :ALEFindReferences<cr>
	nmap <leader>h :ALEHover<cr>
	nmap <leader>d :ALEDetail<cr>
endfunction


let g:ale_lint_on_text_changed = 0
augroup ALERunOnInsertLeaveGroup
	autocmd!
	autocmd InsertLeave * call ale#Queue(0)
augroup END

augroup ALERunOnTextChangedNormalGroup
	autocmd!
	autocmd TextChanged * call ale#Queue(g:ale_lint_delay)
augroup END

" vnoremap <cr> "vy:let @/=@"<cr>
" vnoremap <cr> y:let @/=@"<cr>

