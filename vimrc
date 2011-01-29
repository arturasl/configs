" vim: foldmethod=marker
" vim: foldmarker={{,}}

" PLUGINS{{
    " PATHOGEN{{
		filetype off
		call pathogen#helptags()
		call pathogen#runtime_append_all_bundles()
	" }}
	" TAGLIST{{
		let Tlist_Auto_Open = 0					" let the tag list open automagically
		let Tlist_Compact_Format = 0			" show small menu
		let Tlist_Exist_OnlyWindow = 1			" close if last window
		let Tlist_File_Fold_Auto_Close = 1		" fold closed other trees
		let Tlist_Use_Right_Window = 1			" show on right side
		let Tlist_Show_One_File = 1 			" Displaying tags for only one file

		" show taglist on <-
		map <right> <ESC>:TlistToggle<RETURN>
	" }}
	" LUSTYJUGLER{{
		nmap ,b :LustyJuggler<CR>
	" }}
" }}

" FUNCTION_KEYS{{
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
	nmap <F1> :echo "<F1> Show this help\n<F2> Reindent\n<F3> Remove whitespaces from EOL\n<F4> Reindent with AStyle\n<F5> Check xml syntax\n<F6> Show invisible chars\n"<CR>
	nmap <F2> :call Preserve("normal gg=G")<CR>
	nmap <F3> :call Preserve("%s/\\s\\+$//e")<CR>
	nmap <F4> :%!astyle --indent=tab=4 --brackets=attach --indent-switches --indent-namespaces --indent-preprocessor --indent-col1-comments --break-blocks --pad-oper --pad-header --add-brackets --align-pointer=name --lineend=linux<CR>
	nmap <F5> :!xmllint --valid --noout %<CR>
	nmap <F6> :set list!<CR>
	set listchars=tab:⇾\ ,eol:↩
" }}

" GENERAL{{
	set nocompatible    " use vim defaults
	filetype plugin indent on " load filetype settings
	set number			" show line numbers
	set scrolloff=5		" try to show atleast num lines
	set showmatch		" show matching brackets
	set cursorline		" show current line
	set ruler			" show the cursor position
	set showcmd         " display incomplete commands
	set mouse=a			" more mouse please :)
	set autochdir		" always switch to the current file directory
	set backupdir=~/.vim/backups	"backups
	set visualbell t_vb=			" no bell just blink
	set virtualedit=all	" let cursor fly anythere
	set hidden			" switch buffers without saving
	let g:tex_flavor='latex'
" }}
" COLORS{{
	set background=dark     " dark background (must be before syntax on)
	syntax on               " syntax highlight
	colorscheme lucius
	set t_Co=256            " all colours :)
" }}
" WRAPPING{{
	set wrap           " yes, wrap lines
	set linebreak      " but do not cut in a middle of word
	"move by screen lines not by file
	nmap j gj
	nmap k gk
" }}
" INDENTION{{
	set autoindent      " copy indention from prev line
	set cindent         " c indention
	set shiftwidth=4    " numbers of spaces to <> commands
	set softtabstop=4   " if someone uses spaces delete them with backspace
	set tabstop=4       " numbers of spaces of tab character
	set noexpandtab     " use tab character
	match Error /\s\+$/ " show 'bad' whitespaces
" }}
" SEARCHING_SETTINGS{{
	set ignorecase		" case insensetive search
	set smartcase		" unless capitals are use
	set incsearch		" search while typying
	set hlsearch		" show all results
	set gdefault        " append g to substitution automatically
	" use regex that is more like pcre by default
	nnoremap / /\v
	vnoremap / /\v
" }}
