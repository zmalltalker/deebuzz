# A very basic Ruby DBus server
# We register a "mail server" under the bus name net.kjeldahlnilsson.mail
# with an "instance" /net/kjeldahlnilsson/MyMailServer
# which has one method:
# - deliver - taking three string parameters
#
# and a signal:
# - mailArrived - containing two int32 parameters

require "dbus"
bus = DBus.session_bus

service = bus.request_service("net.kjeldahlnilsson.mail")


class MailServer < DBus::Object
  dbus_interface "net.kjeldahlnilsson.MailServer" do

    dbus_method :deliver, "in subject:s, in recipient:s, in body:s" do |subject, recipient, body|
      puts "I just delivered (#{subject} to #{recipient})"
      puts "The message reads:\n\t#{body}"
    end

    dbus_signal "mailArrived", "toto:u, tutu:u"
  end
end

exported_obj = MailServer.new("/net/kjeldahlnilsson/MyMailServer")

service.export(exported_obj)
exported_obj.mailArrived(10,1)

loop = DBus::Main.new
loop << bus
loop.run
