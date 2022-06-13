(uiop:define-package :webapp/input-protocol
  (:use :common-lisp
	:webapp/html)
  (:export :input-value
	   :render-input))

(in-package :webapp/input-protocol)

(defgeneric input-value (object slot-name)
  (:method (object slot-name)
    (slot-value object slot-name)))

(defgeneric (setf input-value) (value object slot-name)
  (:method (value object slot-name)
    (setf (slot-value object slot-name) value)))

(defgeneric render-input (object slot-name)
  (:method (object slot-name)
    (let ((value (input-value object slot-name)))
      (input :name slot-name :value value))))

