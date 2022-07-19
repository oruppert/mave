(uiop:define-package :mave/forms/form-protocol
    (:use :common-lisp
	  :mave/forms/redirect-mixin
	  :mave/forms/input-protocol
	  :mave/html/all)
  (:export
   #:form-slots
   #:form-update
   #:form-render))

(in-package :mave/forms/form-protocol)

(defgeneric form-slots (object)
  (:method (object)
    (mapcar #'closer-mop:slot-definition-name
	    (closer-mop:class-slots (class-of object)))))

(defgeneric form-update (object)
  (:documentation "Updates the given object from http post values.")
  (:method (object)
    (loop for slot-name in (form-slots object)
	  for parameter-name = (input-name object slot-name)
	  for parameter-value = (hunchentoot:post-parameter parameter-name)
	  do (setf (input-value object slot-name)
		   parameter-value))))

(defgeneric form-render (object &key slot-reader)
  (:method (object &key slot-reader)
    (loop for slot-name in (form-slots object)
	  for value = (funcall slot-reader object slot-name)
	  collect (p (label (input-label object slot-name)
			    (render-input object slot-name value))))))







