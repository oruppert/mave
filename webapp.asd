(defsystem "webapp"
  :class :package-inferred-system
  :depends-on ("hunchentoot"
               "postmodern"
	       "closer-mop"
               "webapp/all"))
