" set the leader
let mapleader=","

" Basic settings
filetype plugin indent on
syntax enable
set autoread " detect when a file is changed
set history=1000 " change history to 1000
set textwidth=120
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set number " set the line number
set mouse=a " enable the mouse
set hidden " current buffer can be put into background
set showbreak=... " show the line break
set autoindent " auto indent
set scrolloff=1 " skip one line on the top/bottom while scrolling
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab  " tab behaviour to spaces
set ignorecase smartcase hlsearch incsearch magic " for smart searching
" to clear the highlighted search
noremap <space> :set hlsearch! hlsearch?<cr>
set backspace=indent,eol,start " backspace should work like normal
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors
set cursorline " set the cursor line

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
        let g:airline#extensions#tabline#enabled = 1
        " only show the file name
        let g:airline#extensions#tabline#formatter = 'unique_tail'
        " enable the powerline fonts
        let g:airline_powerline_fonts = 1
        " no whitespace extension required
        let g:airline#extensions#whitespace#enabled = 0
        " enable the tmuxline extension
        let g:airline#extensions#tmuxline#enabled = 1

    " Fuzzy file, buffer, mru, tag, etc finder. 
    Plug 'ctrlpvim/ctrlp.vim'
    " settings
        let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

    " A solid language pack for Vim.
    Plug 'sheerun/vim-polyglot'
    " nova theme
    Plug 'trevordmiller/nova-vim'
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
    " Simple tmux statusline generator with support for powerline symbols and statusline / airline / lightline integration
    Plug 'edkolev/tmuxline.vim'
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
            nmap <leader>h <Plug>GitGutterNextHunk
            nmap <leader>h <Plug>GitGutterPrevHunk
    endif

" Language specific
    " emmet for vim:
    Plug 'mattn/emmet-vim', { 'for': ['html', 'javascript.jsx']}
    " emmet
        let g:user_emmet_settings = {
        \  'javascript.jsx': {
        \      'extends': 'jsx',
        \  },
        \}
        let g:user_emmet_leader_key='<C-e>'

    " React JSX syntax highlighting and indenting for vim.
    Plug 'mxw/vim-jsx', { 'for': ['javascript.jsx', 'javascript'] }

    " Vim bundle for styled-components based javascript files.
    Plug 'styled-components/vim-styled-components', { 'branch': 'main' }

    " Asynchronous linting/fixing for Vim and Language Server Protocol (LSP) integration
    Plug 'w0rp/ale'
    " ale settings
        " fix on save
        let g:ale_fix_on_save = 1
        " only run the specified linters
        let g:ale_linters_explicit = 1
        " show the errors all the time
        let g:ale_sign_column_always = 1

        " fixers
        let g:ale_fixers = {
        \   'javascript': ['prettier'],
        \   'css': ['prettier'],
        \   'scss': ['prettier'],
        \   'sass': ['prettier'],
        \   'json': ['prettier'],
        \   'yml': ['prettier'],
        \   'markdown': ['prettier'],
        \}
        " linters
        let g:ale_linter_aliases = {'jsx': 'css'}
        let g:ale_linters = {
        \   'javascript': ['eslint'],
        \   'jsx': ['stylelint', 'eslint'],
        \}
        " navigate between errors
        nmap <silent> [e <Plug>(ale_previous_wrap)
        nmap <silent> ]e <Plug>(ale_next_wrap)
        " window of quickfix
        let g:ale_open_list = 1

        " message formatting
        let g:ale_sign_error = 'x'
        let g:ale_sign_warning = '>'
        let g:ale_echo_msg_error_str = 'x'
        let g:ale_echo_msg_warning_str = '>'
        let g:ale_echo_msg_format = '%severity% %s% [%linter%% code%]'


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

silent! colorscheme nova

