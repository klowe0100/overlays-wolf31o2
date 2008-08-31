# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/net-snmp/net-snmp-5.4.1.1.ebuild,v 1.9 2008/06/23 18:59:58 ranger Exp $

EAPI=1

inherit fixheadtails flag-o-matic perl-module python autotools


DESCRIPTION="Software for generating and retrieving SNMP data"
HOMEPAGE="http://java.sun.com/javase/6/docs/jre/api/management"
SRC_URI="${HOMEPAGE}/JVM-MANAGEMENT-MIB.mib"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	insinto /usr/share/snmp/mibs
	newins "${DISTDIR}"/JVM-MANAGEMENT-MIB.mib JVM-MANAGEMENT-MIB.txt
}
