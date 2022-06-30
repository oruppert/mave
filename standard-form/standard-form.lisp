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

(defgeneric standard-form-submit-value (object form))

(defgeneric standard-form-delete-value (object form))

(defclass standard-form ()
  ((allow-delete :initarg :allow-delete :initform nil)))

(defmethod standard-form-slots (object)
  (mapcar #'closer-mop:slot-definition-name
	  (closer-mop:class-direct-slots
	   (class-of object))))

(defmethod standard-form-submit-value (object (self standard-form))
  nil)

(defmethod standard-form-delete-value (object (self standard-form))
  "Delete")

(defmethod handle (object (self standard-form) (method (eql :delete)))
  (with-slots (allow-delete) self
    (assert allow-delete)
    (database-delete object)
    (delete-redirect)))

(defmethod handle (object (self standard-form) (method (eql :post)))
  (dolist (slot-name (standard-form-slots object))
    (setf (input-value object slot-name)
	  (hunchentoot:post-parameter
	   (string-downcase slot-name))))
  (database-upsert object)
  (submit-redirect))

(defmethod display (object (self standard-form))
  (with-slots (allow-delete) self
    (let ((submit (standard-form-submit-value object self))
	  (delete (standard-form-delete-value object self)))
      (form :method :post
	    (input :type :submit :hidden t)
	    (loop for slot-name in (standard-form-slots object)
		  collect (p (label (input-label object slot-name)
				    (render-input object slot-name))))
	    (p
	     (when allow-delete
	       (button :name :method :value :delete delete))
	     (input :type :submit :value submit))))))

(defun do-redirect (location)
  (when (hunchentoot:within-request-p)
    (let ((here (hunchentoot:request-uri*)))
      (hunchentoot:redirect (or location here)))))

(hunchentoot:define-easy-handler submit-redirect (submit-location location back)
  (do-redirect (or submit-location location back)))

(hunchentoot:define-easy-handler delete-redirect (delete-location location back)
  (do-redirect (or delete-location location back)))






