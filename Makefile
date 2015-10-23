#
# Copyright (c) 2010-2014 Todd C. Miller <Todd.Miller@courtesan.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

srcdir = .
devdir = $(srcdir)
top_builddir = .
top_srcdir = .

# Installation paths for package building
prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
sbindir = $(exec_prefix)/sbin
sysconfdir = /etc
libexecdir = $(exec_prefix)/libexec
includedir = $(prefix)/include
datarootdir = $(prefix)/share
localedir = $(datarootdir)/locale
localstatedir = $(prefix)/var
docdir = $(datarootdir)/doc/$(PACKAGE_TARNAME)
mandir = $(prefix)/man
rundir = /var/run/sudo
vardir = /var/lib/sudo

# User and group ids the installed files should be "owned" by
install_uid = 0
install_gid = 0

# sudoers owner and mode for package building
sudoersdir = $(sysconfdir)
sudoers_uid = 0
sudoers_gid = 0
sudoers_mode = 0440
shlib_mode = 0644

SUBDIRS = compat common  plugins/group_file plugins/sudoers \
	  plugins/system_group src include doc

SAMPLES = plugins/sample

VERSION = 1.8.10p3
PACKAGE_TARNAME = sudo

LIBTOOL_DEPS = ./ltmain.sh

SHELL = /bin/bash

INSTALL = $(SHELL) $(top_srcdir)/install-sh -c

ECHO_N = -n
ECHO_C = 

# Message catalog support
NLS = enabled
POTFILES = src/po/sudo.pot plugins/sudoers/po/sudoers.pot
LOCALEDIR_SUFFIX = 
MSGFMT = msgfmt
MSGMERGE = msgmerge
XGETTEXT = xgettext
XGETTEXT_OPTS = -F -k_ -kN_ -kU_ --copyright-holder="Todd C. Miller" \
		"--msgid-bugs-address=http://www.sudo.ws/bugs" \
		--package-name=sudo --package-version=$(VERSION) \
		--flag warning:1:c-format --flag warningx:1:c-format \
		--flag fatal:1:c-format --flag fatalx:1:c-format \
		--flag easprintf:3:c-format --flag lbuf_append:2:c-format \
		--flag lbuf_append_quoted:3:c-format --foreign-user

# Default cppcheck options when run from the top-level Makefile
CPPCHECK_OPTS = -q --force --enable=warning,performance,portability --suppress=constStatement --error-exitcode=1 --inline-suppr -U__cplusplus -UQUAD_MAX -UQUAD_MIN -UUQUAD_MAX -U_POSIX_HOST_NAME_MAX -U_POSIX_PATH_MAX

all: config.status
	for d in $(SUBDIRS); do \
	    (cd $$d && exec $(MAKE) $@) && continue; \
	    exit $$?; \
	done

check pre-install: config.status
	for d in $(SUBDIRS); do \
	    (cd $$d && exec $(MAKE) $@) && continue; \
	    exit $$?; \
	done

cppcheck: config.status
	rval=0; \
	for d in $(SUBDIRS); do \
	    echo checking $$d; \
	    (cd $$d && exec $(MAKE) CPPCHECK_OPTS="$(CPPCHECK_OPTS)" $@) || rval=`expr $$rval + $$?`; \
	done; \
	exit $$rval

install-dirs install-binaries install-includes install-plugin: config.status pre-install
	for d in $(SUBDIRS); do \
	    (cd $$d && exec $(MAKE) $@) && continue; \
	    exit $$?; \
	done

install-doc: config.status ChangeLog
	for d in $(SUBDIRS); do \
	    (cd $$d && exec $(MAKE) $@) && continue; \
	    exit $$?; \
	done

install: config.status ChangeLog pre-install install-nls
	for d in $(SUBDIRS); do \
	    (cd $$d && exec $(MAKE) $@) && continue; \
	    exit $$?; \
	done

uninstall: uninstall-nls
	for d in $(SUBDIRS); do \
	    (cd $$d && exec $(MAKE) $@) && continue; \
	    exit $$?; \
	done

uninstall-nls:
	for pot in $(POTFILES); do \
	    domain=`basename $$pot .pot`; \
	    rm -f $(DESTDIR)$(localedir)/*/LC_MESSAGES/$$domain.mo; \
	done

siglist.c signame.c:
	(cd compat && exec $(MAKE) $@)

depend: siglist.c signame.c
	@if test "$(srcdir)" != "."; then \
	    echo "make depend only supported in the source directory"; \
	    exit 1; \
	fi; \
	$(srcdir)/mkdep.pl $(srcdir)/common/Makefile.in \
	    $(srcdir)/compat/Makefile.in $(srcdir)/plugins/sample/Makefile.in \
	    $(srcdir)/plugins/group_file/Makefile.in \
	    $(srcdir)/plugins/sudoers/Makefile.in \
	    $(srcdir)/plugins/system_group/Makefile.in \
	    $(srcdir)/src/Makefile.in $(srcdir)/zlib/Makefile.in; \
	./config.status --file $(srcdir)/common/Makefile \
	    --file $(srcdir)/compat/Makefile \
	    --file $(srcdir)/plugins/sample/Makefile \
	    --file $(srcdir)/plugins/group_file/Makefile \
	    --file $(srcdir)/plugins/sudoers/Makefile \
	    --file $(srcdir)/plugins/system_group/Makefile \
	    --file $(srcdir)/src/Makefile --file $(srcdir)/zlib/Makefile

ChangeLog:
	if test -d $(srcdir)/.hg && cd $(srcdir); then \
	    if hg log --style=changelog -b default > $@.tmp; then \
		mv -f $@.tmp $@; \
	    else \
		rm -f $@.tmp; \
	    fi; \
	fi

config.status:
	@if [ ! -s config.status ]; then \
		echo "Please run configure first"; \
		exit 1; \
	fi

libtool: $(LIBTOOL_DEPS)
	$(SHELL) ./config.status --recheck

Makefile: $(srcdir)/Makefile.in
	./config.status --file Makefile

sync-po: rsync-po compile-po

rsync-po:
	rsync -Lrtvz  translationproject.org::tp/latest/sudo/ src/po/
	rsync -Lrtvz  translationproject.org::tp/latest/sudoers/ plugins/sudoers/po/

update-pot:
	@if $(XGETTEXT) --help >/dev/null 2>&1; then \
	    cd $(top_srcdir); \
	    for pot in $(POTFILES); do \
		echo "Updating $$pot"; \
		domain=`basename $$pot .pot`; \
		case "$$domain" in \
		    sudo) tmpfiles=; cfiles="src/*c common/*c compat/*c";; \
		    sudoers) \
			echo "syntax error" > confstr.sh; \
			sed -n -e 's/^badpass_message="/gettext "/p' \
			    -e 's/^passprompt="/gettext "/p' \
			    -e 's/^mailsub="/gettext "/p' configure.ac \
			    >> confstr.sh; \
			tmpfiles=confstr.sh; \
			cfiles="plugins/sudoers/*.c plugins/sudoers/auth/*.c";; \
		    *) echo unknown domain $$domain; continue;; \
		esac; \
		$(XGETTEXT) $(XGETTEXT_OPTS) -d$$domain $$cfiles $$tmpfiles -o $$pot.tmp; \
		test -n "$$tmpfiles" && rm -f $$tmpfiles; \
		if diff -I'^.POT-Creation-Date' -I'^.Project-Id-Version' -I'^#' $$pot.tmp $$pot >/dev/null; then \
		    rm -f $$pot.tmp; \
		else \
		    printf '/^#$$/+1,$$d\nw\nq\n' | ed - $$pot; \
		    sed '1,/^#$$/d' $$pot.tmp >> $$pot; \
		    rm -f $$pot.tmp; \
		fi; \
	    done; \
	fi

update-po: update-pot
	@if $(MSGFMT) --help >/dev/null 2>&1; then \
	    cd $(top_srcdir); \
	    for pot in $(POTFILES); do \
		podir=`dirname $$pot`; \
		for po in $$podir/*.po; do \
		    echo $(ECHO_N) "Updating $$po$(ECHO_C)"; \
		    $(MSGMERGE) --update $$po $$pot; \
		    $(MSGFMT) --output /dev/null --check-format $$po || exit 1; \
		done; \
	    done; \
	fi

compile-po:
	@if $(MSGFMT) --help >/dev/null 2>&1; then \
	    cd $(top_srcdir); \
	    rm -f Makefile.$$$$; \
	    POFILES=""; \
	    for pot in $(POTFILES); do \
		podir=`dirname $$pot`; \
		for po in $$podir/*.po; do \
		    POFILES="$$POFILES $$po"; \
		done; \
	    done; \
	    echo "all: `echo $$POFILES | sed 's/\.po/.mo/g'`" >> Makefile.$$$$; \
	    echo "" >> Makefile.$$$$; \
	    for po in $$POFILES; do \
		mo=`echo $$po | sed 's/po$$/mo/'`; \
		echo "$$mo: $$po" >> Makefile.$$$$; \
		echo "	$(MSGFMT) --statistics -c -o $$mo $$po" >> Makefile.$$$$; \
	    done; \
	    make -f Makefile.$$$$; \
	    rm -f Makefile.$$$$; \
	fi

install-nls:
	@if test "$(NLS)" = "enabled"; then \
	    cd $(top_srcdir); \
	    for pot in $(POTFILES); do \
		podir=`dirname $$pot`; \
		domain=`basename $$pot .pot`; \
		SUDO_LINGUAS=$${LINGUAS-"`echo $$podir/*.mo|sed 's:'$$podir'/\([^ ]*\).mo:\1:g'`"}; \
		echo $(ECHO_N) "Installing $$domain message catalogs:$(ECHO_C)"; \
		for lang in $$SUDO_LINGUAS; do \
		    test -s $$podir/$$lang.mo || continue; \
		    echo $(ECHO_N) " $$lang$(ECHO_C)"; \
		    $(SHELL) $(top_srcdir)/mkinstalldirs $(DESTDIR)$(localedir)/$$lang/LC_MESSAGES; \
		    if test -n "$(LOCALEDIR_SUFFIX)"; then \
			if test ! -d $(DESTDIR)$(localedir)/$$lang$(LOCALEDIR_SUFFIX); then \
			    ln -s $$lang $(DESTDIR)$(localedir)/$$lang$(LOCALEDIR_SUFFIX); \
			fi; \
		    fi; \
		    $(INSTALL) -O $(install_uid) -G $(install_gid) -m 0644 $$podir/$$lang.mo $(DESTDIR)$(localedir)/$$lang/LC_MESSAGES/$$domain.mo; \
		done; \
		echo ""; \
	    done; \
	fi

check-dist: update-pot compile-po
	@if [ -d .hg ]; then \
	    if test `hg stat -am | wc -l` -ne 0; then \
		echo "Uncommitted changes" 1>&2; \
		hg stat -am 1>&2; \
		exit 1; \
	    fi; \
	fi

dist: check-dist force-dist

force-dist: ChangeLog $(srcdir)/MANIFEST
	pax -w -x ustar -s '/^/$(PACKAGE_TARNAME)-$(VERSION)\//' \
	    -f ../$(PACKAGE_TARNAME)-$(VERSION).tar \
	    `sed 's/[ 	].*//' $(srcdir)/MANIFEST`
	gzip -9f ../$(PACKAGE_TARNAME)-$(VERSION).tar
	ls -l ../$(PACKAGE_TARNAME)-$(VERSION).tar.gz

package: sudo.pp
	DESTDIR=`cd $(top_builddir) && pwd`/destdir; rm -rf $$DESTDIR; \
	$(MAKE) install DESTDIR=$$DESTDIR && \
	$(SHELL) $(srcdir)/pp $(PPFLAGS) \
	    --destdir=$$DESTDIR \
	    $(srcdir)/sudo.pp \
	    bindir=$(bindir) \
	    sbindir=$(sbindir) \
	    libexecdir=$(libexecdir) \
	    includedir=$(includedir) \
	    vardir=$(vardir) \
	    rundir=$(rundir) \
	    mandir=$(mandir) \
	    localedir=$(localedir) \
	    docdir=$(docdir) \
	    sysconfdir=$(sysconfdir) \
	    sudoersdir=$(sudoersdir) \
	    sudoers_uid=$(sudoers_uid) \
	    sudoers_gid=$(sudoers_gid) \
	    sudoers_mode=$(sudoers_mode) \
	    shlib_mode=$(shlib_mode) \
	    version=$(VERSION) $(PPVARS)

clean: config.status
	for d in $(SUBDIRS) $(SAMPLES); do \
	    (cd $$d && exec $(MAKE) $@); \
	done

mostlyclean: clean

distclean: config.status
	for d in $(SUBDIRS) $(SAMPLES); do \
	    (cd $$d && exec $(MAKE) $@); \
	done
	-rm -rf Makefile pathnames.h config.h config.status config.cache \
		config.log libtool stamp-* autom4te.cache

cleandir: distclean

clobber: distclean

realclean: distclean

me:

a:

sandwich:
	@if test -n "$$SUDO_USER"; then \
	    echo "Okay."; \
	else \
	    echo "What?  Make it yourself!"; \
	fi

.PHONY: ChangeLog me a sandwhich
