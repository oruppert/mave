(uiop:define-package :webapp/standard-page
  (:use :common-lisp
	:webapp/generics
	:webapp/html)
  (:export :standard-page))

(in-package :webapp/standard-page)

(defclass standard-page ()
  ((title :initarg :title)))

(defmethod page-title (object (self standard-page))
  (if (slot-boundp self 'title)
      (slot-value self 'title)
      (call-next-method)))

(defmethod page-style append ((self standard-page))
  nil)

(defmethod page-script append ((self standard-page))
  nil)

(defmethod render (object (self standard-page))
  (print-html-to-string
   (html
    (head (title (page-title object self))
	  (style (page-style self)))
    (body (when (next-method-p)
	    (call-next-method))
	  (script (page-script self))))))

