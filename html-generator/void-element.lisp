(uiop:define-package :webapp/html-generator/void-element
  (:use :common-lisp
	:webapp/html-generator/print-html)
  (:export :void-element
	   :element-name
	   :element-attributes
	   :br
	   :hr
	   :meta
	   :input
	   :img))

(in-package :webapp/html-generator/void-element)

(defclass void-element ()
  ((name :initarg :name :reader element-name)
   (attributes :initarg :attributes :reader element-attributes)))

(defmethod print-object ((self void-element) stream)
  (print-html self stream))

(defmethod print-html :before ((self void-element) stream)
  (fresh-line stream))

(defmethod print-html :after ((self void-element) stream)
  (fresh-line stream))

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

(defun make-void-element (name attributes)
  (make-instance 'void-element :name name :attributes attributes))

(defun br (&rest attributes)
  (make-void-element "br" attributes))

(defun hr (&rest attributes)
  (make-void-element "hr" attributes))

(defun meta (&rest attributes)
  (make-void-element "meta" attributes))

(defun input (&rest attributes)
  (make-void-element "input" attributes))

(defun img (&rest attributes)
  (make-void-element "img" attributes))
