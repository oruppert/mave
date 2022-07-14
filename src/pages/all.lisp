(uiop:define-package :mave/pages/all
  (:nicknames :mave/pages)
  (:use-reexport :mave/pages/page-protocol
		 :mave/pages/standard-page
		 ;; mixins
		 :mave/pages/tachyons-mixin/tachyons-mixin
		 :mave/pages/bootstrap-mixin/bootstrap-mixin
		 :mave/pages/bulma-mixin/bulma-mixin
		 :mave/pages/water-mixin/water-mixin))

