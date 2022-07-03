(uiop:define-package :webapp/standard-page/bootstrap-mixin/bootstrap-mixin
  (:use :common-lisp
	:webapp/standard-page/page-protocol)
  (:nicknames :webapp/standard-page/bootstrap-mixin)
  (:export :bootstrap-mixin))

(in-package :webapp/standard-page/bootstrap-mixin/bootstrap-mixin)

(defparameter *stylesheet-uri*
  "/webapp/standard-page/bootstrap-mixin/bootstrap.min.css")

(defparameter *javascript-uri*
  "/webapp/standard-page/bootstrap-mixin/bootstrap.bundle.min.js")

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


