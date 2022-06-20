(uiop:define-package :webapp/html-generator/elements/standard-element
  (:use :common-lisp
	:webapp/html-generator/print-html
	:webapp/html-generator/elements/abstract-element
	:webapp/html-generator/elements/void-element)
  (:export :standard-element))

(in-package :webapp/html-generator/elements/standard-element)

(defclass standard-element (void-element) ())

(defmethod print-html ((self standard-element) stream)
  (call-next-method)
  (print-html (element-children self) stream)
  (write-char #\< stream)
  (write-char #\/ stream)
  (write-string (string-downcase (element-name self)) stream)
  (write-char #\> stream))
