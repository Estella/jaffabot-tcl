Jaffabot Tcl Edition
====

Welcome to Jaffabot. Jaffabot is a modular IRC bot capable of very little.
Jaffabot used to be written in PHP but it got unwieldy. So now, it's in TCL.

At this time, planned features include multiple network support.

Rather than being in PHP and using JSON, it's in TCL and uses SQLite.

Running is simple. Once you've prepped your config file (the S= in front of a server
is NOT currently supported but is also a planned feature) just type
```
./main.tcl &lt;config file&gt;
```

replacing &lt;config file&gt; with the config file's name.

Some admin commands are in the "core" module, which I advise you don't unload
(you'll lose the ability to load modules). Others are in various admin- modules,
which will be in admin.tcl and others.

I'm not even bothering to document Jaffabot, because TCL is rather readable.
But ok, I'll document it.

Jaffabot is currently very hodge podge thanks to an earlier module system I used.
Replace Jaffabot with your instance's nick (by default Randumbot)

```
Msg commands so far implemented:
/msg Jaffabot loadmod <module>
 Load a module in an already-loaded TCL script.
/msg Jaffabot loadsmod <tcl file> <module>
 Load a module from the mentioned tcl file.
/msg Jaffabot loadscript <tcl file>
 Load a tcl file without loading a module.
/msg Jaffabot unloadmod <module>
 Disable a module. This does NOT unload the module.
/msg Jaffabot !join <channel>
 Join a channel. This can also be called as !join in a channel the bot is already in.
/msg Jaffabot part <channel>
 Leave a channel. This can also be called in the channel being left as !part .

Public commands so far implemented:
!weed <nick>
 Hand <nick> an assortment of combinations of weed and smoking system.
 Implemented in ./weed.tcl
 Module weed
!roll <sides>
 Roll a die.
 Implemented in ./dice.tcl
 Module dice
!coffee <nick>
 Hand <nick> a coffee
 Implemented in ./testscript.tcl
 Module testscript
.bots
 Check for bots
 Implemented in ./bots.tcl
 Module botstrig
!ping
 Check connection liveness
 Implemented in ./testscript.tcl
 Module testscript 
!lag
 Check connection latency. Requires a client that echoes /ctcp ping verbatim.
 Implemented in ./testscript.tcl
 Module testscript
```
