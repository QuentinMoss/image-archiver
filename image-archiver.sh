#!/bin/bash
#Enable Debugging
#set -x on
#######################################################################################################################
# This script uses rsync to sync directory contents from source to destination while keeping a 1 to 1 directory structure.
# * Note * This script does not handle duplicate directory names. Think of this as taking a snap shot if files meet a criteria.
#
# Examples:
#    move from:    nfs://productionstudio/digitalassets/_PHOTOS_FILES/CREATIVE/HL_HEROES
#    move to:    smb://10.240.11.60/Archive_2016/HEROES/HL_HEROES
#    move from:    nfs://productionstudio/digitalassets/_PHOTOS_FILES/CREATIVE/DUAL_FLASH
#    move to:    smb://10.240.11.60/Archive_2016/HEROES/DUAL_FLASH
#
# Move criteria: all files in a given directory are at least thirty days old
#
# Note: at this point only handles directories directly under set $image_path, does not go deeper
# Note: uses directory timestamp year for archive year
#
# Created by Quentin Moss <quejmoss@gmail.com>
#######################################################################################################################
image_path=/tmp/rsync_tests/images
archive_mount=/tmp/rsync_tests # note that this is now basically the archive path mount, not the whole path
rsync_success=0

# We need to handle spaces in file names. We will set internal field separator as new line
IFS="
"

# Verify provided directory exists
if [ ! -d $image_path ]; then
    echo $image_path "does not exist"
    exit 1
fi

if [ ! -d $archive_mount ]; then
    echo $archive_mount "does not exist"
    exit 1
fi

for i in "$image_path"/*; do # per each subdirectory in images dir..
    if [[ ! $(find "$i" -type f -mtime -30) ]]; then # if we find no recently modified files in that subdir..
        echo "[$i]"
        archive_path=$archive_mount"/archive_"$(date +%Y -r "$i")
        if [ ! -d $archive_path ]; then # create destination archive path if doesn't exist..
            mkdir -p $archive_path || exit 1; # but if we fail here, let's just leave.
        fi
        # and rsync to the destination archive path that now surely exists.
        rsync -va --remove-source-files "$i" "$archive_path" && rsync_success=1 || rsync_success=0
    fi
    if [ ! $rsync_success ]; then # if an rsync failed or no rsyncs occured, let's not delete directories
        echo "Rsync had issues, leaving."
        exit 1
    fi
done

echo "Rsync completed successfully. Removing empty directories.."
find $image_path -type d -empty -not -path $image_path -delete -print | sed -e "s/$/  < deleted/"
