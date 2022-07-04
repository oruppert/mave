(uiop:define-package :webapp/utilities/back
  (:use :common-lisp)
  (:export :back))

(in-package :webapp/utilities/back)

(defun parameters (uri)
  "string -> alist"
  (loop with query-string = (second (cl-ppcre:split #\? uri :limit 2))
	for parameter-string in (cl-ppcre:split #\& query-string)
	for (k v) = (cl-ppcre:split #\= parameter-string :limit 2)
	collect (cons (hunchentoot:url-decode k)
		      (hunchentoot:url-decode v))))

(defun parameter (name uri)
  "string, string -> string"
  (cdr (assoc name (parameters uri) :test #'string=)))

(defun request-uri ()
  "-> string"
  (when (hunchentoot:within-request-p)
    (hunchentoot:request-uri*)))

(defun back (&optional (uri (request-uri)))
  "string -> string"
  (or (parameter "back" uri) "/"))


