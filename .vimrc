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
set nocscopetag


" Pretty up our Vim a bit.
colorscheme darkblue
set ruler
set title
set showcmd
set cursorline
set scrolloff=3
set hlsearch
set number
set list
" Note the trailing space character in each of these commands.
set fillchars+=vert:\ 
set listchars=tab:\|\ 



" Colors.
hi CursorLine cterm=bold,underline
hi TabLineSel ctermbg=green
hi Search ctermbg=green ctermfg=white
hi VertSplit ctermbg=green
hi StatusLine ctermbg=green ctermfg=white
hi StatusLineNC ctermbg=black ctermfg=white
hi PmenuSbar ctermbg=black ctermfg=black
hi Normal ctermbg=NONE guibg=NONE


" Highlight matches to the word under cursor.
hi MyMatch ctermbg=Blue ctermfg=white
let g:cursor_word_match=1
autocmd CursorMoved * call HighMatchesUnderCursor
ab nomatch call ToggleWordMatching()


" Configure Netrw explorer settings.
let g:netrw_banner=0
let g:netrw_liststyle=4
let g:netrw_browse_split=4
let g:netrw_altv=2
let g:netrw_winsize = 20
let g:netrw_bufsettings='wrap nonu'


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


" Read in CTag files. Change searched directory as needed.
for t in split(glob('~/CTags/*.tag'), '\n')
    execute "set tags+=".t
endfor
set notagrelative


" Omni-complete.
set omnifunc=syntaxcomplete#Complete
set completeopt-=preview


" Typing behavior.
set autoindent
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


" Macros:
" Open file under cursor. Requires full, or relative to current, path.
map gf :tabe <cfile><CR> 
" Open current directory in Netrw.
" map <c-n> :edit .<CR>
" Perform a CScope search on the word under cursor.
map <C-n> :call CscopeSearch(expand("<cword>"))


" Functions:
" Open a directory explorer window to the left that dynamically updates its directory
" according to the path to the open file on the right.
autocmd VimEnter * call ExplorerUpdate()
autocmd BufRead  * call ExplorerUpdate()
function! ExplorerUpdate()
    if exists('t:created')
        let t:dir=expand('%:p:h')
        wincmd h
        execute "E ". t:dir
    else
        Vex
        let t:created=1
    endif
    wincmd l
endfunction


function! HighMatchesUnderCursor()
    if g:cursor_word_match == 1
        exe printf('match MyMatch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
    endif
endfunction


function! ToggleWordMatching()
    if g:cursor_word_match == 1
        leg g:cursor_word_match=0
        match
    else
        let g:cursor_word_match=1
    endif
endfunction

 
" Opening a CScope database makes startup sluggish. Instead, use lazy initialization.
function! CscopeSearch(name)
     if !exists('g:scope_set')
         cscope add ~/CScope/
         let g:scope_set=1
     endif
     exe "cscope f s". a:name
endfunction
