(defsystem "webapp"
  :class package-inferred-system
  :depends-on ("hunchentoot"
	       "cl-ppcre"
	       "webapp/all"))
