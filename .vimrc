" bscheibe .vimrc file.

" Configure behavior.
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

" Configure Netrw explorer settings.
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_browse_split=4
let g:netrw_altv=2
let g:netrw_winsize = 25
augroup DirExplorer
  autocmd!
  autocmd VimEnter * :Vexplore
augroup END
autocmd VimEnter * let t:created=1
autocmd TabEnter * if !exists('t:created') | :Vex | wincmd p | let t:created=1 | endif

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
" Open file under cursor. Requires full, or relative to current, path.
:map gf :tabe <cfile><CR> 

" Read in CTag files. Change searched directory as needed.
for t in split(glob('~/CTags/*.tag'), '\n')
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

" Searching behavior.
set incsearch
set ignorecase
set smartcase

" Ensure opening a session does not overload .vimrc settings.
set sessionoptions-=globals
set sessionoptions-=localoptions
set sessionoptions-=options

" C++ specific.
set matchpairs+=<:>
