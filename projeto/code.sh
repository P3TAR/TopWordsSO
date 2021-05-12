#!/usr/bin/env bash
mode=$1
file=$2

if [ -z "$mode" ] && [ -z "$file" ]
	then
		echo "[ERROR] insufficient parameters"
		exit
fi



if [[ $3 == "" ]]
	then
		stop="./projeto/en.stop_words.txt" 

elif [ $3 == 'pt' ] || [ $3 == 'PT' ]
	then
		stop="./projeto/pt.stop_words.txt"
	
elif [ $3 == 'en' ] || [ $3 == 'EN']
	then
		stop="./projeto/en.stop_words.txt"
fi





if [[ $(head -c 4 $2) == "%PDF" ]] 
	then
		pdftotext $2 "${2}.txt"
	 	file=${2}.txt
fi




if [[ $WORDS_STATS_TOP == 0 ]] || [[ $WORDS_STATS_TOP == '' ]] || [[ $WORDS_STATS_TOP == [a-zA-Z] ]]
	then
		topwords=10
	else
		topwords=$WORDS_STATS_TOP

fi



plot_graph () {
	 gnuplot -e "set xlabel 'words'; set ylabel 'number of occurrences'; set title 'top words for ${file}'; set term png; set output 'result---${file}.png'; set boxwidth 0.5; set style fill solid; plot 'result---${file}' using 1:3xtic(2) with boxes"
}



create_html () {

	{
	echo "<html>"
	echo "<head>"
	echo "<meta charset='utf-8'>"
	echo "<title>'$file'<title>"
	echo "</head>"
	echo "<body>"
	echo "<img src='result---${file}.png'>"
		}>> result---${file}.html

}



if [ $mode == "c" ]
	then 
		grep -oE '[[:alpha:]]+' $file | tr 'A-Z' 'a-z' | grep -vwFf $stop | sort | uniq -c | sort -nr | tee "./projeto/result---${file}"

elif [ $mode == "C" ]
	then
		grep -oE '[[:alpha:]]+' $file | tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr | tee "./projeto/result---${file}"
	


elif [ $mode == "t" ]
	then 
		grep -oE '[[:alpha:]]+' $file  | tr 'A-Z' 'a-z' | grep -vwFf $stop | sort | uniq -c | sort -nr | nl | head -$topwords | tee "./projeto/result---${file}"

elif [ $mode == "T" ]
	then
		grep -oE '[[:alpha:]]+' $file | tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr | nl | head -$topwords | tee "./projeto/result---${file}"



elif [ $mode == "p" ]
	then

		grep -oE '[[:alpha:]]+' $file  | tr 'A-Z' 'a-z' | grep -vwFf $stop | sort | uniq -c | sort -nr | nl | head -$topwords | tee "result---${file}"
	
			plot_graph "result---${file}"
	
			create_html "result---${file}.png"
	
elif [ $mode == "P" ]
	then

		grep -oE '[[:alpha:]]+' $file | tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr | nl | head -$topwords | tee "result---${file}"
	
			plot_graph "result---${file}"	
	
			create_html "result---${file}.png"



else
	echo "[ERROR] unknown command $1"

fi
