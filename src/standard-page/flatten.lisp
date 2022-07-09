(uiop:define-package :webapp/html-generator/flatten
    (:use :common-lisp)
  (:export :flatten))

(in-package :webapp/html-generator/flatten)

(defun flatten (list)
  (loop for item in list
	when (atom item)
	  collect item
	else
	  nconc (flatten item)))
