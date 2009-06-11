# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="decodes Cisco Discovery Protocol (CDP) packets"
HOMEPAGE="http://sourceforge.net/projects/cdpr"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-libs/libpcap"
RDEPEND="${DEPEND}"

### TODO: Add support for the cdprs server scripts

src_install() {
	dosbin cdpr || die
}
