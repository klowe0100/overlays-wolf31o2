# Copyright 2009-2009 Chris GIanelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="industry-standard LLDP (802.1ab) daemon"
HOMEPAGE="https://trac.luffy.cx/lldpd"
SRC_URI="http://www.luffy.cx/lldpd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="snmp"

DEPEND="snmp? ( net-analyzer/net-snmp )"
RDEPEND="${DEPEND}"

