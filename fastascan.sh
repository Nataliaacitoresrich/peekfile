##Midterm 3. Master in Bioinformatics for health sciences, UPF. 


####Defining variables for the report
#creating the variables X, indicating the input folder.
if [[ -d "$1" ]]; then 		#checking if the first argument is a folder, otherwise it could be the input number for variable N.
if [[ ! "$1" ]]
then X="$(pwd)"
else
X="$1"
fi ; fi
#creating the variable N, which stands for the input number. 
if [[ "$1" -gt 0 ]] 		#checking if the first argument is numerical
then N="$1" 			#if it is numerical then N will be the first argument
elif [[ ! "$2" ]]		#if $2 does not exist, N will be 0 
then N="0"			
else N="$2"			#if $2 exists it will be the variable N
fi	
#defining a variable called filename which is the command that enables us to find the fasta files
filename=$(find $X -type f -name "*.fa" -or -name "*.fasta")



#######Creating the REPORT
#1st: Printing the total number of fasta files:
echo The number of Fasta files is $(echo "$filename" | wc -l)
echo " " #adding an space

#2nd: Printing how many unique Fasta IDs there are in total: 
echo "$filename" | while read i      			
do grep ">" $i | awk '
{split($0,A,/ /); print A[1]}' 			#getting the Fasta IDs, and sorting to get the unique ID's
done | sort -n | uniq -c | awk -F' ' '		
$1==1{print $1}					#from the unique output, getting only the numbers, then only keeping the unique Ids
' | sort |uniq -c |awk -F' ' '
{print "There are " $1 " unique Fasta IDs" }'		


##3rd: Printing for each file a header and lines to be displayed. 
aa_non_nt="[RDQEHILKMFPSWYV]" #defining string of aa that do not match any nucleotide symbol or Ns as is how missmatches are displayed in the sequence. 

#Header:
for i in $filename
do echo "======$i"		#printing filename
if [[ -h "$i" ]]; then
echo "it is a symlink"		#checking if the file is a symlink
fi 
echo There are $(grep ">" "$i" | wc -l) sequences in this file	#Number of sequences inside

#from every fasta file, we want to know the total sequences length, in order to do so, we first have to remove gaps, spaces and newlines.
grep -v -h ">" "$i" | awk '	
	
        { gsub("-", "") 	#removing gaps "-"
        gsub(" ", "")		#removing spaces
        gsub ("\n","")		#removing newlines
        print $0}
' | echo The total sequences length is $(wc -m) 	 

# to check if the sequences are nucleotidic or aminoacidic:
grep -v -h ">" "$i" | awk '	
	
        { gsub("-", "") 	#removing gaps "-"
        gsub(" ", "")		#removing spaces
        gsub ("\n","")		#removing newlines
        print $0}
'|awk  -v aa_nt_awk="$aa_non_nt" ' 							#including the aa_non_nt variable in awk.
{if ($0~aa_nt_awk) {print "The sequences have aminoacids   AA"} 			#printing if the sequence is composed of aminoacids or nucleotides
else {print "The sequences have nucleotides   NT"}}' | sort | uniq 	

# Displaying sequence lines given the condition: if the file has 2N lines or fewer, then display its full content; if not, show the first N lines, then "...", then the last N lines. If N is 0, skip this step.
linecount=$(wc -l "$i"|awk '{split ($0,A,/ /); print A[1]}')		#count the lines and print only the number, not the path to the file
if [[ "$linecount" -le $((2*N)) ]]; then #setting the condition
cat "$i"
else 
head -n $N "$i"
echo "..."
tail -n $N "$i"
fi
done













