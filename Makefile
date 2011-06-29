TEX=plan.tex

DVI=$(TEX:.tex=.dvi)
PS=$(TEX:.tex=.ps)
PDF=$(TEX:.tex=.pdf)
AUX=$(TEX:.tex=.aux)
LOG=$(TEX:.tex=.log)
SNM=$(TEX:.tex=.snm)
OUT=$(TEX:.tex=.out)
NAV=$(TEX:.tex=.nav)
TOC=$(TEX:.tex=.toc)
BBL=$(TEX:.tex=.bbl)
BLG=$(TEX:.tex=.blg)
LOF=$(TEX:.tex=.lof)
IDX=$(TEX:.tex=.idx)

all: images graphs diagrams $(PDF)

images:
	make -C $@

graphs:
	make -C $@

diagrams:
	make -C $@

%.dvi: %.tex
	latex $<

%.ps: %.dvi
	dvips $<

%.pdf: %.ps
	ps2pdf $<

sign: $(PDF)
	openssl req -x509 -nodes -days 365 -subj '/C=US/ST=Oregon/L=Portland/CN=www.madboa.com' -newkey rsa:1024 -keyout mycert.pem -out mycert.pem
	openssl pkcs12 -export -in mycert.pem -out mycert.pfx
	PortableSigner -n -s mycert.pfx -t $(PDF) -o $(PDF:.pdf=)-signed.pdf

clean:
	make clean -C images
	make clean -C graphs
	make clean -C diagrams
	rm -f $(DVI) $(PS) $(PDF) $(AUX) $(LOG) $(SNM) $(OUT) $(NAV) $(TOC) $(BBL) $(BLG) $(LOF) $(IDX) $(PDF:.pdf=)-signed.pdf *~ *.ps *.log

.PHONY: graphs diagrams images clean
