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
   :render-field
   ;; entity
   #:entity-id
   #:entity-insert
   #:entity-update
   #:entity-delete))

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

;;;; entity

(defgeneric entity-id (object))

(defgeneric (setf entity-id) (value object))

(defgeneric entity-insert (object))

(defgeneric entity-update (object))

(defgeneric entity-delete (object))
