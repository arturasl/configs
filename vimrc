" vim: foldmethod=marker
" vim: foldmarker={{,}}

" PLUGINS{{
	" PATHOGEN{{
		filetype off
		call pathogen#helptags()
		call pathogen#runtime_append_all_bundles()
   " }}
   " TAGLIST{{
		let Tlist_Auto_Open = 0            " let the tag list open automagically
		let Tlist_Compact_Format = 0       " show small menu
		let Tlist_Exist_OnlyWindow = 1     " close if last window
		let Tlist_File_Fold_Auto_Close = 1 " fold closed other trees
		let Tlist_Use_Right_Window = 1     " show on right side
		let Tlist_Show_One_File = 1        " Displaying tags for only one file

		" show taglist on ->
		map <right> <ESC>:TlistToggle<RETURN>
	" }}
	" LUSTYJUGLER{{
		nmap ,b :LustyJuggler<CR>
	" }}
	" NETRW{{
		let g:netrw_browse_split = 4 " open new buffer in previous window
		let g:netrw_liststyle = 3    " by default use tree view
		let g:netrw_winsize = 25     " default window size
		" show netrw on <-
		map <left> <ESC>:Vexplore<CR>
	" }}
	" OMNICPPCOMPLETE{{
		let OmniCpp_GlobalScopeSearch   = 1  " allow global scope search
		let OmniCpp_NamespaceSearch     = 1  " extract namespaces from current buffer
		let OmniCpp_DisplayMode         = 0  " let omnicppcomplete to choose which members to show
		let OmniCpp_ShowScopeInAbbr     = 0  " do not show abbreviations for scope
		let OmniCpp_ShowPrototypeInAbbr = 0  " do not show abbreviations for prototypes
		let OmniCpp_ShowAccess          = 1  " show access information (+ public, # protected, - private)

		" do not show completion automatically
		let OmniCpp_MayCompleteDot      = 0
		let OmniCpp_MayCompleteArrow    = 0
		let OmniCpp_MayCompleteScope    = 0
		let OmniCpp_LocalSearchDecl     = 0
	" }}
" }}

" FUNCTION_KEYS{{
	" Author of this function:
	" http://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
	function! Preserve(command)
		" Preparation: save last search, and cursor position.
		let _s=@/
		let l = line(".")
		let c = col(".")
		" Do the business:
		execute a:command
		" Clean up: restore previous search history, and cursor position
		let @/=_s
		call cursor(l, c)
		nohl
	endfunction

	function! ShowHelp()
		echo "<F1> Show this help"
		echo "<F2> Reindent"
		echo "<F3> Remove whitespaces from EOL"
		echo "<F4> Check xml syntax"
		echo "<F5> Build"
		echo "<F6> Show invisible chars"
	endfunction

	function! BuildFile()
		silent make
		copen
		redraw!
	endfunction

	nmap <F1> :call ShowHelp()<CR>
	nmap <F2> :call Preserve("normal gg=G") \| echo "Internal"<CR>
	nmap <F3> :call Preserve("%s/\\s\\+$//e")<CR>
	nmap <F4> :!xmllint --valid --noout %<CR>
	nmap <F5> :call BuildFile()<CR>
	nmap <F6> :set list!<CR>
	set listchars=tab:>-,eol:*,nbsp:-,trail:-,extends:>,precedes:<
" }}
" GENERAL{{
	set nocompatible          " use vim defaults
	filetype plugin indent on " load filetype settings
	set number                " show line numbers
	set scrolloff=5           " try to show atleast num lines
	set showmatch             " show matching brackets
	set cursorline            " show current line
	set ruler                 " show the cursor position
	set showcmd               " display incomplete commands
	set mouse=a               " more mouse please :)
	set autochdir             " always switch to the current file directory
	set visualbell t_vb=      " no bell just blink
	set virtualedit=all       " let cursor fly anythere
	set hidden                " switch buffers without saving
	let g:tex_flavor='latex'
" }}
" COLORS{{
	set background=dark " dark background (must be before syntax on)
	syntax on           " syntax highlight
	set t_Co=256        " all colours :)

	function! ShiftColors()
		if !exists('g:nShifColors') || g:nShifColors == 0
			let g:nShifColors  = 1
			let g:lucius_style = 'dark'

			colorscheme lucius
		elseif g:nShifColors == 1
			let g:nShifColors  = 0
			let g:lucius_style = 'light'

			colorscheme lucius
		endif
	endfunction

	call ShiftColors()
" }}
" WRAPPING{{
	set wrap      " yes, wrap lines
	set linebreak " but do not cut in a middle of word
	"move by screen lines not by file
	nmap j gj
	vmap j gj

	nmap k gk
	vmap k gk
" }}
" INDENTION{{
	set autoindent             " copy indention from prev line
	set cindent                " c indention
	set shiftwidth=4           " numbers of spaces to <> commands
	set softtabstop=4          " if someone uses spaces delete them with backspace
	set tabstop=4              " numbers of spaces of tab character
	set noexpandtab            " use tab character
	" show me then tabs are used for alignment
	" show whitespaces which are at the end of file
	match Error /\s\+$\|[^\t]\zs\t\+/
" }}
" SEARCHING_SETTINGS{{
	set ignorecase " case insensetive search
	set smartcase  " unless capitals are use
	set incsearch  " search while typying
	set hlsearch   " show all results
	set gdefault   " append g to substitution automatically
	" use regex that is more like pcre by default
	nnoremap / /\v
	vnoremap / /\v
" }}
" TMP_FILES{{
	set backup
	set backupext=.bak
	set backupdir=~/.vim/tmp/backups/

	set swapfile
	set directory=~/.vim/tmp/swap/

	if has('persistent_undo')
		set undofile
		set undodir=~/.vim/tmp/undo/
	endif
"}}
" COMPLETION{{
	" pop-up menu settings
	set completeopt=menuone,menu,longest,preview

	if has("autocmd")
		" automatically close preview window
		autocmd CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
	endif

	" load tags, specific to the language defined by strLang parameter
	function! LoadLangTags(strLang)
		let l:files = split(globpath('~/.vim/tags/', a:strLang . '_*.tags'), '\n')
		for l:strTag in l:files
			execute 'setlocal tags+='.l:strTag
		endfor
	endfunction
" }}

" LANG_SPECIFIC{{
	if has("autocmd")
	" JAVA{{
		autocmd FileType java setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
		autocmd FileType java setlocal foldmethod=syntax foldnestmax=2

		autocmd Filetype java setlocal omnifunc=javacomplete#Complete
		" too slow
		"autocmd Filetype java imap <buffer> . .<C-x><C-o>

		" do not indent classes (-C) as it will result in double indention
		" use for spaces (s4)
		autocmd FileType java nmap <buffer> <F2> :call Preserve('%!astyle -s4 -c -aC -S -N -L -w -Y -f -p -H -U -j -k3 -q -z2') \| echo "AStyle Java"<CR>

		function! SetMakeForJava()
			if getftype('makefile') ==? 'file' || getftype('Makefile') ==? 'file'
				setlocal makeprg=make\ $*
				setlocal errorformat=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
			else
				setlocal makeprg=javac\ %
				setlocal errorformat=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
			endif
		endfunction

		autocmd FileType java call SetMakeForJava()
	" }}
	" C/CPP{{
		autocmd FileType c,cpp setlocal foldmethod=syntax foldnestmax=1

		autocmd FileType cpp call LoadLangTags('cpp')
		autocmd Filetype c,cpp imap <buffer> . .<C-x><C-o>
		autocmd Filetype c,cpp imap <buffer> -> -><C-x><C-o>
		autocmd Filetype c,cpp imap <buffer> :: ::<C-x><C-o>

		autocmd FileType c,cpp nmap <buffer> <F2> :call Preserve('%!astyle -T4 -a -C -S -N -L -w -Y -f -p -H -U -j -k3 -q -z2') \| echo "AStyle Cpp"<CR>

		function! SetMakeForCpp()
			if getftype('makefile') ==? 'file' || getftype('Makefile') ==? 'file'
				setlocal makeprg=make\ $*
			elseif &ft ==? 'c'
				setlocal makeprg=gcc\ -g\ -Wall\ -pedantic\ -std=c99\ -Wno-long-long\ $*\ %\ -o\ %:r
			elseif &ft ==? 'cpp'
				setlocal makeprg=g++\ -g\ -Wall\ -pedantic\ -std=c++98\ -Wno-long-long\ $*\ %\ -o\ %:r
			else
				setlocal makeprg=$*
			endif
		endfunction

		autocmd FileType c,cpp call SetMakeForCpp()
	" }}
	endif
" }}
