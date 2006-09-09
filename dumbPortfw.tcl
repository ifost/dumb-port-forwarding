#!/usr/bin/tclsh

# When you can't use anything else... e.g. firewalling is off,  xinetd is
# playing up and you're really otherwise stuffed.  This little thing
# solves the problem.

# Just change the following variables...

set MY_PORT 8080
set OTHER_PORT 80
set OTHER_SERVER 192.168.1.248



proc read_from_write_to {readchan writechan} {
    if [eof $readchan] {
	close $readchan
	close $writechan
	return
    }
    set data [gets $readchan]
    puts $writechan  $data
    puts "Doing $data"
}

proc handle_connection {channel srcip srcport} {
    global lookup_table OTHER_PORT OTHER_SERVER
    set other_end [socket $OTHER_SERVER $OTHER_PORT]
    fileevent $channel readable "read_from_write_to $channel $other_end"
    fileevent $other_end readable "read_from_write_to $other_end $channel"
    
}

socket -server handle_connection $MY_PORT

vwait foobar