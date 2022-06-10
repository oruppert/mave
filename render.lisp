;;;; The Render Function

(uiop:define-package :webapp/render
    (:use :common-lisp)
  (:export :render
	   :display-name))

(in-package :webapp/render)

(define-method-combination primary-only (&optional (order :most-specific-first))
  ((methods () :order order))
  `(call-method ,(car methods)
		,(cdr methods)))

(defgeneric render (object view)
  (:method-combination primary-only :most-specific-last))

(defgeneric display-name (object view))


