(uiop:define-package :webapp/pages/bulma-mixin/bulma-mixin
  (:use :common-lisp
	:webapp/pages/page-protocol)
  (:nicknames :webapp/pages/bulma-mixin)
  (:export :bulma-mixin))

(in-package :webapp/pages/bulma-mixin/bulma-mixin)

(defparameter *uri*
  "/webapp/standard-page/bulma-mixin/bulma.min.css")

(hunchentoot:define-easy-handler (style-handler :uri *uri*) ()
  (setf (hunchentoot:content-type*) "text/css")
  (setf (hunchentoot:header-out :cache-control) "max-age:3600")
  #.(uiop:read-file-string
     (merge-pathnames
      "bulma.min.css"
      (asdf/pathname:pathname-directory-pathname
       (or *compile-file-truename* *load-truename*)))))

(defclass bulma-mixin () ())

(defmethod page-external-styles append ((self bulma-mixin))
  (list *uri*))

