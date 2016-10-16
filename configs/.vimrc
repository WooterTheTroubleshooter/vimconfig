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

noremap <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
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

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch

	:highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
	:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" Show trailing whitespace and spaces before a tab:
	:match ExtraWhitespace /\s\+$\| \+\ze\t/
" " :Show trailing whitepace and spaces before a tab:
	:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/
endif
filetype plugin on
au BufNewFile,BufRead *.sah set filetype=javascript


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

" Cygwin specific settings

endif

if (has('mouse'))
	set mouse=a
endif
if has('mouse_sgr')
	set ttymouse=sgr
endif

call pathogen#infect()

" Customization
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
set sidescrolloff=32

" Tab completion for :
set wildmode=longest,list

" Code completion.
set omnifunc=phpcomplete#CompletePHP
set completeopt=menu,longest

set titlestring=%t
set title

" Make sure ctrlp uses case matching.
set smartcase

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

" Persistent macros.
let @u = "gUiw" " Convert word to uppercase.
let @l = "guiw" " Convert word to lowercase.

" Syntax checking
let g:used_javascript_libs = 'jquery, angularjs'
let g:syntastic_javascript_checkers = ['jsl']

let g:syntastic_php_checkers = ['php', 'phpmd']

let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_pylint_args = '--rcfile=/home/wnm/.vim/configs/.pylintrc'

let g:syntastic_perl_checkers = ['perl']
let g:syntastic_enable_perl_checker = 1

let g:syntastic_java_javac_config_file_enabled=1
" let g:syntastic_java_javac_config_file = '.syntastic_javac_config'

" Custom key mappings
let mapleader = "\<Space>"

map <leader>p <Esc>:FZF<Cr>
map <leader>f <Esc>:FZF<Cr>

map <F3> <Esc>:EnableFastPHPFolds<Cr>
map <F4> <Esc>:foldclose<Cr>

map <F5> <Esc><C-W>W
map <F6> <Esc><C-W>w
map! <F5> <Esc><C-W>W
map! <F6> <Esc><C-W>w

map <F7> <Esc>:tabp<Cr>
map <F8> <Esc>:tabn<Cr>
map! <F7> <Esc>:tabp<Cr>
map! <F8> <Esc>:tabn<Cr>


map <F10> <Esc>:w<Cr>:SyntasticCheck<Cr>
map! <F10> <Esc>:w<Cr>SyntasticCheck<Cr>

map <F11> <Esc>:EnablePHPFolds<Cr> 
map <F12> <Esc>:DisablePHPFolds<Cr> 

colorscheme wooter
highlight Folded ctermfg=100
highlight Folded ctermbg=0

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
