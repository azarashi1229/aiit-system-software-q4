#!/bin/bash

# 最大公約数を求める関数
gcd() {
  a=$1
  b=$2
  while [ "$b" -ne 0 ]; do
    t=$b
    # shellcheck disable=SC2004
    b=$(( $a % $b ))
    a=$t
  done
  echo "$a"
}

# 引数が1つか2つあることを確認
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Usage: $0 <num1> [<num2>]"
  exit 1
fi

# 引数が整数であること、かつ一定の範囲内であることを確認
re='^[0-9]+$'
max_int=9223372036854775807  # 64-bit signed integerの最大値
# shellcheck disable=SC2068
for arg in $@; do
  if ! [[ $arg =~ $re ]]; then
    echo "Error: Arguments must be integers."
    exit 1
  fi
  if (( arg > max_int )); then
    echo "Error: Argument is too large."
    exit 1
  fi
done

# 引数が1つの場合はその数を返す、2つの場合は最大公約数を求める
if [ $# -eq 1 ]; then
  echo "$1"
else
  # shellcheck disable=SC2005
  # shellcheck disable=SC2046
  echo $(gcd "$1" "$2")
fi
