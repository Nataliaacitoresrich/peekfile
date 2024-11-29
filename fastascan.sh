####Defining variables for the report
#creating the variables X, indicating the input folder.
if [[ ! "$1" ]]; then X="$(pwd)"; else X="$1"; fi 
#creating the variable N, which stands for the input number. 
if [[ ! "$2" ]]; then N="0"; else N="$2"; fi 
#defining a variable called filename which is the command that enables us to find the fasta files
filename=$(find $X -type f -name "*.fa" -or -name "*.fasta")

#######Creating the REPORT
#1st: Printing the total number of fasta files:
echo The number of Fasta files is "$filename" | wc -l 

echo " " #adding an space


#2nd: For each fasta file how many unique Fasta IDs are there: 

echo "$filename" | while read i      			# finding each fasta file and deriving the paths of the files to a loop 
do echo ======$i                                        # echoing the name of the fasta file. 
(grep ">" $i | awk '{split($0,A,/ /); print A[1]}'| sort -n | uniq -c | awk -F' ' '$1==1{print $1}' | sort |uniq -c |awk -F' ' '{print $1}')
# grepping the header using ">", then splitting the output by spaces in order to haven only the Fasta ID (print A[1]). afterwards we sorted the Id's and counted them. From this output we now filter to keep only the ones with counts = 1 (unique). After this we filter again to print only the number, not the ID's. 
done


##3rd: Printing for each file a header and lines to be displayed. 
aa_non_nt="[RNDQEHILKMFPSWYV]" #defining string of aa that are do not match any nucleotide symbol.

###Header:
for i in $filename
do echo "======$i"		#printing filename
if [[ -h "$i" ]]; then
echo "it is a symlink"	#checking if the file is a symlink
fi 
grep ">" "$i" | wc -l		#Number of sequences inside
grep -v -h ">" "$i" | awk '	#from every fasta file, we want to count the sequence length, in order to do so we first have to remove gaps, spaces and newlines
	
        { gsub("-", "") 	#removing gaps "-"
        gsub(" ", "")		#removing spaces
        gsub ("\n","")		#removing newlines
        print $0}
' |awk  -v aa_nt_awk="$aa_non_nt" ' 				#including the aa_non_nt variable in awk.
{if ($0~aa_nt_awk) {print "AA" " " length} 			#printing the length of the sequences and if it is an aminoacidic sequence (AA) and nucleotidic sequence (NT)
else {print "NT" " " length}}' 
done	

####Displaying sequence lines given the condition: if the file has 2N lines or fewer, then display its full content; if not, show the first N lines, then "...", then the last N lines. If N is 0, skip this step.














