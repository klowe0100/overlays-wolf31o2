# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils nagios-plugins

DESCRIPTION="A nagios plugin for checking logfiles"
HOMEPAGE="http://labs.consol.de/lang/en/nagios/check_hpasm/"

SRC_URI="http://labs.consol.de/wp-content/uploads/2009/09/${P}.tar.gz"
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
