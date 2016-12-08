#!/bin/bash
#Enable Debugging
#set -x on
#######################################################################################################################
# This script uses rsync to sync directory contents from source to destination while keeping a 1 to 1 directory structure.
# * Note * This script does not handle duplicate directory names. Think of this as taking a snap shot if files meet a criteria.
#
# Created by Quentin Moss <quejmoss@gmail.com>
#######################################################################################################################
IMAGE_PATH=/home/rsync_tests/images
ARCHIVE_PATH=/home/rsync_tests/archive

# We need to handle spaces in file names. We will set internal field separator as new line
IFS="
"

# Verify provided directory exists
if [ ! -d $IMAGE_PATH ]; then
	echo $IMAGE_PATH "does not exist"
	exit 1
fi

if [ ! -d $ARCHIVE_PATH ]; then
	echo $ARCHIVE_PATH "does not exist"
	exit 1
fi

# Start image sync, and remove source files after successful sync.
for i in $(find "$IMAGE_PATH" -type f -mtime +30); do
	echo "[$i]"
	FILE=$(basename "$i")
	FILEPARENT=$(echo "$i" | sed -e s%$IMAGE_PATH%% -e s%$FILE%%)
	YEAR=$(date +%Y -r "$i")
	#FILEDATE=$(stat -c '%y' "$i" | date "+%Y/%m")
	mkdir -p $ARCHIVE_PATH/$YEAR/$FILEPARENT
	rsync -van --stats --remove-source-files "$i" "$ARCHIVE_PATH/$YEAR/$FILEPARENT/$FILE" || exit 1
done

echo "Rsync completed successfully. Removing empty directories"
find $IMAGE_PATH -type d -empty -not -path $IMAGE_PATH -ls -delete | sed -e "s/$/  < deleted/"
