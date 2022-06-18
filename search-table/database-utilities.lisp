(uiop:define-package :webapp/search-table/database-utilities
  (:use :common-lisp)
  (:export :identifier-name))

(in-package :webapp/search-table/database-utilities)

(defun identifier-name (identifier)
  (etypecase identifier
    (string identifier)
    (symbol (postmodern:sql-escape identifier))))

