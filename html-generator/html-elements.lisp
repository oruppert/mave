(uiop:define-package :webapp/html-generator/html-elements
  (:use :common-lisp
	:webapp/html-generator/html-string
	:webapp/html-generator/print-html)
  (:export :void-element
	   :standard-element
	   :text-element))

(in-package :webapp/html-generator/html-elements)

(defclass abstract-element ()
  ((name :initarg :name :reader element-name)
   (attributes :initarg :attributes :reader element-attributes)
   (children :initarg :children :reader element-children)))

(defmethod print-object ((self abstract-element) stream)
  (print-html self stream))

(defmethod print-html :before ((self abstract-element) stream)
  (fresh-line stream))

(defmethod print-html :after ((self abstract-element) stream)
  (fresh-line stream))

(defclass void-element (abstract-element) ())

(defmethod print-html ((self void-element) stream)
  (write-char #\< stream)
  (write-string (element-name self) stream)
  (loop for (k v) on (element-attributes self) by #'cddr do
    (unless (or (null v)
		(eq v :null))
      (write-char #\Space stream)
      (write-string (string-downcase k) stream)
      (unless (eq v t)
	(write-char #\= stream)
	(write-char #\" stream)
	(print-html v stream)
	(write-char #\" stream))))
  (write-char #\> stream))

(defclass standard-element (void-element) ())

(defmethod print-html ((self standard-element) stream)
  (call-next-method)
  (print-html (element-children self) stream)
  (write-char #\< stream)
  (write-char #\/ stream)
  (write-string (element-name self) stream)
  (write-char #\> stream))

(defclass text-element (standard-element) ())

(defmethod element-children ((self text-element))
  (list
   (html-string
    (format nil "~%~{~a~%~}"
	    (alexandria:flatten
	     (call-next-method))))))
