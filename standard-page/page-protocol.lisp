(uiop:define-package :webapp/standard-page/page-protocol
    (:use :common-lisp)
  (:export :page-script-uris
	   :page-style-uris
	   :page-style
	   :page-script
	   :additional-head-elements))

(in-package :webapp/standard-page/page-protocol)

(defgeneric page-script-uris (page)
  (:documentation "Retuns a list of script uris for the given page.")
  (:method-combination append :most-specific-last)
  (:method append (page) nil))

(defgeneric page-style-uris (page)
  (:documentation "Returns a list of stylesheet uris for the given page.")
  (:method-combination append :most-specific-last)
  (:method append (page) nil))

(defgeneric page-style (page)
  (:documentation "Returns the styles of the given page as a list of strings.")
  (:method-combination append :most-specific-last)
  (:method append (page) nil))

(defgeneric page-script (page)
  (:documentation "Returns the script of the given page as a list of strings.")
  (:method-combination append :most-specific-last)
  (:method append (page) nil))

(defgeneric additional-head-elements (page)
  (:documentation "Returns a list of additional html head elements.")
  (:method-combination append :most-specific-last)
  (:method append (page) nil))
