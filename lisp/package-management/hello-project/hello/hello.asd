(defsystem "hello"
  :version "0.0.1"
  :author "wshito"
  :depends-on (:date
;	       :dummy
	       )
  :components ((:module "src"
		:components
		((:file "hello")))))	
