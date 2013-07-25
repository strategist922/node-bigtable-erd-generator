#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"              
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done                                          
DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

mkdir -p build
rm -f ${DIR}/build/erd.gv && node bin/generate --outDir ${DIR}/build/ --yamlDir ${DIR}/yaml/
rm -f ${DIR}/build/erd.png && dot ${DIR}/build/erd.gv | neato -n -Tpng -o${DIR}/build/erd.png

