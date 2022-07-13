(uiop:define-package :webapp/html/functions
  (:use :common-lisp
	:webapp/html/constructors)
  (:export
   ;; structure elements
   :html :head :body :title
   ;; head elements
   :title :meta :link
   ;; string elements
   :style-element :script-element
   ;; table elements
   :table :tr :th :td
   ;; grouping elements
   :div :span
   ;; form elements
   :form :button :input :select :option :label
   ;; semantic elements
   :section :h1
   ;; other elements
   :a :p))

(in-package :webapp/html/functions)

;;;; Structure Elements

(defun html (&rest attributes/children)
  (make-element "html" attributes/children))

(defun head (&rest attributes/children)
  (make-element "head" attributes/children))

(defun body (&rest attributes/children)
  (make-element "head" attributes/children))

;;;; Head Elements

(defun title (&rest attributes/children)
  (make-element "title" attributes/children))

(defun meta (&rest attributes)
  (make-void-element "meta" attributes))

(defun link (&rest attributes)
  (make-void-element "link" attributes))

;;;; String Elements

(defun style-element (&rest attributes/children)
  (make-string-element "style" attributes/children))

(defun script-element (&rest attributes/children)
  (make-string-element "script" attributes/children))

;;;; Table Elements

(defun table (&rest attributes/children)
  (make-element "table" attributes/children))

(defun tr (&rest attributes/children)
  (make-element "tr" attributes/children))

(defun th (&rest attributes/children)
  (make-element "th" attributes/children))

(defun td (&rest attributes/children)
  (make-element "td" attributes/children))

;;;; Grouping Elements

(defun div (&rest attributes/children)
  (make-element "div" attributes/children))

(defun span (&rest attributes/children)
  (make-element "span" attributes/children))

;;;; Form Elements

(defun form (&rest attribtues/children)
  (make-element "form" attribtues/children))

(defun button (&rest attributes/children)
  (make-element "button" attributes/children))

(defun input (&rest attributes)
  (make-void-element "input" attributes))

(defun select (&rest attributes/children)
  (make-element "select" attributes/children))

(defun option (&rest attributes/children)
  (make-element "option" attributes/children))

(defun label (&rest attributes/children)
  (make-element "label" attributes/children))

;;;; Semantic Elements

(defun section (&rest attributes/children)
  (make-element "section" attributes/children))

(defun h1 (&rest attributes/children)
  (make-element "h1" attributes/children))

;;;; Other Elements

(defun a (&rest attributes/children)
  (make-element "a" attributes/children))

(defun p (&rest attributes/children)
  (make-element "p" attributes/children))
