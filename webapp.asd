(defsystem "webapp"
  :class :package-inferred-system
  :pathname "src/"
  :depends-on ("hunchentoot"
               "postmodern"
	       "closer-mop"
	       ;; XXX: remove alexandria: use ower own flatten which
	       ;; does not remove nulls.
	       "alexandria"
               "webapp/all"))
