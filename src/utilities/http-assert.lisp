(uiop:define-package :webapp/utilities/http-assert
  (:use :common-lisp)
  (:export :http-assert))

(in-package :webapp/utilities/http-assert)

(defun abort-request-handler (return-code)
  (setf (hunchentoot:return-code*) return-code)
  (hunchentoot:abort-request-handler))

(defun http-assert (value &optional (return-code 404))
  (or value (abort-request-handler return-code)))
