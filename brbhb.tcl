bind brbhb pub "*brb*" hurryback
bind brbhb pub "*bbiab*" hurryback
bind brbhb pub "*bbiaf*" hurryback
bind brbhb pub "*back*" wback
bind brbhb pub "*baq*" wback
bind brbhb pub "ACTION is now away*" hurryback

array set backs {}
proc hurryback {from to text} {
	global backs
	putmsg $to "Hurry back \00312[getnick $from]\017!"
	set backs([getnick $from]) [clock clicks -milliseconds]
}

proc wback {from to text} {
	global backs
	putmsg $to "Welcome back \00312[getnick $from]\017! You were gone for \00312[expr {([clock clicks -milliseconds] - $backs([getnick $from])) / 1000}]\017 seconds."
	unset backs([getnick $from])
}
