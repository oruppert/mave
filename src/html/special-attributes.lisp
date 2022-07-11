(uiop:define-package :webapp/html-generator/special-attributes
  (:use :common-lisp)
  (:export :parameter-name
	   :parameter-value
	   :href
	   :action
	   :classes))

(in-package :webapp/html-generator/special-attributes)

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

(defun make-uri (path parameters)
  (format nil "~@[~a~]?~{~a=~a~^&~}" path
	  (mapcan (lambda (parameter)
		    (when parameter
		      (let ((name (parameter-name parameter))
			    (value (parameter-value parameter)))
			(list (hunchentoot:url-encode (string-downcase name))
			      (hunchentoot:url-encode (princ-to-string value))))))
		  (cons (back-parameter)
			(parse-parameters parameters)))))

(defun href (path &rest parameters)
  (list :href (make-uri path parameters)))

(defun action (path &rest parameters)
  (list :action (make-uri path parameters)))

(defun classes (&rest classes)
  (list :class (format nil "~{~a~^ ~}"
		       (loop for class in (alexandria:flatten classes)
			     when class collect (etypecase class
						  (string class)
						  (symbol
						   (string-downcase class)))))))

