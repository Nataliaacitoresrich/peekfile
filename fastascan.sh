#creating the variables X, indicating the input folder.
if [[ ! "$1" ]]; then X="$(pwd)"; else X="$1"; fi 
#creating the variable N, which stands for the input number. 
if [[ ! "$2" ]]; then N="0"; else N="$2"; fi 

#Function to find fasta files:
#find $X -type f -name "*.fa" -or -name "*.fasta"

#######Creating the REPORT
#1st: Number of fasta files
echo The number of Fasta files is $(find $X -type f -name "*.fa" -or -name "*.fasta" | wc -l )

echo " " #adding an space

#2nd: For each fasta file how many unique Fasta IDs are there. #First finding each fasta file, and for each file echoing the name and print the number of unique Fasta IDs in the next line.
find $X -type f -name "*.fa" -or -name "*.fasta" | while read i; do echo ======$i; (grep ">" $i | awk '{split($0,A,/ /); print A[1]}'| sort -n | uniq -c | awk -F' ' '$1==1{print $1}' | sort |uniq -c |awk -F' ' '{print $1}'); done

##3rd: Printing for each file 
#defining variable for filename
filename=$(find $X -type f -name "*.fa" -or -name "*.fasta")

#Header with: filename, number of sequences inside, total sequences length in each file and type.
echo $(for i in $filename; do echo ======$i;grep ">" $i | wc -l;grep -v -h ">" $filename | awk '{print length $0}'; done)
#count of sequences: grep -v -h ">" $filename | awk '{print length $0}'

