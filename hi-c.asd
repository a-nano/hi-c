(defsystem #:hi-c
  :description "High-grade cffi functions"
  :viersion "0.0.1"
  :author "Akihide Nano <an74abc@gmail.com>"
  :license "LLGPL"
  :serial t
  :components
  ((:module "src"
	    (:file "hi-c")
	    (:file "package")))
  :depends-on
  ("cffi"))
