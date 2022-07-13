(uiop:define-package :webapp/pages/page-protocol
    (:use :common-lisp)
  (:export :page-external-scripts
	   :page-external-styles
	   :page-inline-styles
	   :page-inline-scripts))

(in-package :webapp/pages/page-protocol)

(defgeneric page-external-scripts (page)
  (:documentation "Returns a list of script uris for the given page.")
  (:method-combination append :most-specific-last))

(defgeneric page-external-styles (page)
  (:documentation "Returns a list of stylesheet uris for the given page.")
  (:method-combination append :most-specific-last))

(defgeneric page-inline-styles (page)
  (:documentation "Returns the styles of the given page as a list of strings.")
  (:method-combination append :most-specific-last))

(defgeneric page-inline-scripts (page)
  (:documentation "Returns the scripts of the given page as a list of strings.")
  (:method-combination append :most-specific-last))
