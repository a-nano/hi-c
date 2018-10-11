(in-package :cl-user)
(defpackage hi-c
  (:use :cl :cffi)
  (:export :defhicconstant
	   :defhicenum
	   :defhictype
	   :defhicstruct
	   :defhicunion
	   :defhicfun
	   :defhiclispfun))
