# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

CACTI_PLUG_SUPPORTED="yes"
PLUGIN_NEEDS_SQL="yes"
MYSQL_SCRIPTS="${PN}.sql"

inherit eutils cacti-plugins

SRC_URI="http://docs.cacti.net/_media/plugin:${PN}-latest.tgz -> ${P}.tar.gz"

RDEPEND="${RDEPEND} virtual/tftp"

src_prepare() {
	default_src_prepare
	epatch "${FILESDIR}"/${PV}/*
	sed -i -e 's/0.1/0.2/' setup.php || die
}
