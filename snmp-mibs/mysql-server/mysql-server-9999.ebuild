# Copyright 2009-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

# mysql-server-9999     -> latest git
# mysql-server-VER      -> normal MIB release

MY_PN="mysql-snmp"

if [[ ${PV} == 9999* ]]
then
	EGIT_REPO_URI="git://github.com/masterzen/mysql-snmp.git"
	inherit git eutils multilib
	SRC_URI=""
	S=${WORKDIR}/${MY_PN}
	KEYWORDS=""
else
	inherit eutils multilib
	SRC_URI="http://wolf31o2.org/sources/${MY_PN}/${MY_PN}-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S=${MY_PN}-${PV}
fi

DESCRIPTION="MIB for MySQL statistics"
HOMEPAGE="http://github.com/masterzen/mysql-snmp"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	if [[ ${PV} == 9999* ]] ; then
		git_src_unpack
	else
		unpack ${A}
		cd "${S}"
	fi
}

src_install() {
	insinto /usr/share/snmp/mibs
	doins MYSQL-SERVER-MIB.txt
}
