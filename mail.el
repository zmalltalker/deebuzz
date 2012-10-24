(require 'dbus)
(defvar z-mail-bus-name "net.kjeldahlnilsson.mail" "The name on the session bus")
(defvar z-mail-bus-object "/net/kjeldahlnilsson/MyMailServer" "The name of the object you're talking to")
(defvar z-mail-interface "net.kjeldahlnilsson.MailServer" "The interface your object implements")

(defun z-mail-send (recipient subject body)
  "Send a message using DBus"
  (dbus-call-method-asynchronously :session z-mail-bus-name z-mail-bus-object z-mail-interface "deliver" 'message subject recipient body)
)

(defun z-mail-readsync ()
  "Read mail from DBus synchronously."
  (dbus-call-method :session z-mail-bus-name z-mail-bus-object z-mail-interface "readMail" :timeout 1000)
)

(defun z-mail-read ()
  "Read mail async. Doesn't seem to do anything - meh"
  (dbus-call-method-asynchronously :session z-mail-bus-name z-mail-bus-object z-mail-interface "readMail" 'message :timeout 1000)
)

;; Send a message
;;(z-mail-send "marius" "This is absolutely amazing" "Hello there")

;; Read a message
;;(z-mail-readsync)
