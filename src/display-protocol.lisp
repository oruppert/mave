;;;; Display Protocol

(uiop:define-package :mave/display-protocol
    (:use :common-lisp)
  (:export :display
	   :display-name))

(in-package :mave/display-protocol)

(define-method-combination primary-only (&optional (order :most-specific-first))
  ((methods () :order order))
  `(call-method ,(car methods)
		,(cdr methods)))

(defgeneric display (view object)
  (:method-combination primary-only :most-specific-last))

(defgeneric display-name (view object))





