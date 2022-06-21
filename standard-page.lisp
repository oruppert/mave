;;;; Standard Page

(uiop:define-package :webapp/standard-page
  (:use :common-lisp
	:webapp/display-protocol
	:webapp/html-generator/all)
  (:export :page-style
	   :page-script
	   :additional-head-elements
	   :standard-page))

(in-package :webapp/standard-page)

;;;; Generic Functions

(defgeneric page-style (page)
  (:documentation "Returns the styles of the given page as a list of strings.")
  (:method-combination append :most-specific-last))

(defgeneric page-script (page)
  (:documentation "Returns the script of the given page as a list of strings.")
  (:method-combination append :most-specific-last))

(defgeneric additional-head-elements (page)
  (:documentation "Returns a list of additional html head elements.")
  (:method-combination append :most-specific-last))

;;;; Default Implementation

(defclass standard-page ()
  ((title :initarg :title)
   (doctype :initarg :doctype)))

(defmethod display-name (object (self standard-page))
  (if (slot-boundp self 'title)
      (slot-value self 'title)
      (when (next-method-p)
	(call-next-method))))

(defmethod page-style append ((self standard-page))
  nil)

(defmethod page-script append ((self standard-page))
  nil)

(defmethod additional-head-elements append ((self standard-page))
  nil)

(defmethod display-name (object (self standard-page))
  (if (slot-boundp self 'title)
      (slot-value self 'title)
      (when (next-method-p)
	(call-next-method))))

(defmethod display (object (self standard-page))
  (print-html-to-string
   (list
    (when (slot-boundp self 'doctype)
      (html-string
       (slot-value self 'doctype)))
    (html
     (head
      (title (display-name object self))
      (meta :name "viewport" :content "width=device-width, initial-scale=1")
      (style (page-style self))
      (additional-head-elements self))
     (body (when (next-method-p)
	     (call-next-method))
	   (script (page-script self)))))))


