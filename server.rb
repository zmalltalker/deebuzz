#!/usr/bin/ruby
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

# Register a name on the session bus
service = bus.request_service("net.kjeldahlnilsson.mail")


class Mailbox
  def initialize
    @messages = []
  end

  def <<(message)
    @messages << message
  end

  def size
    @messages.count
  end

  def pop
    @messages.pop
  end

  def empty?
    @messages.empty?
  end
end

class MailServer < DBus::Object
  @mailbox = Mailbox.new

  def self.mailbox
    @mailbox
  end
  dbus_interface "net.kjeldahlnilsson.MailServer" do

    dbus_method :deliver, "in subject:s, in recipient:s, in body:s, out response:s" do |subject, recipient, body|
      MailServer.mailbox << [subject,recipient,body]
      puts "I just delivered (#{subject} to #{recipient})"
      puts "The message reads:\n\t#{body}"
      "Thanks for your message. I now hold #{MailServer.mailbox.size} messages"
    end

    dbus_method :readMail, "out subject:s" do
      if MailServer.mailbox.empty?
        "No mail"
      else
        message = MailServer.mailbox.pop
        puts "Someone stopped by to check the mail. I now keep #{MailServer.mailbox.size} messages"
        message[0]
      end
    end

    dbus_signal "mailArrived", "toto:u, tutu:u"
  end
end

# Register an object
exported_obj = MailServer.new("/net/kjeldahlnilsson/MyMailServer")

service.export(exported_obj)
exported_obj.mailArrived(10,1)

loop = DBus::Main.new
loop << bus
loop.run
