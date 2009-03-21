# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-plugins-snmp/nagios-plugins-snmp-0.5.5.ebuild,v 1.3 2007/06/30 16:37:45 dertobi123 Exp $

inherit eutils

MY_PN="nagios-snmp-plugins"

DESCRIPTION="Additional Nagios plugins for monitoring SNMP capable devices"
HOMEPAGE="http://nagios.manubulon.com"
SRC_URI="http://nagios.manubulon.com/${MY_PN}.${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="net-analyzer/net-snmp"
RDEPEND="${DEPEND}"

S=${WORKDIR}/nagios_plugins

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_install() {
	sed -i 's#/usr/local/nagios/libexec#/usr/nagios/libexec#' *.pl
	exeinto /usr/nagios/libexec
	doexe *.pl || die "doexe failed"

	chown -R root:nagios "${D}"/usr/nagios/libexec || die "Failed Chown of ${D}usr/nagios/libexec"
	chmod -R o-rwx "${D}"/usr/nagios/libexec || "Failed Chmod of ${D}usr/nagios/libexec"

	dohtml doc
}
