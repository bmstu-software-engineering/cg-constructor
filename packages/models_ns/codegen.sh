#!/bin/bash

rm -rf .dart_tool/
find . -iname "*.freezed.dart" -or -iname "*.g.dart" | xargs rm
fvm flutter pub run build_runner build --delete-conflicting-outputs
