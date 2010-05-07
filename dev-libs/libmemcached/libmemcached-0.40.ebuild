# Copyright 1999-2009 Gentoo Foundation ; 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmemcached/libmemcached-0.31.ebuild,v 1.1 2009/07/22 17:32:33 robbat2 Exp $

inherit eutils

DESCRIPTION="a C client library to the memcached server"
HOMEPAGE="http://libmemcached.org/libMemcached.html"
SRC_URI="http://launchpad.net/${PN}/1.0/0.40/+download/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug hsieh"

DEPEND="net-misc/memcached"
RDEPEND="${DEPEND}"

src_compile() {
	econf \
		$(use_with debug debug) \
		$(use_enable hsieh hsieh_hash)
	emake || die "Build failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}

src_test() {
	emake test || die "Tests failed"
}
