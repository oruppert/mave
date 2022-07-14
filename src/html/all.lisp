(uiop:define-package :mave/html/all
  (:nicknames :mave/html)
  (:use-reexport :mave/html/print-html
		 :mave/html/constructors
		 :mave/html/functions
		 #+nil
		 :mave/html/href))
