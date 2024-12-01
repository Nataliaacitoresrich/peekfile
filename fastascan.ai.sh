###AI version of the Midterm3, Natalia Acitores Rich

#### Defining Variables for the Report ####

# Setting input folder (X) and input number (N)
if [[ -d "$1" ]]; then       # If the first argument is a directory
    X="${1:-$(pwd)}"         # Use it as X; otherwise, default to the current directory
else
    X="$(pwd)"               # Default to the current directory if no valid folder is provided
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then   # If the first argument is numeric, set N
    N="$1"
else
    N="${2:-0}"                  # Otherwise, use the second argument as N, defaulting to 0
fi

# Finding all Fasta files in the folder
filename=$(find "$X" -type f \( -name "*.fa" -or -name "*.fasta" \))

#### Creating the Report ####

# 1st: Printing the total number of Fasta files
echo "The number of Fasta files is $(echo "$filename" | wc -l)"
echo "" # Blank line for readability

# 2nd: Printing the number of unique Fasta IDs
echo "$filename" | while read -r i; do
    grep ">" "$i" | awk '{split($0, A, / /); print A[1]}'
done | sort -n | uniq -c | awk '$1 == 1 {count++} END {print "There are", count, "unique Fasta IDs"}'

# 3rd: Printing per-file details
aa_non_nt="[RDQEHILKMFPSWYV]"  # Amino acids that don't match nucleotides

for i in $filename; do
    echo "====== $i"             # File header
    [[ -h "$i" ]] && echo "It is a symlink" # Check for symlink

    # Count and display the number of sequences in the file
    seq_count=$(grep ">" "$i" | wc -l)
    echo "There are $seq_count sequences in this file."

    # Calculate and display the total sequence length
    total_length=$(grep -v -h ">" "$i" | tr -d " \n-" | wc -m)
    echo "The total sequence length is $total_length."

    # Determine if the sequences are aminoacidic or nucleotidic
    grep -v -h ">" "$i" | tr -d " \n-" | awk -v aa_nt_awk="$aa_non_nt" '
    {
        if ($0 ~ aa_nt_awk) {
            aa_flag = 1
        } else {
            nt_flag = 1
        }
    }
    END {
        if (aa_flag) print "The sequences have aminoacids (AA)."
        if (nt_flag) print "The sequences have nucleotides (NT)."
    }'

    # Display file content conditionally
    linecount=$(wc -l < "$i")
    if [[ "$linecount" -le $((2 * N)) ]]; then
        cat "$i"
    elif [[ "$N" -gt 0 ]]; then
        head -n "$N" "$i"
        echo "..."
        tail -n "$N" "$i"
    fi
    echo "" # Blank line for readability
done


