;;;; Html Functions

(uiop:define-package :webapp/html-generator/html-functions
  (:use :common-lisp
	:webapp/html-generator/html-destruct
	:webapp/html-generator/html-elements))

(in-package :webapp/html-generator/html-functions)

(defmacro define-html-functions (class-name &rest names)
  (flet ((expand-symbol (name)
	   `(defun ,name (&rest attributes/children)
	      (multiple-value-bind (attributes children)
		  (html-destruct attributes/children)
		(make-instance ',class-name
			       :name ,(string-downcase name)
			       :attributes attributes
			       :children children))))
	 (export-symbol (name)
	   `(export ',name)))
    `(progn ,@(mapcar #'expand-symbol names)
	    ,@(mapcar #'export-symbol names))))

(define-html-functions void-element br hr meta input img)

(define-html-functions text-element style script)

(define-html-functions standard-element
  a p h1 li td th tr ul div nav html head body span form link title
  main label table select button option legend section fieldset)

