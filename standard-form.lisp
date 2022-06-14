;;;; Standard Form

(uiop:define-package :webapp/standard-form
  (:use :common-lisp
	:webapp/input-protocol
	:webapp/database-protocol
	:webapp/display-protocol
	:webapp/html)
  (:export :standard-form))

(in-package :webapp/standard-form)

;;;; Generic Functions

(defgeneric handle-form (object form method))

;;;; Default Implementation

(defclass standard-form ()
  ((allow-delete :initarg :allow-delete :initform nil)
   (delete-button-value :initarg :delete-button-value :initform nil)
   (submit-button-value :initarg :submit-button-value :initform nil)))

(defmethod handle-form (object (self standard-form) (method (eql :get)))
  (display object self))

(defmethod handle-form (object (self standard-form) (method (eql :delete)))
  (with-slots (allow-delete) self
    (assert allow-delete)
    (database-delete object)
    (redirect)))

(defmethod handle-form (object (self standard-form) (method (eql :post)))
  (dolist (slot-name (input-slots object self))
    (setf (input-value object slot-name)
	  (hunchentoot:post-parameter
	   (string-downcase slot-name))))
  (database-upsert object)
  (redirect))

(defmethod display (object (self standard-form))
  (with-slots (allow-delete
	       delete-button-value
	       submit-button-value)
      self
    (form :method :post
	  (input :type :submit :hidden t)
	  (loop for slot-name in (input-slots object self)
		collect (p (label (input-label object slot-name)
				  (render-input object slot-name))))
	  (p
	   (when allow-delete
	     (button :name :method :value :delete delete-button-value))
	   (input :type :submit :value submit-button-value)))))

(hunchentoot:define-easy-handler redirect (back location)
  (when (hunchentoot:within-request-p)
    (let ((here (hunchentoot:request-uri*)))
      (hunchentoot:redirect
       (or back location here)))))





