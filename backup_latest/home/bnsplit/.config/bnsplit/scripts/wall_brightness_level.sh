#!/bin/bash

image=$1
mean=$(magick "$image" -colorspace Gray -format "%[fx:mean]" info:)
echo $mean
