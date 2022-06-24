;;;; Standard Page

(uiop:define-package :webapp/standard-page/standard-page
  (:use :common-lisp
	:webapp/display-protocol
	:webapp/html-generator/all
	:webapp/standard-page/page-protocol)
  (:export :standard-page))

(in-package :webapp/standard-page/standard-page)

(defclass standard-page ()
  ((title :initarg :title)
   (doctype :initarg :doctype)))

(defmethod display-name (object (self standard-page))
  (if (slot-boundp self 'title)
      (slot-value self 'title)
      (when (next-method-p)
	(call-next-method))))

(defmethod display (object (self standard-page))
  (print-html-to-string
   (when (slot-boundp self 'doctype)
     (html-string (slot-value self 'doctype)))
   (html
    (head
     (title (display-name object self))
     (meta :name "viewport" :content "width=device-width, initial-scale=1")
     (style (page-style self))
     (additional-head-elements self))
    (body (when (next-method-p)
	    (call-next-method))
	  (script (page-script self))))))

