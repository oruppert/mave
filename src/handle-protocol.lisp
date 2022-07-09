(uiop:define-package :webapp/handle-protocol
  (:use :common-lisp)
  (:export :handle))

(in-package :webapp/handle-protocol)

(defgeneric handle (object handler method))
