# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/pidgin-libnotify/pidgin-libnotify-0.14.ebuild,v 1.5 2009/09/06 14:42:07 maekke Exp $

EAPI="2"

MY_PN=${PN/pidgin-/}

DESCRIPTION="provides /stfw or /lmgtfy commands to send lmgtfy links"
HOMEPAGE="http://linuxandwhatever.wordpress.com/stfw-pidgin-plugin/"
SRC_URI="http://www.cs.hs-rm.de/~ksteb001/${MY_PN}/${MY_PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-im/pidgin[gtk]
	>=dev-libs/glib-2
	>=x11-libs/gtk+-2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_PN}

src_compile() {
	cd "${S}"
	./build || die
}

src_install() {
	exeinto /usr/$(get_libdir)/purple-2
	doexe ${MY_PN}.so
}
