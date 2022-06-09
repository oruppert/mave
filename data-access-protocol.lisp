;;;; Data Access Protocol

(uiop:define-package :webapp/data-access-protocol
  (:use :common-lisp)
  (:export :database-insert
	   :database-update
	   :database-delete
	   :database-upsert))

(in-package :webapp/data-access-protocol)

(defgeneric database-insert (object)
  (:documentation "Insert the given object into the database."))

(defgeneric database-update (object)
  (:documentation "Update the database from the given object."))

(defgeneric database-delete (object)
  (:documentation "Delete the given object from the database."))

(defgeneric database-upsert (object)
  (:documentation "Updates or inserts, depending on the state of object."))

