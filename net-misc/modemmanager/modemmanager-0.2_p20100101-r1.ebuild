# Copyright 1999-2009 Gentoo Foundation ; 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils autotools

# ModemManager likes itself with capital letters
MY_P=${P/modemmanager/ModemManager}

DESCRIPTION="Modem and mobile broadband management libraries"
HOMEPAGE="http://mail.gnome.org/archives/networkmanager-list/2008-July/msg00274.html"
SRC_URI="http://wolf31o2.org/sources/snapshots/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
RESTRICT="primaryuri"
IUSE=""

RDEPEND="net-dialup/ppp"

DEPEND=">=sys-fs/udev-145[extras]
	dev-libs/dbus-glib
	dev-util/pkgconfig
	dev-util/intltool"

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	econf \
		--with-docs \
		--disable-dependency-tracking \
		--disable-maintainer-mode \
		--disable-more-warnings
}

S=${WORKDIR}/${MY_P/_p20090806/}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
