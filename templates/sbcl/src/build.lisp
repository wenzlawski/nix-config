(load (sb-ext:posix-getenv "ASDF"))
(asdf:load-asd (pathname (truename "test.asd")))
(asdf:load-system 'test)
(sb-ext:save-lisp-and-die 
 #p"test"
 :compression t
 :toplevel #'test::main
 :executable t)
