# directory to backup old dotfiles to
backup_dir="$HOME/.dotfiles_old/"
mkdir -p "$backup_dir"

# directory this script lives in
df_dir=$( dirname "$0" )

# symlink all .sym files into home dir
for file in $( basename -s .sym $(find "$df_dir" -name '*.sym') )
do
  original="$HOME/.$file"

  # make backup if a backup doesn't exist yet
  if [ -e "$original" ] && [ ! -e "$backup_dir.$file" ]; then
    echo "Backing up $original $backup_dir"
    mv "$original" "$backup_dir"
  fi

  # symlink the file into home
  if [ ! -e "$original" ]; then
    echo "ln -s $df_dir/$file.sym $original"
    ln -s "$df_dir/$file.sym" "$original"
  fi
done

#merge .folders
for dir in $(find $df_dir -depth 1 -type d -not -name .git)
do
  echo cp -R "$dir" "$HOME/.$( basename $dir )"
  #cp -R "$dir" "../.$dir"
done

#install vim pathogen
if [ ! -f ~/.vim/autoload/pathogen.vim ]; then
  mkdir -p ~/.vim/autoload ~/.vim/bundle
  curl -Sso ~/.vim/autoload/pathogen.vim \
    https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
fi

#install syntax checking plugin
if [ ! -e ~/.vim/bundle/syntastic ]; then
  git clone https://github.com/scrooloose/syntastic ~/.vim/bundle/syntastic
fi

#install file finder
if [ ! -e ~/.vim/bundle/ctrlp ]; then
  git clone https://github.com/kien/ctrlp.vim ~/.vim/bundle/ctrlp
fi

#add local bashrc file
touch ~/.bashrc_local

#source new bash file
source ~/.bashrc
