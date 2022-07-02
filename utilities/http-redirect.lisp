;;;; Http Redirect

;;; This is such an important function.  Hunchentoot calls
;;; abort-request-handler when redirect is called.  But I open my
;;; database connections and transactions in an handle-request :around
;;; method.  That means my transaction is rolled back if I call
;;; redirect.  That is ofthen not what I want.  I follow the POST,
;;; REDIRECT, GET pattern.  In this case, a redirect is not an
;;; exceptional operation, and I want my transaction commited.

;;; Is it better to start the transaction in a handle :around method?
;;; Does not work, since I make database calls in define-easy-handler
;;; parameters.

;;; So here is ower non throwing redirect:

(uiop:define-package :webapp/utilities/http-redirect
    (:use :common-lisp)
  (:export :http-redirect))

(in-package :webapp/utilities/http-redirect)

(defun http-redirect (&optional location)
  "Works like hunchentoot:redirect, but does not throw.
Should be the last statement in a define-easy-handler.  Note! Does not
normalize relative uris like hunchentoot:redirect, but most browsers
support relative uris."
  (when (hunchentoot:within-request-p)
    (setf (hunchentoot:header-out :location)
	  (or location (hunchentoot:request-uri*)))
    (setf (hunchentoot:return-code*) 302)
    (values nil)))
