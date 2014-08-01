bind dice pub "!roll" rolldie

proc rand {minn maxx} {
	set maxnum [expr {$maxx - $minn}]
	set fp [open /dev/urandom r]
	set bytes [read $fp 6]
	close $fp
	scan $bytes %c%c%c%c%c%c ca co ce cu ci ch
	set co [expr {$co * (2 ** 8)}]
	set ce [expr {$ce * (2 ** 16)}]
	set cu [expr {$cu * (2 ** 24)}]
	set ci [expr {$ci * (2 ** 32)}]
	set ch [expr {$ch * (2 ** 40)}]
	return [expr {$minn+(($ca+$co+$ce+$cu+$ci+$ch)%$maxnum)}]
}

proc rolldie {from to text} {
	# So hey, let's use our function above.
	set maxnum [lindex [split $text " "] 1]
	if {$maxnum != ""} {set num [rand 1 $maxnum]} {set num [rand 1 6]}
	puts stdout "Got !roll command"
	putmsg $to "[getnick $from]: Your die rolled $num"
}
