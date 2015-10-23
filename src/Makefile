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
# src/Makefile.  Generated from Makefile.in by configure.
#

#### Start of system configuration section. ####

srcdir = .
devdir = $(srcdir)
top_builddir = ..
top_srcdir = ..
incdir = $(top_srcdir)/include
cross_compiling = no

# Compiler & tools to use
CC = gcc
LIBTOOL = $(SHELL) $(top_builddir)/libtool --tag=disable-static

# Our install program supports extra flags...
INSTALL = $(SHELL) $(top_srcdir)/install-sh -c

# Libraries
LT_LIBS = $(top_builddir)/common/libsudo_util.la $(LIBOBJDIR)libreplace.la
LIBS =   -lutil    $(LT_LIBS) -ldl

# C preprocessor flags
CPPFLAGS = -I$(incdir) -I$(top_builddir) -I. -I$(srcdir) -I$(top_srcdir) -D__STDC_WANT_LIB_EXT1__=1

# Usually -O and/or -g
CFLAGS = -g -O2 -fvisibility=hidden

# Flags to pass to the link stage
LDFLAGS =  -Wl,-z,relro
LT_LDFLAGS = 

# PIE flags
PIE_CFLAGS = -fPIE
PIE_LDFLAGS = -Wc,-fPIE -pie

# Stack smashing protection flags
SSP_CFLAGS = -fstack-protector-strong
SSP_LDFLAGS = -Wc,-fstack-protector-strong

# cppcheck options, usually set in the top-level Makefile
CPPCHECK_OPTS = -q --force --enable=warning,performance,portability --suppress=constStatement --error-exitcode=1 --inline-suppr -U__cplusplus -UQUAD_MAX -UQUAD_MIN -UUQUAD_MAX -U_POSIX_HOST_NAME_MAX -U_POSIX_PATH_MAX

# Where to install things...
prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin
sbindir = $(exec_prefix)/sbin
sysconfdir = /etc
libexecdir = $(exec_prefix)/libexec
datarootdir = $(prefix)/share
localedir = $(datarootdir)/locale
localstatedir = $(prefix)/var
noexecfile = sudo_noexec.so
noexecdir = $(exec_prefix)/libexec/sudo

# User and group ids the installed files should be "owned" by
install_uid = 0
install_gid = 0

# File extension and mode to use for shared libraries
shlib_ext = .so
shlib_mode = 0644

# Optional init script and rc.d link
INIT_DIR=
INIT_SCRIPT=
RC_LINK=

TEST_PROGS = check_ttyname
TEST_LIBS =   $(LT_LIBS)
TEST_LDFLAGS =  -Wl,-z,relro

# OS dependent defines
DEFS =  -D_GNU_SOURCE -D_FORTIFY_SOURCE=2 -DLOCALEDIR=\"$(localedir)\" 

#### End of system configuration section. ####

SHELL = /bin/bash

PROGS = sudo libsudo_noexec.la

OBJS = conversation.o env_hooks.o exec.o exec_common.o exec_pty.o \
       get_pty.o hooks.o net_ifs.o load_plugins.o parse_args.o \
       preserve_fds.o signal.o sudo.o sudo_edit.o tgetpass.o ttyname.o \
       utmp.o  locale_stub.o

SESH_OBJS = sesh.o locale_stub.o exec_common.o

CHECK_TTYNAME_OBJS = check_ttyname.o locale_stub.o ttyname.o

LIBOBJDIR = $(top_builddir)/compat/

VERSION = 1.8.10p3

all: $(PROGS)

Makefile: $(srcdir)/Makefile.in
	(cd $(top_builddir) && ./config.status --file src/Makefile)

./sudo_usage.h: $(srcdir)/sudo_usage.h.in
	(cd $(top_builddir) && ./config.status --file src/sudo_usage.h)

.SUFFIXES: .c .h .lo .o

.c.o:
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $<

.c.lo:
	$(LIBTOOL) --mode=compile $(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $<

sudo: $(OBJS) $(LT_LIBS) 
	$(LIBTOOL) --mode=link $(CC) -o $@ $(OBJS) $(LDFLAGS) $(PIE_LDFLAGS) $(SSP_LDFLAGS) $(LIBS) 

libsudo_noexec.la: sudo_noexec.lo
	$(LIBTOOL) --mode=link $(CC) $(LDFLAGS) $(LT_LDFLAGS) -o $@ sudo_noexec.lo -avoid-version -rpath $(noexecdir)

sesh: $(SESH_OBJS)  $(LT_LIBS)
	$(LIBTOOL) --mode=link $(CC) -o $@ $(SESH_OBJS) $(LDFLAGS) $(PIE_LDFLAGS) $(SSP_LDFLAGS)  $(LIBS)

check_ttyname: $(CHECK_TTYNAME_OBJS) $(top_builddir)/common/libsudo_util.la $(LIBOBJDIR)libreplace.la
	$(LIBTOOL) --mode=link $(CC) -o $@ $(CHECK_TTYNAME_OBJS) $(TEST_LDFLAGS) $(PIE_LDFLAGS) $(SSP_LDFLAGS) $(TEST_LIBS)

pre-install:

install: install-binaries install-rc install-noexec

install-dirs:
	$(SHELL) $(top_srcdir)/mkinstalldirs $(DESTDIR)$(bindir) \
	    $(DESTDIR)$(libexecdir)/sudo $(DESTDIR)$(noexecdir)

install-rc:
	@if [ -n "$(INIT_SCRIPT)" ]; then \
	    $(SHELL) $(top_srcdir)/mkinstalldirs $(DESTDIR)$(INIT_DIR) \
		`echo $(DESTDIR)$(RC_LINK)|sed 's,/[^/]*$$,,'`; \
	    $(INSTALL) -O $(install_uid) -G $(install_gid) -m 0755 $(top_srcdir)/init.d/$(INIT_SCRIPT) $(DESTDIR)$(INIT_DIR)/sudo; \
	    rm -f $(DESTDIR)$(RC_LINK); \
	    ln -s $(INIT_DIR)/sudo $(DESTDIR)$(RC_LINK); \
	fi

install-binaries: install-dirs $(PROGS)
	$(INSTALL) -b~ -O $(install_uid) -G $(install_gid) -m 04755 sudo $(DESTDIR)$(bindir)/sudo
	rm -f $(DESTDIR)$(bindir)/sudoedit
	ln -s sudo $(DESTDIR)$(bindir)/sudoedit
	if [ -f sesh ]; then $(INSTALL) -b~ -O $(install_uid) -G $(install_gid) -M 0755 sesh $(DESTDIR)$(libexecdir)/sudo/sesh; fi

install-doc:

install-includes:

# We install sudo_noexec by hand so we can avoid a "lib" prefix
# and a version number.  Since we use LD_PRELOAD, neither is needed.
install-noexec: install-dirs libsudo_noexec.la
	if [ -f .libs/libsudo_noexec$(shlib_ext) ]; then $(INSTALL) -b~ -O $(install_uid) -G $(install_gid) -m $(shlib_mode) .libs/libsudo_noexec$(shlib_ext) $(DESTDIR)$(noexecdir)/$(noexecfile); fi

install-plugin:

uninstall:
	-rm -f	$(DESTDIR)$(bindir)/sudo $(DESTDIR)$(bindir)/sudoedit \
		$(DESTDIR)$(libexecdir)/sudo/sesh \
		$(DESTDIR)$(noexecdir)/$(noexecfile)
	@if [ -n "$(INIT_SCRIPT)" ]; then \
	    rm -f $(DESTDIR)$(RC_LINK) $(DESTDIR)$(INIT_DIR)/sudo; \
	fi

cppcheck:
	cppcheck $(CPPCHECK_OPTS) -I$(incdir) -I$(top_builddir) -I. -I$(srcdir) -I$(top_srcdir) $(srcdir)/*.c

check: $(TEST_PROGS)
	@if test X"$(cross_compiling)" != X"yes"; then \
	    ./check_ttyname; \
	fi

clean:
	-$(LIBTOOL) --mode=clean rm -f $(PROGS) $(TEST_PROGS) *.lo *.o *.la *.a stamp-* core *.core core.*

mostlyclean: clean

distclean: clean
	-rm -rf Makefile .libs sudo_usage.h

clobber: distclean

realclean: distclean
	rm -f TAGS tags

cleandir: realclean

# Autogenerated dependencies, do not modify
check_ttyname.o: $(srcdir)/regress/ttyname/check_ttyname.c $(incdir)/alloc.h \
                 $(incdir)/fatal.h $(incdir)/missing.h $(incdir)/sudo_util.h \
                 $(top_builddir)/config.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/regress/ttyname/check_ttyname.c
conversation.o: $(srcdir)/conversation.c $(incdir)/alloc.h $(incdir)/fatal.h \
                $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
                $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
                $(incdir)/sudo_plugin.h $(incdir)/sudo_util.h $(srcdir)/sudo.h \
                $(srcdir)/sudo_plugin_int.h $(top_builddir)/config.h \
                $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/conversation.c
env_hooks.o: $(srcdir)/env_hooks.c $(incdir)/alloc.h $(incdir)/fatal.h \
             $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
             $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
             $(incdir)/sudo_dso.h $(incdir)/sudo_plugin.h \
             $(incdir)/sudo_util.h $(srcdir)/sudo.h $(top_builddir)/config.h \
             $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/env_hooks.c
exec.o: $(srcdir)/exec.c $(incdir)/alloc.h $(incdir)/fatal.h \
        $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
        $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
        $(incdir)/sudo_event.h $(incdir)/sudo_plugin.h $(incdir)/sudo_util.h \
        $(srcdir)/sudo.h $(srcdir)/sudo_exec.h $(srcdir)/sudo_plugin_int.h \
        $(top_builddir)/config.h $(top_builddir)/pathnames.h \
        $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/exec.c
exec_common.o: $(srcdir)/exec_common.c $(incdir)/alloc.h $(incdir)/fatal.h \
               $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
               $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
               $(incdir)/sudo_util.h $(srcdir)/sudo.h $(srcdir)/sudo_exec.h \
               $(top_builddir)/config.h $(top_builddir)/pathnames.h \
               $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/exec_common.c
exec_pty.o: $(srcdir)/exec_pty.c $(incdir)/alloc.h $(incdir)/fatal.h \
            $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
            $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
            $(incdir)/sudo_event.h $(incdir)/sudo_plugin.h \
            $(incdir)/sudo_util.h $(srcdir)/sudo.h $(srcdir)/sudo_exec.h \
            $(srcdir)/sudo_plugin_int.h $(top_builddir)/config.h \
            $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/exec_pty.c
get_pty.o: $(srcdir)/get_pty.c $(incdir)/alloc.h $(incdir)/fatal.h \
           $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
           $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
           $(incdir)/sudo_util.h $(srcdir)/sudo.h $(top_builddir)/config.h \
           $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/get_pty.c
hooks.o: $(srcdir)/hooks.c $(incdir)/alloc.h $(incdir)/fatal.h \
         $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
         $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
         $(incdir)/sudo_plugin.h $(incdir)/sudo_util.h $(srcdir)/sudo.h \
         $(srcdir)/sudo_plugin_int.h $(top_builddir)/config.h \
         $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/hooks.c
load_plugins.o: $(srcdir)/load_plugins.c $(incdir)/alloc.h $(incdir)/fatal.h \
                $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
                $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
                $(incdir)/sudo_dso.h $(incdir)/sudo_plugin.h \
                $(incdir)/sudo_util.h $(srcdir)/sudo.h \
                $(srcdir)/sudo_plugin_int.h $(top_builddir)/config.h \
                $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/load_plugins.c
locale_stub.o: $(srcdir)/locale_stub.c $(incdir)/fatal.h $(incdir)/gettext.h \
               $(incdir)/missing.h $(top_builddir)/config.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/locale_stub.c
net_ifs.o: $(srcdir)/net_ifs.c $(incdir)/alloc.h $(incdir)/fatal.h \
           $(incdir)/gettext.h $(incdir)/missing.h $(incdir)/queue.h \
           $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
           $(top_builddir)/config.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/net_ifs.c
openbsd.o: $(srcdir)/openbsd.c $(incdir)/alloc.h $(incdir)/fatal.h \
           $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
           $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
           $(incdir)/sudo_util.h $(srcdir)/sudo.h $(top_builddir)/config.h \
           $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/openbsd.c
parse_args.o: $(srcdir)/parse_args.c $(incdir)/alloc.h $(incdir)/fatal.h \
              $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/lbuf.h \
              $(incdir)/missing.h $(incdir)/queue.h $(incdir)/sudo_conf.h \
              $(incdir)/sudo_debug.h $(incdir)/sudo_util.h $(srcdir)/sudo.h \
              $(top_builddir)/config.h $(top_builddir)/pathnames.h \
              $(top_srcdir)/compat/getopt.h $(top_srcdir)/compat/stdbool.h \
              ./sudo_usage.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/parse_args.c
preload.o: $(srcdir)/preload.c $(incdir)/sudo_dso.h $(incdir)/sudo_plugin.h \
           $(top_builddir)/config.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/preload.c
preserve_fds.o: $(srcdir)/preserve_fds.c $(incdir)/alloc.h $(incdir)/fatal.h \
                $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
                $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
                $(incdir)/sudo_util.h $(srcdir)/sudo.h \
                $(top_builddir)/config.h $(top_builddir)/pathnames.h \
                $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/preserve_fds.c
selinux.o: $(srcdir)/selinux.c $(incdir)/alloc.h $(incdir)/fatal.h \
           $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
           $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
           $(incdir)/sudo_util.h $(srcdir)/sudo.h $(srcdir)/sudo_exec.h \
           $(top_builddir)/config.h $(top_builddir)/pathnames.h \
           $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/selinux.c
sesh.o: $(srcdir)/sesh.c $(incdir)/alloc.h $(incdir)/fatal.h \
        $(incdir)/gettext.h $(incdir)/missing.h $(incdir)/queue.h \
        $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h $(incdir)/sudo_plugin.h \
        $(srcdir)/sudo_exec.h $(top_builddir)/config.h \
        $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/sesh.c
signal.o: $(srcdir)/signal.c $(incdir)/alloc.h $(incdir)/fatal.h \
          $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
          $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
          $(incdir)/sudo_util.h $(srcdir)/sudo.h $(top_builddir)/config.h \
          $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/signal.c
solaris.o: $(srcdir)/solaris.c $(incdir)/alloc.h $(incdir)/fatal.h \
           $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
           $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
           $(incdir)/sudo_util.h $(srcdir)/sudo.h $(top_builddir)/config.h \
           $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/solaris.c
sudo.o: $(srcdir)/sudo.c $(incdir)/alloc.h $(incdir)/fatal.h \
        $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
        $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
        $(incdir)/sudo_plugin.h $(incdir)/sudo_util.h $(srcdir)/sudo.h \
        $(srcdir)/sudo_plugin_int.h $(top_builddir)/config.h \
        $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h \
        ./sudo_usage.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/sudo.c
sudo_edit.o: $(srcdir)/sudo_edit.c $(incdir)/alloc.h $(incdir)/fatal.h \
             $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
             $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
             $(incdir)/sudo_util.h $(srcdir)/sudo.h $(top_builddir)/config.h \
             $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/sudo_edit.c
sudo_noexec.lo: $(srcdir)/sudo_noexec.c $(incdir)/missing.h \
                $(top_builddir)/config.h
	$(LIBTOOL) --mode=compile $(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/sudo_noexec.c
tgetpass.o: $(srcdir)/tgetpass.c $(incdir)/alloc.h $(incdir)/fatal.h \
            $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
            $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
            $(incdir)/sudo_plugin.h $(incdir)/sudo_util.h $(srcdir)/sudo.h \
            $(top_builddir)/config.h $(top_builddir)/pathnames.h \
            $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/tgetpass.c
ttyname.o: $(srcdir)/ttyname.c $(incdir)/alloc.h $(incdir)/fatal.h \
           $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
           $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
           $(incdir)/sudo_util.h $(srcdir)/sudo.h $(top_builddir)/config.h \
           $(top_builddir)/pathnames.h $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/ttyname.c
utmp.o: $(srcdir)/utmp.c $(incdir)/alloc.h $(incdir)/fatal.h \
        $(incdir)/fileops.h $(incdir)/gettext.h $(incdir)/missing.h \
        $(incdir)/queue.h $(incdir)/sudo_conf.h $(incdir)/sudo_debug.h \
        $(incdir)/sudo_util.h $(srcdir)/sudo.h $(srcdir)/sudo_exec.h \
        $(top_builddir)/config.h $(top_builddir)/pathnames.h \
        $(top_srcdir)/compat/stdbool.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(PIE_CFLAGS) $(SSP_CFLAGS) $(DEFS) $(srcdir)/utmp.c
