;;
;; See http://diary.wshito.com/comp/lisp/clack/lack-middleware-mount/
;; for explanation.
;;

(require 'clack)
(require 'lack)

;;
;; Echos current path-info
;;
(setf my-echo
      (lambda (env)
	`(200 (:content-type "text/plain") ,(list (getf env :path-info)))))
;;
;; Creates Lack Application
;;
(defparameter *app*
  (lack:builder
    (:mount "/echo" my-echo)
    (:mount "/hello"
	    (lambda (env)
	      (declare (ignore env))
	      '(200 (:content-type "text/plain") ("Hello world!"))))
    (lambda (env)
      (declare (ignore env))
      '(404 (:content-type "text/plain") ("Not found, mate!")))))
;;
;; Starts the Web server
;;
(defparameter *handler*
  (clack:clackup *app*))

;;
;; Stops the Web server
;;
; (clack:stop *handler*)
