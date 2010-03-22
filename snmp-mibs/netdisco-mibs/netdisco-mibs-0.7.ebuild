# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="MIB collection for netdisco"
HOMEPAGE="http://netdisco.org/"
SRC_URI="mirror://sourceforge/netdisco/netdisco-mibs/${P}.tar.gz"
# GIT_REPO="http://repo.or.cz/w/nagiosmib.git"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

NETDISCO_MIB_VENDORS="allied arista aruba asante cabletron cisco cyclades dell
enterasys extreme foundry hp juniper netscreen net-snmp nortel rfc"

src_install() {
	insinto /usr/share/netdisco
	doins -r ${NETDISCO_MIB_VENDORS}
	dosbin chk_dups chk_mibs chk_mibs_all rm_cisco_dups
	dobin snmpwalkmib walk_all
	dodoc mib_index.txt README
	insinto /usr/local/snmp/etc
	doins snmp.conf
}
