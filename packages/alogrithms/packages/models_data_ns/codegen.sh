#!/bin/bash

rm -rf .dart_tool 
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm dart format .
