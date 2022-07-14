(uiop:define-package :mave/database/slot-utilities
    (:use :common-lisp)
  (:export :direct-slots
	   :bound-slots
	   :bound-values))

(in-package :mave/database/slot-utilities)

(defun direct-slots (object)
  (mapcar #'closer-mop:slot-definition-name
	  (closer-mop:class-direct-slots (class-of object))))

(defun bound-slots (object)
  (remove-if-not (lambda (slot-name) (slot-boundp object slot-name))
		 (direct-slots object)))

(defun bound-values (object)
  (mapcar (lambda (slot-name) (slot-value object slot-name))
	  (bound-slots object)))
