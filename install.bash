# directory to backup old dotfiles to
backup_dir="$HOME/.dotfiles_old/"
mkdir -p "$backup_dir"

# where to log errors to
logfile="$backup_dir/log"

function log {
  echo "[$( date )]: $*" >> $logfile
}

# save the current pwd so we can cd back to it after
pwd=$(pwd)

cd $HOME

# directory this script lives in
dotfiles_path=$( dirname $pwd/$0 )

# symlink all .sym files into home dir
for filename in $(find "$dotfiles_path" -name '*.sym')
do
  file=$( basename $filename .sym )
  original="$HOME/.$file"

  # make backup if a backup doesn't exist yet
  if [ -e "$original" ] && [ ! -e "$backup_dir.$file" ]; then
    log Backing up $original to $backup_dir
    mv "$original" "$backup_dir" 2>>$logfile
  fi

  # symlink the file into home
  if [ ! -e "$original" ]; then
    log "ln -s $dotfiles_path/$file.sym $original"
    ln -s "$dotfiles_path/$file.sym" "$original" 2>>$logfile
  fi
done

#merge .folders
for dirpath in $(find "$dotfiles_path" -maxdepth 1 -mindepth 1 -type d -not -name .git)
do
  dirname=$( basename $dirpath )
  original="$HOME/.$dirname"

  # make backup if a backup doesn't exist yet
  if [ -e "$original" ] && [ ! -e "$backup_dir.$dirname" ]; then
    log Backing up $original to $backup_dir
    mv "$original" "$backup_dir" 2>>$logfile
  fi


  if [ ! -e "$HOME/.$dirname" ]; then
    ln -s "$dotfiles_path/$dirname" "$HOME/.$dirname"
  fi
done

#install vim pathogen
if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

#add local files
touch ~/.bashrc_local
touch ~/.vimrc_local

#source local files
source ~/.bashrc
source ~/.vimrc_local

cd $pwd
