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
  (:method-combination append :most-specific-last)
  (:method append (page) nil))

(defgeneric page-script (page)
  (:documentation "Returns the script of the given page as a list of strings.")
  (:method-combination append :most-specific-last)
  (:method append (page) nil))

(defgeneric additional-head-elements (page)
  (:documentation "Returns a list of additional html head elements.")
  (:method-combination append :most-specific-last)
  (:method append (page) nil))

;;;; Default Implementation

(defclass standard-page ()
  ((title :initarg :title)))

(defmethod display-name (object (self standard-page))
  (if (slot-boundp self 'title)
      (slot-value self 'title)
      (when (next-method-p)
	(call-next-method))))

(defmethod display (object (self standard-page))
  (print-html-to-string
   (html
    (head
     (title (display-name object self))
     (meta :name "viewport" :content "width=device-width, initial-scale=1")
     (style (page-style self))
     (additional-head-elements self))
    (body (when (next-method-p)
	    (call-next-method))
	  (script (page-script self))))))


