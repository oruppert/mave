(uiop:define-package :webapp/standard-page/standard-page
  (:use :common-lisp
	:webapp/handle-protocol
	:webapp/display-protocol
	:webapp/html-generator/all
	:webapp/standard-page/page-protocol)
  (:export :standard-page))

(in-package :webapp/standard-page/standard-page)

;;;; Request Language

(defun request-language ()
  (when (hunchentoot:within-request-p)
    (let (r)
      (setq r (hunchentoot:header-in* :accept-language))
      (setq r (first (cl-ppcre:split #\; r)))
      (setq r (first (last (cl-ppcre:split #\, r))))
      (setq r (string-trim #(#\Space #\Tab #\Newline #\Return) r)))))

;;;; Standard Page

(defclass standard-page ()
  ((title :initarg :title)
   (doctype :initarg :doctype)))

;;;; Handle Protocol Implementation

(defmethod handle (object (page standard-page) (method (eql :get)))
  (display object page))

;;;; Display Protocol Implementation

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
    :lang (request-language)
    (head
     (title (display-name object self))
     (meta :name "viewport" :content "width=device-width, initial-scale=1")
     (loop for uri in (page-external-styles self)
	   collect (link :rel :stylesheet :href uri))
     (style (page-inline-style self)))
    (body (when (next-method-p)
	    (call-next-method))
	  (loop for uri in (page-external-scripts self)
		collect (script :src uri))
	  (script (page-inline-script self))))))

;;;; Page Protocol Implementation

(defmethod page-external-scripts append ((self standard-page))
  (values nil))

(defmethod page-external-styles append ((self standard-page))
  (values nil))

(defmethod page-inline-style append ((self standard-page))
  (values nil))

(defmethod page-inline-script append ((self standard-page))
  (values nil))




