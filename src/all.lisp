;;;; Package Structure

;;; We are using the ``modern'' lisp package style.  That means every
;;; file declares its own package and the ``mave/all'' package
;;; includes all of these packages.

;;; A nice thing about this structure is, that you do not need to
;;; ``:use'' the whole ``mave'' package, but instead ``:use'' only
;;; the packages you actually need.

(uiop:define-package :mave/all
  (:use-reexport

   :mave/display-protocol
   :mave/handle-protocol

   :mave/database/all
   :mave/html/all

   :mave/pages/all
   :mave/forms/all


)
  (:nicknames :mave))
