(defsystem "test"
	   :version "0.1.0"
	   :components ((:module "src"
				 :components
				 ((:file "main"))))
	   ;; :in-order-to ((test-op (test-op "tfcserver-test")))
	   ;; :defsystem-depends-on (:deploy)  ;; (ql:quickload "deploy") before
	   :build-operation "program-op" ;; leave as is
	   :build-pathname "test"
	   :entry-point "test::main")
