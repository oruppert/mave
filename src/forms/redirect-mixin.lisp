(uiop:define-package :mave/forms/redirect-mixin
  (:use :common-lisp
	:mave/handle-protocol)
  (:export :redirect-location
	   :redirect-mixin))

(in-package :mave/forms/redirect-mixin)

(defgeneric redirect-location (object))

(defclass redirect-mixin () ())

(defmethod handle :around ((self redirect-mixin) object (method (eql :post)))
  (call-next-method)
  (when (hunchentoot:within-request-p)
    (setf (hunchentoot:return-code*) 302)
    (setf (hunchentoot:header-out :location)
	  (redirect-location self)))
  (values nil))



