(uiop:define-package :webapp/html/nodes
  (:use :common-lisp
	:webapp/html/print-html)
  (:export :html-string
	   :void-element
	   :element))

(in-package :webapp/html/nodes)

;;;; Html Nodes

(defclass node () ())

(defmethod print-html :before ((self node) stream)
  (fresh-line stream))

(defmethod print-html :after ((self node) stream)
  (fresh-line stream))

(defclass html-string (node)
  ((string :initarg :string)))

(defmethod print-html ((self html-string) stream)
  (with-slots (string) self
    (write-string string stream)))

(defclass void-element (node)
  ((name :initarg :name)
   (attributes :initarg :attributes)))

(defmethod print-html ((self void-element) stream)
  (with-slots (name attributes) self
    (print-opening-tag name attributes stream)))

(defclass element (node)
  ((name :initarg :name)
   (attributes :initarg :attributes)
   (children :initarg :children)))

(defmethod print-html ((self element) stream)
  (with-slots (name attributes children) self
    (print-opening-tag name attributes stream)
    (dolist (child children)
      (print-html child stream))
    (print-closing-tag name stream)))

;;;; Html Print Functions

(defun print-opening-tag (name attributes stream)
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
  (check-type name string)
  (write-char #\< stream)
  (write-char #\/ stream)
  (write-string name stream)
  (write-char #\> stream))
