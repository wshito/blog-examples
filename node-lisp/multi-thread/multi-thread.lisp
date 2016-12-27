(require 'cl-async)
(require 'bordeaux-threads)

(as:with-event-loop()
  (let* ((notifier (as:make-notifier
		    (lambda ()
		      (format t "Threaded job done.~%")
		      (as:exit-event-loop)))))
    (format t "App started.~%")
    (bt:make-thread (lambda ()
		      (sb-ext:run-program
		       "/bin/bash" (list "./echo.sh")
		       :output t)
		      (as:trigger-notifier notifier))))
  (format t "Waiting......~%"))
