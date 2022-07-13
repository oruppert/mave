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
   :form
   ;; semantic elements
   :section
   :h1))

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

;;;; Semantic Elements

(defun section (&rest attributes/children)
  (make-element "section" attributes/children))

(defun h1 (&rest attributes/children)
  (make-element "h1" attributes/children))
