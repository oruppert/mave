(uiop:define-package :webapp/form
  (:use :common-lisp
	:hunchentoot
	:webapp/html)
  (:import-from :webapp/database :insert)
  (:import-from :webapp/render :render)
  (:import-from :webapp/model :model-value)
  (:export

   ;; field
   #:field
   #:field-name
   #:field-label
   ;; conversion
   #:param->field
   #:model->field
   #:field->model

   #:field-invalid
   #:field-update-model-p

   ;; form
   #:form
   #:form-fields
   #:form-submit
   ;; input
   #:input
   #:input-type
   #:input-validator
   ;; checkbox
   #:checkbox
   ;; select
   #:select
   #:select-options))

(in-package :webapp/form)

(defclass field ()
  ((name :initarg :name :reader field-name)
   (label :initarg :label :initform nil :reader field-label)))

(defmethod param->field ((self field) value) value)
(defmethod model->field ((self field) value) value)
(defmethod field->model ((self field) value) value)

(defmethod field-invalid ((self field) value) nil)

(defmethod field-update-model-p ((self field) value) t)

(defmethod render ((self field) value)
  (p
   (label
    (or (field-label self)
	(string-capitalize
	 (field-name self)))
    (when (eq :post (request-method*))
      (let ((error-message (field-invalid self value)))
	(when error-message
	  (span error-message))))
    (call-next-method))))

;;;; form

(defclass form ()
  ((table :initarg :table :reader form-table)
   (submit :initarg :submit :initform nil)))

(defmethod form-submit ((self form) model)
  (with-slots (submit) self
    submit))

(defmethod form-fields ((self form) model) nil)

(defmethod render ((self form) model)
  (let* ((fields (form-fields self model))
	 (values
	   (if (eq :post (request-method*))
	       (loop for field in fields
		     for value = (post-parameter
				  (string-downcase
				   (field-name field)))
		     collect (param->field field value))
	       (loop for field in fields
		     collect
		     (when model
		       (model->field field
				     (model-value model
						  (field-name field))))))))
    (when (and (eq :post (request-method*))
	       (loop for field in fields
		     for value in values
		     never (field-invalid field value)))
      (if (null model)
	  (apply #'insert
		 (form-table self)
		 (loop for field in fields
		       for value in values
		       collect (field-name field)
		       collect (field->model field value)))
	  (loop for field in fields
		for value in values
		when (field-update-model-p field value)
		  do (setf (model-value model (field-name field))
			   (field->model field value))))
      (redirect (or (parameter "back")
		    (referer)
		    "/")))
    (form :method :post
	  (loop for field in fields
		for value in values
		collect (render field value))
	  (p (input :type :submit
		    :value (form-submit self model))))))

;;;; input

(defclass input (field)
  ((type :initarg :type :reader input-type :initform nil)
   (validator :initarg :validator :reader input-validator :initform nil)))

(defmethod render ((self input) value)
  (input :name (field-name self)
	 :type (input-type self)
	 :value value))

(defmethod field-invalid ((self input) value)
  (when (input-validator self)
    (when (stringp value)
      (when (eq :post (request-method*))
	(funcall (input-validator self)
		 value)))))

;;;; checkbox

(defclass checkbox (field) ())

(defmethod param->field ((self checkbox) value)
  (if value t nil))

(defmethod field->model ((self checkbox) value)
  (if value :true :false))

(defmethod render ((self checkbox) value)
  (input :name (field-name self)
	 :type :checkbox
	 :checked value))

;;;; select

(defclass select (field)
  ((options :initarg :options :reader select-options)))

(defmethod render ((self select) value)
  (select :name (field-name self)
	  (loop for (name option-value) in (select-options self)
		for a = (princ-to-string option-value)
		for b = (princ-to-string value)
		for selected = (string= a b)
		collect (option name :value option-value
				     :selected selected))))







