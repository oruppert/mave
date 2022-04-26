(uiop:define-package :html
  (:use :common-lisp)
  (:export
   #:text
   #:html-destruct
   #:html-fragment
   #:html-element))

(in-package :html)

(defun html-destruct (attributes/children)
  (loop while attributes/children
	for item = (pop attributes/children)
	when (keywordp item) collect item into attributes
	and collect (pop attributes/children) into attributes
	else collect item into children
	finally (return (values attributes children))))

(defun print-fragment (children stream)
  (dolist (child children)
    (fresh-line stream)
    (if (listp child)
	(print-fragment child stream)
	(princ child stream))
    (fresh-line stream)))

(defun html-fragment (&rest children)
  (with-output-to-string (stream)
    (print-fragment children stream)))

(defun print-safe (object stream)
  (when object
    (loop for char across (if (symbolp object)
			      (string-downcase object)
			      (princ-to-string object))
	  do
	     (case char
	       (#\< (write-string "&lt;" stream))
	       (#\> (write-string "&gt;" stream))
	       (#\& (write-string "&amp;" stream))
	       (#\" (write-string "&quot;" stream))
	       (t (write-char char stream))))))

(defun text (object)
  (with-output-to-string (stream)
    (print-safe object stream)))

(defun html-element (name void-p &rest attributes/children)
  (with-output-to-string (stream)
    (multiple-value-bind (attributes children)
	(html-destruct attributes/children)
      (write-char #\< stream)
      (write-string (string-downcase name) stream)
      (loop for (k v) on attributes by #'cddr do
	(when v
	  (write-char #\Space stream)
	  (write-string (string-downcase k) stream)
	  (unless (eql v t)
	    (write-char #\= stream)
	    (write-char #\" stream)
	    (print-safe v stream)
	    (write-char #\" stream))))
      (write-char #\> stream)
      (unless void-p
	(print-fragment children stream)
	(write-char #\< stream)
	(write-char #\/ stream)
	(write-string (string-downcase name) stream)
	(write-char #\> stream)))))

(defmacro define-element (name &optional void-p)
  `(progn
     (defun ,name (&rest attributes/children)
       (apply #'html-element ',name ,void-p attributes/children))
     (export ',name)))

(define-element html)
(define-element body)
(define-element section)
(define-element head)
(define-element h1)
(define-element a)
(define-element input t)
(define-element div)



