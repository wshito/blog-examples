(in-package :cl)

(defpackage :date
  (:use :cl)
  (:export :today))

(in-package :date)

(defmacro with-utime-decoding ((utime &optional zone) &body body)
  `(multiple-value-bind (sec min h date month year day-of-week daylight-p zone)
       (decode-universal-time ,utime ,@(if zone (list zone)))
     (declare (ignorable sec min h date month year day-of-week daylight-p zone))
     ,@body))

(defun today ()
  (with-utime-decoding ((get-universal-time))
      (format nil "~A年~A月~A日（~[月~;火~;水~;木~;金~;土~;日~]）~A時~A分~A秒"
	      year month date day-of-week h min sec)))
  
  
