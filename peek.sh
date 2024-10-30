if [[ -n $2 ]]; then 
lines=$2
else 
lines=3
fi

head -n "$lines" "$1" 
echo "..."
tail -n "$lines" "$1"




