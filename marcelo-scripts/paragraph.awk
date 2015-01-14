#!/usr/bin/awk -f
#this script prints everything after a chosen paragraph  made of a line  that starts with Description starting with + or not including text after Description: up to a line that starts with +Test: or Test: or ///  

BEGIN { paragraph=2 ; var1="^\\+?Description:" ; var2="^\\+?Test:|^\\+?///" }

$0 ~ var2 && i == paragraph { exit }
flag && i == paragraph { print }

$0 ~ var1 { 
		i++ 
		if ( i == paragraph ) {
			 flag = 1  ; sub(/^\+?Description:[[:space:]]*/,"")
			 print
		}
}
