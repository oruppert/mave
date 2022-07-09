(uiop:define-package :webapp/pages/water-mixin/water-mixin
  (:use :common-lisp
	:webapp/pages/page-protocol)
  (:nicknames :webapp/pages/water-mixin)
  (:export :water-mixin
	   :water-dark-mixin
	   :water-light-mixin))

(in-package :webapp/pages/water-mixin/water-mixin)

(defparameter *water-css-uri* "/webapp/standard-page/water-mixin/water.css")
(defparameter *water-dark-css-uri* "/webapp/standard-page/water-mixin/dark.css")
(defparameter *water-light-css-uri* "/webapp/standard-page/water-mixin/light.css")

(defclass water-mixin () ())
(defclass water-dark-mixin () ())
(defclass water-light-mixin () ())

(defmethod page-external-styles append ((self water-mixin))
  (list *water-css-uri*))

(defmethod page-external-styles append ((self water-dark-mixin))
  (list *water-dark-css-uri*))

(defmethod page-external-styles append ((self water-light-mixin))
  (list *water-light-css-uri*))

(hunchentoot:define-easy-handler (water-css-handler :uri *water-css-uri*) ()
  (setf (hunchentoot:content-type*) "text/css")
  (setf (hunchentoot:header-out :cache-control) "max-age:3600")
  #.(uiop:read-file-string
     (merge-pathnames
      "water.css"
      (asdf/pathname:pathname-directory-pathname
       (or *compile-file-truename* *load-truename*)))))

(hunchentoot:define-easy-handler (water-dark-css-handler :uri *water-dark-css-uri*) ()
  (setf (hunchentoot:content-type*) "text/css")
  (setf (hunchentoot:header-out :cache-control) "max-age:3600")
  #.(uiop:read-file-string
     (merge-pathnames
      "dark.css"
      (asdf/pathname:pathname-directory-pathname
       (or *compile-file-truename* *load-truename*)))))

(hunchentoot:define-easy-handler (water-light-css-handler :uri *water-light-css-uri*) ()
  (setf (hunchentoot:content-type*) "text/css")
  (setf (hunchentoot:header-out :cache-control) "max-age:3600")
  #.(uiop:read-file-string
     (merge-pathnames
      "light.css"
      (asdf/pathname:pathname-directory-pathname
       (or *compile-file-truename* *load-truename*)))))





