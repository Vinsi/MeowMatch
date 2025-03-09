#!/bin/sh

if [ "$1" == "" ]; then
  echo "Requires directory"
  exit 1
fi

# run Swiftformat
./mint run swiftformat swiftformat $1 --swiftversion 5.0 --stripunusedargs  closure-only --disable blankLinesAtStartOfScope --patternlet inline --exclude
if [ $? -ne 0 ]; then
    echo "swiftformat error"
    exit 2
fi

# run Swiftlint
./mint run swiftlint swiftlint lint $1 --config .swiftlint.yml
if [ $? -ne 0 ]; then
    echo "swiftlint error"
    exit 3
fi
