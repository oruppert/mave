(uiop:define-package :webapp/html/constructors
    (:use :common-lisp
	  :webapp/html/nodes)
  (:export :make-html-string
	   :make-void-element
	   :make-element
	   :make-string-element))

(in-package :webapp/html/constructors)

(defun make-html-string (string)
  "Returns a html-string for the given string.
A html string is used to emit unescaped html."
  (check-type string string)
  (make-instance 'html-string :string string))

(defun make-void-element (name attributes)
  "Returns a void element for the given name and attributes.
A void element does not have any children.  Note that the attributes
get flattened.  This allows functions to return attributes as two
element lists."
  (check-type name string)
  (make-instance 'void-element
		 :name name
		 :attributes (flatten attributes)))

(defun make-element (name element-argument-list)
  "Returns an element for the given name, attributes and children.
Note that the element-argument-list gets flattened.  This allows
functions to return attributes as two element lists."
  (check-type name string)
  (multiple-value-bind (attributes children)
      (parse-element-argument-list
       (flatten element-argument-list))
    (make-instance 'element
		   :name name
		   :attributes attributes
		   :children children)))

(defun make-string-element (name element-argument-list)
  "Returns an element which children consists solely of unescaped strings.
Note that the element-argument-list gets flattened.  This allows
functions to return attributes as two element lists."
  (check-type name string)
  (multiple-value-bind (attributes children)
      (parse-element-argument-list
       (flatten element-argument-list))
    (make-instance 'element
		   :name name
		   :attributes attributes
		   :children (loop for child in children
				when child
				collect (make-html-string child)))))

(defun parse-element-argument-list (element-argument-list)
  "Returns the attributes and children of the given element-argument-list.
An element-argument-list consists of attributes and children.
Attributes are key-value pairs, all other elements are children."
  (loop while element-argument-list
	for item = (pop element-argument-list)
	when (keywordp item) collect item into attributes
	and collect (pop element-argument-list) into attributes
	else collect item into children
	finally (return (values attributes children))))

(defun flatten (list)
  "Flattens the given list, preserves null values."
  (loop for item in list
	when (atom item)
	  collect item
	else
	  nconc (flatten item)))
