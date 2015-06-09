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
df_dir=$( dirname $pwd/$0 )

# symlink all .sym files into home dir
for filename in $(find "$df_dir" -name '*.sym')
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
    log "ln -s $df_dir/$file.sym $original"
    ln -s "$df_dir/$file.sym" "$original" 2>>$logfile
  fi
done

#merge .folders
for dirname in $(find "$df_dir" -maxdepth 1 -mindepth 1 -type d -not -name .git)
do
  dir=$( basename $dirname )
  original="$HOME/.$file"

  # make backup if a backup doesn't exist yet
  if [ -e "$original" ] && [ ! -e "$backup_dir.$dir" ]; then
    log Backing up $original to $backup_dir
    mv "$original" "$backup_dir" 2>>$logfile
  fi


  if [ ! -e "$HOME/.$dir" ]; then
    ln -s "$df_dir/$dir" "$HOME/.$dir"
  fi
done

#install vim pathogen
if [ ! -e ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

#add local bashrc file
touch ~/.bashrc_local

#source new bash file
source ~/.bashrc

cd $pwd
