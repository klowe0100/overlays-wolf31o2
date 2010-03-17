# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libnl/libnl-1.1-r2.ebuild,v 1.4 2010/01/14 21:36:48 fauli Exp $

EAPI="2"

inherit eutils multilib

DESCRIPTION="A library for applications dealing with netlink socket"
HOMEPAGE="http://people.suug.ch/~tgr/libnl/"
SRC_URI="http://people.suug.ch/~tgr/libnl/files/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

src_prepare() {
	# Gentoo patches
	epatch "${FILESDIR}"/${P}-vlan-header.patch
	epatch "${FILESDIR}"/${P}-minor-leaks.patch
	# Fedora patches
	epatch "${FILESDIR}"/${P/1.1/1.0-pre5}-static.patch
	epatch "${FILESDIR}"/${P/1.1/1.0-pre5}-debuginfo.patch
	epatch "${FILESDIR}"/${P/1.1/1.0-pre8}-use-vasprintf-retval.patch
	epatch "${FILESDIR}"/${P/1.1/1.0-pre8}-more-build-output.patch
	epatch "${FILESDIR}"/${P}-include-limits-h.patch
	epatch "${FILESDIR}"/${P}-doc-inlinesrc.patch
	epatch "${FILESDIR}"/${P}-no-extern-inline.patch
	# My patch
	epatch "${FILESDIR}"/${P}-flags2.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog
}
