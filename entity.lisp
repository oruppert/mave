;;;; package

(uiop:define-package :webapp/entity
  (:use :common-lisp
	:webapp/generics
	:webapp/html)
  (:export
   #:entity
   #:list-entities))

(in-package :webapp/entity)

;;;; entity

(defclass entity ()
  ((id :initarg :id :initform nil :accessor entity-id)))

(defmethod print-object ((self entity) stream)
  (print-unreadable-object (self stream :type t)
    (princ (entity-id self))))

(defmethod slot-unbound (class (self entity) slot-name)
  (assert (entity-id self))
  (setf (slot-value self slot-name)
	(caar (postmodern:query
	       (format nil "select ~a from ~a where id = ~a"
		       (postmodern:sql-escape slot-name)
		       (postmodern:sql-escape (class-name class))
		       (postmodern:sql-escape (entity-id self)))))))

(defun list-entities (class control-string &rest format-arguments)
  (loop with sql = (apply #'format nil control-string format-arguments)
	for initargs in (postmodern:query sql :plists)
	collect (apply #'make-instance class initargs)))

(defun bound-attributes (object)
  (loop with class = (class-of object)
	for slot in (sb-mop:class-slots class)
	for slot-name = (sb-mop:slot-definition-name slot)
	when (slot-boundp object slot-name) collect slot-name into slots
	and collect (slot-value object slot-name) into values
	finally (return (values slots values))))

(defmethod entity-insert ((self entity))
  (assert (null (entity-id self)))
  (multiple-value-bind (attributes values)
      (bound-attributes self)
    (assert attributes)
    (setf (entity-id self)
	  (caar (postmodern:query
		 (format nil "insert into ~a(~{~a~^, ~}) values(~{~a~^, ~}) returning id"
			 (postmodern:sql-escape (class-name (class-of self)))
			 (mapcar #'postmodern:sql-escape attributes)
			 (mapcar #'postmodern:sql-escape values))))))
  self)

(defmethod entity-update ((self entity))
  (assert (entity-id self))
  (multiple-value-bind (attributes values)
      (bound-attributes self)
    (when attributes
      (postmodern:query
       (format nil "update ~a set ~{~a = ~a~^, ~} where id = ~a"
	       (postmodern:sql-escape (class-name (class-of self)))
	       (mapcar #'postmodern:sql-escape (mapcan #'list attributes values))
	       (postmodern:sql-escape (entity-id self))))))
  self)

(defmethod entity-delete ((self entity))
  (assert (entity-id self))
  (postmodern:query (format nil "delete from ~a where id = ~a"
			    (postmodern:sql-escape (class-name (class-of self)))
			    (postmodern:sql-escape (entity-id self))))
  (setf (entity-id self) nil)
  self)

;;;; parameter

(defmethod parameter-name ((self entity))
  (class-name (class-of self)))

(defmethod parameter-value ((self entity))
  (assert (entity-id self))
  (entity-id self))

;;;; form

(defmethod field-value :around ((self entity) slot-name)
  (when (or (entity-id self)
	    (slot-boundp self slot-name))
    (call-next-method)))
