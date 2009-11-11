# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="A nagios plugin for checking logfiles"
HOMEPAGE="http://www.consol.com/opensource/nagios/check-logfiles"

SRC_URI="http://www.consol.com/fileadmin/opensource/Nagios/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS=""
IUSE=""

DEPEND=">=net-analyzer/nagios-plugins-1.4.13-r1"
RDEPEND="${DEPEND}"

src_compile() {
	econf \
		--prefix=/usr \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--sysconfdir=/etc/nagios || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
