" vim: foldmethod=marker
" vim: foldmarker={{,}}

" UTIL {{
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

	function! UtilToogleWindow(windowName, openCmd)
		let l:win = bufwinnr(a:windowName)
		if l:win != -1
			execute l:win . ' wincmd w'
			silent! close
		else
			execute a:openCmd
			return bufnr('%')
		endif
	endfunction

	" Searches for given items in parent directories
	" @param withOneOfItems arrays of items to search for items are objects what
	"        must contain `name` key (indicating item to search for), and may have
	"        on of the following keys:
	"        `isDir` - indicates that item is a directory not regular file
	"        `findLast` - indicates that this function should not stop searching
	"        and try to find additional item in parent directory
	" @param giveDirectory (=0) if this parameter is set this function will return
	"        directory in which item lies not the item itself
	" @param startFromDirectory (='.') indicates from which directory begin
	"        searching
	function! FindRoot(withOneOfItems, ...)
		let l:giveDirectory = 0
		let l:startFromDirectory = '.'
		if a:0 > 0 | let l:giveDirectory = a:1 | endif
		if a:0 > 1 | let l:startFromDirectory = a:2 | endif

		for l:item in a:withOneOfItems
			let l:found = ''
			if has_key(l:item, 'isDir') && l:item.isDir
				let l:found = finddir(l:item.name, l:startFromDirectory . ';')
			else
				let l:found = findfile(l:item.name, l:startFromDirectory . ';')
			endif

			if empty(l:found)
				continue
			endif

			let l:found = fnamemodify(l:found, ':p')

			if has_key(l:item, 'isDir') && l:item.isDir
				" :h will remove trailing slash from directory name and
				" additional :h will give actual parent directory without
				" slash.
				let l:foundInDir = fnamemodify(l:found, ':h:h')
			else
				let l:foundInDir = fnamemodify(l:found, ':h')
			endif
			" always add a trailing slash for directories
			let l:foundInDir = fnamemodify(l:foundInDir . '/', ':p')

			if has_key(l:item, 'findLast') && l:item.findLast
				let l:foundRecursively = FindRoot(a:withOneOfItems, l:giveDirectory, fnamemodify(l:foundInDir, ':h:h'))
				if !empty(l:foundRecursively)
					return l:foundRecursively
				endif
			endif

			if l:giveDirectory
				return l:foundInDir
			else
				return l:found
			endif
		endfor

		return ''
	endfunction

	function! FindProjectsRoot()
		let l:projectsDirecoty = FindRoot([
			\ {'name': '.git', 'isDir': 1}
			\ , {'name': '.svn', 'isDir': 1, 'findLast': 1}
		\ ], 1)

		if empty(l:projectsDirecoty)
			return './'
		else
			return l:projectsDirecoty
		endif
	endfunction
" }}

" BUNDLES{{
	if has('vim_starting')
		if empty(glob('~/.vim/bundle/neobundle.vim'))
			execute '!curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh'
		endif
		set nocompatible
		set runtimepath+=~/.vim/bundle/neobundle.vim
	endif
	call neobundle#begin(expand('~/.vim/neobundle/'))

	NeoBundle 'Shougo/vimproc.vim', { 'build': {'unix': 'make'} }

	NeoBundle 'Raimondi/delimitMate'
	NeoBundle 'Shougo/neocomplete.vim'
	NeoBundle 'Shougo/unite.vim'
	NeoBundle 'SirVer/ultisnips'
	NeoBundle 'bling/vim-airline'
	NeoBundle 'chrisbra/NrrwRgn'
	NeoBundle 'davidhalter/jedi-vim'
	NeoBundle 'derekwyatt/vim-fswitch'
	NeoBundle 'derekwyatt/vim-protodef'
	NeoBundle 'embear/vim-localvimrc'
	NeoBundle 'godlygeek/tabular'
	NeoBundle 'jonathanfilip/vim-lucius'
	NeoBundle 'jpalardy/vim-slime'
	NeoBundle 'kien/rainbow_parentheses.vim'
	NeoBundle 'majutsushi/tagbar'
	NeoBundle 'mattn/emmet-vim'
	NeoBundle 'scrooloose/syntastic'
	NeoBundle 'sjl/gundo.vim'
	NeoBundle 'tomtom/tcomment_vim'
	NeoBundle 'tpope/vim-repeat'
	NeoBundle 'tpope/vim-sleuth'
	NeoBundle 'tpope/vim-surround'
	NeoBundle 'vim-scripts/matchit.zip.git'
	NeoBundle 'yegappan/mru'
	" NeoBundle 'junegunn/limelight.vim'
	NeoBundle 'haya14busa/incsearch.vim'

	NeoBundle '~/configs/vim/bundle/bufkill/'
	NeoBundle '~/.vim/bundle/Spelling/'

	" Languages
	NeoBundle 'elzr/vim-json'

	" NeoBundle 'tpope/vim-markdown'
	" NeoBundle 'nelstrom/vim-markdown-folding'
	NeoBundle 'vim-pandoc/vim-pandoc'
	NeoBundle 'vim-pandoc/vim-pandoc-syntax'
	NeoBundle 'vim-pandoc/vim-pandoc-after'

	NeoBundle 'groenewege/vim-less'
	NeoBundle 'alunny/pegjs-vim'
	NeoBundle 'Shirk/vim-gas'
	NeoBundle 'vim-scripts/bnf.vim'

	call neobundle#end()
" }}

" PLUGINS{{
	" INCSHEARCH{{
		map /  <Plug>(incsearch-forward)
		map ?  <Plug>(incsearch-backward)
		let g:incsearch#magic = '\v'
		augroup incsearch-keymap
			autocmd!
			autocmd VimEnter call s:incsearch_keymap()
		augroup END
		function! s:incsearch_keymap()
			IncSearchNoreMap <C-f> <Right>
			IncSearchNoreMap <C-b> <Left>
		endfunction
	" }}
	" RAINBOW PARENTHESIS{{
		if has("autocmd")
			augroup plugin_rainbow_parenthesis
			autocmd!
			autocmd FileType lisp :RainbowParenthesesToggle
			augroup END
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
		nnoremap <right> <esc>:TagbarToggle<cr>
	" }}
	" UNITE {{
		let g:unite_data_directory = expand('~/configs/vim/tmp/unite')
		let g:unite_split_rule     = 'botright'
		call unite#filters#matcher_default#use(['matcher_fuzzy'])

		nnoremap ,b :Unite -quick-match buffer<cr>

		" while it is possible to use ! to indicate 'projects root' use internal
		" function as it might be used in other plases
		nnoremap ,t :execute ':Unite -start-insert file_rec/async:' . FindProjectsRoot()<cr>

		call unite#util#set_default('g:unite_source_grep_command', 'g')
		call unite#util#set_default('g:unite_source_grep_default_opts', '--color=never')
		nnoremap ,g :execute ':Unite -no-split -auto-preview grep:' . FindProjectsRoot()<cr>
	" }}
	" SLIME {{
		let g:slime_target = "tmux"
		let g:slime_no_mappings  = 1
		let g:slime_paste_file = expand('~/configs/vim/tmp/slime')

		" execute paragrap
		nmap ,ep <Plug>SlimeParagraphSend
		" " execute line
		nmap ,el <plug>SlimeLineSend
		" " execute custom prompt
		" use execute in order to ignore white space errors
		execute('nnoremap ,ee :SlimeSend1 ')

		" " connect
		nnoremap ,ec :SlimeConfig<cr>
	" }}
	" NETRW{{
		let g:netrw_browse_split = 4 " open new buffer in previous window
		let g:netrw_liststyle = 3    " by default use tree view
		let g:netrw_winsize = 25     " default window size
		" show netrw on <-
		let g:netrw_buffer_nr = -1
		nnoremap <left> :let g:netrw_buffer_nr = UtilToogleWindow(g:netrw_buffer_nr, ':Vexplore')<cr>
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
	" TCOMMENT{{
		let g:tcommentMaps = 0

		nnoremap ,ci :TComment<cr>
		xnoremap ,ci :TComment<cr>
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

	nnoremap ,s :FSHere<cr>
	" }}
	" PROTODEF{{
		let g:disable_protodef_mapping = 1 " I will define my own mappings
		let g:protodefprotogetter = '~/configs/vim/bundle/protodef/pullproto.pl'
		nnoremap ,i i<c-r>=protodef#ReturnSkeletonsFromPrototypesForCurrentBuffer({})<cr><esc>='[
	" }}
	" GUNDO {{
		nnoremap <down> :GundoToggle<cr>
		let g:gundo_preview_bottom = 1
	" }}
	" NRV {{
		xnoremap ,nw :NR<cr>
		xnoremap ,nb :NR!<cr>
		xnoremap ,np :NRP<cr>
		nnoremap ,np :NRP<cr>
		"nnoremap ,ns :call Preserve(['g/<c-r>//NRP', 'NRM!'])<cr> - reset position in wrong buffer
		nnoremap ,ns :g/<c-r>//NRP<cr>:NRM<cr>
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
		let g:syntastic_javascript_jslint_conf = "--continue --regexp --white"

		" CSS
		let g:syntastic_csslint_options = "--ignore=box-model,adjoining-classes,unique-headings,qualified-headings"
	" }}
	" MRU {{
		nnoremap <up> :call UtilToogleWindow('__MRU_Files__', ':MRU')<cr>

		let MRU_Max_Entries = 1000
		let MRU_Exclude_Files = '.*/tmp/.*'
		let MRU_Max_Menu_Entries = 100
	" }}
	" DELIMITMATE {{
		let g:delimitMate_excluded_regions = "String"
		let g:delimitMate_expand_space = 1
		let g:delimitMate_expand_cr = 1
		let g:delimitMate_matchpairs = "(:),[:],{:}"

		autocmd!
			autocmd FileType xml,html let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
		augroup END
	" }}
	" BUFKILL {{
		let g:BufKillCreateMappings = 0
		let g:BufKillCommandPrefix = "BufKill"
		cabbrev bun BufKillUN
		cabbrev bw BufKillW
		cabbrev bd BufKillD
	" }}
	" JEDI-VIM {{
		let g:jedi#completions_enabled = 0 " will use neocomplete for that
		let g:jedi#goto_assignments_command = "<c-]>"
		let g:jedi#popup_on_dot = 1
		let g:jedi#popup_select_first = 1
		let g:jedi#documentation_command = "K"
		let g:jedi#show_call_signatures = 1
		let g:jedi#use_tabs_not_buffers = 0
	" }}
	" AIRLINE {{
		set ttimeoutlen=50
		let g:airline_exclude_preview = 1
		let g:airline_left_sep = ''
		let g:airline_right_sep = ''
	" }}
	" LOCALVIMRC {{
		let g:localvimrc_persistent = 2 " store all decisions
		let g:localvimrc_persistence_file = expand('~/configs/vim/tmp/localvimrc_persistent')
	" }}
	" NEOCOMPLETE {{
		let g:neocomplete#enable_at_startup = 1
		let g:neocomplete#auto_completion_start_length = 4
		let g:neocomplete#min_keyword_length = g:neocomplete#auto_completion_start_length
		let g:neocomplete#enable_smart_case = 0
		let g:neocomplete#enable_fuzzy_completion = 1
		let g:neocomplete#data_directory = expand('~/configs/vim/tmp/neocomplete')
	" }}
	" ULTISNIPS {{
		let g:UltiSnipsSnippetsDir = expand('~/configs/vim/snips')
		let g:UltiSnipsSnippetDirectories = ['UltiSnips', g:UltiSnipsSnippetsDir]
		let g:UltiSnipsExpandTrigger = '<tab>'
		let g:UltiSnipsJumpForwardTrigger = '<tab>'
		let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
		let g:UltiSnipsNoPythonWarning = 1
		let g:UltiSnipsUsePythonVersion = 2
	" }}
	" PANDOC {{
		let g:pandoc#syntax#codeblocks#embeds#langs = ["ruby", "python", "sql", "bash=sh", "tex", "cpp"]
		let g:pandoc#syntax#conceal#blacklist = ['codeblock_delim']
	" }}
" }}

" FUNCTION_KEYS{{
	function! ShowHelp()
		echo "<F1> Show this help"
		echo "<F2> Reindent"
		echo "<F3> Remove whitespaces from EOL"
		echo "<F4> Check xml syntax"
		echo "<F5> Build"
		echo "<F6> Show invisible chars"
		echo "<F7> Switch line number mode"
		echo "<F8> Show indentent blocks"
		echo "<F10> Show highlighing group"
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

	let g:toogleShowIndententBlocksIds = []
	function! ToogleShowIndententBlocks()
		let l:MAX_DEPTH = 9 " no more than 9
		let l:space = ' '
		let l:spaceMulti = &shiftwidth
		let l:BG = 233

		if &expandtab == 0 " no more than 9
			let l:space = '\t'
			let l:spaceMulti = 1
		endif

		if empty(g:toogleShowIndententBlocksIds)
			for i in range(1, l:MAX_DEPTH)
				execute 'highlight def BlockColor' . i . ' guibg=#22222' . i . ' ctermbg=' . (l:BG + i)
				call add(g:toogleShowIndententBlocksIds, matchadd(
					\ 'BlockColor' . i
					\ , '^' . l:space . '\{' . (i * l:spaceMulti) . '}'
					\ , i ))
			endfor
		else
			for l:id in g:toogleShowIndententBlocksIds
				call matchdelete(l:id)
			endfor
			let g:toogleShowIndententBlocksIds = []
		endif
	endfunction

	nnoremap <f1> :call ShowHelp()<cr>
	nnoremap <f2> :call Preserve("normal gg=G") \| echo "Internal"<cr>
	nnoremap <f3> :call Preserve("%s/\\s\\+$//e")<cr>
	nnoremap <f4> :!xmllint --valid --noout %<cr>
	nnoremap <f5> :call BuildFile()<cr>
	nnoremap <f6> :set list!<cr>
	nnoremap <f7> :if &rnu \| set nu \| else \| set rnu \| endif<cr>
	nnoremap <f8> :call ToogleShowIndententBlocks()<cr>

	" original idea: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
	nnoremap <f10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
		\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
		\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

	set listchars=tab:·\ ,nbsp:•,trail:•,extends:»,precedes:«
" }}
" GENERAL{{
	set nocompatible          " use vim defaults
	filetype plugin indent on " load filetype settings
	set number
	if exists('+relativenumber')
		set relativenumber        " show relative line numbers by default
	endif
	set scrolloff=5           " try to show atleast num lines
	set showmatch             " show matching brackets
	set cursorline            " show current line
	set ruler                 " show the cursor position
	set list                  " show invisible characters by default
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
	set shell=bash            " use bash as default shell for vim
	" paste from clipboard without reformatting text
	nnoremap ,p :set invpaste<cr>
	nnoremap ,p+ :silent! set paste<cr>"+p:set nopaste<cr>
	nnoremap ,p* :silent! set paste<cr>"*p:set nopaste<cr>

	" force vim to save file as root
	cnoremap w!! w !sudo tee %

	" use spell check for english and lithuanian languages
	set spelllang=en,lt

	" status line
	set statusline=
	set statusline+=%F%m%r
	set statusline+=%=\ %Y\ [FORMAT=%{&ff},%{&encoding}]\ [CHAR=\%03.3b/0x\%02.2B]\ [%p%%]
	set laststatus=2 " always show status line

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

			if has('conceal')
				highlight Conceal ctermbg=None ctermfg=white
			endif

			" less visible tab characters
			highlight SpecialKey ctermfg=8 guifg=#4F4F4F

			" do not hide cursor
			highlight MatchParen cterm=bold ctermbg=none ctermfg=67
		elseif g:nShifColors == 1
			let g:nShifColors  = 0
			LuciusLightHighContrast

			if has('conceal')
				highlight Conceal ctermbg=None ctermfg=black
			endif
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
" }}
" SEARCHING_SETTINGS{{
	set ignorecase " case insensetive search
	set smartcase  " unless capitals are use
	set incsearch  " search while typying
	set hlsearch   " show all results
	set gdefault   " append g to substitution automatically
	" use regex that is more like pcre by default
	" nnoremap / /\v " done by INCSHEARCH
	" xnoremap / /\v " done by INCSHEARCH
	" show match in the center of window (and open folds)
	nnoremap n nzzzR
	nnoremap N NzzzR
" }}
" TMP_FILES{{
	set backup
	set backupext=.bak
	set backupdir=~/.vim/tmp/backups/
	set backupcopy=yes " make backup by copying original file

	set swapfile
	" use double // to use full path as swap file name
	set directory=~/.vim/tmp/swap//

	if has('persistent_undo')
		set undofile
		set undodir=~/.vim/tmp/undo/
	endif

	if has('viminfo')
		set viminfo='20,<0,/0,:20,h,n~/configs/vim/tmp/viminfo
		augroup viminfo
		autocmd!
			" restore cursor position (and open folds so that it would be visible)
			autocmd BufWinEnter *
				\ if line("'\"") >= 1 && line("'\"") <= line('$')
					\ | execute 'normal! g`"'
					\ | if &foldenable && foldlevel(line('.')) > 0
						\ | execute 'normal! zO'
					\ | endif
				\ | endif
		augroup END
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
	" if shell (:!sleep 10) does not eat input (press anything while sleeping)
	" from user, this input is sent to vim. Enter (<cr>) is interpreted as c-j. So
	" pressing enter (and having `nnoremap <c-j> :resize -2<cr>`) while in shell may
	" resize window in vim...
	nnoremap <c-w><s-j> :resize -2<cr>
	nnoremap <c-w><s-k> :resize +2<cr>
	nnoremap <c-w><s-h> 2<c-w><
	nnoremap <c-w><s-l> 2<c-w>>
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

		function! SetMakePRGToMake()
			let l:directoryWithMakeFile = FindRoot([
				\ {'name': 'makefile'}
				\, {'name': 'Makefile'}
			\ ], 1)

			if !empty(l:directoryWithMakeFile)
				execute 'setlocal makeprg=make\ -C\ ' . shellescape(escape(l:directoryWithMakeFile, ' ()\')) . '"\ $*'
				return 1
			endif

			return 0
		endfunction

		augroup language_specific
		autocmd!
	" JAVA{{
		autocmd FileType java setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
		autocmd FileType java setlocal foldmethod=syntax foldnestmax=2

		autocmd Filetype java setlocal omnifunc=javacomplete#Complete
		" too slow
		"autocmd Filetype java imap <buffer> . .<c-x><c-o>

		" do not indent classes (-C) as it will result in double indention
		" use for spaces (s4)
		autocmd FileType java nnoremap <buffer> <f2> :call Preserve('%!astyle -s4 -c -a -S -N -L -w -Y -f -p -H -U -j -k3 -q -z2') \| echo "AStyle Java"<cr>

		function! SetMakeForJava()
			if !SetMakePRGToMake()
				setlocal makeprg=javac\ %
			endif
			setlocal errorformat=%A%f:%l:\ %m,%+Z%p^,%+C%.%#,%-G%.%#
		endfunction

		autocmd FileType java call SetMakeForJava()
	" }}
	" C/CPP{{
		autocmd FileType c,cpp setlocal foldmethod=syntax foldnestmax=1
		autocmd FileType cpp call LoadLangTags('cpp')
		autocmd FileType c,cpp nnoremap <buffer> <f2> :call Preserve('%!astyle -T4 -C -S -N -L -w -Y -f -p -H -U -j -k3 -q -z2 --style=attach') \| echo "AStyle Cpp"<cr>
		" T4 - 4 space tab
		" -C - indent inner part of classes
		" -S - indent inner part of switches
		" -N - indent inner poart of namespaces
		" -L - gives single tab for labels
		" -w - indent defines
		" -Y - indent comments same as code
		" -f - empty line between for/if/while blocks
		" -p - pad operators with single space
		" -H - insert space after if/while
		" -U - remove indentation inside of if ( a ) -> if(a)
		" -j - always use {}
		" -k3 - pointer alignment
		" -q - no output
		" -z2 - use \n as line ending
		" --style=attach - add {} on same line

		function! SetMakeForCpp()
			if SetMakePRGToMake()
				" do nothing
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
			if !SetMakePRGToMake()
				autocmd QuickFixCmdPost make
										\ if &ft ==? 'dot'|
											\ execute 'silent !~/configs/scripts/showme.bash --silent-detached %.png &>/dev/null &'|
										\ endif

				setlocal makeprg=dot\ %\ -Tpng\ -O
			endif
		endfunction

		autocmd FileType dot call SetMakeForDot()
	" }}
	" TEX{{
		function! SetMakeForTex()
			if !SetMakePRGToMake()
				autocmd QuickFixCmdPost make
										\ if &ft ==? 'tex'|
											\ execute 'silent !~/configs/scripts/showme.bash --silent-detached %:r.pdf &>/dev/null &'|
										\ endif

				setlocal makeprg=pdflatex\ -shell-escape\ -file-line-error\ -interaction=nonstopmode\ %
			endif
			setlocal errorformat=%f:%l:\ %m
		endfunction

		autocmd FileType tex
			\ call SetMakeForTex()
			\ | set spell

		if has('conceal') && &enc == 'utf-8'
			" keep syntax elements sorted!
			autocmd FileType tex
				\ setlocal conceallevel=2
				\ | syntax match texStatement '\\item\>' contained conceal cchar=•
				\ | syntax match texStatement '\\not=' contained conceal cchar=≠
				\ | syntax match texStatement '\\not\\in' contained conceal cchar=∉
				\ | syntax match texStatement '\\not\\subset' contained conceal cchar=⊄
				\ | syntax match texStatement '\\not\\subseteq' contained conceal cchar=⊈
				\ | syntax match texStatement '\\not\\supset' contained conceal cchar=⊅
				\ | syntax match texStatement '\\not\\supseteq' contained conceal cchar=⊉
		endif

		let g:tex_conceal="adgm" " conceal Acents Delimiters Greak letters and Math symbols
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
			if !SetMakePRGToMake()
				setlocal makeprg=pylint\ --output-format=parseable\ --reports=n\ %
				setlocal errorformat=%f:%l:\ [%t]%m,%f:%l:%m
			endif
		endfunction

		" makeprg
		autocmd FileType python call SetMakeForPython()

		" formating
		autocmd FileType python nnoremap <buffer> <f2> :call Preserve('%!PythonTidy.py') \| echo "PythonTidy"<cr>
	" }}
	" PHP{{
		autocmd FileType php setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
	" }}
	" M4{{
		function! SetMakeForM4()
			if !SetMakePRGToMake()
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
		autocmd FileType json nnoremap <buffer> <f2> :call Preserve('%!python -mjson.tool')<cr>
	" }}
	" XML{{
		autocmd FileType xml nnoremap <buffer> <f2> :call Preserve('%!python -c "import xml.dom.minidom; import sys; xml = xml.dom.minidom.parse(sys.stdin); print(xml.toprettyxml())"')<cr>
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
			\ nnoremap <buffer> <f5> G:call Preserve('silent r!openssl asn1parse -inform DER -in %') \| setlocal readonly<cr>

		autocmd bufreadpre,bufnewfile *.crt
			\ nnoremap <buffer> <f5> G:call Preserve('silent r!openssl x509 -in % -noout -text') \| setlocal readonly<cr>
		autocmd bufreadpre,bufnewfile *.key
			\ nnoremap <buffer> <f5> G:call Preserve('silent r!openssl rsa -in % -noout -text') \| setlocal readonly<cr>
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
			setlocal makeprg=pandoc\ --latex-engine=xelatex\ --highlight-style=pygments\ -V\ geometry:margin=0.5in\ --standalone\ --tab-stop=2\ '--output=/tmp/%.pdf'\ '%'\ &&\ ~/configs/scripts/showme.bash\ '/tmp/%.pdf'
		endfunction

		autocmd BufRead,BufNewFile *.rst,*.mkd
			\ call SetMakeForRST()
			\ | setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
			\ | nnoremap <buffer> <enter> :call RSTEnter()<cr>
			\ | set spell

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
		autocmd bufreadpre,bufnewfile *.mail set ft=mail
		" not so fancy formatting options for mail files - we want to allow receivers to reformat emails
		" a - automatically reformat paragraph if text changed
		" w - trailing whitespace means that paragraph continues in next line
		autocmd FileType mail setlocal spell formatoptions=aw
		autocmd FileType mail setlocal nosmartindent nocindent noautoindent indentexpr=

		function! GetMailFoldLvl(nLine)
			let l:strLine    = getline(a:nLine)
			let l:nSetFoldTo = 0

			for l:i in range(0, len(l:strLine))
				if l:strLine[l:i] == '>'
					let l:nSetFoldTo += 1
				else
					break
				endif
			endfor

			return min([l:nSetFoldTo, &foldnestmax])
		endfunction

		autocmd FileType mail setlocal foldmethod=expr foldexpr=GetMailFoldLvl(v:lnum) foldnestmax=10
	" }}
	" COMMIT MESSAGES {{
		" then editing commit messages enable spell checking
		" and jump to first line of buffer (overrides cursor restoring
		" behaviour)
		autocmd FileType gitcommit setlocal spell
		autocmd BufWinEnter COMMIT_EDITMSG normal gg
	" }}
	" VIMRC {{
		autocmd FileType vim setlocal keywordprg=:help
	" }}
	" HTML {{
		" https://groups.google.com/forum/#!topic/vim_use/-SMIZaur74Y
		" folding for html
		autocmd FileType html
			\ syntax region SynFold
			\ start="\v\<%(html|body|head|param|link|input|hr|frame|br|base|area|img|meta)@!\z([a-z]+)%(\_s[^>]*[^>/])*\>"
			\ end="</\z1>"
			\ transparent fold keepend extend
			\ containedin=ALLBUT,htmlComment
			\ | setlocal foldmethod=syntax foldnestmax=1

		" open all folds by default
		autocmd BufEnter *.html,*.htm silent! %foldopen!

		" do not underline white spaces in links
		autocmd FileType html
			\ syntax match htmlLinkWhite '\v\s' contained containedin=htmlLink
			\ | highlight default link htmlLinkWhite Ignore
	" }}
		augroup END
	endif
" }}
