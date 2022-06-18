(uiop:define-package :webapp/search-table/database-table
  (:use :common-lisp
	:webapp/search-table/database-column
	:webapp/search-table/database-utilities)
  (:export :table-name
	   :table-schema
	   :table-alias
	   :list-columns
	   :database-table))

(in-package :webapp/search-table/database-table)

(defgeneric table-name (table)
  (:documentation "table -> string"))

(defgeneric table-schema (table)
  (:documentation "table -> string"))

(defgeneric table-alias (table)
  (:documentation "table -> string"))

(defgeneric list-columns (table)
  (:documentation "table -> (database-column...)"))

(defclass database-table ()
  ((name :initarg :name :reader table-name)
   (schema :initarg :schema :reader table-schema)
   (alias :initarg :alias :reader table-alias)
   (column-names :reader column-names)))

(defun database-table (name &optional (alias name) (schema "public"))
  (make-instance 'database-table
		 :name name
		 :alias alias
		 :schema schema))

(defmethod table-name :around ((self database-table))
  (identifier-name (call-next-method)))

(defmethod table-schema :around ((self database-table))
  (identifier-name (call-next-method)))

(defmethod table-alias :around ((self database-table))
  (identifier-name (call-next-method)))

(defmethod slot-unbound (class
			 (self database-table)
			 (slot-name (eql 'column-names)))
  (setf (slot-value self 'column-names)
	(database-columns (table-name self)
			  (table-schema self))))

(defmethod list-columns ((self database-table))
  (mapcar (alexandria:curry #'database-column (table-alias self))
	  (column-names self)))

