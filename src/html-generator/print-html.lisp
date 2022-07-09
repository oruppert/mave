(uiop:define-package :webapp/html-generator/print-html
    (:use :common-lisp)
  (:export :print-html-to-string
	   :print-html))

(in-package :webapp/html-generator/print-html)

(defun print-html-to-string (&rest objects)
  (with-output-to-string (stream)
    (dolist (object objects)
      (print-html object stream))))

(defgeneric print-html (object stream)
  (:method (object stream)
    (print-html (princ-to-string object) stream))
  (:method ((null null) stream)
    (values))
  (:method ((null (eql :null)) stream)
    (values))
  (:method ((symbol symbol) stream)
    (write-string (string-downcase symbol) stream))
  (:method ((string string) stream)
    (loop for char across string do
      (case char
	(#\< (write-string "&lt;" stream))
	(#\> (write-string "&gt;" stream))
	(#\& (write-string "&amp;" stream))
	(#\" (write-string "&quot;" stream))
	(t (write-char char stream))))))
