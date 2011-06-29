#!/bin/sh

#HACK aux is not created on first run
#this is currently unresolved issue of
#texlive  June,2011
make
rm plan.out.ps
rm plan.pdf
make
