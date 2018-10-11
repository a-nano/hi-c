(in-package :hi-c)

(defmacro defhicconstant (name value &optional doc)
  "Wrapper around `defconstant' which exports the constant."
  `(progn
     (eval-when (:compile-toplevel :load-toplevel :execute)
       (defparameter ,name ,value ,doc))
     (export ',name)))

(defmacro defhicenum (name &body enum-list)
  "Wrapper around `defcenum' whitch exports the enum type and each enum name within."
  `(progn
     (defcenum ,name
	 ,@enum-list)
     ;; Export enum name
     (export ',name)
     ;; Export each enum value
     (export
      ',(mapcar
	 (lambda (spec)
	   (if (cl:atom spec)
	       spec
	       (car spec)))
	 ;; Skip docstring if present
	 (if (typep (car enum-list) 'string)
	     (cdr enum-list)
	     enum-list)))
      ;; Return name of enum
      ',name))

(defmacro defhictype (name base-type &optional documentation)
  `(progn
     (defctype ,name ,base-type ,docmentation)
     ;; Export name
     (export ',name)
					; Retrun name of type
     ',name))

(defmacro defhicstruct (name &body fields
			&aux
			  (tag-name (intern (concatenate 'string "TAG-" (symbol-name name)) :hi-c)))
  "Wrapper around `defcstruct' which also defines a type for the struct, and exports all of its fields."
  `(progn
     (defcstruct ,tag-name
	 ,@fields)
     ;; typedef it
     (defctype ,name (:struct ,tag-name))
     ;; Export name
     (export ',name)
     ;; Export each field
     (export ',(mapcar #'car (if (typep (car fields) 'string) (cdr fields) fields)))
     ;; Return the name of struct
     ',name))

(defmacro defhicunion (name &body fields)
  "Wrapper around `defcunion' which exports the union and all of its fields."
  `(progn
     (defcunion ,name
	 ,@fields)
     ;;typedef it
     (defctype ,name (:union ,name))
     ;; Export name
     (export ',name)
     ;; Export each member
     (export ',(mapcar #'car (if (typep (car fields) 'string) (cdr fields) fields)))
     ;; Return name of union
     ',name))

(defmacro defhicfun ((c-name lisp-name library) return-type &body args)
  "Wrapper around `defcfun' that sets the library and convention to the correct values, and performs an EXPORT of the lisp name."
  (assert (type c-name 'string))
  (assert (and (symbolp lisp-name)
	       (not (keywordp lisp-name))))
  `(progn
     (defcfun (,c-name ,lisp-name :library ,library :convention :stdcall) ,return-type
       ,@args)
     ;; Export the lisp name of the function
     (export ',lisp-name)
     ;; Return the lisp-name
     ',lisp-name))

(defmacro defhiclispfun (name lambda-list &body body)
  "Wrapper around `defun' which additionally exports the function name."
  (assert (and (symbolp name)
	       (not (keywordp name))))
  `(progn
     (defun ,name ,lambda-list
       ,@body)
     ;; Export it
     (export ',name)
     ;; Retrun the name
     ',name))
