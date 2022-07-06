;;;; Redirect Mixin

(uiop:define-package :webapp/utilities/redirect-mixin
    (:use :common-lisp
	  :webapp/handle-protocol)
  (:export :redirect-mixin))

(in-package :webapp/utilities/redirect-mixin)

(defclass redirect-mixin ()
  ((location :initarg :location :reader redirect-location)))

(defmethod handle :around (object (self redirect-mixin) method)
  (call-next-method)
  (when (hunchentoot:within-request-p)
    (setf (hunchentoot:return-code*) 302
	  (hunchentoot:header-out :location)
	  (redirect-location self))
    (values nil)))

