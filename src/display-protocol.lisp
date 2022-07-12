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

;;; XXX: should the display function take handler object parameters?

(defgeneric display (object view)
  (:method-combination primary-only :most-specific-last))

(defgeneric display-name (object view))





