# Copyright 2009-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

# mysql-snmp-9999       -> latest git
# mysql-snmp-VER        -> normal MIB release

EAPI=2

if [[ ${PV} == 9999* ]]
then
	EGIT_REPO_URI="git://github.com/masterzen/mysql-snmp.git"
	inherit git eutils multilib
	SRC_URI=""
	S=${WORKDIR}/${PN}
	KEYWORDS=""
else
	inherit eutils multilib
	SRC_URI="http://wolf31o2.org/sources/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="AgentX subagent for net-snmp to get MySQL statistics"
HOMEPAGE="http://github.com/masterzen/mysql-snmp"

LICENSE="GPL-2"
SLOT="0"
IUSE="gmp"

# We do not need anything to build, since we're just a perl script.
DEPEND=""
# We do not need mysql, since we use the perl DBI
RDEPEND="dev-lang/perl
	>=net-analyzer/net-snmp-5.4.2[perl]
	dev-perl/DBI
	dev-perl/Unix-Syslog
	virtual/perl-Getopt-Long
	virtual/perl-Math-BigInt
	virtual/perl-Math-BigInt-FastCalc
	gmp? ( dev-perl/Math-BigInt-GMP )"

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
	newsbin mysql-agent mysql-snmp || die
	newinitd "${FILESDIR}"/mysql-snmp.rc mysql-snmp || die
	newconfd "${FILESDIR}"/mysql-snmp.confd mysql-snmp || die
	dodoc README
}
