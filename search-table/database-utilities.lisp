(uiop:define-package :webapp/search-table/database-utilities
  (:use :common-lisp)
  (:export :identifier-name
	   :database-columns))

(in-package :webapp/search-table/database-utilities)

(defun identifier-name (identifier)
  (etypecase identifier
    (string identifier)
    (symbol (postmodern:sql-escape identifier))))

(defun database-columns (table &optional (schema "public"))
  (check-type table string)
  (check-type schema string)
  (postmodern:query "
	select
		column_name
	from
		information_schema.columns

	where
		table_name = $1 and
		table_schema = $2

	order by
		ordinal_position"
		    :column
		    table
		    schema))
