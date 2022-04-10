all: autofill.min.js

clean:
	rm -f autofill.min.js

autofill.min.js: autofill.js
	closure-compiler --formatting SINGLE_QUOTES --compilation_level ADVANCED_OPTIMIZATIONS --js $< --js_output_file $@
