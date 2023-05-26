#!/bin/bash
program=`basename $0`
echo $program

dairy_enc()
{
	local dir=$1
	local files
	local filename
	files=$(ls "$dir")
	pass=$2
	enc_suffix=".enc"
	
	for file in $files
	do
		local path="$dir/$file"
		if [ -d "$path" ]; then
			dairy_enc "$path" $2
		else
			if [ "$file" != "$program" ]; then
				#openssl enc -e -des-cfb -k "$pass" -in "$path" -out "$path""$enc_suffix" 
				openssl enc -e -aes-128-cbc -k "$pass" -in "$path" -out "$path""$enc_suffix" 
				rm "$path"
			else
				echo "$path"
			fi
		fi
	done
}

dairy_dec()
{
	local dir=$1
	local files
	local file_name
	files=$(ls "$dir")
	pass=$2	
	
	for file in $files
	do
		local path="$dir/$file"
		if [ -d "$path" ]; then
			dairy_dec "$path" $2
		else
			if [ "$file" != "$program" ]; then
				file_name=`echo "$path" | sed 's/.enc//g'`
				#openssl enc -d -des-cfb -k "$pass" -in "$path" -out "$file_name" 
				openssl enc -d -aes-128-cbc -k "$pass" -in "$path" -out "$file_name" 
				rm "$path"
			else
				echo "$path"
			fi
		fi
	done
}

dairy_insert()
{
	echo "insert" $1 "to" $2
	date=`date`
	if [ ! -f "$1" ]; then
		exit 0
	fi	
	if [ ! -f "$2" ]; then
		exit 0
	fi	
	echo "insert" $1 "to" $2
	echo "#######################"$date"####################" >> $2
	cat $1 >> $2
	echo "#######################"$date"####################" >> $2
}

if [ "$#" != 3 ];then
	echo "dairy.sh e/d/i . pass"	
	exit 0
fi
if [ "$1" = "e" ]; then
	dairy_enc $2 $3
elif [ "$1" = "d" ]; then
	dairy_dec $2 $3
elif [ "$1" = "i" ]; then
	dairy_insert $2 $3
else
	echo "dairy.sh e/d/i ./dairy pass"	
fi
