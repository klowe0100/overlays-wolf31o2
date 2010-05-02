# Copyright 1999-2010 Gentoo Foundation ; 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

MY_PV=${PV/./}0

inherit depend.php webapp

DESCRIPTION="media streaming and management system"
HOMEPAGE="http://www.jinzora.com"
SRC_URI="mirror://sourceforge/jinzora/jz${MY_PV}.tar.gz"

RESTRICT=""
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

need_httpd_cgi
need_php_httpd

# S=${WORKDIR}/${MY_PN}-${PV}

S=${WORKDIR}/${PN}2

pkg_setup() {
	webapp_pkg_setup
	has_php
	require_php_with_use mysql
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	touch settings.php
	doins -r .

	webapp_configfile "${MY_HTDOCSDIR}"/settings.php
	webapp_configfile "${MY_HTDOCSDIR}"/jukebox/settings.php

	webapp_serverowned "${MY_HTDOCSDIR}"/settings.php
	webapp_serverowned "${MY_HTDOCSDIR}"/jukebox/settings.php
	webapp_serverowned -R "${MY_HTDOCSDIR}"/data
	webapp_serverowned -R "${MY_HTDOCSDIR}"/temp

	webapp_src_install
}
