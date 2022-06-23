(uiop:define-package :webapp/handle-protocol
  (:use :common-lisp
	:webapp/display-protocol)
  (:export :handle))

(in-package :webapp/handle-protocol)

(defgeneric handle (object view method))

(defmethod handle (object view (method (eql :get)))
  (display object view))
