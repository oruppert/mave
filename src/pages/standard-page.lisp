(uiop:define-package :mave/pages/standard-page
  (:use :common-lisp
	:mave/handle-protocol
	:mave/display-protocol
	:mave/html/all
	:mave/pages/page-protocol)
  (:export :standard-page))

(in-package :mave/pages/standard-page)

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
  ((title :initarg :title :initform nil :reader page-title)
   (doctype :initarg :doctype)))

;;;; Handle Protocol Implementation

(defmethod handle ((page standard-page) object (method (eql :get)))
  (display page object))

;;;; Display Protocol Implementation

(defmethod display-name ((self standard-page) object)
  (or (page-title self)
      (when (next-method-p)
	(call-next-method))))

(defmethod display ((self standard-page) object)
  (print-html-to-string
   (when (slot-boundp self 'doctype)
     (make-html-string (slot-value self 'doctype)))
   (html
    :lang (request-language)
    (head
     (title (display-name self object))
     (meta :name "viewport" :content "width=device-width, initial-scale=1")
     (loop for uri in (page-external-styles self)
	   collect (link :rel :stylesheet :href uri))
     (apply #'style-element (page-inline-styles self)))
    (body (when (next-method-p)
	    (call-next-method))
	  (loop for uri in (page-external-scripts self)
		collect (script-element :src uri))
	  (apply #'script-element (page-inline-scripts self))))))

;;;; Page Protocol Implementation

(defmethod page-external-scripts append ((self standard-page))
  (values nil))

(defmethod page-external-styles append ((self standard-page))
  (values nil))

(defmethod page-inline-styles append ((self standard-page))
  (values nil))

(defmethod page-inline-scripts append ((self standard-page))
  (values nil))




