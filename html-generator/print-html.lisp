(uiop:define-package :webapp/html-generator/print-html
    (:use :common-lisp)
  (:export :print-html
	   :print-html-to-string))

(in-package :webapp/html-generator/print-html)

(defgeneric print-html (object stream))

(defun print-html-to-string (object)
  (with-output-to-string (stream)
    (print-html object stream)))

(defmethod print-html (object stream)
  (print-html (princ-to-string object) stream))

(defmethod print-html ((null null) stream))

(defmethod print-html ((object (eql :null)) stream))

(defmethod print-html ((list list) stream)
  (dolist (item list)
    (print-html item stream)))

(defmethod print-html ((symbol symbol) stream)
  (write-string (string-downcase symbol) stream))

(defmethod print-html ((string string) stream)
  (loop for char across string do
    (case char
      (#\< (write-string "&lt;" stream))
      (#\> (write-string "&gt;" stream))
      (#\& (write-string "&amp;" stream))
      (#\" (write-string "&quot;" stream))
      (t (write-char char stream)))))
