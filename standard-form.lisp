(uiop:define-package :webapp/standard-form
  (:use :common-lisp
	:webapp/generics
	:webapp/display-protocol
	:webapp/html)
  (:export :standard-form))

(in-package :webapp/standard-form)

(defclass standard-form ()
  ((submit :initarg :submit :initform nil :reader form-submit)))

(defmethod display (object (self standard-form))
  (form :method :post
	(loop for name in (list-fields object)
	      collect (p (label (field-label object name)
				(render-field object name))))
	(p (input :type :submit :value (form-submit self)))))



