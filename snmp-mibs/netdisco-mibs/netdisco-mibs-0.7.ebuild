# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Nagios notification MIB"
HOMEPAGE="http://netdisco.org/"
SRC_URI="mirror://sourceforge/netdisco/netdisco-mibs/${P}.tar.gz"
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
