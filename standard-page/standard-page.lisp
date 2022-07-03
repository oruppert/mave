;;;; Standard Page

(uiop:define-package :webapp/standard-page/standard-page
  (:use :common-lisp
	:webapp/handle-protocol
	:webapp/display-protocol
	:webapp/html-generator/all
	:webapp/standard-page/page-protocol)
  (:export :standard-page))

(in-package :webapp/standard-page/standard-page)

;;; Class definition.

(defclass standard-page ()
  ((title :initarg :title)
   (doctype :initarg :doctype)))

;;; Implement the handle protocol.

(defmethod handle (object (page standard-page) (method (eql :get)))
  (display object page))

;;; Implement the display protocol.

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

;;; Implement the page protocol. 

(defmethod page-external-scripts append ((self standard-page))
  (values nil))

(defmethod page-external-styles append ((self standard-page))
  (values nil))

(defmethod page-inline-style append ((self standard-page))
  (values nil))

(defmethod page-inline-script append ((self standard-page))
  (values nil))

(defmethod page-additional-head-elements append ((self standard-page))
  (values nil))



