#!/bin/bash
#Enable Debugging
#set -x on
#######################################################################################################################
# This script will sync all folders (recursively) that are older to than 30 days to the specified archive directory
#
# * Note * This script does not have logic to decide if the files inside of the directories have a modified time less than 30 days
#    If the direcotry is older than 30 days then everything inside will be archived
# Created by Quentin Moss <quejmoss@gmail.com>
#######################################################################################################################
IMAGE_PATH=images/
ARCHIVE_PATH=archive/

# We need to handle spaces in file names. We set new line as delimiter.
IFS="
"

# Verify provided directory exists
if [ ! -d $IMAGE_PATH ]; then
  echo $IMAGE_PATH "does not exist"
  exit 1
fi

if [ ! -d $ARCHIVE_PATH ] ; then
  echo $ARCHIVE_PATH "does not exist"
  exit 1
fi

# Start image sync, and remove source files after successful sync.
for i in $(find $IMAGE_PATH -type f -mtime +30); \
  do rsync -vaR --stats --remove-source-files "$i" $ARCHIVE_PATH; RESULT=$?; done
  echo $RESULT

# Rsync does not support removing directories and files. I would love to be proved wrong here. Because this straight up G
if [ $RESULT == 0 ]; then
  echo "Rsync completed successfully"
  find $IMAGE_PATH -type d -empty -delete
fi
