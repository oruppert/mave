;;;; Search Table

(uiop:define-package :webapp/search-table
  (:use :common-lisp))

(in-package :webapp/search-table)

;;;; Generic Functions

(defgeneric column-name (column)
  (:documentation "column -> string"))

(defgeneric column-qualifier (column)
  (:documentation "column -> string"))

(defgeneric column-qualified-name (column)
  (:documentation "column -> string"))

(defgeneric column-alias (column)
  (:documentation "column -> string"))

(defgeneric column-alias-keyword (column)
  (:documentation "column -> symbol"))

(defgeneric table-name (table)
  (:documentation "table -> string"))

(defgeneric table-alias (table)
  (:documentation "table -> string"))

(defgeneric list-columns (object)
  (:documentation "object -> list"))

(defgeneric list-tables (object)
  (:documentation "object -> list"))

(defgeneric select-columns (object)
  (:documentation "object -> string"))

;;;; Column

(defclass column ()
  ((name :initarg :name :reader column-name)
   (qualifier :initarg :qualifier :reader column-qualifier)))

(defmethod column-name :around ((self column))
  (let ((value (call-next-method)))
    (etypecase value
      (string value)
      (symbol (postmodern:sql-escape value)))))

(defmethod column-qualifier :around ((self column))
  (let ((value (call-next-method)))
    (etypecase value
      (string value)
      (symbol (postmodern:sql-escape value)))))

(defmethod column-qualified-name ((self column))
  (format nil "~a.~a"
	  (column-qualifier self)
	  (column-name self)))

(defmethod column-alias ((self column))
  (format nil "~a_~a"
	  (column-qualifier self)
	  (column-name self)))

(defmethod column-alias-keyword ((self column))
  (intern (substitute #\- #\_ (string-upcase (column-alias self)))
	  :keyword))

;;;; Table

(defclass table ()
  ((name :initarg :name :reader table-name)
   (alias :initarg :alias :reader table-alias)
   (column-names :reader column-names)))

(defmethod table-name :around ((self table))
  (let ((value (call-next-method)))
    (etypecase value
      (string value)
      (symbol (postmodern:sql-escape value)))))

(defmethod table-alias :around ((self table))
  (let ((value (call-next-method)))
    (etypecase value
      (string value)
      (symbol (postmodern:sql-escape value)))))

(defmethod slot-unbound (class (self table) (slot-name (eql 'column-names)))
  (setf (slot-value self 'column-names)
	(postmodern:query
	 "select column_name from information_schema.columns where table_name = $1"
	 (table-name self)
	 :column)))

(defmethod list-columns ((self table))
  (loop with table-alias = (table-alias self)
	for column-name in (column-names self)
	collect (make-instance 'column
			       :name column-name
			       :qualifier table-alias)))

;;;; Search Table

(defclass search-table ()
  ((table-spec :initarg :table-spec)
   (tables :reader list-tables)
   (from :initarg :from)
   (join :initarg :join)))

(defmethod slot-unbound (class (self search-table) (slot-name (eql 'tables)))
  (setf (slot-value self 'tables)
	(mapcar (lambda (table)
		  (destructuring-bind (name &optional (alias name))
		      (alexandria:ensure-list table)
		    (make-instance 'table :name name :alias alias)))
		(slot-value self 'table-spec))))

(defmethod list-columns ((self search-table))
  (loop for table in (list-tables self)
	append (list-columns table)))

(defmethod select-columns ((self search-table))
  (format nil "~%~{        ~40a as ~a~^,~%~}~%"
	  (mapcan (lambda (column)
		    (list (column-qualified-name column)
			  (column-alias column)))
		  (list-columns self))))



