(uiop:define-package :webapp/standard-page/page-protocol
    (:use :common-lisp)
  (:export :page-style
	   :page-script
	   :additional-head-elements))

(in-package :webapp/standard-page/page-protocol)

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
