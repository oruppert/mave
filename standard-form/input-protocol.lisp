;;;; Input Protocol

(uiop:define-package :webapp/standard-form/input-protocol
  (:use :common-lisp
	:webapp/html-generator/all)
  (:export :input-value
	   :input-label
	   :render-input))

(in-package :webapp/standard-form/input-protocol)

(defgeneric input-value (object slot-name)
  (:documentation
   "Returns the input value for the given object and slot-name.")
  (:method (object slot-name)
    (slot-value object slot-name)))

(defgeneric (setf input-value) (value object slot-name)
  (:documentation
   "Sets the input value of the given object and slot-name.")
  (:method (value object slot-name)
    (setf (slot-value object slot-name) value)))

(defgeneric input-label (object slot-name)
  (:documentation
   "Returns the input label for the given object and slot-name.")
  (:method (object slot-name)
    (string-capitalize slot-name)))

(defgeneric render-input (object slot-name)
  (:documentation
   "Renders the input element of the given object and slot-name.")
  (:method (object slot-name)
    (let ((value (input-value object slot-name)))
      (input :name slot-name :value value))))

