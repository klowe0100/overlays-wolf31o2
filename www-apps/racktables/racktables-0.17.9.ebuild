# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/websvn/websvn-2.1.0.ebuild,v 1.3 2009/05/25 18:58:35 ranger Exp $

inherit depend.php eutils webapp

MY_PN="RackTables"

DESCRIPTION="datacenter and server room asset management"
HOMEPAGE="http://www.racktables.org/"
#SRC_URI="http://www.racktables.org/files/${MY_PN}-${PV}.tar.gz"
SRC_URI="mirror://sourceforge/racktables/${MY_PN}-${PV}.tar.gz"

RESTRICT=""
LICENSE="GPL-2"
IUSE=""
KEYWORDS="~amd64 ~x86"

need_httpd_cgi
need_php_httpd

S=${WORKDIR}/${MY_PN}-${PV}

pkg_setup() {
	webapp_pkg_setup
	has_php
	if [[ ${PHP_VERSION} == "4" ]] ; then
		require_php_with_use expat
	else
		require_php_with_use mysql
	fi
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
