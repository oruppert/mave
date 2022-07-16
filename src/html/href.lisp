(uiop:define-package :mave/html/href
  (:use :common-lisp)
  (:export :href-parameter-name
	   :href-parameter-value
	   :href))

(in-package :mave/html/href)

(defclass href-parameter ()
  ((name :initarg :name :reader href-parameter-name)
   (value :initarg :value :reader href-parameter-value)))

(defun make-back-parameter ()
  (when (hunchentoot:within-request-p)
    (make-instance 'href-parameter
		   :name :back
		   :value (hunchentoot:request-uri*))))

(defun parse-parameters (parameter-list)
  (loop while parameter-list
	for name = (pop parameter-list)
	when (keywordp name)
	  collect (make-instance 'href-parameter
				 :name name
				 :value (pop parameter-list))
	else
	  collect name))

(defun href (path &rest parameters)
  (list :href
	(format nil "~@[~a~]?~{~a=~a~^&~}" path
		(mapcan
		 (lambda (parameter)
		   (when parameter
		     (let ((name (href-parameter-name parameter))
			   (value (href-parameter-value parameter)))
		       (unless (or (null value)
				   (eq value :null))
			 (list (hunchentoot:url-encode (string-downcase name))
			       (hunchentoot:url-encode (princ-to-string value)))))))
		 (cons (make-back-parameter)
		       (parse-parameters parameters))))))


