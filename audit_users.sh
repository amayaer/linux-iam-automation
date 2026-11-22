#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

findings=0 

report_result() {
  if [ -z "$1" ]; then
      echo "No findings"
  else
      echo "$1"
      count=$(echo "$1" | wc -l)
      findings=$((findings + count))
  fi
}

print_header() {
   local title="$1"
   printf "\n=====================================\n"
   printf "  %s\n" "$title"
   printf "=====================================\n\n"
}

print_header "UID 0 accounts"
uid0=$(awk -F: '$3 == 0 && $1 != "root" { print $1 }' /etc/passwd)
report_result "$uid0"

print_header "Locked accounts"
users=$(awk -F: '$3 >= 1000 && $3 < 65534 { print $1 }' /etc/passwd)
locked=""

while read -r username; do
  userlk=$(passwd -S "$username" | awk '$2 == "LK" { print $1 }')
  locked+="$userlk"
done <<< "$users"
report_result "$locked"