# Copyright 1999-2009 Gentoo Foundation ; 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils flag-o-matic

DESCRIPTION="A terminal anywhere"
HOMEPAGE="http://anyterm.org/"
SRC_URI="http://anyterm.org/download/${P}.tbz2"

LICENSE="GPL-2 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mod_proxy"

RDEPEND="virtual/ssh"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.34.1"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.1.28-respect-LDFLAGS.patch"
	epatch "${FILESDIR}/${P}-gcc-4.4.patch"
}

src_compile() {
	# this package uses `ld -r -b binary` and thus resulting executalbe contains
	# executable stack
	append-ldflags -Wl,-z,noexecstack
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" || die
}

src_install() {
	dosbin anytermd || die
	dodoc CHANGELOG README || die
	doman anytermd.1 || die
	newinitd "${FILESDIR}/anyterm.init.d" anyterm || die "init.d"
	newconfd "${FILESDIR}/anyterm.conf.d" anyterm || die "conf.d"
	if use mod_proxy ; then
		insinto /etc/apache2/modules.d
		newins "${FILESDIR}"/apache2.conf-proxy 99_anyterm.conf || die "apache2.conf-proxy"
		# TODO: add sed-fu to add proxy to anyterm.js
	fi
}

pkg_postinst() {
	elog "To proceed installation, read following:"
	elog "http://anyterm.org/1.1/install.html"
}
