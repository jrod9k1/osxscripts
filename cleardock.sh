#!/bin/sh

# Script to clear a user's dock completely
# Please make sure to run this script under the user who's dock you are attempting to clear!

defaults write com.apple.dock static-only -bool TRUE
killall Dock
