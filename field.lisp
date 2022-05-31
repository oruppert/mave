;;;; field standard-object implementation

(uiop:define-package :webapp/field
  (:use :common-lisp
	:webapp/generics
	:webapp/html))

(in-package :webapp/field)

(defmethod list-fields ((object standard-object))
  (mapcar #'sb-mop:slot-definition-name
	  (sb-mop:class-slots (class-of object))))

(defmethod field-label ((object standard-object) name)
  (string-capitalize name))

(defmethod field-value ((object standard-object) name)
  (slot-value object name))

(defmethod (setf field-value) (value (object standard-object) name)
  (setf (slot-value object name) value))

(defmethod render-field ((object standard-object) name)
  (let ((value (field-value object name)))
    (input :name name :value value)))
