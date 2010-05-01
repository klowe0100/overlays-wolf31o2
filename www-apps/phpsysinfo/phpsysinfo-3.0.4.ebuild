# Copyright 1999-2008 Gentoo Foundation ; 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils webapp depend.php

DESCRIPTION="nice package that will display your system stats via PHP"
HOMEPAGE="http://phpsysinfo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/${PN}

need_httpd_cgi
need_php_httpd

pkg_setup() {
	webapp_pkg_setup
	require_php_with_use pcre xml
}

src_install() {
	webapp_src_preinst

	dodoc README

	insinto "${MY_HTDOCSDIR}"
	doins -r [:dit:]*
	newins config.php{.new,}

	webapp_configfile "${MY_HTDOCSDIR}"/config.php
	webapp_src_install
}
