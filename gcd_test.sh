#!/bin/bash

# gcd.shのフルパス（例：/path/to/gcd.sh）を指定します。
GCD_SCRIPT="./gcd.sh"

# 全てのテストが成功したかどうかを追跡するためのフラグ変数。
all_tests_passed=true

# 正常なケースとエラーケースの両方をテストします。
for i in {1..100}; do
  # 1から100までのランダムな整数を生成します。
  a=$((RANDOM % 100 + 1))
  b=$((RANDOM % 100 + 1))

  # 2つの数に対するgcd.shの呼び出しと結果の確認。
  result=$($GCD_SCRIPT $a $b 2>/dev/null)
  if [ -z "$result" ] || ((a % result != 0)) || ((b % result != 0)); then
    echo "Test failed with a=$a, b=$b, gcd=$result"
    all_tests_passed=false
  fi

  # 1つの数に対するgcd.shの呼び出しと結果の確認。
  result=$($GCD_SCRIPT $a 2>/dev/null)
  if [ -n "$result" ] && ((result == a)); then
    : # テスト成功：何もしない
  else
    echo "Test failed with a=$a, gcd=$result"
    all_tests_passed=false
  fi

  # 想定外の入力に対するエラーチェック
  result=$($GCD_SCRIPT $a $b $b 2>/dev/null)
  if [ -z "$result" ]; then
    echo "Test failed: Script should fail with three arguments"
    all_tests_passed=false
  fi

  result=$($GCD_SCRIPT "abc" 2>/dev/null)
  if [ -z "$result" ]; then
    echo "Test failed: Script should fail with non-integer arguments"
    all_tests_passed=false
  fi

  # 負の数のテスト
  result=$($GCD_SCRIPT -$a -$b 2>/dev/null)
  if [ -n "$result" ]; then
    : # テスト成功：何もしない
  else
    echo "Test failed: Script should fail with negative numbers"
    all_tests_passed=false
  fi

  # 小数のテスト
  result=$($GCD_SCRIPT $a.$b 2>/dev/null)
  if [ -n "$result" ]; then
    : # テスト成功：何もしない
  else
    echo "Test failed: Script should fail with decimal numbers"
    all_tests_passed=false
  fi

  # エラーにならない大きな数のテスト
  large_number=$((RANDOM * 10000000000000))
  result=$($GCD_SCRIPT $large_number $b 2>/dev/null)
  if [ -z "$result" ] || ((large_number % result != 0)) || ((b % result != 0)); then
    echo "Test failed with large_number=$large_number, b=$b, gcd=$result"
    all_tests_passed=false
  fi

  # 整数の範囲ギリギリの大きな数のテスト。64bitの最大の数
  large_number=9223372036854775807
  result=$($GCD_SCRIPT $large_number $b 2>/dev/null)
  if [ -z "$result" ] || ((large_number % result != 0)) || ((b % result != 0)); then
    echo "Test failed with large_number=$large_number, b=$b, gcd=$result"
    all_tests_passed=false
  fi

done

# 全てのテストが成功した場合、メッセージを表示します。
if $all_tests_passed; then
  echo "All tests passed successfully!"
  exit 0
else
  echo "Some tests failed. Please check the output for details."
  exit 1
fi
