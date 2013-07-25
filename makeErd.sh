#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"              
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done                                          
DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

IN_DIR=$1
OUT_DIR=$2

mkdir -p ${OUT_DIR}
rm -f ${OUT_DIR}/erd.gv && node ${DIR}/bin/generate --outDir ${OUT_DIR} --yamlDir ${IN_DIR}
rm -f ${OUT_DIR}/erd.png && dot ${OUT_DIR}/erd.gv | neato -n -Tpng -o${OUT_DIR}/erd.png

