#!/bin/bash
#Enable Debugging
#set -x on
#######################################################################################################################
# This script uses rsync to sync directory contents from source to destination while keeping a 1 to 1 directory structure.
# * Note * This script does not handle duplicate directory names. Think of this as taking a snap shot if files meet a criteria.
#
# Created by Quentin Moss <quejmoss@gmail.com>
#######################################################################################################################
image_path=/home/rsync_tests/images
archive_path=/home/rsync_tests/archive

# We need to handle spaces in file names. We will set internal field separator as new line
IFS="
"

# Verify provided directory exists
if [ ! -d $image_path ]; then
	echo $image_path "does not exist"
	exit 1
fi

if [ ! -d $archive_path ]; then
	echo $archive_path "does not exist"
	exit 1
fi

# Start image sync, and remove source files after successful sync.
for i in $(find "$image_path" -type f -mtime +30); do
	echo "[$i]"
	file=$(basename "$i")
	fileparent=$(echo "$i" | sed -e s%$image_path%% -e s%$file%%)
	year=$(date +%Y -r "$i")
	mkdir -p $archive_path/$year/$fileparent
	rsync -van --stats --remove-source-files "$i" "$archive_path/$year/$fileparent/$file" || exit 1
done

echo "Rsync completed successfully. Removing empty directories"
find $image_path -type d -empty -not -path $image_path -ls -delete | sed -e "s/$/  < deleted/"
