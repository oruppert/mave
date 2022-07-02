(uiop:define-package :webapp/standard-page/page-protocol
    (:use :common-lisp)
  (:export :page-external-scripts
	   :page-external-styles
	   :page-inline-style
	   :page-inline-script
	   :page-additional-head-elements))

(in-package :webapp/standard-page/page-protocol)

(defgeneric page-external-scripts (page)
  (:documentation "Retuns a list of script uris for the given page.")
  (:method-combination append :most-specific-last))

(defgeneric page-external-styles (page)
  (:documentation "Returns a list of stylesheet uris for the given page.")
  (:method-combination append :most-specific-last))

(defgeneric page-inline-style (page)
  (:documentation "Returns the styles of the given page as a list of strings.")
  (:method-combination append :most-specific-last))

(defgeneric page-inline-script (page)
  (:documentation "Returns the scripts of the given page as a list of strings.")
  (:method-combination append :most-specific-last))

(defgeneric page-additional-head-elements (page)
  (:documentation "Returns a list of additional html head elements.")
  (:method-combination append :most-specific-last))
