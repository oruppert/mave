;;;; package

(uiop:define-package :webapp/generics
  (:use :common-lisp)
  (:export
   ;; display-name
   #:display-name
   ;; parameter
   #:parameter-name
   #:parameter-value
   ;; form
   #:input-name
   #:input-label
   #:input-value
   #:render-input
   #:form-slots
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

;;;; form

(defgeneric input-name (object slot-name))

(defgeneric input-label (object slot-name))

(defgeneric input-value (object slot-name))

(defgeneric (setf input-value) (value object slot-name))

(defgeneric render-input (object slot-name))

(defgeneric form-slots (object))

;;;; entity

(defgeneric entity-id (object))

(defgeneric (setf entity-id) (value object))

(defgeneric entity-insert (object))

(defgeneric entity-update (object))

(defgeneric entity-delete (object))
