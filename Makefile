PREFIX =	/usr/local
BINDIR =	$(PREFIX)/bin
MANDIR =	$(PREFIX)/share/man
MAN1DIR =	$(MANDIR)/man1

INSTALL =	install
RONN =		ronn-1.9

BIN =		withlock
MANPAGE =	withlock.1

$(MANPAGE): $(MANPAGE).ronn
	$(RONN) --roff $<
	$(RONN) --html $<

install: $(BIN) $(MANPAGE)
	$(INSTALL) -d $(BINDIR) $(MAN1DIR)
	$(INSTALL) $(BIN) $(BINDIR)
	$(INSTALL) -m 0644 $(MANPAGE) $(MANDIR)/man1

