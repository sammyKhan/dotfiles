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
df_dir=$( dirname "$pwd/$0" )

# symlink all .sym files into home dir
for file in $( basename -s .sym $(find "$df_dir" -name '*.sym') )
do
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
for dir in $( basename $(find $df_dir -depth 1 -type d -not -name .git) )
do
  if [ ! -e "$HOME/.$dir" ]; then
    ln -s "$df_dir/$dir" "$HOME/.$dir"
  fi
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

#add local bashrc file
touch ~/.bashrc_local

#source new bash file
source ~/.bashrc

cd $pwd
