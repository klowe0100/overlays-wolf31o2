# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

CACTI_PLUG_SUPPORTED="yes"
#PLUGIN_NEEDS_SQL="yes"
#MYSQL_SCRIPTS="discover.sql"

inherit eutils cacti-plugins

S=${WORKDIR}/${PN}_v${PV}
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default_src_prepare
	epatch "${FILESDIR}"/${PV}/*
	sed -i 's/plugin_discover_os/plugin_discover_template/g' findhosts.php
}
