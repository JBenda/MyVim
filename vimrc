:set tabstop=2 
:set shiftwidth=2
:set ignorecase
:set smartcase
:set mouse=a
:set number
:set autoindent
:set colorcolumn=81
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

:set spell
:set rtp+=~/.vim/tabnine-vim


call plug#begin('~/.vim/plugged')
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'pdavydov108/vim-lsp-cquery'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"Plug 'thomasfaingnaert/vim-lsp-snippets'
"Plug 'thomasfaingnaert/vim-lsp-ultisnips'
call plug#end()

let g:lsp_highlight_references_enabled = 0
let g:lsp_signs_enabled = 0
let g:lsp_diagnostics_echo_cursor = 0
set foldmethod=expr
	\ foldexpr=lsp#ui#vim#folding#foldexpr()
	\ foldtext=lsp#ui#vim#folding#foldtext()

if executable('cquery')
	 au User lsp_setup call lsp#register_server({
			\ 'name': 'cquery',
			\ 'cmd': {server_info->['cquery']},
			\ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
			\ 'initialization_options': { 'cacheDirectory': $HOME.'/var/cquery' },
			\ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
			\ })
endif

:nmap <f12> <Plug>(lsp-definition)
:nmap <S-f12> <Plug>(lsp-type-definition)
:autocmd FileType c,cc,cpp,cxx,h,hpp nnoremap <C-f12> :LspCqueryBase<CR>
:nmap <f2>  <Plug>(lsp-rename)

let g:UltiSnipsExpandTrigger="<c-t>"
:nmap <S-tab> :call UltiSnips#ListSnippets()<CR>
let g:UltiSnipsJumpForwardTrigger="OF" 
let g:UltiSnipsJumpBackwardTrigger="OH"
let g:UltiSnipsSnippetDirectories=["UltiSnips", $HOME."/.vim/mySnippets"]

set completeopt+=menuone
