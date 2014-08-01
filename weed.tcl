proc weedtrig {from targ text} {
	set payload [lindex [split $text " "] 1]
	switch [expr {int(rand()*4)}] {
		0 {
			putmsg $targ "\001ACTION packs a bowl of nugs and hands a bong to $payload\001"
		}
		1 {
			putmsg $targ "\001ACTION rolls a joint and hands to $payload\001"
		}
		2 {
			putmsg $targ "\001ACTION fills the hookah with dried nugs and hands to $payload\001"
		}
		3 {
			putmsg $targ "\001ACTION passes $payload the vape pen\001"
		}
	}
}

bind weed pub "!weed" weedtrig
