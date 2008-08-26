# Copyright 2008 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit cacti-plugins

SRC_URI="${PLUG_BASE}/${PLUG_NAME}-${PV}.tar.gz"

LICENSE="GPL-2"
IUSE="memory"

DEPEND="${DEPEND}
	memory? ( >=virtual/mysql-5 )"

pkg_setup() {
	if use memory ; then
		SQL_SCRIPTS="boost_sql_memory.sql"
	else
		SQL_SCRIPTS="boost_sql_myisam.sql"
	fi
	cacti-plugins_pkg_setup
}

src_install() {
	local dir=${CACTI_HOME}/cache/png
	dodir "${dir}"
	keepdir "${dir}"
	fowners apache:apache "${dir}"
	fperms 775 "${dir}"
	cacti-plugins_src_install
}
