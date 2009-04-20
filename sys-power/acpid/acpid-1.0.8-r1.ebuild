# Copyright 1999-2008 Gentoo Foundation ; 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="Daemon for Advanced Configuration and Power Interface"
HOMEPAGE="http://acpid.sourceforge.net"
SRC_URI="mirror://sourceforge/acpid/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+syslog"

DEPEND="sys-apps/sed"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e '/^CFLAGS /{s:=:+=:;s:-Werror -g::}' \
		Makefile
}

src_compile() {
	append-flags -D_GNU_SOURCE

	# DO NOT COMPILE WITH OPTIMISATIONS (bug #22365)
	# That is a note to the devs.  IF you are a user, go ahead and optimise
	# if you want, but we won't support bugs associated with that.
	emake CC="$(tc-getCC)" INSTPREFIX="${D}" || die "emake failed"
}

src_install() {
	local __syslog=
	emake INSTPREFIX="${D}" install || die "emake install failed"

	exeinto /etc/acpi
	newexe "${FILESDIR}"/${P}-default.sh default.sh || die
	insinto /etc/acpi/events
	newins "${FILESDIR}"/${P}-default default || die

	dodoc README Changelog TODO

	newinitd "${FILESDIR}"/${P}-init.d acpid
	# Enable syslog support, by default
	if use syslog ; then
		__syslog='--logevents'
	fi
	sed \
		"s/%%SYSLOG%%/$_syslog/" \
		"${FILESDIR}"/${P}-conf.d > "${T}"/${P}-conf.d
	newconfd "${T}"/${P}-conf.d acpid

	docinto examples
	dodoc samples/{acpi_handler.sh,sample.conf}

	docinto examples/battery
	dodoc samples/battery/*

	docinto examples/panasonic
	dodoc samples/panasonic/*
}

pkg_postinst() {
	echo
	einfo "You may wish to read the Gentoo Linux Power Management Guide,"
	einfo "which can be found online at:"
	einfo "    http://www.gentoo.org/doc/en/power-management-guide.xml"
	echo
	elog "As of version 1.0.6, acpid uses system log facility instead of custom log"
	elog "file. This means acpid messages will be usually located in "
	elog "/var/log/messages (and not in /var/log/acpid) for common setups."
	echo
}
