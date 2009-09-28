# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

# ramon-9999            -> latest git
# ramon-VER             -> normal MIB release

EAPI=2

if [[ ${PV} == 9999* ]]
then
	EGIT_REPO_URI="git://git.sv.gnu.org/ramon.git"
	inherit git eutils multilib
	SRC_URI=""
	S=${WORKDIR}/${PN}
else
	inherit eutils multilib
	SRC_URI="http://wolf31o2.org/sources/${PN}/${P}.tar.bz2"
fi

DESCRIPTION="AgentX subagent for net-snmp to get RMON2 statistics"
HOMEPAGE="http://www.nongnu.org/ramon"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-analyzer/net-snmp
	>=net-libs/libpcap-0.7.1"
DEPEND="${RDEPEND}
	sys-devel/flex"

src_unpack() {
	if [[ ${PV} == 9999* ]] ; then
		git_src_unpack
	else
		unpack ${A}
		cd "${S}"
	fi
}

src_prepare() {
	# Fix SNMP location
	sed -i 's:/usr/local/include:/usr/include:' Makefile
}
