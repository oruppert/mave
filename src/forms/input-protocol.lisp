(uiop:define-package :mave/forms/input-protocol
    (:use :common-lisp)
  (:export :input-name
	   :input-label
	   :input-value
	   :input-default-value
	   :render-input)
  (:import-from :mave/html/all :input))

(in-package :mave/forms/input-protocol)

(defgeneric input-name (object slot-name)
  (:documentation
   "Returns a unique name for the given object and slot-name combination.")
  (:method (object slot-name)
    (let ((class-name (class-name (class-of object))))
      (concatenate 'string
		   (remove #\- (string-capitalize class-name))
		   (remove #\- (string-capitalize slot-name))))))

(defgeneric input-label (object slot-name)
  (:documentation
   "Returns the input label for the given object and slot-name.")
  (:method (object slot-name)
    (declare (ignore object))
    (string-capitalize slot-name)))

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

(defgeneric input-default-value (object slot-name)
  (:documentation
   "Returns the input default value for the given object and slot-name.")
  (:method (object slot-name)
    (declare (ignore object slot-name))
    (values nil)))

(defgeneric render-input (object slot-name value)
  (:documentation
   "Renders the input element of the given object and slot-name.")
  (:method (object slot-name value)
    (let ((name (input-name object slot-name)))
      (input :name name :value value))))
