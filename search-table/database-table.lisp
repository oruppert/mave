;;;; Database Table

(uiop:define-package :webapp/search-table/database-table
  (:use :common-lisp
	:webapp/search-table/database-column
	:webapp/search-table/database-utilities)
  (:export :table-name
	   :table-alias
	   :list-columns
	   :database-table))

(in-package :webapp/search-table/database-table)

(defgeneric table-name (table)
  (:documentation "table -> string"))

(defgeneric table-alias (table)
  (:documentation "table -> string"))

(defgeneric list-columns (table)
  (:documentation "table -> (database-column...)"))

(defclass database-table ()
  ((name :initarg :name :reader table-name)
   (alias :initarg :alias :reader table-alias)
   (column-names :reader column-names)))

(defun database-table (name &optional (alias name))
  (make-instance 'database-table :name name :alias alias))

(defmethod table-name :around ((self database-table))
  (identifier-name (call-next-method)))

(defmethod table-schema :around ((self database-table))
  (identifier-name (call-next-method)))

(defmethod table-alias :around ((self database-table))
  (identifier-name (call-next-method)))

(defmethod slot-unbound (class (self database-table)
			 (slot-name (eql 'column-names)))
  (setf (slot-value self slot-name)
	(postmodern:list-columns (table-name self))))

(defmethod list-columns ((self database-table))
  (mapcar (alexandria:curry #'database-column (table-alias self))
	  (column-names self)))

