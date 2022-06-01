;;;; package

(uiop:define-package :webapp/generics
  (:use :common-lisp)
  (:export
   ;; display-name
   #:display-name
   ;; parameter
   #:parameter-name
   #:parameter-value
   ;; field
   :list-fields
   :field-label
   :field-value
   :render-field))

(in-package :webapp/generics)

;;;; display-name

(defgeneric display-name (object))

;;;; parameter

(defgeneric parameter-name (object))

(defgeneric parameter-value (object))

;;;; field

(defgeneric list-fields (object))

(defgeneric field-label (object name))

(defgeneric field-value (object name))

(defgeneric (setf field-value) (value object name))

(defgeneric render-field (object name))

