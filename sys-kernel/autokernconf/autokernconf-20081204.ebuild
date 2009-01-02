# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PV=2008-12-04

DESCRIPTION="Automagical Kernel Configuration"
HOMEPAGE="http://cateee.net/autokernconf/"
SRC_URI="http://cateee.net/sources/autokernconf/${PN}-${MY_PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}-${MY_PV}

src_install() {
	dosbin kdetect.sh autokernconf.sh || die
}
