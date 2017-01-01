(require 'cl-libuv)

(defparameter *loop* (uv:uv-default-loop))
(uv:uv-run *loop* (cffi:foreign-enum-value 'uv:uv-run-mode :run-default))

(format t "Now quitting.~%")

(uv:uv-loop-close *loop*)
