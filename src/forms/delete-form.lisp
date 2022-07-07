(uiop:define-package :webapp/forms/delete-form
  (:use :common-lisp
	:webapp/handle-protocol
	:webapp/database/database-protocol
	:webapp/forms/confirmation-form)
  (:export :delete-form))

(in-package :webapp/forms/delete-form)

(defclass delete-form (confirmation-form) ())

(defmethod handle (object (self delete-form) (method (eql :post)))
  (when (confirmed-p self)
    (database-delete object)))



