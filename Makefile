CONVERT		= convert
COOPTS		= -units PixelsPerInch -density $(DPI)
SVGCOOPTS	= -transparent white
CROPOPTS	= -gravity Center -crop 50%x50%+0+0
WOBOPTS		= -negate -threshold 0
BOWOPTS		= $(WOBOPTS) -negate
DPI		= 300

OUTDIR		= out
PNGDIR		= $(OUTDIR)/png
JPGDIR		= $(OUTDIR)/jpeg
OUTDIRS		= $(PNGDIR) $(JPGDIR)

INFILES		= $(wildcard *.svg)
PNGFILES_COLOUR	= $(addprefix $(PNGDIR)/, \
		  	$(INFILES:%.svg=%.orig.png) \
			$(INFILES:%.svg=%.crop.png))

PNGFILES	= $(PNGFILES_COLOUR) \
		  $(PNGFILES_COLOUR:%.png=%.bow.png) \
		  $(PNGFILES_COLOUR:%.png=%.wob.png)

JPGFILES	= $(subst $(PNGDIR),$(JPGDIR),$(PNGFILES:%.png=%.jpg))

.PHONY: all clean outdirs

all: outdirs $(PNGFILES) $(JPGFILES)
	@echo PNG: $(PNGFILES)
	@echo JPG: $(JPGFILES)

$(PNGDIR)/%.orig.png: %.svg
	$(CONVERT) $(COOPTS) $(SVGCOOPTS) $< $@

$(PNGDIR)/%.crop.png: %.svg
	$(CONVERT) $(COOPTS) $(SVGCOOPTS) $< $(CROPOPTS) $@

$(PNGDIR)/%.wob.png: $(PNGDIR)/%.png
	$(CONVERT) $(COOPTS) $< $(WOBOPTS) $@

$(PNGDIR)/%.bow.png: $(PNGDIR)/%.png
	$(CONVERT) $(COOPTS) $< $(BOWOPTS) $@

$(JPGDIR)/%.jpg: $(PNGDIR)/%.png
	$(CONVERT) $(COOPTS) $< $@

outdirs:
	mkdir -p $(OUTDIRS)

clean:
	rm -rf $(PNGDIR) $(JPGDIR)
