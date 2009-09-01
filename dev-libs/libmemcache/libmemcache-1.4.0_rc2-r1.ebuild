# Copyright 1999-2008 Gentoo Foundation ; 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs autotools

MY_PV="${PV/_rc/.rc}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="C API for memcached"
HOMEPAGE="http://people.freebsd.org/~seanc/libmemcache/"
SRC_URI="http://people.freebsd.org/~seanc/libmemcache/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -rf test/unit
	sed -i -e '/DIR/s,unit,,g' test/Makefile.am
	sed -i \
		-e 's,test/unit/Makefile,,g' \
		-e '/^CFLAGS=.*Wall.*pipe/s,-Wall,${CFLAGS} -Wall,g' \
		-e '/^OPTIMIZE=/d' \
		-e '/^PROFILE=/d' \
		configure.ac
	eautoreconf
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc ChangeLog
}
