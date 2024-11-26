#creating the variables X, indicating the input folder.
if [[ ! "$1" ]]; then X="$(pwd)"; else X="$1"; fi 
#creating the variable N, which stands for the input number. 
if [[ ! "$2" ]]; then N="0"; else N="$2"; fi 

#Function to find fasta files:
#find $X -type f -name "*.fa" -or -name "*.fasta"

#######Creating the REPORT
#1st: Number of fasta files
echo The number of Fasta files is $(find $X -type f -name "*.fa" -or -name "*.fasta" | wc -l )

#2nd: For each fasta file how many unique Fasta IDs are there
find $X -type f -name "*.fa" -or -name "*.fasta" | while read i; do echo $i; grep ">" $i; done #####continuar para que me coja el ID, probablemente con sort, mirar que lo separa si espacio o tab o ns, ahora mismo es como si tuviera una tabla
