(uiop:define-package :webapp/html-generator/elements/text-element
  (:use :common-lisp
	:webapp/html-generator/html-string
	:webapp/html-generator/elements/abstract-element
	:webapp/html-generator/elements/standard-element)
  (:export :text-element))

(in-package :webapp/html-generator/elements/text-element)

(defclass text-element (standard-element) ())

(defmethod element-children ((self text-element))
  (list
   (html-string
    (format nil "~%~{~a~%~}~%"
	    (alexandria:flatten
	     (call-next-method))))))

