# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MY_PV=${PV/_p11/}
MY_REV=11

DESCRIPTION="Percona high-performance MySQL"
HOMEPAGE="http://www.percona.com/docs/wiki/release:start"
SRC_URI="http://www.percona.com/mysql/${MY_PV}-b${MY_REV}/source/mysql-${MY_PV}-${PN}-highperf-b${MY_REV}-src.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

