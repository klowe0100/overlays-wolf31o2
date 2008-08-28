# Copyright 2008 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cacti-plugins

SRC_URI="${PLUG_BASE}/${PLUG_NAME}-${PV}.tar.gz"

LICENSE="GPL-2"
IUSE="memory"

DEPEND="${DEPEND}
	memory? ( >=virtual/mysql-5 )"

pkg_setup() {
	if use memory ; then
		SQL_SCRIPTS=${PLUG_HOME}/boost_sql_memory.sql
	else
		SQL_SCRIPTS=${PLUG_HOME}/boost_sql_myisam.sql
	fi
	cacti-plugins_pkg_setup
}

src_install() {
	local dir=${CACTI_HOME}/cache/png
	dodir "${dir}"
	keepdir "${dir}"
	fowners apache:apache "${dir}"
	fperms 775 "${dir}"
	edos2unix *.php
	if use memory ; then
		newinitd "${FILESDIR}"/cacti-boost.rc.memory cacti-boost
	else
		newinitd "${FILESDIR}"/cacti-boost.rc cacti-boost
	fi
	newconfd "${FILESDIR}"/cacti-boost.confd cacti-boost
	cacti-plugins_src_install
}
