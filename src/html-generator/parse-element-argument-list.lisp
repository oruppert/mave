(uiop:define-package :webapp/html-generator/parse-element-argument-list
  (:use :common-lisp)
  (:export :parse-element-argument-list))

(in-package :webapp/html-generator/parse-element-argument-list)

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

(defun flatten (list)
  (loop for item in list
	when (atom item)
	  collect item
	else
	  nconc (flatten item)))


