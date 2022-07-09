(uiop:define-package :webapp/forms/confirmation-form
  (:use :common-lisp
	:webapp/handle-protocol
	:webapp/html-generator/all
	:webapp/standard-page/page-protocol
	:webapp/forms/redirect-mixin)
  (:export :confirmed-p
	   :confirmation-controller
	   :confirmation-view
	   :confirmation-form))

(in-package :webapp/forms/confirmation-form)

(defgeneric confirmed-p (object))

(defclass confirmation-controller (redirect-mixin)
  ((yes-location :initarg :yes-location :reader yes-location)
   (no-location :initarg :no-location :reader no-location)))

(defmethod redirect-location ((self confirmation-controller))
  (if (confirmed-p self)
      (yes-location self)
      (no-location self)))

(defclass confirmation-view () ())

(defmethod confirmed-p ((self confirmation-view))
  (equal "yes" (hunchentoot:parameter "answer")))

(defmethod display (object (self confirmation-view))
  (form :method :post
	:class :confirmation
	(p :class :message)
	(p (button :class :yes :name "answer" :value "yes")
	   (button :class :no :name "answer" :value "no"))))

(defmethod page-inline-style append ((self confirmation-view))
  (list #.(uiop:read-file-string
	   (make-pathname :type "css"
			  :defaults *compile-file-truename*))))

(defclass confirmation-form (confirmation-controller
			     confirmation-view)
  ())



