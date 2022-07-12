(defsystem "webapp"
  :class :package-inferred-system
  :pathname "src/"
  :depends-on ("hunchentoot"
               "postmodern"
	       "closer-mop"
               "webapp/all"))
