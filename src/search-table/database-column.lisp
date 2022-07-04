;;;; Database Column

(uiop:define-package :webapp/search-table/database-column
  (:use :common-lisp
	:webapp/search-table/database-utilities)
  (:export
   #:database-column
   #:column-name
   #:column-qualifier
   #:column-qualified-name
   #:column-alias
   #:column-alias-keyword))

(in-package :webapp/search-table/database-column)

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

(defclass database-column ()
  ((name :initarg :name :reader column-name)
   (qualifier :initarg :qualifier :reader column-qualifier)))

(defun database-column (qualifier name)
  (make-instance 'database-column :name name :qualifier qualifier))

(defmethod column-name :around ((self database-column))
  (identifier-name (call-next-method)))

(defmethod column-qualifier :around ((self database-column))
  (identifier-name (call-next-method)))

(defmethod column-qualified-name ((self database-column))
  (format nil "~a.~a"
	  (column-qualifier self)
	  (column-name self)))

(defmethod column-alias ((self database-column))
  (format nil "~a_~a"
	  (column-qualifier self)
	  (column-name self)))

(defmethod column-alias-keyword ((self database-column))
  (intern (substitute #\- #\_ (string-upcase (column-alias self)))
	  :keyword))
