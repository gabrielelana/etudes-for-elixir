" autoload the local .vimrc file you need to have
" https://github.com/MarcWeber/vim-addon-local-vimrc
" plugin installed

nnoremap <silent> <Leader>r :exec '!
  \ for module in ' . expand('%:p:h') . '/*.ex; do; elixirc $module; done;
  \ iex;
  \ rm -f *.beam 2> /dev/null;
  \ ' <CR>
