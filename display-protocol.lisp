;;;; Display Protocol

(uiop:define-package :webapp/display-protocol
    (:use :common-lisp)
  (:export :display
	   :display-name))

(in-package :webapp/display-protocol)

(define-method-combination primary-only (&optional (order :most-specific-first))
  ((methods () :order order))
  `(call-method ,(car methods)
		,(cdr methods)))

(defgeneric display (object view)
  (:method-combination primary-only :most-specific-last))

(defgeneric display-name (object view)
  (:argument-precedence-order view object))

(defmethod display-name (object view)
  "Ensure display-name is always defined."
  (princ-to-string (or view object)))




