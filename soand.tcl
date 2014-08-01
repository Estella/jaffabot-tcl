bind soand pub "so and*" soandbus

proc soandbus {from to text} {
	putmsg $to "[getnick $from], bus."
}
