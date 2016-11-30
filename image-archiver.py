#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os,sys

def main():
    # Take argument on script execution. Provided directory should contain all images.
    directory_path = sys.argv[1]

    # Create the archiev directory if it does not exist
    createArchiveDirectory()

    #print directory_path
    for folderName, subfolders, filenames in os.walk(directory_path):
        print('The current folder is ' + folderName)
    for subfolder in subfolders:
        print('subfolder of ' + folderName + ': ' + subfolder)
    for filename in filenames:
        print('file inside' + folderName + ': '+ filename)

def createArchiveDirectory():
    if not os.path.exists('archiev'):
        os.makedirs('archiev')

if __name__ == "__main__":
    main()
