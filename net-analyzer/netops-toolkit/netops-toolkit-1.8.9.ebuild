# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

MY_PN="Netops-Toolkit"

DESCRIPTION="perl scripts to manipulate layer 0-4 enterprise network devices"
HOMEPAGE="http://netops.sourceforge.net"
SRC_URI="mirror://sourceforge/netops/${MY_PN}-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl
	net-analyzer/net-snmp[perl]"
RDEPEND="${DEPEND}"

