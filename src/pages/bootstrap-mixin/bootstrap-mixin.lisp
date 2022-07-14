(uiop:define-package :mave/pages/bootstrap-mixin/bootstrap-mixin
  (:use :common-lisp
	:mave/pages/page-protocol)
  (:nicknames :mave/pages/bootstrap-mixin)
  (:export :bootstrap-mixin))

(in-package :mave/pages/bootstrap-mixin/bootstrap-mixin)

(defparameter *stylesheet-uri*
  "/mave/standard-page/bootstrap-mixin/bootstrap.min.css")

(defparameter *javascript-uri*
  "/mave/standard-page/bootstrap-mixin/bootstrap.bundle.min.js")

(hunchentoot:define-easy-handler (stylesheet-handler :uri *stylesheet-uri*) ()
  (setf (hunchentoot:content-type*) "text/css")
  (setf (hunchentoot:header-out :cache-control) "max-age:3600")
  #.(uiop:read-file-string
     (merge-pathnames
      "bootstrap.min.css"
      (asdf/pathname:pathname-directory-pathname
       (or *compile-file-truename* *load-truename*)))))

(hunchentoot:define-easy-handler (javascript-handler :uri *javascript-uri*) ()
  (setf (hunchentoot:content-type*) "application/javascript")
  (setf (hunchentoot:header-out :cache-control) "max-age:3600")
  #.(uiop:read-file-string
     (merge-pathnames
      "bootstrap.bundle.min.js"
      (asdf/pathname:pathname-directory-pathname
       (or *compile-file-truename* *load-truename*)))))

(defclass bootstrap-mixin () ())

(defmethod page-external-styles append ((self bootstrap-mixin))
  (list *stylesheet-uri*))

(defmethod page-external-scripts append ((self bootstrap-mixin))
  (list *javascript-uri*))


