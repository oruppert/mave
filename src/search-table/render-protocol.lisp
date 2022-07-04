(uiop:define-package :webapp/search-table/render-protocol
  (:use :common-lisp
	:webapp/html-generator/all)
  (:export))

(in-package :webapp/search-table/render-protocol)

(defgeneric render-table-head (alias)
  (:method (alias)
    (th (string-capitalize alias))))

(defgeneric render-table-data (alias value &key)
  (:method (alias value &key)
    (declare (ignore alias))
    (td value)))


