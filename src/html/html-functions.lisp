;;;; Html Functions

(uiop:define-package :webapp/html-generator/html-functions
  (:use :common-lisp
	:webapp/html-generator/html-destruct
	:webapp/html-generator/html-elements))

(in-package :webapp/html-generator/html-functions)

;;; XXX: is it possible to call alexandria:flatten
;;; before destructing the arguments?  It would
;;; allow functions to return attributes:
;;;
;;;    (href "/url" param1) => (list :href "/url?param1=")
;;;
;;;    (class :foo :bar :baz) => (list :class "foo bar baz")

(defmacro define-html-functions (class-name &rest names)
  (flet ((expand-symbol (name)
	   `(defun ,name (&rest attributes/children)
	      (multiple-value-bind (attributes children)
		  #+nil
		  (html-destruct attributes/children)

		  (html-destruct (flatten attributes/children))
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


(defun flatten (list)
  (loop for item in list
	when (atom item)
	  collect item
	else
	  append (flatten item)))
