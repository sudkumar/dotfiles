" set the leader
let mapleader=" "

" Basic settings
filetype plugin indent on
set mouse=a
set autoread " detect when a file is changed
set history=1000 " change history to 1000
set textwidth=120
set nobackup
syntax on
set nowritebackup
set number " set the line number
set relativenumber
set hidden " current buffer can be put into background
set showbreak=... " show the line break
set autoindent " auto indent
set scrolloff=1 " skip one line on the top/bottom while scrolling
set tabstop=4 softtabstop=0 expandtab shiftwidth=4 smarttab  " tab behaviour to spaces
set ignorecase smartcase hlsearch incsearch magic " for smart searching
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" to clear the highlighted search
noremap <leader>, :set hlsearch! hlsearch?<cr>
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors
set cursorline " set the cursor line
" open the current file in new tab
noremap tt :tabedit %<CR>
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif
set termguicolors

set cmdheight=2

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

" Auto Correct for misspelled words
    " ctrl-l autocorrect the last misspelled word in insert mode
    inoremap <C-L> <C-G>u<Esc>[s1z=`]a<C-G>u
    hi clear SpellBad
    hi SpellBad cterm=underline
    " auto enable spell check for documents
    autocmd FileType latex,tex,md,markdown setlocal spell spelllang=en_us

call plug#begin('~/.vim/plugged')
" Make sure you use single quotes

" General purpose

    " Color scheme
    Plug 'NLKNguyen/papercolor-theme'

    " repeat.vim: enable repeating supported plugin maps with '.'
    Plug 'tpope/vim-repeat'

    " surround.vim: quoting/parenthesizing made simple
    Plug 'tpope/vim-surround'

    " EditorConfig plugin for Vim
    Plug 'editorconfig/editorconfig-vim'

    " lean & mean status/tabline for vim that's light as air
    Plug 'vim-airline/vim-airline'
    " airline settings
        " enable integration with ale
        let g:airline#extensions#ale#enabled = 1

        " Automatically displays all buffers when there's only one tab open.
        let g:airline#extensions#tabline#enabled = 0
        " enable the powerline fonts
        let g:airline_powerline_fonts = 1
        " no whitespace extension required
        let g:airline#extensions#whitespace#enabled = 0


    " nerd tree
    Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
    let g:NERDTreeWinPos = "right"
    " Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
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


    " Fuzzy file, buffer, mru, tag etc finder
    Plug 'ctrlpvim/ctrlp.vim'
        " Open with leader-t
        let g:ctrlp_map = '<leader>t'
        let g:ctrlp_cmd = 'CtrlP'
        " Use a custom file listing command:
        let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Tmux integration
    " seamless navigation betweeen tmux and vim
    Plug 'christoomey/vim-tmux-navigator'

" Git
    " A Git wrapper so awesome, it should be illegal
    Plug 'tpope/vim-fugitive'

    " A Vim plugin which shows a git diff in the gutter (sign column) and stages/undoes hunks.
    if has('nvim') || has('patch-8.0.902')
      Plug 'mhinz/vim-signify'
    else
      Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif
    let g:signify_sign_add    = '┃'
    let g:signify_sign_change = '┃'
    let g:signify_sign_delete = '•'

    let g:signify_sign_show_count = 0 " Don’t show the number of deleted lines.

" Language specific
    " Commenting
    Plug 'tpope/vim-commentary'

    " Javascript Syntax
    " Plug 'pangloss/vim-javascript'
    " Plug 'maxmellon/vim-jsx-pretty'
    Plug 'sheerun/vim-polyglot'


    " Auto completion and linting
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    nmap <silent> <leader>gd <Plug>(coc-definition)
    nmap <silent> <leader>gr <Plug>(coc-references)
    nmap <silent> <leader>gj <Plug>(coc-implementation)
    nmap <leader>rn <Plug>(coc-rename)

    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> <leader>[ <Plug>(coc-diagnostic-prev)
    nmap <silent> <leader>] <Plug>(coc-diagnostic-next)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Map function and class text objects
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction

    " extensions
    let g:coc_global_extensions = ['coc-prettier', 'coc-css', 'coc-json', 'coc-tsserver', 'coc-eslint', 'coc-phpls']

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
    autocmd BufRead,BufNewFile *.{hbs,ejs,njk,svelte} set filetype=html
    autocmd BufRead,BufNewFile .{jscs,jshint,eslint,prettier,babel}rc set filetype=json
    autocmd QuickFixCmdPost *grep* cwindow
augroup END

" all key mapping
" window navigation in vim
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

set background=light
colorscheme PaperColor

" airline with coc
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
