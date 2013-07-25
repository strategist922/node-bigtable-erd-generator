#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"              
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done                                          
DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

mkdir -p build
rm -f build/erd.gv && node ${DIR}/bin/generate --outDir build/ --yamlDir yaml/
rm -f build/erd.png && dot build/erd.gv | neato -n -Tpng -obuild/erd.png

