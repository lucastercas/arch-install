#!/usr/bin/env bash

packages_file="./src/pkgs/default.txt"
packages=""
while IFS= read -r line; do
  packages="${packages} ${line}"
done < "$packages_file"

echo "$packages"
