# Copyright 1999-2009 Gentoo Foundation ; 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

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

src_prepare() {
	EPATCH_OPTS="-F 40" epatch "${FILESDIR}/${PN}-0.39-runtestsasuser.patch"
	sed -r -i \
		-e 's,(context)(__attribute__),\1 \2,g' \
		libhashkit/hsieh.c || die "Failed to fix upstream typo"
}

src_configure() {
	econf \
		$(use_with debug debug) \
		$(use_enable hsieh hsieh_hash)
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README* THANKS TODO
	# Rather than remove the man page, I've chosen to keep it.  Check out the
	# upstream Gentoo bug #299330 for their reasons for renaming it.
}

src_test() {
	emerge -j1 test-docs test-mem test-hash test-plus || die "Tests failed"
}
