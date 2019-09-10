" set the leader
let mapleader=" "

" Basic settings
filetype plugin indent on
set mouse=a
syntax enable
set autoread " detect when a file is changed
set history=1000 " change history to 1000
set textwidth=120
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set number " set the line number
set relativenumber
set hidden " current buffer can be put into background
set showbreak=... " show the line break
set autoindent " auto indent
set scrolloff=1 " skip one line on the top/bottom while scrolling
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab  " tab behaviour to spaces
set ignorecase smartcase hlsearch incsearch magic " for smart searching
" to clear the highlighted search
noremap <leader>, :set hlsearch! hlsearch?<cr>
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors
set cursorline " set the cursor line
" open the current file in new tab
noremap tt :tabedit %<CR>

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Use actual tab chars in Makefiles.
    autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
endif

" install the plugin manager Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" Make sure you use single quotes

" General purpose
    " Plugin to help you stop repeating the basic movement keys
    " :help work-motions and :h motion
    Plug 'takac/vim-hardtime'
    let g:hardtime_default_on = 0
    let g:list_of_disabled_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]

    Plug 'sheerun/vim-polyglot'
    Plug 'joshdick/onedark.vim'
    " color scheme
    Plug 'NLKNguyen/papercolor-theme'

    " repeat.vim: enable repeating supported plugin maps with '.'
    Plug 'tpope/vim-repeat'

    " surround.vim: quoting/parenthesizing made simple
    Plug 'tpope/vim-surround'
    " EditorConfig plugin for Vim
    Plug 'editorconfig/editorconfig-vim'
    " lean & mean status/tabline for vim that's light as air
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " airline settings
        " enable integration with ale
        let g:airline#extensions#ale#enabled = 1

        " Automatically displays all buffers when there's only one tab open.
        let g:airline#extensions#tabline#enabled = 0
        " enable the powerline fonts
        let g:airline_powerline_fonts = 1
        " no whitespace extension required
        let g:airline#extensions#whitespace#enabled = 0

    " Dark powered asynchronous unite all interfaces for Neovim/Vim8
    Plug 'Shougo/denite.nvim'
    " === Denite shorcuts === "
    "   ;         - Browser currently open buffers
    "   <leader>t - Browse list of files in current directory
    "   <leader>g - Search current directory for occurences of given term and
    "   close window if no results
    "   <leader>j - Search current directory for occurences of word under cursor
    nmap <leader>; :Denite buffer -split=floating -winrow=1<CR>
    nmap <leader>t :Denite file/rec -split=floating -winrow=1<CR>
    nnoremap <leader>f :<C-u>Denite grep:. -no-empty -split=floating -mode=normal<CR>
    nnoremap <leader>j :<C-u>DeniteCursorWord grep:. -split=floating -mode=normal<CR>

    " Custom options for Denite
    "   auto_resize             - Auto resize the Denite window height automatically.
    "   prompt                  - Customize denite prompt
    "   direction               - Specify Denite window direction as directly below current pane
    "   winminheight            - Specify min height for Denite window
    "   highlight_mode_insert   - Specify h1-CursorLine in insert mode
    "   prompt_highlight        - Specify color of prompt
    "   highlight_matched_char  - Matched characters highlight
    "   highlight_matched_range - matched range highlight
    let s:denite_options = {'default' : {
    \ 'auto_resize': 1,
    \ 'prompt': 'λ:',
    \ 'direction': 'rightbelow',
    \ 'winminheight': '10',
    \ 'highlight_mode_insert': 'Visual',
    \ 'highlight_mode_normal': 'Visual',
    \ 'prompt_highlight': 'Function',
    \ 'highlight_matched_char': 'Function',
    \ 'highlight_matched_range': 'Normal'
    \ }}

    " nerd tree
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    " settings
        " Toggle NERDTree
        function! ToggleNerdTree()
            if @% != "" && (!exists("g:NERDTree") || (g:NERDTree.ExistsForTab() && !g:NERDTree.IsOpen()))
                :NERDTreeFind
            else
                :NERDTreeToggle
            endif
        endfunction
        " toggle nerd tree
        nmap <silent> <leader>k :call ToggleNerdTree()<cr>


    " vim stargify
    Plug 'mhinz/vim-startify'

" Tmux integration
    " seamless navigation betweeen tmux and vim
    Plug 'christoomey/vim-tmux-navigator'

" Git
    " A Git wrapper so awesome, it should be illegal
    Plug 'tpope/vim-fugitive'

    if has("signs")
        " A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
        Plug 'airblade/vim-gitgutter'
        " vim gitgutter
            " jump between hunks
            nmap [h <Plug>GitGutterNextHunk
            nmap ]h <Plug>GitGutterPrevHunk
    endif

" Language specific
    " Commenting
    Plug 'tpope/vim-commentary'

    "Intellisense engine for vim8 & neovim, full language server protocol support as VSCode
    " Note: for vim users, global installed `vim-node-rpc` module is required.
    Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}
    " === coc.nvim === "
    nmap <silent> <leader>gd <Plug>(coc-definition)
    nmap <silent> <leader>gr <Plug>(coc-references)
    nmap <silent> <leader>gj <Plug>(coc-implementation)
    " extensions
    Plug 'neoclide/coc-prettier', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-eslint', {'do': 'yarn install --frozen-lockfile'}
    Plug 'marlonfan/coc-phpls', {'do': 'yarn install --frozen-lockfile'}
    Plug 'neoclide/coc-python', {'do': 'yarn install --frozen-lockfile'}

    " Javascript syntax
    Plug 'pangloss/vim-javascript'
    let g:javascript_plugin_jsdoc = 1
    let g:javascript_plugin_flow = 1

    " Typescript syntax
    Plug 'leafgarland/typescript-vim'


    " PHP Syntax
    Plug 'StanAngeloff/php.vim'


    " Vim bundle for styled-components based javascript files.
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }


" Initialize plugin system
call plug#end()


augroup ConfigGroup
    autocmd!
    " automatically resize panes on resize
    autocmd VimResized * exe 'normal! \<c-w>='
    autocmd BufWritePost .vimrc,.vimrc.local,init.vim source %
    autocmd BufWritePost .vimrc.local source %
    " make quickfix windows take all the lower section of the screen
    " when there are multiple windows open
    autocmd FileType qf wincmd J
    autocmd FileType qf nmap <buffer> q :q<cr>
	" When editing a file, always jump to the last known cursor position.
    " Don't do it for commit messages, when the position is invalid, or when
    " inside an event handler (happens when dropping a file on gvim).
	autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
	" Set syntax highlighting for specific file types
    autocmd BufNewFile,BufRead *.jsx set filetype=javascript.jsx
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd BufRead,BufNewFile .{jscs,jshint,eslint,prettier,babel}rc set filetype=json
    autocmd QuickFixCmdPost *grep* cwindow
augroup END

" all key mapping
" window navigation in vim
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" copy to clipboard
vmap <Leader>y "+y
" delete and copy to clipboard
vmap <Leader>d "+d

" denite with ag
if executable('ag')
    call denite#custom#var('file/rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

" airline with coc
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'


silent! colorscheme PaperColor
set background=light
