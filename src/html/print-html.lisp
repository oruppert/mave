(uiop:define-package :mave/html/print-html
    (:use :common-lisp)
  (:export :print-html
	   :print-html-to-string))

(in-package :mave/html/print-html)

(defgeneric print-html (object stream)
  (:documentation
   "Prints object as properly escaped html to stream.")
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

(defun print-html-to-string (&rest objects)
  "Returns the html representation of objects as a string."
  (with-output-to-string (stream)
    (dolist (object objects)
      (print-html object stream))))



