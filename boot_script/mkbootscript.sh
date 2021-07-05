#!/bin/sh

mkimage -A arm64 -C none -T script -d $1 $2
