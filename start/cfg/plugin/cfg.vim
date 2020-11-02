
let g:ale_linters = {
    \ 'bash': ['bash-language-server', 'start'],
    \ 'c': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'cpp': ['ccls', '--log-file=/tmp/cc.log'],
    \ 'go': ['gopls'],
    \ 'ruby': ['~/.rbenv/shims/solargraph', 'stdio'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'vim': ['vim-language-server', '--stdio'],
    \ 'yaml': ['yaml-language-server', '--stdio'],
    \}
    " \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    " \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],


let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \}
"
" Plugins need to be added to runtimepath before helptags can be generated.
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1

let g:ale_disable_lsp = 1
let g:ale_fix_on_save = 1
