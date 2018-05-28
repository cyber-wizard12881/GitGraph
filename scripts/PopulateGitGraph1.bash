#!\bin\bash
#Step 0. Get a List of Top 3 committers/authors for the Repository....
authorsNCommits="$(git shortlog -sne --since=1.years | head -3)"

#Step 1. Iterate through the set of Authors obtained in the step above....
commit=()
author=()
authorNCommits=()
while read -r -a authorNCommit; do
    read -a authorNCommits <<< "${authorNCommit[@]}"
	commit+=("${authorNCommits[0]}")
	tmpAuthor="${authorNCommits[@]:1}"
	author+=("$tmpAuthor")
done <<< "$authorsNCommits"

#Step 2. Get Commits for each of the top 3 authors for the Repository
commit1=()
commit2=()
commit3=()

#Step 2.1 Fill Commits for the 1st author
if [[ "${#author[@]}" -gt "0" ]];then
tmpCommit="$(git shortlog -sne --since=1.years --until=11.months --author="${author[0]}")"
if [[   -z  $tmpCommit  ]]; then
commit1="	0	"
else
commit1=${tmpCommit%	*}
fi

for ((i=11; i>=1; i--)); do
   tmpCommit="$(git shortlog -sne --since=$i.months --until=$((i-1)).months --author="${author[0]}")"
   if [[   -z  $tmpCommit  ]]; then
      commit1+="	0	"
   else
      commit1+=${tmpCommit%	*}
   fi
done
fi

#Step 2.2 Fill Commits for the 2nd author
if [[ "${#author[@]}" -gt "1" ]];then
tmpCommit="$(git shortlog -sne --since=1.years --until=11.months --author="${author[1]}")"
if [[   -z  $tmpCommit  ]]; then
commit2="	0	"
else
commit2=${tmpCommit%	*}
fi

for ((i=11; i>=1; i--)); do
   tmpCommit="$(git shortlog -sne --since=$i.months --until=$((i-1)).months --author="${author[1]}")"
   if [[   -z  $tmpCommit  ]]; then
      commit2+="	0	"
   else
      commit2+=${tmpCommit%	*}
   fi
done
fi

#Step 2.3 Fill Commits for the 3rd author
if [[ "${#author[@]}" -gt "2" ]];then
tmpCommit="$(git shortlog -sne --since=1.years --until=11.months --author="${author[2]}")"
if [[   -z  $tmpCommit  ]]; then
commit3="	0	"
else
commit3=${tmpCommit%	*}
fi

for ((i=11; i>=1; i--)); do
   tmpCommit="$(git shortlog -sne --since=$i.months --until=$((i-1)).months --author="${author[2]}")"
   if [[   -z  $tmpCommit  ]]; then
      commit3+="	0	"
   else
      commit3+=${tmpCommit%	*}
   fi
done
fi

#Step 3. Write out the data to a File.
{
graphDataFile="graphData1.dat"

#write data for 1st Committer.
if [[ "${#author[@]}" -gt "0" ]];then
printf "\"${author[0]}\"\n" >>$graphDataFile
index=0
commits1="${commit1[@]}"
for icommit in $commits1
do
    # bash arrays are 0-indexed
	((index++))
    printf "%s %s\n" "$index" "$icommit" >>$graphDataFile
done
printf "\n\n" >>$graphDataFile
fi

#write data for 2nd Committer.
if [[ "${#author[@]}" -gt "1" ]];then
printf "\"${author[1]}\"\n" >>$graphDataFile
index=0
commits2="${commit2[@]}"
for icommit in $commits2
do
    # bash arrays are 0-indexed
	((index++))
    printf "%s %s\n" "$index" "$icommit" >>$graphDataFile
done
printf "\n\n" >>$graphDataFile
fi

#write data for 3rd Committer.
if [[ "${#author[@]}" -gt "2" ]];then
printf "\"${author[2]}\"\n" >>$graphDataFile
index=0
commits3="${commit3[@]}"
for icommit in $commits3
do
    # bash arrays are 0-indexed
	((index++))
    printf "%s %s\n" "$index" "$icommit" >>$graphDataFile
done
printf "\n\n" >>$graphDataFile
fi

} &> /dev/null

#Step 3.5. Greeting Message
echo "Git Graph for the Current Repository."

#Step4. Plot the Graph using Gnuplot with data from the graphData.dat file above.
if [[ "${#author[@]}" -eq "3" ]];then
gnuplot -p -e "set terminal dumb;plot for [IDX=0:2] 'graphData1.dat' i IDX u 1:2 w lines title columnheader(1);"
elif [[ "${#author[@]}" -eq "2" ]]; then
gnuplot -p -e "set terminal dumb;plot for [IDX=0:1] 'graphData1.dat' i IDX u 1:2 w lines title columnheader(1);"
elif [[ "${#author[@]}" -eq "1" ]]; then
gnuplot -p -e "set terminal dumb;plot for [IDX=0:0] 'graphData1.dat' i IDX u 1:2 w lines title columnheader(1);"
fi

#Step5. Finally, Cleanup the Graph Data File.
if [[ "${#author[@]}" -gt "0" ]]; then
rm -f $graphDataFile
fi

#Step5. Print Closing Message!
echo -e "Excellent Job! You are now ready to contribute to the Development of the current Repository, like your Peers."
echo -e "Happy Coding!"
