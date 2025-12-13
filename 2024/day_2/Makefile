%:
	@echo $@
	@time echo "Part 1: $$(sbcl --script solver.lisp $@-input.txt 0)"
	@time echo "Part 2: $$(sbcl --script solver.lisp $@-input.txt 1)"

all: example puzzle

.PHONY: all
