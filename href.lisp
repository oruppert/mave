(uiop:define-package :webapp/href
  (:use :common-lisp
	:webapp/generics)
  (:export :href))

(in-package :webapp/href)

(defclass parameter ()
  ((name :initarg :name :reader parameter-name)
   (value :initarg :value :reader parameter-value)))

(defun make-parameter (name value)
  (make-instance 'parameter :name name :value value))

(defun back-parameter ()
  (when (hunchentoot:within-request-p)
    (make-parameter :back (hunchentoot:request-uri*))))

(defun parse-parameters (parameters)
  (loop while parameters
	for parameter = (pop parameters)
	when (keywordp parameter)
	  collect (make-parameter parameter (pop parameters))
	else collect parameter))

(defun href (path &rest parameters)
  (format nil "~@[~a~]?~{~a=~a~^&~}" path
	  (mapcan (lambda (parameter)
		    (when parameter
		      (let ((name (parameter-name parameter))
			    (value (parameter-value parameter)))
			(list (hunchentoot:url-encode (string-downcase name))
			      (hunchentoot:url-encode (princ-to-string value))))))
		  (cons (back-parameter)
			(parse-parameters parameters)))))
