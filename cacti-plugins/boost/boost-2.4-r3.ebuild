# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils cacti-plugins

#SRC_URI="http://docs.cacti.net/_media/plugin:${PN}_v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="${CACTI_PLUG_BASE}/${P}.tar.gz"

LICENSE="GPL-2"
IUSE="+memory"
KEYWORDS="~amd64 ~x86"

DEPEND="${DEPEND}
	memory? ( >=virtual/mysql-5 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

pkg_preinst() {
	if [ -e "${CACTI_PLUG_HOME}/${CACTI_PLUG_NAME}" ]
	then
		ebegin "Flushing Boost Poller Tables"
		/usr/bin/php -q \
			${CACTI_PLUG_BASE}/${CACTI_PLUG_NAME}/poller_boost.php -f > \
			/dev/null 2>&1
		eend $?
	fi
}

pkg_postinst() {
	if use memory ; then
		MYSQL_SCRIPTS=${CACTI_PLUG_HOME}/boost_sql_memory.sql
	else
		MYSQL_SCRIPTS=${CACTI_PLUG_HOME}/boost_sql_myisam.sql
	fi

	if [ -n "${MYSQL_PASS}" ] ; then
		cacti-plugins_pkg_postinst
	fi
}

src_unpack() {
	default_src_unpack
	epatch "${FILESDIR}"/${P}-defaults.patch
}

src_install() {
	local _cachedir=${CACTI_HOME}/cache/png _piddir=/var/run/cacti
	dodir "${_cachedir}" "${_piddir}" || die "dodir"
	keepdir "${_cachedir}" "${_piddir}" || die "keepdir"
	fowners apache:apache "${_cachedir}" || die "fowners"
	fperms 775 "${_cachedir}" || die "fperms"
	newinitd "${FILESDIR}"/cacti-boost.rc-merged cacti-boost || die "newinitd"
	newconfd "${FILESDIR}"/cacti-boost.confd cacti-boost || die "newconfd"
	for i in boost_rrdupdate.php boost_server.php poller_boost.php ; do
		fperms 755 $i || die "fperms $i"
		# Boost README tells us to do this... yeah, right
		#fperms 4755 boost/$i
	done
	cacti-plugins_src_install
}
