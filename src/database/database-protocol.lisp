;;;; Database Protocol

(uiop:define-package :webapp/database/database-protocol
  (:use :common-lisp)
  (:export :database-insert
	   :database-update
	   :database-delete))

(in-package :webapp/database/database-protocol)

(defgeneric database-insert (object)
  (:documentation "Insert the given object into the database."))

(defgeneric database-update (object)
  (:documentation "Update the database from the given object."))

(defgeneric database-delete (object)
  (:documentation "Delete the given object from the database."))
