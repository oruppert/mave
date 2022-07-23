(uiop:define-package :mave/forms/form-protocol
    (:use :common-lisp)
  (:export :form-input-value))

(in-package :mave/forms/form-protocol)

#+Nil(defgeneric form-update-model (form object))

#+Nil(defgeneric form-render-body (form object))

(defgeneric form-input-value (form object slot-name))


















