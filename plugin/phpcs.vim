" File: phpcs.vim
" Author: Benjamin Pearson (bpearson AT squiz DOT com DOT au)
" Version: 0.3
" Last Modified: July 3, 2014
" Copyright: Copyright (C) 2014 Benjamin Pearson
"            See LICENSE for more information
"
" The "Vim PhpCs" plugin runs PHP_CodeSniffer and displays the results
" in Vim.
"
" Installation
" ------------
" 1. Obtain a copy of this plugin and place phpcs.vim in your Vim plugin
"    directory and vim-phpcs.txt in the docs/ directory.
" 2. Add let Vimphpcs_Standard='STANDARDNAME' to your .vimrc file.
" 3. Restart Vim.
" 4. You can now use the ":CodeSniff" command to run PHP_CodeSniffer
"    and display the results.
"
" ****************** Do not modify after this line ************************

if exists("g:loaded_Vimphpcs") || &cp
    finish
endif

let g:loaded_Vimphpcs = 0.3
let s:keepcpo         = &cpo
set cpo&vim

" Test for CodeSniffer
if !exists('Vimphpcs_Phpcscmd')
    if executable('phpcs')
        let Vimphpcs_Phpcscmd='phpcs '
    else
        " Unable to find the CodeSniffer executable
        echomsg 'Unable to find phpcs in the current PATH.'
        echomsg 'Plugin not loaded.'
        let &cpo = s:keepcpo
        finish
    endif
endif

" Options
if !exists('Vimphpcs_Standard')
    let Vimphpcs_Standard='PEAR'
endif

if !exists('Vimphpcs_ExtraArgs')
    let Vimphpcs_ExtraArgs=''
endif

function! s:CodeSniff(extraarg)
    set errorformat+=\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"\\,%*[a-zA-Z0-9_.-\\,]
    let l:extraarg       = a:extraarg.' '.g:Vimphpcs_ExtraArgs
	let l:filename       = @%
    let l:phpcs_cmd      = g:Vimphpcs_Phpcscmd
    let l:phpcs_standard = g:Vimphpcs_Standard
    let l:phpcs_opts     = ' '.l:extraarg.' --report=csv --standard='.l:phpcs_standard
	let l:phpcs_output   = system(l:phpcs_cmd.l:phpcs_opts.' '.l:filename)
    let l:phpcs_output   = substitute(l:phpcs_output, '\\"', "'", 'g')
	let l:phpcs_results  = split(l:phpcs_output, "\n")
	unlet l:phpcs_results[0]
	cexpr l:phpcs_results
	copen
endfunction

command! CodeSniff :call <SID>CodeSniff('')
command! CodeSniffErrorOnly :call <SID>CodeSniff('-n')
