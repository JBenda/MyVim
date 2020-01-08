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
:set backspace=indent
" :au BufRead,BufNewFile *.cc\|*.h\|*.hxx setfiletype cpp

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_winsize = 25

let s:CXX_Whitlist = [ 'cpp', 'hpp', 'cc', 'h' ]


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
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'jackguo380/vim-lsp-cxx-highlight', { 'for': ['cpp'] }
call plug#end()


set foldmethod=syntax


let g:lsp_highlight_references_enabled = 1
let g:lsp_signs_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1

if executable('cquery')
	 au FileType cpp setlocal omnifunc=lsp#complete
	 au User lsp_setup call lsp#register_server({
			\ 'name': 'cquery',
			\ 'cmd': {server_info->['cquery']},
			\ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
			\ 'initialization_options': {
	 		\ 'cacheDirectory': lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json') . '/.cquery_cache',
	 		\ 'highlight': { 'enabled': v:true},
	 		\	'emitInactiveRegions': v:true
	 		\ },
			\ 'whitelist': s:CXX_Whitlist + ['c', 'objc', 'objcpp'],
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

function LspCxxHlInfo()
    let l:line = line('.')
    let l:col = col('.')

		let l:hit = 0
    for l:sym in get(b:, 'lsp_cxx_hl_symbols', [])
        let l:under_cursor = 0

        let l:pos = []

        for l:range in get(l:sym, 'ranges', [])
            let l:pos += lsp_cxx_hl#match#lsrange2match(l:range)
        endfor

        if has('byte_offset')
            for l:offset in get(l:sym, 'offsets', [])
                let l:pos += lsp_cxx_hl#match#offsets2match(l:offset)
            endfor
        endif

        for l:p in l:pos
            if type(l:p) ==# type(0) && l:line == l:p
                let l:under_cursor = 1
            elseif type(l:p) ==# type([])
                if len(l:p) == 1 && l:line == l:p[0]
                    let l:under_cursor = 1
                elseif len(l:p) == 2 && l:line == l:p[0] && l:col == l:p[1]
                    let l:under_cursor = 1
                elseif len(l:p) == 3 && l:line == l:p[0] && l:p[1] <= l:col
                            \ && l:col <= (l:p[1] + l:p[2])
                    let l:under_cursor = 1
                endif
            endif
        endfor

        if l:under_cursor
					let l:hit = 1
					echon 'kind: '
					echon get(l:sym, 'kind', '')
					let l:storage = get(l:sym, 'storage', '')
					if ! (l:storage ==# "None")
						echon ' ' . get(l:sym, 'storage', '') 
					endif
					echon '    parentKind: '
					echon get(l:sym, 'parentKind', '')
        endif
    endfor
		if !l:hit
			echon 'No Symbole'
		endif
endfunction
nmap <silent><Plug>(lsp-symbol-info)  :<C-U>call LspCxxHlInfo()<CR>

:autocmd FileType cpp call CppIncludePath() 

:nmap <f12> <Plug>(lsp-definition)
:nmap <S-f12> <Plug>(lsp-type-definition)
:nmap <f3> <Plug>(lsp-hover)
:nmap <f2>  <Plug>(lsp-rename)
:nmap <f1> <Plug>(lsp-symbol-info)

let g:UltiSnipsExpandTrigger="<c-t>"
:nmap <S-tab> :call UltiSnips#ListSnippets()<CR>
" end
let g:UltiSnipsJumpForwardTrigger="OF" 
" pos
let g:UltiSnipsJumpBackwardTrigger="OH"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/.vim/mySnippets"]

" cxx_hl
let g:lsp_cxx_hl_ft_whitlist = s:CXX_Whitlist 

" lsp log
"let g:lsp_log_verbose = 1
"let g:lsp_log_file = expand('~/vim-lsp.log')


