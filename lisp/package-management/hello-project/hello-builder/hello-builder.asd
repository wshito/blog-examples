(in-package :cl-user)

(defpackage hello-builder-asd
  (:use :cl :asdf))

(in-package :hello-builder-asd)

(defsystem "hello-builder"
  :version "1.0"
  :author "wshito"
  :components ((:file "builder")))

;; Set up source-registry
(asdf:initialize-source-registry
 '(:source-registry
   (:tree (:home "program/blog-examples/lisp/package-management/hello-project"))
   :inherit-configuration))
