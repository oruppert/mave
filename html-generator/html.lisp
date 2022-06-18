(uiop:define-package :webapp/html-generator/html
  (:use :common-lisp
	:webapp/html-generator/html-destruct
	:webapp/html-generator/print-html
	;; needed here?
	:webapp/html-generator/html-string
	:webapp/html-generator/void-element)
  (:export
   #:html-element
   #:print-html-to-string
   #:print-html
   ;; text only elements
   #:style
   #:script))

(in-package :webapp/html-generator/html)

(defclass html-element (void-element)
  ((children :initarg :children :reader element-children)))

(defmethod print-html ((self html-element) stream)
  (call-next-method)
  (print-html (element-children self) stream)
  (write-char #\< stream)
  (write-char #\/ stream)
  (write-string (string-downcase (element-name self)) stream)
  (write-char #\> stream))

(defun html-element (name void-p &rest attributes/children)
  (multiple-value-bind (attributes children)
      (html-destruct attributes/children)
    (if void-p
	(make-instance 'void-element :name name :attributes attributes)
	(make-instance 'html-element :name name :attributes attributes
		       :children children))))

(defmacro define-element (name &optional void-p)
  `(progn
     (defun ,name (&rest attributes/children)
       (apply #'html-element ',name ,void-p attributes/children))
     (export ',name)))

(define-element a)
(define-element body)
(define-element button)
(define-element div)
(define-element select)
(define-element option)
(define-element form)
(define-element h1)
(define-element meta t)
(define-element head)
(define-element html)
(define-element input t)
(define-element label)
(define-element li)
(define-element nav)
(define-element p)
(define-element section)
(define-element table)
(define-element span)
(define-element td)
(define-element th)
(define-element title)
(define-element link)
(define-element tr)
(define-element ul)
(define-element fieldset)
(define-element legend)

(defun style (&rest attributes/children)
  (multiple-value-bind (attributes children)
      (html-destruct attributes/children)
    (let ((string (format nil "~%~{~A~%~}"
			  (alexandria:flatten children))))
      (make-instance 'html-element
		     :name 'style
		     :attributes attributes
		     :children (list (html-string string))))))

(defun script (&rest attributes/children)
  (multiple-value-bind (attributes children)
      (html-destruct attributes/children)
    (let ((string (format nil "~%~{~A~%~}"
			  (alexandria:flatten children))))
      (make-instance 'html-element
		     :name 'script
		     :attributes attributes
		     :children (list (html-string string))))))
