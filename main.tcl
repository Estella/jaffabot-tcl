#!/usr/bin/env tclsh8.6

package require tls
package require sqlite3

proc putmsg {targ msg} {
	put "PRIVMSG $targ :$msg"
}

proc putnotc {targ msg} {
	put "NOTICE $targ :$msg"
}

proc put {msg} {
	global mainsock
	chan puts stdout "$msg"
	chan puts $mainsock "$msg"
}

array set bindz {}
array set loadedmod {}

proc callbinds {type from to text} {
	global bindz loadedmod
	set matc [lindex [split $text " "] 0]
	foreach {k v} [array get loadedmod] {
		if {$v} {
			if {[info exists ::bindz("$k,$type,$matc")]} {$::bindz("$k,$type,$matc") "$from" "$to" "$text"}
		}
	}
}

proc loadmod {mod} {
	puts stdout "Loaded $mod"
	set ::loadedmod($mod) 1
}

proc unloadmod {mod} {
	puts stdout "Unloaded $mod"
	set ::loadedmod($mod) 0
}

proc bind {mod type match proc} {
	set ::bindz("$mod,$type,$match") $proc
}

proc getline {skt} {
	global admin nick
	if {[chan eof $skt]} {
		chan puts stdout "Socket fucked a duck\n"
		close $skt
		set disconnected 1
	} {
		set get [chan gets $skt]
		if {[string index $get 0] == ":"} {
			set oneend 1
			set twoend 2
		} {
			set oneend 0
			set twoend 1
		}
		set line [split $get ":"]
		set comd [lindex $line $oneend]
		set pyld [join [lrange $line $twoend end] ":"]

		set camd [split $comd " "]
		if {[string index $get 0] == ":"} {
			set src [lindex $camd 0]
		} {
			set src ""
		}
		set cmd [lindex $camd 1]
		set rgs [lrange $camd 2 end]

		if {$cmd == "PRIVMSG"} {
			#chan puts stdout "PRIVMSG $src [lindex $rgs 0] $pyld"
			set isadmin 0
			set ischannel 0

			if {[string match -nocase $admin $src]} {
				set isadmin 1
			}
			if {[string match "#*" [lindex $rgs 0]]} {
				set ischannel 1
			}
			if {$ischannel} {
				callbinds pub $src [lindex $rgs 0] "$pyld"
			} {
				callbinds msg $src [lindex $rgs 0] "$pyld"
			}
			source pmscript.tcl
		}

		if {$cmd == "NOTICE"} {
			#chan puts stdout "PRIVMSG $src [lindex $rgs 0] $pyld"
			set isadmin 0
			set ischannel 0

			if {[string match -nocase $admin $src]} {
				set isadmin 1
			}
			if {[string match "#*" [lindex $rgs 0]]} {
				set ischannel 1
			}
			if {$ischannel} {
				callbinds cnotc $src [lindex $rgs 0] "$pyld"
			} {
				callbinds notc $src [lindex $rgs 0] "$pyld"
			}
			source pmscript.tcl
		}

		callbinds raw $src 0 "$cmd [join $rgs " "] :$pyld"

		#chan puts stdout $get

		if {[string range $get 0 3] == "PING"} {
			put "PONG :$pyld"
			put "PONG $pyld :$pyld"
			put "PRIVMSG $nick :$pyld"
		}
	}
}

sqlite3 jaffadb "./[lindex $argv 0].db"
jaffadb eval {CREATE TABLE IF NOT EXISTS chans(joinline text)}

source [lindex $argv 0]

set counter 0
proc reconnect {} {
	global argv mainsock server myaddr nick email realname perform disconnected
	set mainsock [socket -myaddr $myaddr [lindex $server 0] [lindex $server 1]]
	chan configure $mainsock -blocking 0 -buffering line
	chan event $mainsock read [list getline $mainsock]

	# We dont know what ircds do these days.
	# Just send NICK and USER immediately.

	unset disconnected
	chan puts $mainsock "NICK $nick\r\n"
	chan puts $mainsock "USER $email * * :$realname\r\n"
	chan puts $mainsock "$perform\r\n"
	vwait disconnected
}

set disconnected 1

proc oncon {from to text} {
	puts stdout "Got 001"
	put "$::perform\r\n"
	after 1000 {foreach {joinline} [jaffadb eval {SELECT * FROM chans}] {
		after 500
		put "JOIN $joinline"
	} }
}

bind core raw "001" oncon
bind core msg "loadscript" scriptload
bind core msg "loadmod" modload
bind core msg "loadsmod" modsload
bind core msg "unloadmod" modunload

proc isadmin {mask} {
	return [string match -nocase $::admin $mask]
}

proc getnick {mask} {
	return [lindex [split $mask "!"] 0]
}

proc scriptload {from to text} {
	if {![isadmin $from]} {
		putmsg [getnick $from] "Error: You do not have the correct permissions."
		return
	}
	if {[lindex [split $text " "] 1] == ""} {
		putmsg $from "Please give a script name."
		return
	}
	uplevel "1" source [lindex [split $text " "] 1]
}

proc modsload {from to text} {
	if {![isadmin $from]} {
		putmsg [getnick $from] "Error: You do not have the correct permissions."
		return
	}
	if {[lindex [split $text " "] 1] == ""} {
		putmsg [getnick $from] "Please give a script name."
		return
	}
	if {[lindex [split $text " "] 2] == ""} {
		putmsg [getnick $from] "Please give a module name."
		return
	}
	uplevel "1" source [lindex [split $text " "] 1]
	uplevel "1" loadmod [lindex [split $text " "] 2]
}

proc modload {from to text} {
	if {![isadmin $from]} {
		putmsg [getnick $from] "Error: You do not have the correct permissions."
		return
	}
	if {[lindex [split $text " "] 1] == ""} {
		putmsg [getnick $from] "Please give a module name (preferably in a script you are about to load/have already loaded)."
		return
	}
	uplevel "1" loadmod [lindex [split $text " "] 1]
}

proc modunload {from to text} {
	if {![isadmin $from]} {
		putmsg [getnick $from] "Error: You do not have the correct permissions."
		return
	}
	if {[lindex [split $text " "] 1] == ""} {
		putmsg [getnick $from] "Please give a module name (preferably in a script you are about to load/have already loaded)."
		return
	}
	uplevel "1" unloadmod [lindex [split $text " "] 1]
}

loadmod core
while {[after 4000] == ""} {
	reconnect
}

