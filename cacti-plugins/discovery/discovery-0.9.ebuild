# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils cacti-plugins

SRC_URI="http://docs.cacti.net/_media/plugin:${PN}_v${PV}.tar.gz -> ${PN}_v${PV}.tar.gz"

LICENSE="GPL-2"

MYSQL_SCRIPTS="${CACTI_PLUG_HOME}/discover.sql"

#src_unpack() {
#	unpack ${A}
#	cd "${S}"
#	epatch "${FILESDIR}"/${PVR}/*.patch || die
#}
