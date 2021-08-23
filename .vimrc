" bscheibe .vimrc file.


" Cleanup.
imapclear
mapclear
nmapclear


" Configure behavior.
set nocompatible
set bs=indent,eol,start
set viminfo='20,\"50
set history=50
set wrap
set confirm
set nobackup
set noswapfile
set showmatch
set autoindent
set smartindent
set autochdir
set ignorecase
set smartcase
set splitright
set scrolloff=3
set hidden
set wildmenu
set wildmode=list:longest
set diffopt+=iwhite
filetype plugin on


" Pretty up our Vim a bit.
set ruler
hi clear
colorscheme darkblue
if has("gui_running")
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    color elflord
else
    hi Normal ctermbg=NONE guibg=NONE
endif
set title
set showcmd
set cursorline
set hlsearch
set number
" Note the trailing space character in each of these commands.
set fillchars+=vert:\ 
set listchars=tab:\|\ 
set list

" Colors.
hi CursorLine cterm=bold,underline
hi TabLineSel ctermbg=green
hi Search ctermbg=green ctermfg=white
hi VertSplit ctermbg=green
hi StatusLine ctermbg=green ctermfg=white
hi StatusLineNC ctermbg=black ctermfg=white
hi Visual ctermfg=white ctermbg=black cterm=reverse
" hi PmenuSbar ctermbg=black ctermfg=black
if !has("gui_running")
    hi Normal ctermbg=NONE guibg=NONE
endif


" Macros:
" Buffer switching.
" nnoremap <silent> <tab> :bnext<CR>
" nnoremap <silent> <s-tab> :bprev<CR>
nnoremap <silent> <tab> :b #<CR>
map = :ls <CR>
for num in range(1, 100)
    execute 'nnoremap <expr> '.num."b ':b".num."<CR>'"
endfor
" Open file under cursor. Requires full, or relative to current, path.
map gf :tabe <cfile><CR> 
" Open current directory in Netrw.
" map <c-n> :edit .<CR>
" Perform a CScope search on the word under cursor.
map <C-n> :call CscopeSearch(expand("<cword>"))


" Highlight matches to the word under cursor.
hi MyMatch ctermbg=Blue ctermfg=white guibg=darkgreen guifg=white cterm=bold
let g:cursor_word_match=1
autocmd CursorMoved * call HighMatchesUnderCursor()
ab nomatch call ToggleWordMatching()


" Configure Netrw explorer settings.
let g:netrw_banner=0
let g:netrw_liststyle=4
let g:netrw_browse_split=0
let g:netrw_altv=2
let g:netrw_winsize = 20
let g:netrw_bufsettings='wrap nonu'
let g:netrw_preview=1


" Ensure opening a session does not overload .vimrc settings.
set sessionoptions-=globals
set sessionoptions-=localoptions
set sessionoptions-=options


" Omni-complete.
set omnifunc=syntaxcomplete#Complete
set completeopt-=preview


" C++ help.
set matchpairs+=<:>


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
"for t in split(glob('~/CTags/*.tag'), '\n')
"    execute "set tags+=".t
"endfor
"set notagrelative


" Autocomplete menu configuration.
set completeopt=menuone
set complete=.
" set complete+=t
for ch in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", '\zs')
    execute 'inoremap <expr> '.ch.' pumvisible() ? "'.ch.'" : "'.ch.'\<C-n>\<C-p>"'
endfor
inoremap <expr> <Tab> pumvisible() ? "\<C-n>\<C-y>" : "\<Tab>"


" Functions:
" Open a directory explorer window in a left split that dynamically updates its directory
" according to the path of the open file on the right split.
"autocmd VimEnter * call ExplorerUpdate()
"autocmd BufRead  * call ExplorerUpdate()
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


" Magic number here is the max buffer size in bytes that this feature will be run on. 
" It prevents this function from bogging down Vim while huge (data) files are being viewed. 
function! HighMatchesUnderCursor()
    if g:cursor_word_match == 1
        if 300000 > line2byte('$')
            exe printf('match MyMatch /\V\<%s\>/', escape(expand('<cword>'), '/\'))
        endif
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

" Automatically add a closing character.
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
