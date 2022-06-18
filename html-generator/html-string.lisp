(uiop:define-package :webapp/html-generator/html-string
  (:use :common-lisp
	:webapp/html-generator/print-html)
  (:export :html-string))

(in-package :webapp/html-generator/html-string)

(defclass html-string ()
  ((string :initarg :string)))

(defun html-string (string)
  (check-type string string)
  (make-instance 'html-string :string string))

(defmethod print-html ((self html-string) stream)
  (with-slots (string) self
    (write-string string stream)))
