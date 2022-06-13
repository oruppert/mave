;;;; Form Protocol

(uiop:define-package :webapp/form-protocol
  (:use :common-lisp
	:webapp/html
	:webapp/utilities)
  (:export :handle-form
	   :form-slots
	   :form-label
	   :form-value
	   :form-input))

(in-package :webapp/form-protocol)

;;;; Handle Form Request

(defgeneric handle-form (object form method))

;;;; Form Slot Accces

(defgeneric form-slots (object))

(defgeneric form-label (object slot-name))

(defgeneric form-value (object slot-name))

(defgeneric (setf form-value) (value object slot-name))

(defgeneric form-input (object slot-name))

;;;; Default Implementation

(defmethod form-slots (object)
  (direct-slots object))

(defmethod form-label (object slot-name)
  (declare (ignore object))
  (string-capitalize slot-name))

(defmethod form-value (object slot-name)
  (slot-value object slot-name))

(defmethod (setf form-value) (value object slot-name)
  (setf (slot-value object slot-name) value))

(defmethod form-input (object slot-name)
  (let ((value (form-value object slot-name)))
    (input :name slot-name :value value)))
