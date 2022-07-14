(defsystem "mave"
  :class :package-inferred-system
  :pathname "src/"
  :depends-on ("hunchentoot"
               "postmodern"
	       "closer-mop"
               "mave/all"))
