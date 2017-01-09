#!/bin/bash
base_path=/tmp/rsync_tests

echo base path is $base_path, sleeping for a bit && sleep 5

mkdir -p $base_path/images/should_move
mkdir -p $base_path/images/shouldnt_move
mkdir -p $base_path/images/another_should_move/sub
mkdir -p $base_path/images/another_shouldnt_move/sub

#base_dir shouldn't be moved
touch -t 201610231220   $base_path/images/twomonthsold
touch -t 201609231220   $base_path/images/threemonthsold

touch -t 201609231220   $base_path/images/should_move/threemonthsold
touch -t 201610231220   $base_path/images/should_move/twomonthsold

touch -t 201610231220   $base_path/images/shouldnt_move/twomonthsold
touch -t 201609231220   $base_path/images/shouldnt_move/threemonthsold
touch                   $base_path/images/shouldnt_move/new

touch -t 201609231220   $base_path/images/another_shouldnt_move/threemonthsold
touch -t 201610231220   $base_path/images/another_shouldnt_move/twomonthsold
touch -t 201609231220   $base_path/images/another_shouldnt_move/sub/threemonthsold
touch -t 201610231220   $base_path/images/another_shouldnt_move/sub/twomonthsold
touch                   $base_path/images/another_shouldnt_move/sub/new

touch -t 201609231220   $base_path/images/another_should_move/threemonthsold
touch -t 201610231220   $base_path/images/another_should_move/twomonthsold
touch -t 201609231220   $base_path/images/another_should_move/sub/threemonthsold
touch -t 201610231220   $base_path/images/another_should_move/sub/twomonthsold

echo done:
ls -la $base_path/images $base_path/images/* $base_path/images/*/sub
