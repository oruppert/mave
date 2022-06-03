all: readme.org

clean:
	rm -f readme.org *.fasl

readme.org: *.lisp webapp.asd
	sbcl --script weave.lisp < introduction.lisp > readme.org
