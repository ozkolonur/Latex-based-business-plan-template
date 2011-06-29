PLT := $(wildcard *.plt)
EPS := $(PLT:.plt=.eps)

all: $(EPS) Makefile

%.eps: %.plt
	gnuplot $< > $@

clean:
	rm -f $(EPS)

.PHONY: clean
