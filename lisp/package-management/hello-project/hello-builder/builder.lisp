(in-package :cl-user)

(defpackage hello-builder
  (:use :cl :asdf)
  (:export :make))

(in-package :hello-builder)

(defmacro make (&key (debug nil))
  (let ((dec (if debug
		 '(declaim (optimize (debug 3)))
		 '(declaim (optimize (speed 3)))))
	(comp-op (append '(asdf:compile-system :hello :force) (list debug))))
  `(progn
     ,dec
     ,comp-op
     (asdf:load-system :hello))))
