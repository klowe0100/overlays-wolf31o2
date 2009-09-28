# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/net-snmp/net-snmp-5.4.1.1.ebuild,v 1.9 2008/06/23 18:59:58 ranger Exp $

EAPI=2

DESCRIPTION="Remote Monitoring Version 2 Management Information Base"
HOMEPAGE="http://www.simpleweb.org/ietf/mibs/modules/IETF/txt/RMON2-MIB"
SRC_URI="${HOMEPAGE}"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	insinto /usr/share/snmp/mibs
	newins "${DISTDIR}"/RMON2-MIB RMON2-MIB.txt
}
