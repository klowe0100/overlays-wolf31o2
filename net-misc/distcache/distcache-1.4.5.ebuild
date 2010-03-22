# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils autotools

DESCRIPTION="Distributed SSL Session Cache"
HOMEPAGE="http://www.distcache.org/"
SRC_URI="mirror://sourceforge/distcache/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/openssl
	sys-apps/shadow"
DEPEND="${RDEPEND}
	>=sys-devel/automake-1.7
	>=sys-devel/autoconf-2.50
	sys-devel/libtool"

src_prepare() {
	epatch "${FILESDIR}"/${P}-setuid.patch \
		"${FILESDIR}"/${P}-libdeps.patch \
		"${FILESDIR}"/${P}-limits.patch
	eautoreconf
	default
}

src_install() {
	rm -f INSTALL LICENSE
	dodoc README ANNOUNCE CHANGES BUGS FAQ
	dodoc -r doc
	emake DESTDIR="${D}" install || die "emake install"
	emake -C ssl DESTDIR="${D}" install || die "emake install"
}

pkg_preinst() {
	enewgroup distcache 94
	enewuser distcache 94
}
