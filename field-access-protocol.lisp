;;;; Field Access Protocol

(uiop:define-package :webapp/field-access-protocol
  (:use :common-lisp
	:webapp/html
	:webapp/utilities)
  (:export :list-fields
	   :field-label
	   :field-value
	   :render-input))

(in-package :webapp/field-access-protocol)

;;;; Field Access Functions

(defgeneric list-fields (object context))

(defgeneric field-label (object name))

(defgeneric field-value (object name))

(defgeneric (setf field-value) (value object name))

;;;; Field Render Functions

(defgeneric render-value (object name))

(defgeneric render-input (object name))

;;;; Default Implementation

(defmethod list-fields (object context)
  (declare (ignore context))
  (direct-slots object))

(defmethod field-label (object name)
  (declare (ignore object))
  (string-capitalize name))

(defmethod field-value (object name)
  (slot-value object name))

(defmethod (setf field-value) (value object name)
  (setf (slot-value object name) value))

(defmethod render-field (object name)
  (field-value object name))

(defmethod rener-input (object name)
  (let ((value (field-value object name)))
    (input :name name :value value)))




