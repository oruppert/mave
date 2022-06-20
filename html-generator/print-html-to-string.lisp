(uiop:define-package :webapp/html-generator/print-html-to-string
    (:use :common-lisp
	  :webapp/html-generator/print-html)
  (:export :print-html-to-string))

(in-package :webapp/html-generator/print-html-to-string)

(defun print-html-to-string (object)
  (with-output-to-string (stream)
    (print-html object stream)))
