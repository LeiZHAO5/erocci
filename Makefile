#!/usr/bin/env make -f

LESS = assets/themes/the-minimum/css/style.less

CSS = $(patsubst %.less,%.css,$(LESS))

all: $(CSS)

%.css: %.less
	lessc $< > $@
