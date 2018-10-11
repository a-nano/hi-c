(defsystem #:hi-c
  :description "High-grade cffi functions"
  :version "0.0.1"
  :author "Akihide Nano <an74abc@gmail.com>"
  :license "LLGPL"
  :serial t
  :components
  ((:module "src"
	    :components
	    ((:file "package")
	     (:file "hi-c"))))
  :depends-on
  ("cffi"))
