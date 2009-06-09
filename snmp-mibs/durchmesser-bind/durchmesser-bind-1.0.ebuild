# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

SRC_URI_BASE="http://svn.durchmesser.ch/trac/bindagentx/export/27/tags/bindagentx-${PV}"

DESCRIPTION="MIB definitions for snmp-agents/bindagentx"
HOMEPAGE="http://svn.durchmesser.ch/trac/bindagentx/wiki/MIB"
SRC_URI="http://svn.durchmesser.ch/trac/bindagentx/changeset/27/tags/${P}?old_path=%2F&format=zip -> bindagentx-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/tags/bindagentx-${PV}/mibs

src_install() {
	insinto /usr/share/snmp/mibs
	newins "${S}"/DURCHMESSER-MIB \
		DURCHMESSER-MIB.txt || die "Cannot install files"
	newins "${S}"/DURCHMESSER-BIND-MIB \
		DURCHMESSER-BIND-MIB.txt || die "Cannot install files"
}
