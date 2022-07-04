(uiop:define-package :webapp/standard-page/all
  (:nicknames :webapp/standard-page)
  (:use-reexport :webapp/standard-page/page-protocol
		 :webapp/standard-page/standard-page
		 ;; mixins
		 :webapp/standard-page/tachyons-mixin/tachyons-mixin
		 :webapp/standard-page/bootstrap-mixin/bootstrap-mixin
		 :webapp/standard-page/bulma-mixin/bulma-mixin
		 :webapp/standard-page/water-mixin/water-mixin))

