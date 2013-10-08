#!/bin/bash

backup_dir="$HOME/.dotfiles_old/"

mkdir -p "$backup_dir"

#get files ending in .sym and remove .sym
for file in `find . -name '*.sym' | cut -c 3- | rev | cut -c 5- | rev`
do
  original="$HOME/.$file"

  # only install dotfiles for programs that exist on the system
  if [ -e "$original" ] || [ -h "$original" ]; then
    # make backup if it doesn't exist yet
    if [ ! -e "$backup_dir.$file" ]; then
      echo "Backing up $original"
      mv "$original" "$backup_dir"
    fi

    echo "removing $original"
    rm "$original"
    
    # symlink the new file into home
    if [ ! -e "$original" ]; then
      echo "ln -s `pwd`/$file.sym $original"
      ln -s "`pwd`/$file.sym" "$original" 
    fi
    
  # original doesn't exist
  else
    echo "skipping $original"
  fi
done

