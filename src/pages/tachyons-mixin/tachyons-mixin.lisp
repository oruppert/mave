(uiop:define-package :mave/pages/tachyons-mixin/tachyons-mixin
  (:use :common-lisp
	:mave/pages/page-protocol)
  (:nicknames :mave/pages/tachyons-mixin)
  (:export :tachyons-mixin))

(in-package :mave/pages/tachyons-mixin/tachyons-mixin)

(defparameter *uri*
  "/mave/standard-page/tachyons-mixin/tachyons-mixin/tachyons.min.css")

(hunchentoot:define-easy-handler (style-handler :uri *uri*) ()
  (setf (hunchentoot:content-type*) "text/css")
  (setf (hunchentoot:header-out :cache-control) "max-age:3600")
  #.(uiop:read-file-string
     (merge-pathnames
      "tachyons.min.css"
      (asdf/pathname:pathname-directory-pathname
       (or *compile-file-truename* *load-truename*)))))

(defclass tachyons-mixin () ())

(defmethod page-external-styles append ((self tachyons-mixin))
  (list *uri*))


