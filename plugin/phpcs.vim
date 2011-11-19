"-----------------------------
" VIM PHP Code Sniffer plugin
"-----------------------------

if exists("g:loaded_VimPhpCs") || &cp
    finish
endif

let g:loaded_VimPhpCs = 0.1
let s:keepcpo         = &cpo
set cpo&vim

function! s:CodeSniff(extraarg)
    let l:standard      = 'PEAR'
    let l:extraarg      = a:extraarg
	let l:filename      = @%
	let l:phpcs_output  = system('phpcs '.l:extraarg.' --report=csv --standard='.l:standard.' '.l:filename)
    let l:phpcs_output  = substitute(l:phpcs_output, '\\"', "'", 'g')
	let l:phpcs_results = split(l:phpcs_output, "\n")
	unlet l:phpcs_results[0]
	cexpr l:phpcs_results
	copen
endfunction

set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"\\,%*[a-zA-Z0-9_.-]\\,%*[0-9]
command! CodeSniff :call <SID>CodeSniff('')
command! CodeSniffErrorOnly :call <SID>CodeSniff('-n')
