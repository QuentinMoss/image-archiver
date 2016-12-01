#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os,sys

def main():
    # Take argument on script execution. Provided directory should contain all images. Referred to as parent directory
    directory_path = sys.argv[1]

    # Create the archiev directory if it does not exist
    createArchiveDirectory()

    # Print out the directory
    for folderName, subfolders, filenames in os.walk(directory_path):
        print('The provided parent directory is *' + folderName + '*')
    for subfolder in subfolders:
        print('The parent directory contains the following sub folders *' + folderName + ': ' + subfolder + '*')
    for filename in filenames:
        print('Found the following files *' + folderName + '/'+ filename + '*')

# Define function that creates directory if it does not exist
def createArchiveDirectory():
    if not os.path.exists('archive'):
        os.makedirs('archive')

if __name__ == "__main__":
    main()
