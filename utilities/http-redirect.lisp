(uiop:define-package :webapp/utilities/http-redirect
    (:use :common-lisp)
  (:export :http-redirect))

(in-package :webapp/utilities/http-redirect)

(defun http-redirect (location)
  (setf (hunchentoot:header-out :location) location)
  (setf (hunchentoot:return-code*) 302)
  (values nil))
