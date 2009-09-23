# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

# mysql-snmp-9999       -> latest git
# mysql-snmp-VER        -> normal MIB release

### TODO: create an init script and configuration file

EAPI=2

if [[ ${PV} == 9999* ]]
then
	EGIT_REPO_URI="git://github.com/masterzen/mysql-snmp.git"
	inherit git eutils multilib
	SRC_URI=""
	S=${WORKDIR}/${PN}
else
	inherit eutils multilib
	SRC_URI="http://wolf31o2.org/sources/${PN}/${P}.tar.bz2"
fi

DESCRIPTION="AgentX subagent for net-snmp to get MySQL statistics"
HOMEPAGE="http://github.com/masterzen/mysql-snmp"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl
	net-analyzer/net-snmp[perl]
	dev-perl/DBI"

src_unpack() {
	if [[ ${PV} == 9999* ]] ; then
		git_src_unpack
	else
		unpack ${A}
		cd "${S}"
	fi
}

src_install() {
	# Do not use make install, since it installs the MIB
	newsbin mysql-agent.pl mysql-agent
	dodoc README
}
