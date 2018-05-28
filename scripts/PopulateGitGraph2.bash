#!\bin\bash
#Step 0. Get a Name+Email of current(me)  committer(s)/author(s) for the Repository....
currentAuthorName="$(git config user.name)"
currentAuthorEmail="$(git config user.email)"
authorName="$currentAuthorName <$currentAuthorEmail>"
currentAuthorNCommits="$(git shortlog -sne HEAD --since=1.years --author="$authorName")"

#Step 1. Fill Commits for the current author
commit1=()
tmpCommit="$(git shortlog -sne HEAD --since=1.years --until=11.months --author="$authorName")"
if [[   -z  $tmpCommit  ]]; then
commit1="	0	"
else
commit1=${tmpCommit%	*}
fi

for ((i=11; i>=1; i--)); do
   tmpCommit="$(git shortlog -sne HEAD --since=$i.months --until=$((i-1)).months --author="$authorName")"
   if [[   -z  $tmpCommit  ]]; then
      commit1+="	0	"
   else
      commit1+=${tmpCommit%	*}
   fi
done

#Step 2. Write out the data to a File.
{
graphDataFile="graphData2.dat"

#write data for current Committer.
printf "\"$authorName\"\n" >>$graphDataFile
index=0
commits1="${commit1[@]}"
for icommit in $commits1
do
    # bash arrays are 0-indexed
	((index++))
    printf "%s %s\n" "$index" "$icommit" >>$graphDataFile
done
printf "\n\n" >>$graphDataFile

} &> /dev/null

#Step 2.5. Greeting Message
echo "Git Graph for the Current Repository."

#Step3. Plot the Graph using Gnuplot with data from the graphData.dat file above.
gnuplot -p -e "set terminal dumb;plot for [IDX=0:0] 'graphData2.dat' i IDX u 1:2 w lines title columnheader(1);"

#Step4. Finally, Cleanup the Graph Data File.
rm -f $graphDataFile

#Step5. Print Closing Message! Wrapping things up!
echo -e "Excellent Job! You have contributed to the Development of the current Repository."
echo -e "Keep up the Good Work!"
