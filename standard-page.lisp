;;;; package

(uiop:define-package :webapp/standard-page
  (:use :common-lisp
	:webapp/render
	:webapp/html)
  (:export :page-title
	   :page-style
	   :page-script
	   :standard-page))

(in-package :webapp/standard-page)

;;;; generic functions

(defgeneric page-title (object page)
  (:documentation "Returns the title of the given object and page."))

(defgeneric page-style (page)
  (:documentation "Returns the styles of the given page as a list of strings.")
  (:method-combination append :most-specific-last))

(defgeneric page-script (page)
  (:documentation "Returns the script of the given page as a list of strings.")
  (:method-combination append :most-specific-last))

;;;; standard-page

(defclass standard-page ()
  ((title :initarg :title)))

(defmethod page-title (object (self standard-page))
  (if (slot-boundp self 'title)
      (slot-value self 'title)
      (when (next-method-p)
	(call-next-method))))

(defmethod page-style append ((self standard-page))
  nil)

(defmethod page-script append ((self standard-page))
  nil)

(defmethod render (object (self standard-page))
  (print-html-to-string
   (html
    (head
     (title (page-title object self))
     (meta :name "viewport" :content "width=device-width, initial-scale=1")
     (style (page-style self)))
    (body (when (next-method-p)
	    (call-next-method))
	  (script (page-script self))))))

