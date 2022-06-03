;;;; Package Structure (the webapp/all package)

;;; We are using the ``modern'' lisp package style.  That means every
;;; file declares its own package and the ``all'' includes all these
;;; packages.

;;; A nice thing about this structure is, that you do not need to
;;; include the whole ``webapp'' package, but instead reference only
;;; the packages you actually need.

(uiop:define-package :webapp/all
  (:use-reexport :webapp/generics
		 :webapp/html
		 :webapp/href
		 :webapp/field
		 :webapp/render
		 :webapp/database-object
		 :webapp/standard-page
		 :webapp/standard-form)
  (:nicknames :webapp))
