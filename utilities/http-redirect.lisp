(uiop:define-package :webapp/utilities/http-redirect
    (:use :common-lisp)
  (:export :http-redirect))

(in-package :webapp/utilities/http-redirect)

(defun http-redirect (&optional location)
  (when (hunchentoot:within-request-p)
    (setf (hunchentoot:header-out :location)
	  (or location (hunchentoot:request-uri*)))
    (setf (hunchentoot:return-code*) 302)
    (values nil)))
