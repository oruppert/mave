;;;; Html Destruct

(uiop:define-package :webapp/html-generator/html-destruct
  (:use :common-lisp)
  (:export :html-destruct))

(in-package :webapp/html-generator/html-destruct)

(defun html-destruct (attributes/children)
  (loop while attributes/children
	for item = (pop attributes/children)
	when (keywordp item) collect item into attributes
	and collect (pop attributes/children) into attributes
	else collect item into children
	finally (return (values attributes children))))
