;;;; package

(uiop:define-package :webapp/database-object
  (:use :common-lisp)
  (:export :database-insert
	   :database-update
	   :database-delete))

(in-package :webapp/database-object)

;;;; generic functions

(defgeneric database-insert (object)
  (:documentation "Insert the given object into the database."))

(defgeneric database-update (object)
  (:documentation "Update the database from the given object."))

(defgeneric database-delete (object)
  (:documentation "Delete the given object from the database."))
