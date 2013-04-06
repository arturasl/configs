" vim: foldmethod=marker
" vim: foldmarker={{,}}

" PLUGINS{{
	" PATHOGEN{{
		runtime bundle/vim-pathogen/autoload/pathogen.vim
		execute pathogen#infect()
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
	" TCOMMENT{{
		let g:tcommentMaps = 0

		nnoremap ,ci :TComment<CR>
		xnoremap ,ci :TComment<CR>
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
	" NRV {{
		xnoremap ,nw :NR<CR>
		xnoremap ,nb :NR!<CR>
		xnoremap ,np :NRP<CR>
		nnoremap ,np :NRP<CR>
		"nnoremap ,ns :call Preserve(['g/<C-R>//NRP', 'NRM!'])<CR> - reset position in wrong buffer
		nnoremap ,ns :g/<C-R>//NRP<CR>:NRM<CR>
	" }}
	" SYNTASTIC {{
		let g:syntastic_check_on_open=1
		let g:syntastic_error_symbol='|✗'
		let g:syntastic_warning_symbol='|⚠'
		let g:syntastic_style_error_symbol='S✗'
		let g:syntastic_style_warning_symbol='S⚠'
		let g:syntastic_auto_loc_list=0 " do not open/close error window automatically

		let g:syntastic_mode_map = {
			\ 'mode': 'active',
			\ 'passive_filetypes': ['tex']
		\ }

		" JAVASCRIPT
		let g:syntastic_javascript_checkers=['jslint']
		let g:syntastic_javascript_jslint_conf = "--continue"
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
		if type(a:command) == type([])
			for l:cmd in a:command
				execute l:cmd
			endfor
		else
			execute a:command
		endif
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
	" paste from clipboard without reformatting text
	noremap ,p :set invpaste<CR>
	noremap ,p+ :silent! set paste<CR>"+p:set nopaste<CR>
	noremap ,p* :silent! set paste<CR>"*p:set nopaste<CR>

	let g:tex_flavor='latex'
	let mapleader='\' " map leader to something I do not use (in case some plugin maps keys without my permission)
" }}
" COLORS{{
	set background=dark           " dark background (must be before syntax on)
	syntax on                     " syntax highlight
	let g:load_doxygen_syntax = 1 " if you can, highlight doxygen comments
	set t_Co=256                  " all colours :)

	let g:nShifColors = 0
	function! ShiftColors()
		colorscheme lucius
		if g:nShifColors == 0
			let g:nShifColors  = 1
			LuciusBlackLowContrast
			" do not hide cursor
			hi MatchParen cterm=bold ctermbg=none ctermfg=67
		elseif g:nShifColors == 1
			let g:nShifColors  = 0
			LuciusLightHighContrast
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
	" show match in the center of window (and open folds)
	nnoremap n nzzzR
	nnoremap N NzzzR
" }}
" TMP_FILES{{
	set backup
	set backupext=.bak
	set backupdir=~/.vim/tmp/backups/

	set swapfile
	" use double // to use full path as swap file name
	set directory=~/.vim/tmp/swap//

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
" WINDOWS{{
	" resizing windows
	nnoremap <C-j> :resize -2<CR>
	nnoremap <C-k> :resize +2<CR>
	nnoremap <C-h> 2<C-w><
	nnoremap <C-l> 2<C-w>>
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
											\ execute 'silent !~/configs/scripts/showme.bash --silent-detached %:r.pdf &>/dev/null &'|
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
				setlocal makeprg=m4\ -P\ $*\ %\ >\ %:r
			endif
		endfunction

		" for m4 use syntax of original file if possible
		function! SetSyntaxForM4()
			let l:pathComponents = split(expand('%:t'), '\.')
			if len(l:pathComponents) < 3
				return
			endif

			let s:mapSyntaxForM4Extensions = {'css': 1} " put here extensions of files that we need to support
			let l:ext = l:pathComponents[-2]

			if get(s:mapSyntaxForM4Extensions, l:ext, 0) == 0
				return
			endif

			execute 'set syntax=' . l:ext

			syntax match M4Keyword display 'm4_[a-zA-Z0-9_]\+'
			highlight link M4Keyword Special

			syntax match M4Constant display '\<C_[A-Z0-9_]\+\>'
			highlight link M4Constant Constant

			syntax match M4Quotes display "`.\{-}'"
			highlight link M4Quotes Identifier
		endfunction

		autocmd FileType m4 call SetMakeForM4() | call SetSyntaxForM4()
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
		function! RSTEnter()
			let c_col = col('.')
			let c_line = line('.')
			let line = getline('.')

			let cstart = c_col - 1
			while cstart >= 0
				if line[cstart] == '[' | break | endif
				if line[cstart] == ']' | let cstart = -1 | break | endif
				let cstart -= 1
			endwhile

			let cend = c_col - 1
			while cend < len(line)
				if line[cend] == ']' | break | endif
				if line[cend] == '[' | let cend = len(line) | break | endif
				let cend += 1
			endwhile

			let matched = ' '
			if cstart != -1 && cend != len(line)
				let matched = strpart(line, cstart + 1, cend - cstart - 1)
			endif

			if matched != ' '
				exec 'normal :e ' . escape(matched, ' \') . "\e"
			elseif match(line, '\[ \]') != -1
				call cursor(c_line, match(line, '\[ \]') + 2)
				" put date into braces and cut it to register
				exec 'normal i ' . strftime('%y-%m-%d %H:%M') . "\e"
				normal dd
				"
				" go to first empty line after todo paragraph (if non - create one)
				if getline('.') != ''
					normal }
				endif
				if line('$') == line('.') && getline('.') != ''
					call append('.', '')
					+1
				endif
				"
				" if there are no done header create one
				if line('$') == line('.') || getline(line('.') + 1) != 'Done:'
					call append('.', '')
					call append('.', '')
					call append(line('.') - 1, '')
					normal iDone:
					-1 " we are still on empty line before header
				endif
				"
				" put item in done block
				+2
				normal p
				"
				" go back to the previous position
				call cursor(c_line, c_col)
			endif
		endfunction

		function! SetMakeForRST()
			setlocal makeprg=pandoc\ --to=html5\ --highlight-style=pygments\ --standalone\ --normalize\ --tab-stop=2\ '--output=/tmp/%.html'\ '%'\ &&\ ~/configs/scripts/showme.bash\ '/tmp/%.html'
		endfunction

		autocmd! BufRead,BufNewFile *.rst,*.mkd
			\ call SetMakeForRST() |
			\ setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab |
			\ nnoremap <buffer> <ENTER> :call RSTEnter()<CR>

	" }}
	" PASCAL {{
		function! SetMakeForPascal()
			setlocal makeprg=fpc\ %
			setlocal errorformat=%f(%l\\,%c)\ %m
		endfunction

		autocmd bufreadpre,bufnewfile *.PAS set ft=pascal
		autocmd FileType pascal call SetMakeForPascal()
	" }}
	" MAIL {{
		autocmd FileType mail setlocal spell formatoptions+=aw
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
