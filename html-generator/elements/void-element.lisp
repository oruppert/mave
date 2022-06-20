 ;;;; Void Element

(uiop:define-package :webapp/html-generator/elements/void-element
  (:use :common-lisp
	:webapp/html-generator/print-html
	:webapp/html-generator/elements/abstract-element)
  (:export :void-element))

(in-package :webapp/html-generator/elements/void-element)

(defclass void-element (abstract-element) ())

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

