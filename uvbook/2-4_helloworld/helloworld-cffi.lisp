;; install libuv and cffi first.
(require 'cffi)
(cffi:load-foreign-library '(:default "libuv"))

(cffi:defctype size_t :uint)
(defparameter *size* (* (cffi:foreign-type-size :uint)
			(cffi:foreign-funcall "uv_loop_size" size_t)))
(cffi:defcenum :uv-run-mode
  (:uv-run-default 0)
  :uv-run-once
  :uv-run-nowait)

(cffi:with-foreign-pointer (uvloop *size*)
  (cffi:foreign-funcall "uv_loop_init" :pointer uvloop :int)
  (format t "Now quitting.~%")
  (cffi:foreign-funcall "uv_run" :pointer uvloop :uv-run-mode :uv-run-default)
  (cffi:foreign-funcall "uv_loop_close" :pointer uvloop :int))
