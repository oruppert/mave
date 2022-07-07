(uiop:define-package :webapp/forms/redirect-mixin
  (:use :common-lisp
	:webapp/handle-protocol)
  (:export :redirect-location
	   :redirect-mixin))

(in-package :webapp/forms/redirect-mixin)

(defgeneric redirect-location (object))

(defclass redirect-login () ())

(defmethod handle :around (object (self redirect-login) (method (eql :post)))
  (call-next-method)
  (when (hunchentoot:within-request-p)
    (setf (hunchentoot:return-code*) 302)
    (setf (hunchentoot:header-out :location)
	  (redirect-location self)))
  (values nil))



