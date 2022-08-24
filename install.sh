#!/bin/bash
#
# Symlinks dotfiles into the home dir, moving existing files to ~/dotfiles_old
# first.

set -euxo pipefail

# Directory to backup old dotfiles to.
readonly BACKUP_DIR="${HOME}/.dotfiles_old"
readonly REPO_DIR="$(dirname $(readlink -f $0))"

function backup {
  local file="$1"
  if [ -e "${file}" ] && [ ! -e "${BACKUP_DIR}/$(basename ${file})" ]; then
    mv "${file}" "${BACKUP_DIR}"
  fi
}

# Symlink files and directories ending with a `.sym` extension into the home
# directory.
function install_symlinks {
  for filename in $(find "${REPO_DIR}" -name '*.sym')
  do
    local stem
    stem="$( basename ${filename} .sym )"
    local destination="${HOME}/.${stem}"

    backup "${destination}"

    if [ ! -e "${destination}" ]; then
      ln -s "${filename}" "${destination}"
    fi
  done
}

mkdir -p "${BACKUP_DIR}"
install_symlinks
touch ~/.bashrc_local ~/.vimrc_local ~/.tmux.conf_local
source ~/.bashrc
if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
