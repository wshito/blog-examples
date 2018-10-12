;;; Lisp version of Jeremy's Stream
;;; https://blog.jeremyfairbank.com/javascript/functional-javascript-streams-2/

;;; Stream structure is a list: (value Stream)

;; Stream -> Number
(defmacro stream-value (stream)
  `(first ,stream))

;; Stream -> Stream
(defmacro stream-next (stream)
  `(second ,stream))

;; Number, Stream -> Stream
(defmacro make-stream (value next-stream)
  `(list ,value ,next-stream))

;; () -> function that generates Stream
(defun natural-numbers ()
  (labels ((_stream (n)
             (make-stream n
                          (lambda () (_stream (1+ n))))))
    (lambda () (_stream 1))))
             
(defparameter nats (natural-numbers))

(defparameter one (funcall nats))

(defparameter two (funcall (stream-next one)))

(defparameter three (funcall (stream-next two)))

;; confirm no side-effect
(defparameter two-again (funcall (stream-next one)))

(format t "one value = ~a~%" (stream-value one))
(format t "two value = ~a~%" (stream-value two))
(format t "three value = ~a~%" (stream-value three))
(format t "two-again value = ~a~%" (stream-value two))

;;;; Take function

(defun take (n stream)
  (labels ((_take (n stream accum)
             (let ((strm (funcall stream)))
               (if (= n 0) (nreverse accum)
                   (_take (1- n)
                          (stream-next strm)
                          (cons (stream-value strm) accum))))))
    (_take n stream nil)))

(defparameter first-ten (take 10 nats))

(format t "first-ten = ~a~%" first-ten)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Creating Other Streams

(defun fibonacciSequence ()
  (labels ((_stream (current next)
             (make-stream current
                          (lambda () (_stream next (+ current next))))))
    (lambda () (_stream 0 1))))

(defparameter fibs (fibonacciSequence))
(defparameter fibs-first-ten (take 10 fibs))

(format t "fibs-first-ten = ~a~%" fibs-first-ten)

;;
;; abstracting the construction of stream
;;
(defun stream-factory (fn initial-values)
  (labels ((_stream (value)
             (make-stream value
                          (lambda () (_stream (funcall fn value))))))
    (lambda () (_stream initial-values))))
  
(defparameter nats (stream-factory (lambda (n) (1+ n)) 1))
(defparameter fibs (stream-factory (lambda (pair) (list (second pair)
                                                        (reduce #'+ pair)))
                                   '(0 1)))

(format t "~a~%" (take 10 nats))
(format t "~a~%" (mapcar #'first (take 10 fibs)))

