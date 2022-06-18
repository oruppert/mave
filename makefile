all: readme.org

clean:
	rm -f readme.org *.fasl */*.fasl

readme.org: *.lisp webapp.asd
	sbcl --script weave.lisp < introduction.lisp > readme.org
	sbcl --script weave.lisp < all.lisp >> readme.org
	sbcl --script weave.lisp < render.lisp >> readme.org
	sbcl --script weave.lisp < database-object.lisp >> readme.org
