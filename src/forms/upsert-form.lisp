(uiop:define-package :mave/forms/upsert-form
  (:use :common-lisp
	:mave/handle-protocol
	:mave/display-protocol
	:mave/database/all
	:mave/html-generator/all
	:mave/standard-page/page-protocol
	:mave/forms/redirect-mixin
	:mave/forms/input-protocol)
  (:export :input-label
	   :input-value
	   :render-input
	   :upsert-controller
	   :upsert-view
	   :upsert-form))

(in-package :mave/forms/upsert-form)

;;;; Upsert Controller

(defclass upsert-controller (redirect-mixin)
  ((location :initarg :location :reader redirect-location)))

(defmethod handle (object (self upsert-controller) (method (eql :post)))
  (loop with class = (class-of object)
	for slot in (closer-mop:class-direct-slots class)
	for slot-name = (closer-mop:slot-definition-name slot)
	for parameter-name = (string-downcase slot-name)
	do (setf (input-value object slot-name)
		 (hunchentoot:post-parameter parameter-name)))
  (database-upsert object))

;;;; Upsert View

(defclass upsert-view () ())

(defmethod display (object (view upsert-view))
  (form :method :post
	:class :upsert
	(p (loop with class = (class-of object)
		 for slot in (closer-mop:class-direct-slots class)
		 for slot-name = (closer-mop:slot-definition-name slot)
		 collect (p (label (input-label object slot-name)
				   (render-input object slot-name)))))
	(p (button :class :submit))))

(defmethod page-inline-styles append ((self upsert-view))
  (list #.(uiop:read-file-string
	   (make-pathname :type "css"
			  :defaults *compile-file-truename*))))

;;;; Upsert Form

(defclass upsert-form (upsert-controller
		       upsert-view)
  ())






