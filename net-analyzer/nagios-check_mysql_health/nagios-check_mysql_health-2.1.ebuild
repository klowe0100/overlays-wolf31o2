# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-check_logfiles/nagios-check_logfiles-2.3.2.1-r1.ebuild,v 1.7 2009/03/18 22:18:37 ranger Exp $

inherit eutils
DESCRIPTION="A nagios plugin for checking logfiles"
#HOMEPAGE="http://www.consol.com/opensource/nagios/check-logfiles"
HOMEPAGE="http://labs.consol.de/lang/en/nagios/check_mysql_health"

MY_P=${P/nagios-/}

#SRC_URI="http://www.consol.com/fileadmin/opensource/Nagios/${MY_P}.tar.gz"
SRC_URI="http://labs.consol.de/wp-content/uploads/2009/10/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""
IUSE=""

DEPEND=">=net-analyzer/nagios-plugins-1.4.13-r1
	dev-lang/perl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf \
		--with-mymodules-dir=/usr/$(get_libdir)/nagios/plugins \
		--with-mymodules-dyn-dir=/usr/$(get_libdir)/nagios/plugins || die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
