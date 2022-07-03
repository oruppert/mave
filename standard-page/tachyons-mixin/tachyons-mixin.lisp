(uiop:define-package :webapp/standard-page/tachyons-mixin/tachyons-mixin
  (:use :common-lisp
	:webapp/standard-page/page-protocol)
  (:export :tachyons-mixin))

(in-package :webapp/standard-page/tachyons-mixin/tachyons-mixin)

(defparameter *uri*
  "/webapp/standard-page/tachyons-mixin/tachyons-mixin/tachyons.min.css")

(hunchentoot:define-easy-handler (style-handler :uri *uri*) ()
  (setf (hunchentoot:content-type*) "text/css")
  #.(uiop:read-file-string
     (merge-pathnames
      "tachyons.min.css"
      (asdf/pathname:pathname-directory-pathname
       (or *compile-file-truename* *load-truename*)))))

(defclass tachyons-mixin () ())

(defmethod page-external-styles append ((self tachyons-mixin))
  (list *uri*))


