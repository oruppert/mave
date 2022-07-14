;;;; Database Protocol

(uiop:define-package :mave/database/database-protocol
  (:use :common-lisp)
  (:export :database-insert
	   :database-update
	   :database-delete))

(in-package :mave/database/database-protocol)

(defgeneric database-insert (object)
  (:documentation "Inserts the given object into the database."))

(defgeneric database-update (object)
  (:documentation "Updates the database from the given object."))

(defgeneric database-delete (object)
  (:documentation "Deletes the given object from the database."))
