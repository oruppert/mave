(uiop:define-package :webapp/html-generator/parse-element-argument-list
  (:use :common-lisp)
  (:export :parse-element-argument-list))

(in-package :webapp/html-generator/parse-html-lambda-list)

(defun parse-element-argument-list (argument-list)
  "Returns the attributes and children of an element argument list.
An element argument list consists of attributes and children.
Attributes are key-value pairs, all other elements are children.  Note
that the argument-list gets flattened before parsing.  This allows
functions to return attributes as two element lists."
  (loop with argument-list = (alexandria:flatten argument-list)
	while argument-list
	for item = (pop argument-list)
	when (keywordp item) collect item into attributes
	and collect (pop argument-list) into attributes
	else collect item into children
	finally (return (values attributes children))))




