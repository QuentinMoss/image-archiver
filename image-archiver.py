#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os,sys,re
import filecmp
import shutil

# Take argument on script execution. Provided directory should contain all images. Referred to as parent directory
source_path = sys.argv[1]
archive_path   = sys.argv[2]

def main():
    # Print out the directory structure we will be working with
    print('The provided source directory is *' + source_path + '*')

    # Create the archiev directory if it does not exist
    createArchiveDirectory()

    # Create list of files that we will be archiving
    files_for_sync = filecmp.dircmp(source_path, archive_path).left_only
    print files_for_sync
    for files in files_for_sync:
        shutil.copy(source_path + "/" + files, archive_path)


# Creates archiev directory if it does not exist
def createArchiveDirectory():
    if not os.path.exists('archive'):
        os.makedirs('archive')

if __name__ == "__main__":
    main()
