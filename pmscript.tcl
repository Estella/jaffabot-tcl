# To clarify. $pyld is the payload.
# $rgs is the arguments.

# $isadmin is whether the user is admin.
# $ischannel is whether the target is a global channel.

set msgcmd [lindex $pyld 0]
set payload [join [lrange $pyld 1 end] " "]
set srcnick [lindex [split $src "!"] 0]
if {$ischannel} {
	set targ [lindex $rgs 0]
} {
	set targ $srcnick
}

switch -nocase $msgcmd {
	"!join" {
		if {$isadmin} {
			put "JOIN $payload"
			jaffadb eval {CREATE TABLE IF NOT EXISTS chans(joinline text)}
			jaffadb eval {INSERT INTO chans VALUES($payload)}
		} {
			putmsg $targ "$srcnick, you're not Dave so I can't let you do that."
		}
	}

	"!ping" {
		putmsg $targ "$srcnick, PONG. Your connection still exists."
	}

	"watson" {
		putmsg $targ "Sherlock?"
	}
}
