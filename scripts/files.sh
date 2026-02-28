#!/bin/bash

# NOTE: 複数の値を返却すると受け取りに問題が出るため、個別に取得する関数を用意
get_basename() {
  printf '%s' "${1%.*}"
}

get_ext() {
  printf '%s' "${1##*.}"
}
