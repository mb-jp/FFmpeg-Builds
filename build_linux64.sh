#!/bin/bash
set -xe

. ./setup.sh

setup linux64

./makeimage.sh linux64 lgpl '7.0'
./build.sh     linux64 lgpl '7.0'
