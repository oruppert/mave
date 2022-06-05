;;;; Package Structure

;;; We are using the ``modern'' lisp package style.  That means every
;;; file declares its own package and the ``all''-package includes all
;;; these packages.

;;; A nice thing about this structure is, that you do not need to
;;; include the whole ``webapp'' package, but instead use only the
;;; packages you actually need.

(uiop:define-package :webapp/all
  (:use-reexport
   ;; defines the render generic function
   :webapp/render
   ;; a function based html generator
   :webapp/html
   ;; a simple data access object
   :webapp/database-object
   :webapp/generics
   :webapp/field-access-protocol
   ;; constructing uris
   :webapp/href
   :webapp/field
   ;; defines a bare bones web page
   :webapp/standard-page
   :webapp/standard-form)
  (:nicknames :webapp))
