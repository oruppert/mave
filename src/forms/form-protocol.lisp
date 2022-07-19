(uiop:define-package :mave/forms/form-protocol
    (:use :common-lisp)
  (:export))

(in-package :mave/forms/form-protocol)

(defgeneric form-slots (form object))

(defgeneric form-update-model (form object))

(defgeneric form-render-body (form object))

(defgeneric form-input-name (form object slot-name))

(defgeneric form-input-label (form object slot-name))

(defgeneric from-input-value (form object slot-name))

(defgeneric (setf form-input-value) (value form object slot-name))

(defgeneric form-render-input (form object slot-name value))

(defclass insert-form (standard-form) ())

(defmethod handle :after ((self insert-form) object (method (eql :post)))
  #+nil
  (database-insert object))

(defmethod form-input-value ((self insert-form) object slot-name)
  nil)

(defclass update-form (standard-form) ())

(defmethod form-input-value ((self update-form) object slot-name)
  (values nil))

(defmethod handle :after ((self update-form) object (method (eql :post)))
  #+nil
  (database-update object))










