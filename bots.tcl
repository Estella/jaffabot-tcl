bind botstrig pub ".bots" botsbots

proc botsbots {from to text} {
	putmsg $to "[getnick $from]: I'm a bot written in pure TCL. CTCP VERSION me for more info."
}
