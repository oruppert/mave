(uiop:define-package :webapp/html/print-html
    (:use :common-lisp)
  (:export :print-html
	   :print-html-to-string
	   :make-html-string
	   :make-void-element
	   :make-element
	   :make-string-element))

(in-package :webapp/html/print-html)

;;;; Print Html

(defgeneric print-html (object stream)
  (:documentation "Prints object as properly escaped html to stream.")
  (:method (object stream)
    (print-html (princ-to-string object) stream))
  (:method ((null null) stream)
    (values))
  (:method ((null (eql :null)) stream)
    (values))
  (:method ((symbol symbol) stream)
    (write-string (string-downcase symbol) stream))
  (:method ((string string) stream)
    (loop for char across string do
      (case char
	(#\< (write-string "&lt;" stream))
	(#\> (write-string "&gt;" stream))
	(#\& (write-string "&amp;" stream))
	(#\" (write-string "&quot;" stream))
	(t (write-char char stream))))))

(defun print-html-to-string (&rest objects)
  "Returns the html representation of objects as a string."
  (with-output-to-string (stream)
    (dolist (object objects)
      (print-html object stream))))

(defun print-opening-tag (name attributes stream)
  "Prints an html opening tag to stream."
  (check-type name string)
  (write-char #\< stream)
  (write-string name stream)
  (loop for (k v) on attributes by #'cddr do
    (unless (or (null v)
		(eq v :null))
      (write-char #\Space stream)
      (write-string (string-downcase k) stream)
      (unless (eq v t)
	(write-char #\= stream)
	(write-char #\" stream)
	(print-html v stream)
	(write-char #\" stream))))
  (write-char #\> stream))

(defun print-closing-tag (name stream)
  "Prints an html closing tag to stream."
  (check-type name string)
  (write-char #\< stream)
  (write-char #\/ stream)
  (write-string name stream)
  (write-char #\> stream))

;;;; Html String

(defclass html-string ()
  ((string :initarg :string))
  (:documentation "Used to print unescaped html."))

(defmethod print-html ((self html-string) stream)
  (with-slots (string) self
    (write-string string stream)))

(defun make-html-string (string)
  (check-type string string)
  (make-instance 'html-string :string string))

;;;; Void Element

(defclass void-element ()
  ((name :initarg :name)
   (attributes :initarg :attributes)))

(defmethod print-html ((self void-element) stream)
  (with-slots (name attributes) self
    (fresh-line stream)
    (print-opening-tag name attributes stream)
    (fresh-line stream)))

(defun make-void-element (name attributes)
  (make-instance 'void-element
		 :name name
		 :attribtues (flatten attributes)))

;;;; Element

(defun parse-element-argument-list (argument-list)
  "Returns the attributes and children of the given element argument list.
An element argument list consists of attributes and children.
Attributes are key-value pairs, all other elements are children.  Note
that the argument-list gets flattened before parsing.  This allows
functions to return attributes as two element lists."
  (loop with argument-list = (flatten argument-list)
	while argument-list
	for item = (pop argument-list)
	when (keywordp item) collect item into attributes
	and collect (pop argument-list) into attributes
	else collect item into children
	finally (return (values attributes children))))

(defclass element ()
  ((name :initarg :name)
   (attributes :initarg :attributes)
   (children :initarg :children)))

(defmethod print-html ((self element) stream)
  (with-slots (name attributes children) self
    (fresh-line stream)
    (print-opening-tag name attributes stream)
    (dolist (child children)
      (print-html child stream))
    (print-closing-tag name stream)
    (fresh-line stream)))

(defun make-element (name attributes/children)
  (multiple-value-bind (attributes children)
      (parse-element-argument-list attributes/children)
    (make-instance 'element
		   :name name
		   :attributes attributes
		   :children children)))

(defun make-string-element (name attributes/children)
  "Returns an element which children consists solely of unescaped
strings."
  (multiple-value-bind (attributes children)
      (parse-element-argument-list attributes/children)
    (let ((string (format nil "~%~{~A~%~}" children)))
      (make-instance 'element
		     :name name
		     :attributes attributes
		     :children (list (make-html-string string))))))

;;;; Flatten

(defun flatten (list)
  (loop for item in list
	when (atom item)
	  collect item
	else
	  nconc (flatten item)))
