# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit distutils

DESCRIPTION="extension for libmemcache (C API to memcached)"
HOMEPAGE="http://gijsbert.org/cmemcache/"
SRC_URI="http://gijsbert.org/downloads/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-libs/libmemcache-1.4.0_rc2"
RDEPEND=${DEPEND}
