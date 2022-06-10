;;;; Standard Page

(uiop:define-package :webapp/standard-page
  (:use :common-lisp
	:webapp/display-protocol
	:webapp/html)
  (:export :page-style
	   :page-script
	   :standard-page))

(in-package :webapp/standard-page)

(defgeneric page-style (page)
  (:documentation "Returns the styles of the given page as a list of strings.")
  (:method-combination append :most-specific-last))

(defgeneric page-script (page)
  (:documentation "Returns the script of the given page as a list of strings.")
  (:method-combination append :most-specific-last))

(defclass standard-page ()
  ((name :initarg :name)))

(defmethod page-style append ((self standard-page))
  nil)

(defmethod page-script append ((self standard-page))
  nil)

(defmethod display-name (object (self standard-page))
  (if (slot-boundp self 'name)
      (slot-value self 'name)
      (when (next-method-p)
	(call-next-method))))

(defmethod display (object (self standard-page))
  (print-html-to-string
   (html
    (head
     (title (display-name object self))
     (meta :name "viewport" :content "width=device-width, initial-scale=1")
     (style (page-style self)))
    (body (when (next-method-p)
	    (call-next-method))
	  (script (page-script self))))))


