#!/bin/bash

SHARD_ROCKS_BIN=$HOME/build/shard_rocks
if [ -z "${SHARD_ROCKS_BIN}" ]; then
  echo "${SHARD_ROCKS_BIN} is unset"
  exit 1
fi

sudo ${SHARD_ROCKS_BIN}/server/rocksdb_server -c f -n 4  --socket-mem 256 --log-level 7 \
--file-prefix sr -b 81:00.0  -- --rx "(0,0,0)" --tx "(0,1)" --w "2,3" --pos-lb 43 \
--lpm "192.168.4.0/24=>0;" --bsz "(4,4), (4,4), (4,4)"
