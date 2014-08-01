bind admin-part msg "part" msgpart
bind admin-part pub "!part" pubpart

proc msgpart {from to text} {
	if {[isadmin $from]} {put "PART $text :Requested by the admin";jaffadb eval {DELETE FROM chans where lower(joinline) == lower($text)}
	} {putmsg [getnick $from] "$from, you're not Dave so I can't let you do that."}
}

proc pubpart {from to text} {
	if {[isadmin $from]} {put "PART $to :Requested by the admin";jaffadb eval {DELETE FROM chans where lower(joinline) == lower($to)}
	} {putmsg $to "$from, you're not Dave so I can't let you do that."}
}
