;;;; Package Structure

;;; We are using the ``modern'' lisp package style.  That means every
;;; file declares its own package and the ``webapp/all'' package
;;; includes all of these packages.

;;; A nice thing about this structure is, that you do not need to
;;; ``:use'' the whole ``webapp'' package, but instead ``:use'' only
;;; the packages you actually need.

(uiop:define-package :webapp/all
  (:use-reexport

   :webapp/display-protocol
   :webapp/handle-protocol

   :webapp/database/all
   :webapp/html-generator/all
   :webapp/pages/all


)
  (:nicknames :webapp))
