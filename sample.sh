#!/bin/sh
# Send a message using dbus-send
# Parameters to dbus-send:
# - --dest should be the name of the service
# - next parameter (/net/kjeldahlnilsson/MyMailServer) is the name the "server" is exported as
# - next parameter (net.kjeldahlnilsson.MailServer.deliver) is the "global" name of the message
#   since it was defined inside the dbus interface "net.kjeldahlnilsson.MailServer" and its name
#   is deliver, the full name is the combination of those two

dbus-send --print-reply --dest=net.kjeldahlnilsson.mail /net/kjeldahlnilsson/MyMailServer net.kjeldahlnilsson.MailServer.deliver string:"Oh" string:"marius@stones.com" string:"No f*cking way pardner"

dbus-send --type=signal --dest=net.kjeldahlnilsson.mail /net/kjeldahlnilsson/MyMailServer net.kjeldahlnilsson.MailServer.mailArrived int32:1 int32:100
