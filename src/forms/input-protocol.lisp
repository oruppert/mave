(uiop:define-package :mave/forms/input-protocol
    (:use :common-lisp)
  (:export))

(in-package :mave/forms/input-protocol)

;;;; Input Protocol

(defgeneric input-label (object slot-name)
  (:documentation
   "Returns the input label for the given object and slot-name.")
  (:method (object slot-name)
    (string-capitalize slot-name)))

(defgeneric input-value (object slot-name)
  (:documentation
   "Returns the input value for the given object and slot-name.")
  (:method (object slot-name)
    (slot-value object slot-name)))

;;; XXX: split into insert and update-form?
#+nil
(defgeneric input-initial-value (object slot-name)
  (:method (object slot-name)
    (values nil)))

(defgeneric (setf input-value) (value object slot-name)
  (:documentation
   "Sets the input value of the given object and slot-name.")
  (:method (value object slot-name)
    (setf (slot-value object slot-name) value)))

(defgeneric render-input (object slot-name)
  (:documentation
   "Renders the input element of the given object and slot-name.")
  (:method (object slot-name)
    (let ((value (input-value object slot-name)))
      #+nil
      (input :name slot-name :value value))))
