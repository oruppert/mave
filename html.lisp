(uiop:define-package :webapp/html
    (:use :common-lisp)
  (:export
   #:print-html-to-string
   #:print-html
   #:unsafe-string
   #:void-element
   #:element
   #:element-name
   #:element-attributes
   #:element-children))

(in-package :webapp/html)

(defun print-html-to-string (object)
  (with-output-to-string (stream)
    (print-html object stream)))

(defgeneric print-html (object stream)
  (:method ((null null) stream))
  (:method ((list list) stream)
    (dolist (item list)
      (print-html item stream)))
  (:method ((symbol symbol) stream)
    (write-string (string-downcase symbol) stream))
  (:method ((integer integer) stream)
    (princ integer stream))
  (:method ((string string) stream)
    (loop for char across string do
      (case char
	(#\< (write-string "&lt;" stream))
	(#\> (write-string "&gt;" stream))
	(#\& (write-string "&amp;" stream))
	(#\" (write-string "&quot;" stream))
	(t (write-char char stream))))))

(defclass unsafe-string ()
  ((string :initarg :string)))

(defun unsafe-string (string)
  (make-instance 'unsafe-string :string string))

(defmethod print-html ((self unsafe-string) stream)
  (with-slots (string) self
    (write-string string stream)))

(defclass void-element ()
  ((name :initarg :name :reader element-name)
   (attributes :initarg :attributes :reader element-attributes)))

(defun void-element (name &rest attributes)
  (make-instance 'void-element
		 :name name
		 :attributes attributes))

(defmethod print-html ((self void-element) stream)
  (write-char #\< stream)
  (write-string (string-downcase (element-name self)) stream)
  (loop for (k v) on (element-attributes self) by #'cddr do
    (when v
      (write-char #\Space stream)
      (write-string (string-downcase k) stream)
      (unless (eq v t)
	(write-char #\= stream)
	(write-char #\" stream)
	(print-html v stream)
	(write-char #\" stream))))
  (write-char #\> stream))

(defmethod print-html :before ((self void-element) stream)
  (fresh-line stream))

(defmethod print-html :after ((self void-element) stream)
  (fresh-line stream))

(defmethod print-object ((self void-element) stream)
  (print-html self stream))

(defclass element (void-element)
  ((children :initarg :children :reader element-children)))

(defun element (name &rest attributes/chilren)
  (loop while attributes/chilren
	for item = (pop attributes/chilren)
	when (keywordp item) collect item into attributes
	and collect (pop attributes/chilren) into attributes
	else collect item into children
	finally (return (make-instance 'element
				       :name name
				       :attributes attributes
				       :children children))))

(defmethod print-html ((self element) stream)
  (call-next-method)
  (dolist (child (element-children self))
    (print-html child stream))
  (write-char #\< stream)
  (write-char #\/ stream)
  (write-string (string-downcase (element-name self)) stream)
  (write-char #\> stream))

(defmacro define-void-elements (&rest names)
  (flet ((expand (name)
	   `(progn
	      (defun ,name (&rest attributes)
		(apply #'void-element ',name attributes))
	      (export ',name))))
    `(progn ,@(mapcar #'expand names))))

(define-void-elements br hr img input)

(defmacro define-elements (&rest names)
  (flet ((expand (name)
	   `(progn
	      (defun ,name (&rest attributes/children)
		(apply #'element ',name attributes/children))
	      (export ',name))))
    `(progn ,@(mapcar #'expand names))))

(define-elements html body h1 h2 section title head span div aside p a
  select option button ul li ol table tr th td style form label)
