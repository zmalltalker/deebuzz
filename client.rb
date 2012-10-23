# Run a DBus client in a loop.
# - We connect to the server defined in server.rb
# - We deliver a message using the server
# - Then we listen for the mailArrived signal defined in the server, and
#   print some stuff to STDOUT when it happens
# - Try running ./sample.sh and see what happens here

require "dbus"

bus = DBus.session_bus
ruby_service = bus.service("net.kjeldahlnilsson.mail")
mailserver = ruby_service.object("/net/kjeldahlnilsson/MyMailServer")
mailserver.introspect
mailserver.default_iface = "net.kjeldahlnilsson.MailServer"


mailserver.deliver "This is so awesome", "marius@stones.com", "Me so horny. Love you long time"

mailserver.on_signal("mailArrived") do |new_count, total_count|
  puts "Looks like the mail's still working. #{new_count}/#{total_count} messages."
end

loop = DBus::Main.new
loop << bus
loop.run
