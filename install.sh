#!/bin/bash

# [path-of-the-script]/install.sh
# Folders usecase
# /.git
# /.git/hooks
# /download_dir/install.sh <- this script
# /download_dir/hooks <- path of your hooks
#/download_dir/scripts <- path of your scripts

#Get the directory name from where this install.sh script is being called.
GitGraph_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# list of hooks the script will look for
HOOK_NAMES="post-commit post-checkout post-merge pre-push"

# relative folder path of the .git / current script
GIT_DIR=../.git
# relative folder path of the .git hook / current script
GIT_HOOK_DIR=../.git/hooks
# relative folder path of the custom hooks to deploy / current script
LOCAL_HOOK_DIR=$GitGraph_DIR/hooks
# relative folder path of the custom scripts to deploy / logic scripts folder
SCRIPT_HOOK_DIR=$GitGraph_DIR/scripts

echo "Install project GitGraph hooks ..."

for hook in $HOOK_NAMES; do
    # if we have a custom hook to set
    if [ -f $LOCAL_HOOK_DIR/$hook ]; then
      echo "> Processing Hook $hook"
      # If the hook already exists, is executable, and is not a symlink
      if [ ! -h $GIT_HOOK_DIR/$hook -a -x $GIT_HOOK_DIR/$hook ]; then
          echo " > Old git hook $hook disabled"
          # append .local to disable it
          mv $GIT_HOOK_DIR/$hook $GIT_HOOK_DIR/$hook.local
      fi

      # copy the hook, overwriting the file if it exists
      echo " > Enable project GitGraph hooks ...."
      cp $LOCAL_HOOK_DIR/$hook $GIT_HOOK_DIR/$hook
	  chmod +x $GIT_HOOK_DIR/$hook
	  cp -r $SCRIPT_HOOK_DIR $GIT_DIR 
    fi
done
