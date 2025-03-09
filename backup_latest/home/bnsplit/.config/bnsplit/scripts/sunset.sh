#!/bin/bash

TEMPERATURE=4500
[[ $(pgrep -f hyprsunset) ]] && killall hyprsunset || setsid $(hyprsunset -t $TEMPERATURE &)
