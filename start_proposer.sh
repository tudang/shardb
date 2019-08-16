#!/bin/bash

SHARD_ROCKS_BIN=$HOME/build/shard_rocks
if [ -z "${SHARD_ROCKS_BIN}" ]; then
  echo "${SHARD_ROCKS_BIN} is unset"
  exit 1
fi

sudo ${SHARD_ROCKS_BIN}/client/rocksdb_client -c f0 -n 4  --socket-mem 256 --log-level 7 \
--file-prefix cl -b 08:00.0  -- --rx "(0,0,4)" --tx "(0,5)" --w "6,7" --pos-lb 43 \
--lpm "192.168.4.0/24=>0;" --bsz "(1,1), (1,1), (1,1)"
