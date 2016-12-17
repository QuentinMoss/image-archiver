#!/bin/bash
#Enable Debugging
#set -x on
#######################################################################################################################
# This script uses rsync to sync directory contents from source to destination while keeping a 1 to 1 directory structure.
#
# Move criteria: all files in a given directory are at least thirty days old
#
# Note: at this point only handles directories directly under set $image_path, does not go deeper. That means that even if there subdirectory (mount/dir/subdir) that has all old files, it won't get moved until dir has only old files in all its subdirectories.
# Note: uses directory timestamp year for archive year
#
#######################################################################################################################
image_path=/tmp/rsync_tests/images
archive_mount=/tmp/rsync_tests
rsync_success="no runs"

# We need to handle spaces in file names. We will set internal field separator as new line
IFS="
"

# Verify provided directories exist
if [ ! -d $image_path ]; then
    echo $image_path "does not exist"
    exit 1
fi

if [ ! -d $archive_mount ]; then
    echo $archive_mount "does not exist, may not be mounted"
    exit 1
fi

for i in "$image_path"/*; do # per each subdirectory in images dir..
    if [[ ! $(find "$i" -type f -mtime -30) ]]; then # if we find no recently modified files in that directory..
        echo "[$i]"
        archive_path=$archive_mount"/archive_"$(date +%Y -r "$i")
        if [ ! -d $archive_path ]; then # create destination archive path if doesn't exist..
            mkdir -p $archive_path || exit 1; # but if we fail here, let's just leave.
        fi
        # and rsync to the destination archive path that now surely exists
        rsync -va --remove-source-files "$i" "$archive_path" && rsync_success="success" || rsync_success="failure"

        if [ "$rsync_success" = "failure" ]; then
            echo "An rsync failed, leaving"
            exit 1
        fi
    fi
done

case $rsync_success in
    "no runs")
        echo "No directories with the specified criteria were found, not doing anything."
        exit 0
        ;;
    "success")
        echo "Rsync completed successfully. Removing empty directories.."
        find $image_path -type d -empty -not -path $image_path -delete -print | sed -e "s/$/  < deleted/"
        exit 0
        ;;
    *)
        echo "Unexpected result from rsync, leaving"
        exit 1
esac
