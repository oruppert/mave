(uiop:define-package :webapp/render
    (:use :common-lisp)
  (:export
   #:render))

(in-package :webapp/render)

(define-method-combination primary-only (&key (order :most-specific-first))
  ((methods () :order order))
  `(call-method ,(first methods)
		,(rest methods)))

(defgeneric render (view model)
  (:method-combination primary-only :order :most-specific-last))
