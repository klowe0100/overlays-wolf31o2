# Copyright 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

DESCRIPTION="Statistics for memcached"
HOMEPAGE="http://code.google.com/p/statsproxy/"
SRC_URI="http://statsproxy.googlecode.com/files/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-devel/bison"
RDEPEND=""
# ${DEPEND}"

src_install() {
	### TODO: init script
	insinto /etc
	newins sample.cfg statsproxy.cfg || die "newins"
	dobin statsproxy || die "dobin"
	dodoc README.txt || die "dodoc"
}
