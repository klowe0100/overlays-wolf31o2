# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

SRC_URI_BASE="http://svn.durchmesser.ch/trac/bindagentx/export/27/tags/bindagentx-${PV}"

DESCRIPTION="MIB definitions for snmp-agents/bindagentx"
HOMEPAGE="http://svn.durchmesser.ch/trac/bindagentx/wiki/MIB"
SRC_URI="${SRC_URI_BASE}/mibs/DURCHMESSER-BIND-MIB -> DURCHMESSER-BIND-MIB.txt
	${SRC_URI_BASE}/mibs/DURCHMESSER-MIB -> DURCHMESSER-MIB.txt"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	insinto /usr/share/snmp/mibs
	doins "${DISTDIR}"/DURCHMESSER-MIB.txt \
		"${DISTDIR}"/DURCHMESSER-BIND-MIB.txt || die "Cannot install files"
}
