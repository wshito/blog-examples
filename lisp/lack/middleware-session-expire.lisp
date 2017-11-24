;;
;; See http://diary.wshito.com/comp/lisp/clack/lack-middleware-session/
;; for explanation.
;;

(require :clack)
(require :lack)

;;;;;;;;;;;;; For Debugging ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (declaim (optimize (debug 3)))
;; (asdf:compile-system :hunchentoot :force t)
;; (asdf:compile-system :clack :force t)
;; (asdf:compile-system :lack :force t)
;; (asdf:load-system :clack)
;; (asdf:load-system :lack)
;;
;;  ~/.roswell/lisp/quicklisp/dists/quicklisp/software/lack-20161204-git/src/middleware/session.lisp にbreak挿入．wshitoコメントあり
;; (ql:system-apropos :lack) でロードするシステムの一覧
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defparameter *subtitle*
  "<h2>--- Session expires in 5 secs since the last access ---</h2>")

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
	  ;; expires after 5 seconds since the last acess
	  (setf (getf (getf env :lack.session.options) :expires) 5)
	  (setf (getf (getf env :lack.session.options) :new-session) t)
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

