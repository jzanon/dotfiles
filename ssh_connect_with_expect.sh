#!/usr/bin/expect
set timeout 20
set username [lindex $argv 0]
set password [lindex $argv 1]
set hostname [lindex $argv 2]
set serviceFolder [lindex $argv 3]
log_user 0

if {[llength $argv] == 0} {
  send_user "Usage: scriptname username \'password\' hostname\n"
  exit 1
}

send_user "#SSH connection to $hostname#\n"

spawn ssh -q -o StrictHostKeyChecking=no $username@$hostname

expect {
  timeout { send_user "\nFailed to get password prompt\n"; exit 1 }
  eof { send_user "\nSSH failure for $hostname\n"; exit 1 }
  "*\>" {}
  "*assword:" {
    send "$password\r"
    expect {
      timeout { send_user "\nLogin failed. Password incorrect.\n"; exit 1}
       "*\>"
    }

  }
}

send "bash\r"

send "cd /var/apphome/860_mbbb/\r"

if { [llength $serviceFolder] > 0 } { 
  send "cd $serviceFolder\r"
} 

send "ll\r"

interact
