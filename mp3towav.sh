#!/bin/bash

find . -type f -name "*.mp3" -print0 | while IFS= read -r -d '' i; do
  # create .wav file name
  mkdir -p wav
  out="wav/${i:2}.wav"

  echo -n "Processing ${i}..."
  mpg123 -w "${out}" "$i" &>/dev/null
  echo "done."
done