if [[ -n $2 ]]; then 
lines=$2
else 
lines=3
fi

if [[ $(cat $1 | wc -l) -le $((2*$lines)) ]]; then
cat $1
else
head -n "$lines" "$1" 
echo "..."
tail -n "$lines" "$1"
fi




