prefix      = /usr/local
exec_prefix = $(prefix)
bindir      = $(exec_prefix)/bin
mandir      = $(prefix)/share/man
sysconfdir  = $(prefix)/etc
datadir     = $(prefix)/share
docdir      = $(datadir)/doc/packages

BINDIR =	$(PREFIX)/bin
MANDIR =	$(PREFIX)/share/man

INSTALL =	install
RONN =		ronn-1.9

BIN =		withlock
MANPAGE =	withlock.1

$(MANPAGE): $(MANPAGE).ronn
	$(RONN) --roff $<
	$(RONN) --html $<

install: $(BIN) $(MANPAGE)
	$(INSTALL) -d $(DESTDIR)$(bindir) 
	$(INSTALL) $(BIN) $(DESTDIR)$(bindir)
	$(INSTALL) -d $(DESTDIR)$(mandir)/man1
	$(INSTALL) -m 0644 $(MANPAGE) $(DESTDIR)$(mandir)/man1
	$(INSTALL) -d $(DESTDIR)$(docdir)/withlock
	$(INSTALL) -m 0644 withlock.1.html README.md LICENSE-2.0.txt $(DESTDIR)$(docdir)/withlock

