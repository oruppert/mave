(uiop:define-package :webapp/utilities
    (:use :common-lisp)
  (:export :direct-slots
	   :bound-slots
	   :bound-values))

(in-package :webapp/utilities)

(defun direct-slots (object)
  (mapcar #'sb-mop:slot-definition-name
	  (sb-mop:class-direct-slots (class-of object))))

(defun bound-slots (object)
  (remove-if-not (lambda (slot-name) (slot-boundp object slot-name))
		 (direct-slots object)))

(defun bound-values (object)
  (mapcar (lambda (slot-name) (slot-value object slot-name))
	  (bound-slots object)))
