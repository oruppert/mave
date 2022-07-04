;;;; Standard Form

(uiop:define-package :webapp/standard-form/standard-form
  (:use :common-lisp
	:webapp/database/all
	:webapp/display-protocol
	:webapp/handle-protocol
	:webapp/html-generator/all
	:webapp/standard-form/input-protocol)
  (:export :standard-form-slots
	   :standard-form))

(in-package :webapp/standard-form/standard-form)

(defgeneric standard-form-slots (object))

(defgeneric standard-form-submit-value (object))

(defgeneric standard-form-delete-value (object))

(defclass standard-form ()
  ((allow-delete :initarg :allow-delete :initform nil)))

(defmethod standard-form-slots (object)
  (mapcar #'closer-mop:slot-definition-name
	  (closer-mop:class-direct-slots
	   (class-of object))))

(defmethod standard-form-submit-value (object)
  nil)

(defmethod standard-form-delete-value (object)
  "Delete")

(defmethod handle (object (self standard-form) (method (eql :delete)))
  (with-slots (allow-delete) self
    (assert allow-delete)
    (database-delete object)))

(defmethod handle (object (self standard-form) (method (eql :post)))
  (dolist (slot-name (standard-form-slots object))
    (setf (input-value object slot-name)
	  (hunchentoot:post-parameter
	   (string-downcase slot-name))))
  (database-upsert object))

(defmethod display (object (self standard-form))
  (with-slots (allow-delete) self
    (let ((submit (standard-form-submit-value object))
	  (delete (standard-form-delete-value object)))
      (form :method :post
	    (input :type :submit :hidden t)
	    (loop for slot-name in (standard-form-slots object)
		  collect (p (label (input-label object slot-name)
				    (render-input object slot-name))))
	    (p
	     (when allow-delete
	       (button :name :method :value :delete delete))
	     (input :type :submit :value submit))))))
