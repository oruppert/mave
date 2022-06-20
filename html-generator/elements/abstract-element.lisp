(uiop:define-package :webapp/html-generator/elements/abstract-element
    (:use :common-lisp)
  (:export :element-name
	   :element-attributes
	   :element-children
	   :abstract-element))

(in-package :webapp/html-generator/elements/abstract-element)

(defgeneric element-name (element)
  (:documentation "element -> string"))

(defgeneric element-attributes (element)
  (:documentation "element -> plist"))

(defgeneric element-children (element)
  (:documentation "element -> list"))

(defclass abstract-element ()
  ((name :initarg :name :reader element-name)
   (attributes :initarg :attributes :reader element-attributes)
   (children :initarg :children :reader element-children)))

(defmethod element-name :around ((self abstract-element))
  (string-downcase (call-next-method)))
