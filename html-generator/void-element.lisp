(uiop:define-package :webapp/html-generator/void-element
  (:use :common-lisp
	:webapp/html-generator/print-html)
  (:export :void-element
	   :element-name
	   :element-attributes))

(in-package :webapp/html-generator/void-element)

(defgeneric element-name (element)
  (:documentation "element -> string"))

(defgeneric element-attributes (element)
  (:documentation "element -> plist"))

(defclass void-element ()
  ((name :initarg :name :reader element-name)
   (attributes :initarg :attributes :reader element-attributes)))

(defmethod element-name :around ((self void-element))
  (string-downcase (call-next-method)))

(defmethod print-object ((self void-element) stream)
  (print-unreadable-object (self stream)
    (print-html self stream)))

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
