# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Nagios notification MIB"
HOMEPAGE="http://sourceforge.net/projects/nagiosplug/"
SRC_URI="mirror://sourceforge/nagiosplug/${P}.tar.gz"
# GIT_REPO="http://repo.or.cz/w/nagiosmib.git"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	insinto /usr/share/snmp/mibs
	newins MIB/NAGIOS-NOTIFY-MIB NAGIOS-NOTIFY-MIB.txt || die
	newins MIB/NAGIOS-ROOT-MIB NAGIOS-ROOT-MIB.txt || die
}
