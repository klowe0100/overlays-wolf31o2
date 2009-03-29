# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils cacti-plugins

SRC_URI="${CACTI_PLUG_BASE}/${CACTI_PLUG_NAME}-${PV}.tar.gz"

LICENSE="GPL-2"
IUSE="memory"

DEPEND="${DEPEND}
	memory? ( >=virtual/mysql-5 )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if use memory ; then
		MYSQL_SCRIPTS=${CACTI_PLUG_HOME}/boost_sql_memory.sql
	else
		MYSQL_SCRIPTS=${CACTI_PLUG_HOME}/boost_sql_myisam.sql
	fi
	ebegin "Flushing Boost Poller Tables"
	if [ -e "${CACTI_PLUG_BASE}/${CACTI_PLUG_NAME}" ]
	then
		/usr/bin/php -q \
			${CACTI_PLUG_BASE}/${CACTI_PLUG_NAME}/poller_boost.php -f > \
			/dev/null 2>&1
	fi
	eend $?
	cacti-plugins_pkg_setup
}

src_install() {
	local dir=${CACTI_HOME}/cache/png
	dodir "${dir}"
	keepdir "${dir}"
	fowners apache:apache "${dir}"
	fperms 775 "${dir}"
	edos2unix `find -type f -name '*.php'`
	if use memory ; then
		newinitd "${FILESDIR}"/cacti-boost.rc.memory cacti-boost
	else
		newinitd "${FILESDIR}"/cacti-boost.rc cacti-boost
	fi
	newconfd "${FILESDIR}"/cacti-boost.confd cacti-boost
	cacti-plugins_src_install
}
