:set tabstop=2 
:set shiftwidth=2
:set ignorecase
:set smartcase
:set mouse=a
:set number
:set autoindent
:set colorcolumn=81
:set nofoldenable
:set spell
:set completeopt=menuone,noselect,noinsert
" :au BufRead,BufNewFile *.cc\|*.h\|*.hxx setfiletype cpp

" Grammerous config
:let g:grammarous#default_comments_only_filetypes = {
	\ 'cpp' : 1, 'help' : 0, 'markdown' : 0, '*':0,
	\ }
:let g:grammarous#use_vim_spelllang = 1
:let g:grammarous#show_first_error = 1
:nmap <c-w>i <Plug>(grammarous-move-to-info-window)
:nmap <c-n> <Plug>(grammarous-move-to-next-error)

" unicodes
" :imap -> →<space>

call plug#begin('~/.vim/plugged')
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'pdavydov108/vim-lsp-cquery'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'thomasfaingnaert/vim-lsp-snippets'
"Plug 'thomasfaingnaert/vim-lsp-ultisnips'
call plug#end()


set foldmethod=syntax


let g:lsp_highlight_references_enabled = 0
let g:lsp_signs_enabled = 0
let g:lsp_diagnostics_echo_cursor = 0

if executable('cquery')
	 au FileType cpp setlocal omnifunc=lsp#complete
	 au User lsp_setup call lsp#register_server({
			\ 'name': 'cquery',
			\ 'cmd': {server_info->['cquery']},
			\ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
			\ 'initialization_options': {'cacheDirectory': lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json') . '/.cquery_cache'},
			\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc', 'h', 'hpp'],
			\ })
endif 

:function CppIncludePath()
: let l:path = ""
:	let l:filePath = lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json')
: if strlen(l:filePath)
:		let l:path = ".,/usr/include/"
:		let l:str = join(readfile(l:filePath . "/compile_commands.json"))
:		let l:lst = []
:		call substitute(l:str, '"-I", "\([^"]*\)"', '\=add(lst, submatch(1))', 'g')
:		let l:pathList = []
:		for p in l:lst
:			" let l:hits = split(globpath(l:filePath . '/' . p , '**'), '\n')
: 		" for f in l:hits
:			"	if isdirectory(f)
:			"		call add(l:pathList, f)
:			"	endif
: 		"endfor
:			call add(l:pathList, fnamemodify(l:filePath . '/' . p, ':p'))
:		endfor
:		let l:uniqList = uniq(l:pathList)
:		for d in l:uniqList
:			let l:path .= ',' . d
:		endfor
:		exe 'setlocal path=' . l:path
:		let b:cppIncludePathsAdded=1
: endif
:	
:endfunction

:autocmd FileType cpp call CppIncludePath() 

:nmap <f12> <Plug>(lsp-definition)
:nmap <S-f12> <Plug>(lsp-type-definition)
:autocmd FileType c,cc,cpp,cxx,h,hpp nnoremap <C-f12> :LspCqueryBase<CR>
:nmap <f2>  <Plug>(lsp-rename)

let g:UltiSnipsExpandTrigger="<c-t>"
:nmap <S-tab> :call UltiSnips#ListSnippets()<CR>
" end
let g:UltiSnipsJumpForwardTrigger="OF" 
" pos
let g:UltiSnipsJumpBackwardTrigger="OH"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/.vim/mySnippets"]

