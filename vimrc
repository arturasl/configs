" vim: foldmethod=marker
" vim: foldmarker={{,}}

" PLUGINS{{
	" PATHOGEN{{
		if !exists('g:bPathogenLoaded')
			let g:bPathogenLoaded = 1

			filetype off
			call pathogen#helptags()
			call pathogen#runtime_append_all_bundles()
		endif
	" }}
	" TAGBAR{{
		let g:tagbar_compact = 1            " Do not show header and empty lines
		let g:tagbar_singleclick = 1        " Use single mouse click to go to tag definition
		let g:tagbar_iconchars = ['▶', '▼'] " Fold icons
		" tags for latex
		let g:tagbar_type_tex = {
			\ 'ctagstype' : 'latex',
			\ 'kinds' : [
				\ 's:sections',
				\ 'g:graphics:0:0',
				\ 'l:labels',
				\ 'r:refs:1:0',
				\ 'p:pagerefs:1:0'
			\ ],
			\ 'sort' : 0,
		\ }

		" show tagbar on ->
		nnoremap <right> <ESC>::TagbarToggle<RETURN>
	" }}
	" LUSTYJUGLER{{
		nnoremap ,b :LustyJuggler<CR>
	" }}
	" NETRW{{
		let g:netrw_browse_split = 4 " open new buffer in previous window
		let g:netrw_liststyle = 3    " by default use tree view
		let g:netrw_winsize = 25     " default window size
		" show netrw on <-
		nnoremap <left> <ESC>:Vexplore<CR>
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
	" FUZZY_FINDER{{
		nnoremap ,tb :FufBuffer<CR>
		nnoremap ,tf :FufFile<CR>
		nnoremap ,tq :FufQuickfix<CR>
		nnoremap ,tt :FufBufferTag<CR>
	" }}
	" NERD_COMMENTER{{
		let g:NERDCreateDefaultMappings=0

		nnoremap ,ci :call NERDComment(0, "invert")<CR>
		xnoremap ,ci <ESC>:call NERDComment(1, "invert")<CR>

		nnoremap ,cs :call NERDComment(0, "sexy")<CR>
		xnoremap ,cs <ESC>:call NERDComment(1, "sexy")<CR>


		nnoremap ,c<space> :call NERDComment(0, "toggle")<CR>
		xnoremap ,c<space> <ESC>:call NERDComment(1, "toggle")<CR>
	" }}
	" DBEXT{{
		" execute paragraph
		nnoremap ,dp :call Preserve('normal vip\se')<CR>
		" execute statement
		nnoremap ,de :DBExecSQLUnderCursor<CR>
		" execute line
		nnoremap ,dl :call Preserve('normal V\se')<CR>

		" connect
		nnoremap ,dc :DBPromptForBufferParameters<CR>
		" describe
		nnoremap ,dd :DBDescribeTable<CR>
	" }}
	" FSWITCH{{
	if has("autocmd")
		augroup plugin_fswitch
		autocmd!
			autocmd BufEnter *.cpp,*.c let b:fswitchdst = 'h,hpp' " companion file extension
						\ | let b:fswitchlocs = 'reg:/src/include/,./' " if relative path end with src or source use ../include, else us current dirctory
			autocmd BufEnter *.hpp,*.h let b:fswitchdst = 'cpp,c'
			                       \ | let b:fswitchlocs = 'reg:/include/src/,./'
		augroup END
	endif

	nmap ,s :FSHere<CR>
	" }}
	" PROTODEF{{
		let g:disable_protodef_mapping = 1 " I will define my own mappings
		let g:protodefprotogetter = '~/configs/vim/bundle/protodef/pullproto.pl'
        nmap ,i i<C-r>=protodef#ReturnSkeletonsFromPrototypesForCurrentBuffer({})<CR><ESC>='[
	" }}
	" GUNDO {{
		nnoremap <down> :GundoToggle<CR>
		let g:gundo_preview_bottom = 1
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
		echo "<F7> Switch line number mode"
	endfunction

	function! BuildFile()
		" make current project, but do not jump to first error
		make!
		" open quickfix on error
		cwindow
		" run from quickfix window
		if &buftype ==? 'quickfix'
			wincmd p
		endif
	endfunction

	noremap <F1> :call ShowHelp()<CR>
	noremap <F2> :call Preserve("normal gg=G") \| echo "Internal"<CR>
	noremap <F3> :call Preserve("%s/\\s\\+$//e")<CR>
	noremap <F4> :!xmllint --valid --noout %<CR>
	noremap <F5> :call BuildFile()<CR>
	noremap <F6> :set list!<CR>
	noremap <F7> :if &rnu \| set nu \| else \| set rnu \| endif<CR>
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
	if has('mouse')
		set mouse=a           " more mouse please :)
	endif
	if exists('+autochdir')
		set autochdir         " always switch to the current file directory
	endif
	set visualbell t_vb=      " no bell just blink
	set virtualedit=all       " let cursor fly anythere
	set hidden                " switch buffers without saving
	set wildmenu              " show all matched, let narrow results, then let iterate through results
	set wildmode=longest:full,full
	set wildignore=*.o,*.obj,*.class " do not show file in wildmenu
	set lazyredraw            " do not update screen while doing batch changes
	set fileformats=unix,dos,mac  " for new files use unix line endings. Choose between unix, dos or mac
	set fileencodings=ucs-bom,utf-8,latin1 " encodings to try for existing files (for new one - utf-8)

	let g:tex_flavor='latex'
	let mapleader='\'
" }}
" COLORS{{
	set background=dark           " dark background (must be before syntax on)
	syntax on                     " syntax highlight
	let g:load_doxygen_syntax = 1 " if you can, highlight doxygen comments
	set t_Co=256                  " all colours :)

	let g:nShifColors = 0
	function! ShiftColors()
		if g:nShifColors == 0
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
	nnoremap j gj
	xnoremap j gj

	nnoremap k gk
	xnoremap k gk
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
	xnoremap / /\v
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
" GUI{{
	if has("gui_running")
		set guioptions-=T " remove toolbar
		set guioptions-=t " do not allow to tear off menu items (float around as separate window)
		set guioptions-=m " remove menu
	endif
" }}

" LANG_SPECIFIC{{
	if has("autocmd")
		augroup language_specific
		autocmd!
	" JAVA{{
		autocmd FileType java setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
		autocmd FileType java setlocal foldmethod=syntax foldnestmax=2

		autocmd Filetype java setlocal omnifunc=javacomplete#Complete
		" too slow
		"autocmd Filetype java imap <buffer> . .<C-x><C-o>

		" do not indent classes (-C) as it will result in double indention
		" use for spaces (s4)
		autocmd FileType java nnoremap <buffer> <F2> :call Preserve('%!astyle -s4 -c -a -S -N -L -w -Y -f -p -H -U -j -k3 -q -z2') \| echo "AStyle Java"<CR>

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
		autocmd Filetype c,cpp inoremap <buffer> . .<C-x><C-o>
		autocmd Filetype c,cpp inoremap <buffer> -> -><C-x><C-o>
		autocmd Filetype c,cpp inoremap <buffer> :: ::<C-x><C-o>

		autocmd FileType c,cpp nnoremap <buffer> <F2> :call Preserve('%!astyle -T4 -a -C -S -N -L -w -Y -f -p -H -U -j -k3 -q -z2') \| echo "AStyle Cpp"<CR>

		function! SetMakeForCpp()
			if getftype('makefile') ==? 'file' || getftype('Makefile') ==? 'file'
				setlocal makeprg=make\ $*
			elseif &ft ==? 'c'
				setlocal makeprg=gcc\ -g\ -Wall\ -pedantic\ -std=c99\ -Wno-long-long\ $*\ %\ -o\ %:r
			elseif &ft ==? 'cpp'
				if expand('%:t') ==? 'code.cpp'
					" less restrictive so that gnu specific keywords would be
					" allowed
					setlocal makeprg=g++\ -g\ -Wall\ -pedantic\ -std=gnu++98\ -Wno-long-long\ $*\ %\ -o\ %:r
				else
					setlocal makeprg=g++\ -g\ -Wall\ -pedantic\ -std=c++98\ -Wno-long-long\ $*\ %\ -o\ %:r
				endif
			else
				setlocal makeprg=$*
			endif
		endfunction

		autocmd FileType c,cpp call SetMakeForCpp()
	" }}
	" DOT{{
		function! SetMakeForDot()
			if getftype('makefile') ==? 'file' || getftype('Makefile') ==? 'file'
				setlocal makeprg=make\ $*
			else
				setlocal makeprg=dot\ %\ -Tpng\ -O
			endif
		endfunction

		autocmd FileType dot call SetMakeForDot()
	" }}
	" TEX{{
		function! SetMakeForTex()
			if getftype('makefile') ==? 'file' || getftype('Makefile') ==? 'file'
				setlocal makeprg=make\ $*
			else
				autocmd QuickFixCmdPost make
										\ if &ft ==? 'tex'|
											\ execute 'silent !evince %:r.pdf &>/dev/null &'|
										\ endif

				setlocal makeprg=pdflatex\ -shell-escape\ -file-line-error\ -interaction=nonstopmode\ %
				setlocal errorformat=%f:%l:\ %m
			endif
		endfunction

		autocmd FileType tex call SetMakeForTex()
	" }}
	" PYTHON{{
		" use spaces
		autocmd FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab

		function! GetPythonFoldLvl(nLine)
			let l:strLine         = getline(a:nLine)
			let l:nCurIndentation = indent(a:nLine) / &tabstop
			let l:nSetFoldTo      = 0
			let l:chPrefix        = ''

			if l:strLine =~ ':\s*$'
				" we start block at any line ending with colon
				let l:nSetFoldTo = l:nCurIndentation + 1
				let l:chPrefix   = '>'
			elseif l:strLine == ''
				let l:nNextLine = nextnonblank(a:nLine + 1)

				if l:nNextLine != 0
					" empty lines mimics folding from next non empty line (by indentation level)
					let l:nSetFoldTo = indent(l:nNextLine) / &tabstop
				endif
			else
				let l:nSetFoldTo = l:nCurIndentation
			endif

			if l:nSetFoldTo <= &foldnestmax
				" if folding is not to big return it
				return l:chPrefix . l:nSetFoldTo
			endif

			" fall back to maximum folding allowed
			return &foldnestmax
		endfunction

		" folding
		autocmd FileType python setlocal foldmethod=expr foldexpr=GetPythonFoldLvl(v:lnum) foldnestmax=1

		function! SetMakeForPython()
			if getftype('makefile') ==? 'file' || getftype('Makefile') ==? 'file'
				setlocal makeprg=make\ $*
			else
				setlocal makeprg=pylint\ --output-format=parseable\ --reports=n\ %
				setlocal errorformat=%f:%l:\ [%t]%m,%f:%l:%m
			endif
		endfunction

		" makeprg
		autocmd FileType python call SetMakeForPython()

		" formating
		autocmd FileType python nnoremap <buffer> <F2> :call Preserve('%!PythonTidy.py') \| echo "PythonTidy"<CR>
	" }}
	" PHP{{
		autocmd FileType php setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
	" }}
	" M4{{
		function! SetMakeForM4()
			if getftype('makefile') ==? 'file' || getftype('Makefile') ==? 'file'
				setlocal makeprg=make\ $*
			else
				setlocal makeprg=m4\ -P\ -g\ $*\ %\ >\ %:r
			endif
		endfunction

		autocmd FileType m4 call SetMakeForM4()
	" }}
	" JSON{{
		autocmd! BufRead,BufNewFile *.json set filetype=json
		autocmd FileType json nnoremap <buffer> <F2> :call Preserve('%!python -mjson.tool')<CR>
	" }}
	" BNF{{
		autocmd bufreadpre,bufnewfile *.bnf set ft=bnf
	" }}
	" JAVASCRIPT{{
		function! SetMakeForJavaScript()
			setlocal makeprg=jslint\ --continue\ --\ %
			" http://stackoverflow.com/questions/3713015/vim-errorformat-and-jslint
			setlocal errorformat=%-P%f,
				\%E%>\ #%n\ %m,%Z%.%#Line\ %l\\,\ Pos\ %c,
				\%-G%f\ is\ OK.,%-Q
		endfunction

		autocmd FileType javascript call SetMakeForJavaScript()
	" }}
	" ASN.1 {{
		autocmd bufreadpre,bufnewfile *.der
			\ noremap <buffer> <F5> G:call Preserve('silent r!openssl asn1parse -inform DER -in %') \| setlocal readonly<CR>

		autocmd bufreadpre,bufnewfile *.crt
			\ noremap <buffer> <F5> G:call Preserve('silent r!openssl x509 -in % -noout -text') \| setlocal readonly<CR>
		autocmd bufreadpre,bufnewfile *.key
			\ noremap <buffer> <F5> G:call Preserve('silent r!openssl rsa -in % -noout -text') \| setlocal readonly<CR>
	" }}
	" RST {{
		function! SetMakeForRST()
			setlocal makeprg=pandoc\ --standalone\ --latexmathml\ %\ >\ /tmp/%\ &&\ firefox\ /tmp/%
		endfunction

		autocmd! BufRead,BufNewFile *.rst,*.mkd
			\ call SetMakeForRST() |
			\ setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab

	" }}
	" PASCAL {{
		autocmd bufreadpre,bufnewfile *.PAS set ft=pascal
	" }}
		augroup END
	endif
" }}

" ADDITIONAL_SETTING {{
	function! LoadAdditionalSetting()
		let l:configFile = findfile('vim_additional.vim', '.;') " search upwards
		if l:configFile != ''
			echo 'Using configuration file:' . l:configFile
			sleep 1
			exec 'source ' . l:configFile
		endif
	endfunction
	autocmd! bufreadpre,bufnewfile * :call LoadAdditionalSetting()
" }}
