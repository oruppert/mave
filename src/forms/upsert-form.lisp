(uiop:define-package :mave/forms/upsert-form
  (:use :common-lisp
	:mave/handle-protocol
	:mave/display-protocol
	:mave/database/all
	:mave/html-generator/all
	:mave/standard-page/page-protocol
	:mave/forms/redirect-mixin)
  (:export :input-label
	   :input-value
	   :render-input
	   :upsert-controller
	   :upsert-view
	   :upsert-form))

(in-package :mave/forms/upsert-form)

;;;; Input Protocol

(defgeneric input-label (object slot-name)
  (:documentation
   "Returns the input label for the given object and slot-name.")
  (:method (object slot-name)
    (string-capitalize slot-name)))

(defgeneric input-value (object slot-name)
  (:documentation
   "Returns the input value for the given object and slot-name.")
  (:method (object slot-name)
    (slot-value object slot-name)))

;;; XXX: split into insert and update-form?
#+nil
(defgeneric input-initial-value (object slot-name)
  (:method (object slot-name)
    (values nil)))

(defgeneric (setf input-value) (value object slot-name)
  (:documentation
   "Sets the input value of the given object and slot-name.")
  (:method (value object slot-name)
    (setf (slot-value object slot-name) value)))

(defgeneric render-input (object slot-name)
  (:documentation
   "Renders the input element of the given object and slot-name.")
  (:method (object slot-name)
    (let ((value (input-value object slot-name)))
      (input :name slot-name :value value))))

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






