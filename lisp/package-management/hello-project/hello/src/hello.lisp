(in-package :cl)

(defpackage :hello
  (:use :cl)
  (:export :hello))

(in-package :hello)

(defun hello ()
  (format t "Hello world! ~A" (date:today)))
  
  
