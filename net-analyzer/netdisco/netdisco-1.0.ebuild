# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="web-based network discovery and management tool"
HOMEPAGE="http://netdisco.org/"
SRC_URI="mirror://sourceforge/netdisco/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl
	net-analyzer/net-snmp[perl]"
RDEPEND="${DEPEND}"

