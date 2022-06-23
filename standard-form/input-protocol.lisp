;;;; Input Protocol

(uiop:define-package :webapp/standard-form/input-protocol
  (:use :common-lisp
	:webapp/html-generator/all
	:webapp/standard-form/slot-utilities)
  (:export :input-slots
	   :input-value
	   :input-label
	   :render-input))

(in-package :webapp/standard-form/input-protocol)

(defgeneric input-slots (object context)
  (:method (object context)
    (declare (ignore context))
    (direct-slots object)))

(defgeneric input-value (object slot-name)
  (:method (object slot-name)
    (slot-value object slot-name)))

(defgeneric (setf input-value) (value object slot-name)
  (:method (value object slot-name)
    (setf (slot-value object slot-name) value)))

(defgeneric input-label (object slot-name)
  (:method (object slot-name)
    (string-capitalize slot-name)))

(defgeneric render-input (object slot-name)
  (:method (object slot-name)
    (let ((value (input-value object slot-name)))
      (input :name slot-name :value value))))

