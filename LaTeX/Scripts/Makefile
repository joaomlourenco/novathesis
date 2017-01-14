TDIR = ThesisDIFCTNOVA-$(shell date +%F)
ZFILE = $(TDIR).zip



dist:
	@mkdir $(TDIR)
	@mkdir $(TDIR)/Chapters
	@mkdir $(TDIR)/Chapters/Figures
	@mkdir $(TDIR)/Logo
	@mkdir $(TDIR)/Scripts
	@cat Scripts/FILES.txt | while read i; do cp "$$i" $(TDIR)/`dirname $$i`; done
	zip -r ../$(ZFILE) $(TDIR)
	rm -rf $(TDIR)

cleandist:
	rm -rf $(TDIR)
