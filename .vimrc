" bscheibe's .vimrc

" Configure behavior
set nocompatible
set bs=indent,eol,start
set viminfo='20,\"50
set history=50
set wrap
set confirm
syntax on
set nobackup
set noswapfile
set autoread

" Pretty up our Vim a bit.
colorscheme darkblue
set ruler
set title
set showcmd
set cursorline
set scrolloff=3
set hlsearch
set number
hi CursorLine cterm=bold,underline
hi TabLineSel ctermbg=green
hi Search ctermbg=green ctermfg=white
" Highlight matches to the word under cursor.
hi MyMatch ctermbg=Blue ctermfg=white
autocmd CursorMoved * exe printf('match MyMatch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" Properly handle file types and encodings.
if v:lang =~ "utf$" || v:lang =~ "UTF-8$"
    set fileencodings=ucs-bom,utf-8,latin1
endif
filetype plugin on

" Handle XTerm's quirks.
if &term=="xterm"
    set t_Co=8
    set t_Sb=^[[4%dm
    set t_Sf=^[[3%dm
endif

" Macros.
" Open file under cursor.
:map gf :tabe <cfile><CR> 

" Setup CTags.
for t in split(glob('/home/CTags/*.tag'), '\n')
    execute "set tags+=".t
endfor
set notagrelative

" Omni-complete.
set omnifunc=syntaxcomplete#Complete
set completeopt-=preview
hi PmenuSbar ctermbg=black ctermfg=black

" Typing behavior.
set tabstop=4
set autoindent
set expandtab
set shiftwidth=4
set shiftround
set smarttab
set tabstop=4

" Searching behavior.
set incsearch
set ignorecase
set smartcase
set hlsearch
