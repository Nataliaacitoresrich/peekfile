for file in "$@"; do
countlines=$(cat $1 | wc -l)

if [[ $countlines -eq 0 ]]; then echo "$1 has 0 lines"; elif [[ $countlines -eq 1 ]]; then  echo "$1 has 1 line"; else echo "$1 has >1 line"; fi
done
