#!/bin/bash

set -e

find . -iname "*.g.dart" | xargs rm -rf
rm -rf .dart_tool 
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm dart format .
