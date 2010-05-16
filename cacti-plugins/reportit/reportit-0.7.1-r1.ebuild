# Copyright 2008-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils cacti-plugins

HOMEPAGE="http://sourceforge.net/projects/cacti-reportit/"
SRC_URI="mirror://sourceforge/cacti-reportit/${P/-/_}.tar.gz"
S=${WORKDIR}/${PV}
KEYWORDS="~amd64 ~x86"
RDEPEND="${RDEPEND} dev-php/rrdtool-php"
