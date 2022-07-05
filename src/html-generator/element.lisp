(uiop:define-package :webapp/html-generator/element
  (:use :common-lisp
	:webapp/html-generator/print-html
	:webapp/html-generator/void-element
	:webapp/html-generator/parse-html-lambda-list
	:webapp/html-generator/html-string)
  (:export :element
	   :body
	   :html
	   :style-element))

(in-package :webapp/html-generator/element)

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







