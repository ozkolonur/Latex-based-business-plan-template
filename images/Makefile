TARGET := eps
JPG := $(wildcard *.jpg)
GIF := $(wildcard *.gif)
PNG := $(wildcard *.png)
BMP := $(wildcard *.bmp)
SVG := $(wildcard *.svg)
EPS := $(JPG:.jpg=.eps) $(GIF:.gif=.eps) $(PNG:.png=.eps) $(BMP:.bmp=.eps) $(SVG:.svg=.eps)

all: $(EPS) Makefile
	cp *.eps $(TARGET)

%.eps: %.svg
	inkscape -f $< -E $(TARGET)/$@

%.eps: %.jpg
	convert $< $(TARGET)/$@

%.eps: %.gif
	convert $< $(TARGET)/$@

%.eps: %.png
	convert $< $(TARGET)/$@

%.eps: %.bmp
	convert $< $(TARGET)/$@

test:
	echo $(EPS)

clean:
	rm -f $(TARGET)/*.eps

.PHONY: clean
