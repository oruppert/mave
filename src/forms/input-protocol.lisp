(uiop:define-package :mave/forms/input-protocol
    (:use :common-lisp)
  (:export :input-slots
	   :input-name
	   :input-label
	   :input-value
	   :input-default-value))

(in-package :mave/forms/input-protocol)

(defgeneric input-slots (object)
  (:method (object)
    (mapcar #'closer-mop:slot-definition-name
	    (closer-mop:class-direct-slots
	     (class-of object)))))

(defgeneric input-name (object slot-name)
  (:method (object slot-name)
    (let ((class-name (class-name (class-of object))))
      (concatenate 'string
		   (remove #\- (string-capitalize class-name))
		   (remove #\- (string-capitalize slot-name))))))

(defgeneric input-label (object slot-name)
  (:method (object slot-name)
    (declare (ignore object))
    (string-capitalize slot-name)))

(defgeneric input-value (object slot-name)
  (:method (object slot-name)
    (slot-value object slot-name)))

(defgeneric (setf input-value) (value object slot-name)
  (:method (value object slot-name)
    (setf (slot-value object slot-name) value)))

(defgeneric input-default-value (object slot-name)
  (:method (object slot-name)
    (declare (ignore object slot-name))
    (values nil)))
