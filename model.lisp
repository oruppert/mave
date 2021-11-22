(uiop:define-package :webapp/model
    (:use :common-lisp)
  (:export
   #:model-value
   #:model-delete))

(in-package :webapp/model)

(defmethod model-value (model attribute))

(defmethod (setf model-value) (value model attribute))

(defmethod model-delete (model))
