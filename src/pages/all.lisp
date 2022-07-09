(uiop:define-package :webapp/pages/all
  (:nicknames :webapp/pages)
  (:use-reexport :webapp/pages/page-protocol
		 :webapp/pages/standard-page
		 ;; mixins
		 :webapp/pages/tachyons-mixin/tachyons-mixin
		 :webapp/pages/bootstrap-mixin/bootstrap-mixin
		 :webapp/pages/bulma-mixin/bulma-mixin
		 :webapp/pages/water-mixin/water-mixin))

