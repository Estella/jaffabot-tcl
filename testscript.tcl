bind testscript pub "!explode" kerplode
bind testscript pub "!coffee" coffee
bind testscript pub "!lag" lag
bind testscript msg "!dump" dump
bind testscript pub "!penis" penis
bind testscript msg "VERSION" versi
bind testscript msg "VERSION" versi
bind testscript notc "ECHO" pong
bind testscript notc "PING" pong
loadmod testscript

proc kerplode {from to text} {
	putmsg $to "[lindex [split $from "!"] 0] $from is your Hostmask."
}

proc coffee {from to text} {
	switch [expr {int(rand()*4)}] {
	 0 {putmsg $to "\001ACTION hands [lindex $text 1] a cup of espresso\001"}
	 1 {putmsg $to "\001ACTION hands [lindex $text 1] a cup of Latte\001"}
	 2 {putmsg $to "\001ACTION hands [lindex $text 1] a cup of instant coffee\001"}
	 3 {putmsg $to "\001ACTION hands [lindex $text 1] a cup of cappucino\001"}
	}
}

proc lag {from to text} {
	putmsg [lindex [split $from "!"] 0] "\001PING [clock clicks -milliseconds] $to \001"
}

proc pong {from to text} {
	set ms [lindex $text 1]
	set dest [lindex $text 2]
	#put "NOTICE [lindex [split $from "!"] 0] :Your lag is [expr {[clock clicks -milliseconds] - $ms}] milliseconds according to your client and our measurements."
	put "PRIVMSG $dest :[lindex [split $from "!"] 0], your lag is [expr {[clock clicks -milliseconds] - $ms}] milliseconds according to your client and our measurements."
}

proc dump {from to text} {
	if {[string match -nocase $::admin $from]} {
		put "[join [lrange [split $text " "] 1 end] " "]"
	}
}

proc versi {from to text} {
	put "NOTICE [lindex [split $from "!"] 0] :\001VERSION Jaffabot-TCL 0.1 Jack D. Johnson\001"
}

proc penis {from to text} {
	set facto [open /dev/urandom r+]
	set rando [read $facto 4]
	scan $rando %c%c%c%c co ct cr cf
	set penilen [expr {($co * (2 ** 24))+($ct * (2 ** 16))+($cr * (2 ** 8))+($cf)}]
	close $facto
	put "PRIVMSG $to :[lindex [split $from "!"] 0], your penis is [expr {4 + ${penilen} % 36}]cm long according to our measurements."
}

