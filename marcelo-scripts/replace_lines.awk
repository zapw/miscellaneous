#!/usr/bin/awk -f
#this script deletes comment '/////' lines either beginning with + or not,  and in their place put whatever text appear after a line that begins with +Highlights or Highlights
#the condition is that Highlights must be seen before any other //// comment line or a 'report :' line  else it is reset and the loop starts again

function insert_owner_seperator(){
	if (seperator)
		line = line RS "" 
	 	seperator=0
	 if (owner){
		line = line RS owner
		owner=""
	 }

	 line = line RS line2; line2="" 
}

function extract_fields(linenum){
      	firstfield = index($0,":")
       	first = substr($0, 0, firstfield)
        secondfield=substr($0, firstfield+1, length($0))
        sub(/^[ \t\n\302\240]+/,"",secondfield)
        sub(/[ \t\n\302\240]+$/,"",secondfield)
        firstsecond = sprintf ("%-30s%s", first, secondfield)
	if (linenum == 1)
		line ? line = line RS firstsecond : line = firstsecond
	else if (linenum == 2 )
		line2 ? line2 = line2 RS firstsecond : line2 = firstsecond
}

/^+?[Hh][Ss][dD]:/ && !/N\/?A/{
			FS="[ \t\n\302\240]+" 
                     	$0=$0
			hsd=""
			for (i = 2; i <= NF; i++)
				hsd ? hsd = hsd " " $i : hsd = $i
			FS = " "
		   }

foundslash { 
		if ($0 ~ /^\+?\/\/\//){ 
			if (line2){
				insert_owner_seperator()
			}else 
				 seperator=1
			next 
		}
		if ( $0 ~ /report[[:space:]]+:$/ ){  
			line2 ? line2 = line2 RS $0 : line2 = $0
			insert_owner_seperator()
				
			foundslash=0
			next
		}
		

		if ($0 ~ /^+[ \n\t\302\240]/) {
		     FS="^+[ \t\n\302\240]+"
                     $0=$0
                     sub(/[ \t\n\302\240]+$/,"",$2)
		     firstsecond = sprintf ("%-30s%s", "+",$2)
		     line2 ? line2 = line2 RS firstsecond : line2 = firstsecond
                }else if ($0 ~ /^(+\w|@@[ \t\n\-+0-9,]+@@\s*\w+:)/) { 
			extract_fields(2)
		}else
		     line2 ? line2 = line2 RS $0 : line2 = $0 

		FS = " "
		$0 = $0

		if ( $0 ~ /^\+?Highlights:/ && $0 !~ /N\/A/ ){
			sub(/^\+?Highlights:(\s|\302|\240)+/,"")
                 	sub(/[ \t\n\302\240]+$/,"")
			if (hsd){
				line = line RS "<b><u>" hsd " - " $0 "</b></u>"
				hsd=""
			}else
				line = line RS "<b><u>"$0"</b></u>"
			line = line RS line2
			line2=""
			foundslash=0
			owner=""
		}
		else if ( $0 ~ /^(\+?|@@[ \t\n\-+0-9,]+@@\s*)Owner:/ ){
                        sub(/^(\+?|@@[ \t\n\-+0-9,]+@@\s*)Owner:(\s|\302|\240)+/,"")
                 	sub(/[ \t\n\302\240]+$/,"")
			if (hsd){
				owner = "<b><u><br><font size=4>" hsd " - Commit by: " $1 " " $2 "</font></br></b></u>"
				hsd=""
			}else
				owner = "<b><u><br><font size=4>Commit by: " $1 " " $2 "</font></br></b></u>"
                }
		next
 }

!foundslash {
		if ($0 !~ /^+?\/\/\//){
			if ($0 ~ /^+[ \n\t\302\240]/) {
			     FS="^+[ \t\n\302\240]+"
                             $0=$0
                             sub(/[ \t\n\302\240]+$/,"",$2)
			     firstsecond = sprintf ("%-30s%s", "+",$2)
		 	     line ? line = line RS firstsecond : line = firstsecond
                        }else if ($0 ~ /^+\w/) { 
			     extract_fields(1)
             		}else
		 	     line ? line = line RS $0 : line = $0 
		}else
			foundslash=1
		FS = " "
}

END { 
	insert_owner_seperator()
	print line RS line2
}
