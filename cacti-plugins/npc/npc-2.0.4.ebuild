# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils cacti-plugins

HOMEPAGE="http://trac2.assembla.com/npc"
SRC_URI="http://www.constructaegis.com/downloads/${P}.tar.gz"
S=${WORKDIR}/${PN}

KEYWORDS="~amd64 ~x86"

# Requires JSON and PDO for PHP
# Requires Nagios and NDOUtils
RDEPEND="${RDEPEND}
	dev-lang/php[json,pdo]
	>=net-analyzer/nagios-3.0
	>=net-analyzer/ndoutils-1.4_beta7"
