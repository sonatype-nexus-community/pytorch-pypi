#!/bin/bash

# update a PyPI index from PyTorch = https://download.pytorch.org/$d with d=whl or whl/<compute platform>
# this copies the content (main url + follows links to projects) and does 2 updates:
# 1. copies the content in a "simple/" sub-directory to match the convention from PEP 503 simple (that allows other APIs in parallel)
# 2. updates the links to binary packages by adding "https://download.pytorch.org" prefix to PyTorch-provided "/whl/*" path to link back to PyTorch binaries in their home location
function updateIndex() {
  local d=$1

  # will copy source $d to $d/simple
  mkdir -p $d/simple
  local dir="$(pwd)"
  cd $d/simple

  # projects list
  curl -s https://download.pytorch.org/$d/ | grep -v 'TIMESTAMP 1' > index.html
  local count="$(cat index.html | cut -d '>' -f 2 | cut -d '<' -f 1 | grep -cve '^\s*$')"

  echo "https://download.pytorch.org/$d/ => $d/simple/"
  checkCount $d $count 40

  # copy also content of each project
  local i=0
  for p in `cat index.html | cut -d '>' -f 2 | cut -d '<' -f 1`
  do
    mkdir -p $p
    cd $p
    ((i++))
    curl -s https://download.pytorch.org/$d/$p/ \
      | sed -e 's_href="/whl_href="https://download.pytorch.org/whl_' \
      | grep -v 'TIMESTAMP 1' \
      > index.html

    local pcount="$(cat index.html | grep -c 'https://download.pytorch.org/whl/')"
    printf "%5d / $count                   $d/$p/ => $d/simple/$p/ $pcount\n" $i
    checkCount $d/$p $count 1
    cd ..
  done
  echo
  cd "$dir"
}

function checkCount() {
  local content="$1"
  local count="$2"
  local minimum="$3"

  if [ $count -lt $minimum ]
  then
    echo "!!! failing because low packages count for $content: $count (probably intermittent download failure)"
    exit 1
  fi
}

# update main PyTorch index, that contains everything, whatever the compute platform
updateIndex "whl"

# see resulting updates
git update-index -q --refresh
git diff-index --name-status HEAD

if `git diff-index --quiet HEAD`
then
  echo "no update found in PyTorch main index."
  exit 0
fi
echo "updates found in PyTorch main index: updating also compute platform specific ones..."

# update compute-platform specific indexes
# ignore old non-updated ones:
# - cu75 cu80 cu90 cu91 cu92 cu100 cu101 cu102 cu110 cu111 cu113 cu115 cu116 cu117 cu117_pypi_cudnn
# - rocm3.10 rocm3.7 rocm3.8 rocm4.0.1 rocm4.1 rocm4.2 rocm4.3.1 rocm4.5.2 rocm5.0 rocm5.1.1 rocm5.2 rocm5.3 rocm5.4.2 rocm5.5 rocm5.6 rocm5.7
for d in cpu cpu-cxx11-abi cpu_pypi_pkg cu118 cu121 cu124 rocm6.0 rocm6.1
do
  updateIndex "whl/$d"
done

du -sh whl/*

for d in whl/simple whl/*/simple ; do echo "$(ls $d | wc -l | xargs) $d" ; done > summary.txt
cat summary.txt
