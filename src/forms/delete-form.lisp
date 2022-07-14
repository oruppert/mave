(uiop:define-package :mave/forms/delete-form
  (:use :common-lisp
	:mave/handle-protocol
	:mave/database/database-protocol
	:mave/forms/confirmation-form)
  (:export :delete-form))

(in-package :mave/forms/delete-form)

(defclass delete-form (confirmation-form) ())

(defmethod handle ((self delete-form) object (method (eql :post)))
  (when (confirmed-p self)
    (database-delete object)))



