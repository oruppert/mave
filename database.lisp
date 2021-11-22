(uiop:define-package :webapp/database
    (:use :common-lisp
	  :webapp/model)
  (:export
   #:query
   #:keyword->sql
   #:integer->sql
   #:string->sql
   #:object->sql
   #:insert
   #:entity
   #:entity-id
   #:entity-table))

(in-package :webapp/database)

;;;; database access

(defgeneric query (sql))

;;;; sql

(defun keyword->sql (keyword)
  (check-type keyword keyword)
  (substitute #\_ #\- (string-downcase keyword)))

(defun integer->sql (integer)
  (check-type integer integer)
  (princ-to-string integer))

(defun string->sql (string)
  (check-type string string)
  (with-output-to-string (stream)
    (write-char #\' stream)
    (loop for char across string do
      (case char
	(#\' (write-string "''" stream))
	(t (write-char char stream))))
    (write-char #\' stream)))

(defun object->sql (object)
  (etypecase object
    (keyword (keyword->sql object))
    (integer (integer->sql object))
    (string (string->sql object))))

;;;; insert

(defun insert (table &rest attributes/values)
  (check-type table keyword)
  (multiple-value-bind (attributes values)
      (loop for (k v) on attributes/values by #'cddr
	    collect k into attributes
	    collect v into values
	    finally (return (values attributes values)))
    (query (format nil "INSERT INTO ~A(~{~A~^, ~}) VALUES(~{~A~^, ~})"
		   (keyword->sql table)
		   (mapcar #'keyword->sql attributes)
		   (mapcar #'object->sql values)))
    (apply #'values values)))

;;;; entity

(defclass entity ()
  ((id :initarg :id :reader entity-id)
   (table :initarg :table :reader entity-table)))

(defmethod model-value ((self entity) attribute)
  (check-type attribute keyword)
  (caar (query (format nil "SELECT ~A FROM ~A WHERE ID = ~A"
		       (keyword->sql attribute)
		       (keyword->sql (entity-table self))
		       (object->sql (entity-id self))))))

(defmethod (setf model-value) (value (self entity) attribute)
  (check-type attribute keyword)
  (query (format nil "UPDATE ~A SET ~A = ~A WHERE ID = ~A"
		 (keyword->sql (entity-table self))
		 (keyword->sql attribute)
		 (object->sql value)
		 (object->sql (entity-id self))))
  (values value))

(defmethod model-delete ((self entity))
  (query (format nil "DELETE FROM ~A WHERE id = ~A"
		 (keyword->sql (entity-table self))
		 (object->sql (entity-id self)))))
