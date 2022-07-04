(defsystem "webapp"
  :class :package-inferred-system
  :pathname "src/"
  :depends-on ("hunchentoot"
               "postmodern"
	       "closer-mop"
	       "alexandria"
               "webapp/all"))
