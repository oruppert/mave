(uiop:define-package :webapp/handle-protocol
  (:use :common-lisp)
  (:export :handle))

(in-package :webapp/handle-protocol)

;;; XXX: argument order: (handler object method)

(defgeneric handle (object handler method))
