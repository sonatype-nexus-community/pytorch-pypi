#!/bin/bash

# old non-updated compute platforms:
# cu75 cu80 cu90 cu91 cu92 cu100 cu101 cu102 cu110 cu111 cu113 cu115 cu116 cu117 cu117_pypi_cudnn
# rocm3.10 rocm3.7 rocm3.8 rocm4.0.1 rocm4.1 rocm4.2 rocm4.3.1 rocm4.5.2 rocm5.0 rocm5.1.1 rocm5.2 rocm5.3 rocm5.4.2 rocm5.5 rocm5.6 rocm5.7
for d in . cpu cpu-cxx11-abi cpu_pypi_pkg cu118 cu121 cu124 rocm6.0 rocm6.1
do
  d="whl/$d"
  [ "$d" == "whl/." ] && d="whl"
  mkdir -p $d/simple
  dir="$(pwd)"
  cd $d/simple
  curl -s https://download.pytorch.org/$d/ | grep -v 'TIMESTAMP 1' > index.html
  count="$(cat index.html | cut -d '>' -f 2 | cut -d '<' -f 1 | grep -cve '^\s*$')"

  echo "https://download.pytorch.org/$d/ $count => $d/simple/"
  if [ $count -lt 40 ]
  then
    echo "failing because low packages count for $d: $count (intermittent download failure?)"
    exit 1
  fi

  i=0
  for p in `cat index.html | cut -d '>' -f 2 | cut -d '<' -f 1`
  do
    mkdir -p $p
    cd $p
    ((i++))
    curl -s https://download.pytorch.org/$d/$p/ \
      | sed -e 's_href="/whl_href="https://download.pytorch.org/whl_' \
      | grep -v 'TIMESTAMP 1' \
      > index.html

    count="$(cat index.html | grep -c 'https://download.pytorch.org/whl/')"
    echo "$i                            $d/$p/ => $d/simple/$p/ $count"
    if [ $count -lt 1 ]
    then
      echo "failing because low packages count for $d/$p: $count (intermittent download failure?)"
      exit 1
    fi
    cd ..
  done
  echo
  cd "$dir"
done

du -sh whl/*

for d in whl/simple whl/*/simple ; do echo "$(ls $d | wc -l) $d" ; done > summary.txt
cat summary.txt
