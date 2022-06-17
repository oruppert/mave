(uiop:define-package :webapp/search-table/search-parameters
    (:use :common-lisp)
  (:export :search-parameters
	   :search-columns
	   :search-offset
	   :search-limit))

(in-package :webapp/search-table/search-parameters)

(defclass search-parameters ()
  ((columns :initarg :columns :reader search-columns)
   (offset :initarg :offset :reader search-offset)
   (limit :initarg :limit :reader search-limit)))

(hunchentoot:define-easy-handler search-parameters
    ((columns :parameter-type '(keyword) :real-name "column")
     (offset :parameter-type 'integer :init-form 0)
     (limit :parameter-type 'integer :init-form 50))
  (make-instance 'search-parameters
		 :columns columns
		 :offset offset
		 :limit limit))
