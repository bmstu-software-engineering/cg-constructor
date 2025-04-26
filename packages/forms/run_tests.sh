#!/bin/bash

set -e

./codegen.sh  > /dev/null # т.к. в тестах используется кодген и он мог изменится за время разработки
fvm flutter test -r failures-only --no-pub
