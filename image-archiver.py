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
    # Create directory structure if *doesn't exist* before we begin sync tasks.
    createDirStructure(source_path, archive_path)
    # Create list of files that we will be archiving
    files_for_sync = filecmp.dircmp(source_path, archive_path).left_only
    for files in files_for_sync:
        shutil.copy(source_path + "/" + files, archive_path)

# Creates archiev directory if it does not exist
def createArchiveDirectory():
    if not os.path.exists('archive'):
        os.makedirs('archive')

def createDirStructure(s, a):
    for root, subdirs, files in os.walk(s):
        for subdir in subdirs:
            dir_create = os.path.join(a, subdir)
            if not os.path.exists(dir_create):
                os.makedirs(dir_create)

if __name__ == "__main__":
    main()
