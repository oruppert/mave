(uiop:define-package :mave/handle-protocol
  (:use :common-lisp)
  (:export :handle))

(in-package :mave/handle-protocol)

(defgeneric handle (handler object method))
