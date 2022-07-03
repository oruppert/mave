;;;; Standard Page

(uiop:define-package :webapp/standard-page/standard-page
  (:use :common-lisp
	:webapp/handle-protocol
	:webapp/display-protocol
	:webapp/html-generator/all
	:webapp/standard-page/page-protocol)
  (:export :standard-page))

(in-package :webapp/standard-page/standard-page)

(defclass standard-page ()
  ((title :initarg :title)
   (doctype :initarg :doctype)))

(defmethod handle (object (page standard-page) (method (eql :get)))
  (display object page))

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
     (loop for uri in (page-external-scripts self)
	   collect (link :rel :stylesheet :href uri))
     (style (page-inline-style self))
     (page-additional-head-elements self))
    (body (when (next-method-p)
	    (call-next-method))
	  (loop for uri in (page-external-scripts self)
		collect (script :src uri))
	  (script (page-inline-script self))))))



