# Copyright 1999-2008 Gentoo Foundation ; 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils autotools

DESCRIPTION="Additional Nagios plugins for monitoring SNMP capable devices"
HOMEPAGE="http://nagios.manubulon.com"
SRC_URI="http://nagios.manubulon.com/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="perl"

DEPEND="net-analyzer/net-snmp"
RDEPEND="${DEPEND}
	perl? ( net-analyzer/nagios-plugins-snmp-perl )"

S=${WORKDIR}/nagios-plugins-snmp

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	eautoreconf
}

src_compile() {
	econf \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--sysconfdir=/etc/nagios || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	chown -R root:nagios "${D}"/usr/$(get_libdir)/nagios/plugins || die "Failed chown of ${D}usr/$(get_libdir)/nagios/plugins"
	chmod -R o-rwx "${D}"/usr/$(get_libdir)/nagios/plugins || die "Failed chmod of ${D}usr/$(get_libdir)/nagios/plugins"

	dodoc README NEWS AUTHORS
}
