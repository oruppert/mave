(uiop:define-package :webapp/search
  (:use :common-lisp
	:webapp/database
	:webapp/html)
  (:export
   #:with-column
   #:search-table))

(in-package :webapp/search)

(defclass attribute ()
  ((name :initarg :name :reader attribute-name)
   (type :initarg :type :reader attribute-type)))

(defclass column ()
  ((name :initarg :name :initform nil :reader column-name)
   (attributes :initarg :attributes :reader column-attributes)
   (render-function :initarg :render-function
		    :reader column-render-function)))

(defmacro with-column ((name &rest attributes) &body body)
  (flet ((expand-attribute (name)
	   (destructuring-bind (name &optional type)
	       (if (listp name) name (list name))
	     `(make-instance 'attribute
			     :name ,(intern (string-upcase name) :keyword)
			     :type ,type)))
	 (expand-argument (name)
	   (if (atom name)
	       name
	       (first name))))
    `(make-instance
      'column
      :name ,name
      :attributes (list ,@(mapcar #'expand-attribute attributes))
      :render-function (lambda ,(mapcar #'expand-argument attributes)
			 ,@body))))

(defun search-table (&key sql columns cellpadding rules)
  (let ((rows
	  (query
	   (format nil "SELECT ~{RESULT.~A~^, ~} FROM (~A) RESULT"
		   (loop for column in columns
			 for attributes = (column-attributes column)
			 for names = (mapcar #'attribute-name attributes)
			 append (mapcar #'keyword->sql names))
		   sql))))
    (table
     :cellpadding cellpadding
     :rules rules
     (when (some #'column-name columns)
       (tr (loop for column in columns
		 for name = (column-name column)
		 collect (th name))))
     (loop for row in rows
	   collect
	   (tr (loop for column in columns
		     for attributes = (column-attributes column)
		     for count = (length attributes)
		     for values = (loop repeat count collect (pop row))
		     collect (apply (column-render-function column)
				    values)))))))









