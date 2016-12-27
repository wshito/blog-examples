(require 'cl-async)
(require 'babel)

(defun my-tcp-server ()
  (format t "Starting server.~%")
    (as:tcp-server
     nil 8888  ; nil means 0.0.0.0 to listen for any address
     ;; read-cb
     (lambda (socket data)
       (let ((data-str ; stores the received data in utf8 string
	      (handler-case (babel:octets-to-string data :encoding :utf-8)
		(babel-encodings:invalidutf8-continuation-byte (err)
		  (declare (ignore err))
		  (format nil "^@~%")))))
	 ;; exits if received "bye"
	 (cond ((equal "bye" (string-right-trim '(#\Return #\Newline) data-str))
		(as:close-socket socket)
		(format t "Client disconnected.~%"))
	       (t (format t "~a" data-str) ; echo on the server side
		  (as:write-socket-data socket "Send to server > ")))))
     ;; handle SIGINT
     :event-cb (as:signal-handler 2 (lambda (sig)
				      (declare (ignore sig))
				      (as:free-signal-handler 2)
				      (as:exit-event-loop)))
     :connect-cb (lambda (socket)
		   (format t "Client connected.~%")
		   (as:write-socket-data socket "Send to server > "))))

(as:start-event-loop #'my-tcp-server)
