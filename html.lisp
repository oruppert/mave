(uiop:define-package :webapp/html
  (:use :common-lisp)
  (:export
   #:html-destruct
   #:html-element
   #:html-string
   #:print-html-to-string
   #:print-html
   ;; special elements
   #:style
   #:script))

(in-package :webapp/html)

(defun html-destruct (attributes/children)
  (loop while attributes/children
	for item = (pop attributes/children)
	when (keywordp item) collect item into attributes
	and collect (pop attributes/children) into attributes
	else collect item into children
	finally (return (values attributes children))))

(defun print-text-content (text-content stream)
  (if (listp text-content)
      (dolist (item text-content)
	(fresh-line stream)
	(print-text-content item stream)
	(fresh-line stream))
      (write-string text-content stream)))

(defun print-html-to-string (object)
  (with-output-to-string (stream)
    (print-html object stream)))

(defgeneric print-html (object stream))

(defmethod print-html (object stream)
  (print-html (princ-to-string object) stream))

(defmethod print-html ((null null) stream))

(defmethod print-html ((list list) stream)
  (dolist (item list)
    (print-html item stream)))

(defmethod print-html ((symbol symbol) stream)
  (write-string (string-downcase symbol) stream))

(defmethod print-html ((string string) stream)
  (loop for char across string do
    (case char
      (#\< (write-string "&lt;" stream))
      (#\> (write-string "&gt;" stream))
      (#\& (write-string "&amp;" stream))
      (#\" (write-string "&quot;" stream))
      (t (write-char char stream)))))

(defclass html-string ()
  ((string :initarg :string)))

(defun html-string (string)
  (make-instance 'html-string :string string))

(defmethod print-html ((self html-string) stream)
  (with-slots (string) self
    (write-string string stream)))

(defclass void-element ()
  ((name :initarg :name :reader element-name)
   (attributes :initarg :attributes :reader element-attributes)))

(defmethod print-object ((self void-element) stream)
  (print-html self stream))

(defmethod print-html :before ((self void-element) stream)
  (fresh-line stream))

(defmethod print-html :after ((self void-element) stream)
  (fresh-line stream))

(defmethod print-html ((self void-element) stream)
  (write-char #\< stream)
  (write-string (string-downcase (element-name self)) stream)
  (loop for (k v) on (element-attributes self) by #'cddr do
    (unless (null v)
      (write-char #\Space stream)
      (write-string (string-downcase k) stream)
      (unless (eq v t)
	(write-char #\= stream)
	(write-char #\" stream)
	(print-html v stream)
	(write-char #\" stream))))
  (write-char #\> stream))

(defclass html-element (void-element)
  ((children :initarg :children :reader element-children)))

(defmethod print-children ((self html-element) stream)
  (print-html (element-children self) stream))

(defmethod print-html ((self html-element) stream)
  (call-next-method)
  (print-children self stream)
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
(define-element td)
(define-element th)
(define-element title)
(define-element link)
(define-element tr)
(define-element ul)

(defclass text-content-element (html-element) ())

(defmethod print-children ((self text-content-element) stream)
  (print-text-content (element-children self) stream))

(defun text-content-element (name &rest attributes/children)
  (multiple-value-bind (attributes children)
      (html-destruct attributes/children)
    (make-instance 'text-content-element
		   :name name
		   :attributes attributes
		   :children children)))

(defun style (&rest attributes/children)
  (apply #'text-content-element 'style attributes/children))

(defun script (&rest attributes/children)
  (apply #'text-content-element 'script attributes/children))

(defmacro define-element (name &optional void-p)
  `(progn
     (defun ,name (&rest attributes/children)
       (apply #'html-element ',name ,void-p attributes/children))
     (export ',name)))


