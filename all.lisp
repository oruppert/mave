;;;; Package Structure

;;; We are using the ``modern'' lisp package style.  That means every
;;; file declares its own package and the ``webapp/all'' package
;;; includes all of these packages.

;;; A nice thing about this structure is, that you do not need to
;;; ``:use'' the whole ``webapp'' package, but instead ``:use'' only
;;; the packages you actually need.

(uiop:define-package :webapp/all
  (:use-reexport

   ;; the display and display-name generic functions
   :webapp/display-protocol

   ;; data access
   :webapp/data-access-protocol
   :webapp/data-access-object


   ;; a function based html generator
   :webapp/html


   :webapp/field-access-protocol
   ;; constructing uris
   :webapp/href

   ;; defines a bare bones web page
   :webapp/standard-page)
  (:nicknames :webapp))
