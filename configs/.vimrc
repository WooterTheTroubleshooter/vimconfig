if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

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


if &term=="xterm"
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"

call pathogen#infect() 
" Customization
set shiftwidth=4
set tabstop=4
set autoindent
set scrolloff=12

setlocal foldmethod=manual

set nowrap
set sidescroll=1
set sidescrolloff=32

set wildmode=longest,list

set titlestring=%t
set title

source ~/.vim/phpfolding.vim

"Remove trailing whitespaces
 fun! <SID>StripTrailingWhitespaces()
     let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
 endfun

" Code completion.
set omnifunc=phpcomplete#CompletePHP
set completeopt=menu



function! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>\<c-p>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-x>\<c-o>\<c-p>"
  endif
endfunction
inoremap <expr><tab> InsertTabWrapper()
inoremap <expr><s-tab> pumvisible()?"\<c-p>":"\<c-d>"
inoremap <C-X><C-O> <C-X><C-O><C-P> 

" Syntax checking
let g:used_javascript_libs = 'jquery, angularjs'

let g:syntastic_php_checkers = ['php', 'phpmd']
let g:syntastic_javascript_checkers = ['jsl']
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_pylint_args = '--rcfile=/home/wnm/.vim/configs/.pylintrc'

" Custom key mappings
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

set cursorline