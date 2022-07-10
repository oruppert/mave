(uiop:define-package :webapp/html-generator/element
  (:use :common-lisp
	:webapp/html-generator/print-html
	:webapp/html-generator/void-element
	:webapp/html-generator/html-string
	:webapp/html-generator/flatten)
  (:export :parse-html-lambda-list
	   :element
	   :body
	   :html
	   :style-element))

(in-package :webapp/html-generator/element)

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

(defclass element (void-element)
  ((children :initarg :children :reader element-children)))

(defmethod print-html ((self element) stream)
  (call-next-method)
  (dolist (child (element-children self))
    (print-html child stream))
  (write-char #\< stream)
  (write-char #\/ stream)
  (write-string (element-name self) stream)
  (write-char #\> stream))

(defun make-element (name attributes/chidlren)
  (multiple-value-bind (attributes children)
      (parse-html-lambda-list attributes/chidlren)
    (make-instance 'element
		   :name name
		   :attributes attributes
		   :children children)))

(defun body (&rest attributes/children)
  (make-element "body" attributes/children))

(defun html (&rest attributes/children)
  (make-element "html" attributes/children))

(defun style-element (&rest attributes/children)
  (multiple-value-bind (attributes children)
      (parse-html-lambda-list attributes/children)
    (let ((string (format nil "~%~{~A~%~}" children)))
      (make-instance 'element
		     :name "style"
		     :attributes attributes
		     :children (list (html-string string))))))

(defun script-element (&rest attributes/children)
  (multiple-value-bind (attributes children)
      (parse-html-lambda-list attributes/children)
    (make-instance 'element
		   :name "script"
		   :attributes attributes
		   :children (mapcar #'html-string children))))



(defun a (&rest attributes/children)
  (make-element "a" attributes/children))

(defun section (&rest attributes/children)
  (make-element "section" attributes/children))

(defun h1 (&rest attributes/children)
  (make-element "h1" attributes/children))


;;  a p h1 li td th tr ul div nav html head body span form link title
;;  main label table select button option legend section fieldset







