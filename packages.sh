#!/bin/bash

# Author: Lucas de Macedo <lucasmtercas@gmail.com>

set -eu

packages_file="${1}"

packages=""
while IFS= read -r line; do
  packages="${packages} ${line}"
done < "${packages_file}"
sudo pacman -S --noconfirm ${packages}
