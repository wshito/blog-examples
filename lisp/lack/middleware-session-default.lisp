;;
;; See http://diary.wshito.com/comp/lisp/clack/lack-middleware-session/
;; for explanation.
;;

(require 'clack)
(require 'lack)

(defparameter *subtitle* "<h2>--- With Default Settings ---</h2>")

;; information to extract from :lack.session.options from env
(defparameter *options*
  (list :new-session :change-id :no-store :expire :expires))

;;
;; Echos session info
;;
(defparameter *my-echo*
      (lambda (env)
	(let* ((session (getf env :lack.session))
	       (counter (gethash :visit session -1)))
	  (setf (gethash :visit session) (incf counter))
	  `(200 (:content-type "text/html")
		,(append
		  (list "<html><h1>Lack Session Middleware Test</h1>"
			*subtitle*
			"<ul>"
			(format nil "<li>Visiting times: ~A</li>" counter))
		  (mapcar (lambda (key)
			    (let ((val (getf (getf env :lack.session.options)
					     key)))
			      (format nil "<li>~A = ~A</li>" key val)))
			  *options*)
		  (list "</ul></html>"))))))
;;
;; Creates Lack Application
;;
(defparameter *app*
  (lack:builder
   (lambda (app)
     (lambda (env)
       (let ((res (funcall app env)))
	 res)))
   :session
   *my-echo*))

;;
;; Starts the Web server
;;
(defparameter *handler*
  (clack:clackup *app*))

;;
;; Stops the Web server
;;
; (clack:stop *handler*)

