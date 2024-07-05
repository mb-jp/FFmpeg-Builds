#!/bin/bash
set -xe

. ./setup.sh

setup win64

./makeimage.sh win64 lgpl '7.0'
./build.sh     win64 lgpl '7.0'
