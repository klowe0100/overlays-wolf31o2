# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

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

pkg_setup() {
	webapp_pkg_setup
	has_php
	require_php_with_use mysql
}

src_install() {
	webapp_src_preinst
	dodir ${MY_HTDOCSDIR}

	cp -r . "${D}"${MY_HTDOCSDIR}

	insinto "${MY_HTDOCSDIR}"
	doins -r .

#	webapp_configfile "${MY_HTDOCSDIR}"/include/config.php
#	webapp_configfile "${MY_HTDOCSDIR}"/wsvn.php

#	webapp_serverowned "${MY_HTDOCSDIR}"/cache

	webapp_src_install
}
