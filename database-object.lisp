;;;; Database Object

;;; This package defines generic functions for CRUD operations and a
;;; simple database-object which is able to map every table that has a
;;; single primary key called id.  If you do not like it, nothing is
;;; lost: simply use postmoderns dao.

(uiop:define-package :webapp/database-object
  (:use :common-lisp
	:webapp/utilities
	:webapp/data-access-protocol)
  (:export :database-object
	   :object-id))

(in-package :webapp/database-object)

(defclass database-object ()
  ((id :initarg :id :initform nil :accessor object-id)))

(defmethod slot-unbound (class (self database-object) slot-name)
  (assert (object-id self))
  (setf (slot-value self slot-name)
	(caar (postmodern:query
	       (format nil "select ~a from ~a where id = ~a"
		       (postmodern:sql-escape slot-name)
		       (postmodern:sql-escape (class-name class))
		       (postmodern:sql-escape (object-id self)))))))

(defmethod database-insert ((self database-object))
  (assert (null (object-id self)))
  (setf (object-id self)
	(caar
	 (postmodern:query
	  (format nil "insert into ~a(~{~a~^, ~}) values(~{~a~^, ~}) returning id"
		  (postmodern:sql-escape (class-name (class-of self)))
		  (mapcar #'postmodern:sql-escape (bound-slots self))
		  (mapcar #'postmodern:sql-escape (bound-values self))))))
  self)

(defmethod database-update ((self database-object))
  (assert (object-id self))
  (postmodern:query
   (format nil "update ~a set ~{~a = ~a~^, ~} where id = ~a"
	   (postmodern:sql-escape (class-name (class-of self)))
	   (mapcan #'list
		   (mapcar #'postmodern:sql-escape (bound-slots self))
		   (mapcar #'postmodern:sql-escape (bound-values self)))
	   (postmodern:sql-escape (object-id self))))
  self)

(defmethod database-delete ((self database-object))
  (assert (object-id self))
  (postmodern:query
   (format nil "delete from ~a where id = ~a"
	   (postmodern:sql-escape (class-name (class-of self)))
	   (postmodern:sql-escape (object-id self))))
  (setf (object-id self) nil)
  self)


