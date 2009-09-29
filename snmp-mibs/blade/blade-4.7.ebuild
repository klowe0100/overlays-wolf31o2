# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib

DESCRIPTION="MIB for MySQL statistics"
HOMEPAGE="http://www.ibm.com"
SRC_URI="http://linbsd.net/~solar/mmblade.mib"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	insinto /usr/share/snmp/mibs
	newins mmblade.mib BLADE-MIB.txt
}
