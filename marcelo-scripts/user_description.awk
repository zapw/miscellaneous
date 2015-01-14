#!/usr/bin/awk -f
{ 
  if ( $1 == "commit" ){
	flag=0
	next
  }
  if ( $1 ~ /\[Description\s*\]:/ ){
	sub(/\s*\[Description\]:\s*/,"",$0)
	desc = $0
	flag=1
	next
  }
  if ( $0 ~ /\[User story\s*\]:/ ){
	sub(/\s*\[User story \]:\s*/,"",$0)
	if ( flag == 0 )
		desc=""
	print $0" - "desc
  }
}
