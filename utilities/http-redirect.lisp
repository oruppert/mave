(uiop:define-package :webapp/utilities/http-redirect
    (:use :common-lisp)
  (:export :http-redirect))

(in-package :webapp/utilities/http-redirect)

(defun http-redirect (&optional location)
  "Works like hunchentoot:redirect, but does not throw.
Should be the last statement in a define-easy-handler.  Note! Does not
normalize relative urls like hunchentoot:redirect, but most browsers
support relative urls."
  (when (hunchentoot:within-request-p)
    (setf (hunchentoot:header-out :location)
	  (or location (hunchentoot:request-uri*)))
    (setf (hunchentoot:return-code*) 302)
    (values nil)))
