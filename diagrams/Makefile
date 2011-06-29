DIA := $(wildcard *.dia)
EPS := $(DIA:.dia=.eps)

all: $(EPS) Makefile

%.eps: %.dia
	dia --verbose $< -e $@ -t eps

clean:
	rm -f $(EPS)

.PHONY: clean
