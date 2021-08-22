#!/bin/bash

echo "Download plug.vim...."
proxychains curl -fLo autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Open neovim, execute :PlugInstall, and enjoy it ^_^"
