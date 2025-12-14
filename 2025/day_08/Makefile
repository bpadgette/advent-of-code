SHELL := /bin/bash

%:
	@echo $@
	@time sbcl --script solver.lisp $@-input.txt

all: example puzzle

.PHONY: all
