" $VIMRUNTIME refers to the versioned system directory where Vim stores its
" system runtime files -- /usr/share/vim/vim<version>.
" Vim will load $vimruntime/defaults.vim if the user does not have a vimrc.
" this happens after /etc/vim/vimrc(.local) are loaded, so it will override
" any settings in these files.
"
" if you don't want that to happen, uncomment the below line to prevent
" defaults.vim from being loaded.
" let g:skip_defaults_vim = 1
"
" if you would rather _use_ default.vim's settings, but have the system or
" user vimrc override its settings, then uncomment the line below.
" source $vimruntime/defaults.vim

" all debian-specific settings are defined in $vimruntime/debian.vim and
" sourced by the call to :runtime you can find below.  if you wish to change
" any of those settings, you should do it in this file or
" /etc/vim/vimrc.local, since debian.vim will be overwritten everytime an
" upgrade of the vim packages is performed. it is recommended to make changes
" after sourcing debian.vim so your settings take precedence.

runtime! debian.vim

" uncomment the next line to make vim more vi-compatible
" note: debian.vim sets 'nocompatible'.  setting 'compatible' changes
" numerous options, so any other options should be set after changing
" 'compatible'.
"set compatible

" vim5 and later versions support syntax highlighting. uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" if using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

" uncomment the following to have vim jump to the last position when
" reopening a file
"au bufreadpost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" uncomment the following to have vim load indentation rules and plugins
" according to the detected filetype.
"filetype plugin indent on

" the following are commented out as they cause vim to behave a lot
" differently from regular vi. they are highly recommended though.
"set showcmd		" show (partial) command in status line.
"set showmatch		" show matching brackets.
"set ignorecase		" do case insensitive matching
"set smartcase		" do smart case matching
"set incsearch		" incremental search
set autowrite		" automatically save before commands like :next and :make
"set hidden		" hide buffers when they are abandoned
"set mouse=a		" enable mouse usage (all modes)
set background=dark    " Setting dark mode
set relativenumber
set number
set nowrap


" source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif


" ma config
call plug#begin('~/.vim/plugged')

   " list your plugins here
  Plug 'tpope/vim-sensible'

  Plug 'sirver/ultisnips'
  	let g:UltiSnipsExpandTrigger = '<tab>'
  	let g:UltiSnipsJumpForwardTrigger = '<tab>'
    let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

    
  Plug 'lervag/vimtex'
    let g:tex_flavor='latex'
    let g:vimtex_view_method='zathura'
    let g:vimtex_quickfix_mode=0
    set conceallevel=1
    let g:tex_conceal='abdmg'
    let g:vimtex_compiler_latexmk = {'build_dir' : 'build', 'callback' : 1, 'continuous' : 1, 'executable' : 'latexmk', 'options' : ['-pdf', '-interaction=nonstopmode', '-synctex=1']}


    
  Plug 'KeitaNakamura/tex-conceal.vim'
    set conceallevel=1
    let g:tex_conceal='abdmg'
    hi conceal ctermbg=none

  Plug 'dylanaraps/wal'
    "colorscheme wal
    "set background=dark
	
  " Arborece tree
  Plug 'preservim/nerdtree' 

  " Autocompletion
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
	let g:coc_node_path = "/home/skip/.nvm/versions/node/v24.13.1/bin/node"

  " Automatch
  Plug 'tmsvg/pear-tree'

  " Markdown preview
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

  " Gruvbox
  Plug 'morhetz/gruvbox'
	let g:gruvbox_italic=1
	let g:gruvbox_contrast_dark='soft'

  " fzf
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

call plug#end()

"setlocal spell
"set spelllang=fr
"inoremap <c-l> <c-g>u<esc>[s1z=`]a<c-g>u
colorscheme gruvbox

"refaire (redo) avec 'z'
" nnoremap z <c-r>

" sauvegarder avec 's'
nnoremap s :w<cr>

" window manager 
nnoremap w <c-w>

nnoremap a A
nnoremap A a

" faire en sorte que 'cw' se comporte comme 'ciw'
nnoremap cw ciw
nnoremap yw yiw
nnoremap dw diw
nnoremap vw viw

" quit de maniere efficace
nnoremap S :q<cr>
nnoremap QQQQ :q!<cr>

" copy to clipboard (must have +clipboard option)


" --- configuration des tabulations ---
set tabstop=4       " largeur visuelle d'une tabulation (4 colonnes)
set shiftwidth=4    " indentation automatique = 4 colonnes
set softtabstop=4   " <tab> et <bs> comptent pour 4 espaces en insertion
set noexpandtab     " utiliser des vrais caractères de tabulation, pas des espaces

nnoremap <c-n> :NERDTree<cr>

inoremap <expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

inoremap <c-f> <esc>:silent exec '!cp '.b:vimtex.root.'/figures/temp.png '.b:vimtex.root.'/figures/'.getline('.').'.png'<cr>:silent exec '!drawing '.b:vimtex.root.'/figures/'.getline('.').'.png'<cr>:redraw!<cr><esc>diwa\begin{figure}[!h]<cr>\centering<cr>\includegraphics[width=0.6\textwidth]{figures/<esc>pa.png}<cr>\end{figure}<esc>:w<cr>

inoremap <c-d> <esc>:silent exec '!cp '.b:vimtex.root.'/figures/temp2.png '.b:vimtex.root.'/figures/'.getline('.').'.png'<cr>:silent exec '!drawing '.b:vimtex.root.'/figures/'.getline('.').'.png'<cr>:redraw!<cr><esc>diwa\begin{figure}[!h]<cr>\centering<cr>\includegraphics[width=0.6\textwidth]{figures/<esc>pa.png}<cr>\end{figure}<esc>:w<cr>

nnoremap <c-f> yiwo<esc>p:silent exec '!drawing '.b:vimtex.root.'/figures/'.getline('.').'.png'<cr>:redraw!<cr>dd:w<cr>

nnoremap <c-l> :VimtexCompile<cr>:VimtexView<cr>

vnoremap <SPACE>p P

vnoremap <c-y> y
inoremap <c-v> <esc>"+pa

vnoremap / y/<C-R>=escape(@",'/\')<CR>

nnoremap <c-b> :Buffers<CR>
nnoremap <c-h> :hide edit 

cnoreabbrev ctag exec '!ctags -R ./'
