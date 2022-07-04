(uiop:define-package :webapp/html-generator/parse-html-lambda-list
  (:use :common-lisp)
  (:export :parse-html-lambda-list))

(in-package :webapp/html-generator/parse-html-lambda-list)

(defun parse-html-lambda-list (lambda-list)
  "Parses a html lambda list and returns its attributes and children.
A html lambda list consists of attributes and children.  Attributes
are key-value pairs, all other elements are children.  Note that the
lambda-list gets flattened before parsing.  This allows functions to
return attributes as two element lists.  For examples see the
special-attributes.lisp file."
  (loop with lambda-list = (alexandria:flatten lambda-list)
	while lambda-list
	for item = (pop lambda-list)
	when (keywordp item) collect item into attributes
	and collect (pop lambda-list) into attributes
	else collect item into children
	finally (return (values attributes children))))
