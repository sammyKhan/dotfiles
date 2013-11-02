backup_dir="$HOME/.dotfiles_old/"

mkdir -p "$backup_dir"

# symlink all .sym files into home dir
for file in `find . -name '*.sym' | cut -c 3- | rev | cut -c 5- | rev`
do
  original="$HOME/.$file"

  # make backup if a backup doesn't exist yet
  if [ ! -e "$backup_dir.$file" ]; then
    echo "Backing up $original $backup_dir"
    mv "$original" "$backup_dir"
  fi

  # symlink the file into home
  if [ ! -e "$original" ]; then
    echo "ln -s `pwd`/$file.sym $original"
    ln -s "`pwd`/$file.sym" "$original"
  fi
done

#install vim pathogen
if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
  mkdir -p ~/.vim/autoload ~/.vim/bundle
  curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
fi

#install vim colorscheme
if [ ! -e ~/.vim/bundle/molokai ]; then
  git clone https://github.com/tomasr/molokai ~/.vim/bundle/molokai
fi

#source new bash file
source ~/.bashrc

#source machine-specific config
if [ -f ~/.bashrc_local ]; then
  source ~/.bashrc_local
fi
