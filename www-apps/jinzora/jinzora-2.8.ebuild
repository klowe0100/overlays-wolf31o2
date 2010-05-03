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

DB_IUSE="mssql mysql postgres sqlite"

IUSE="${DB_IUSE}"

need_httpd_cgi
need_php_httpd

RDEPEND="${RDEPEND}
	media-sound/lame"

S=${WORKDIR}/${PN}2

pkg_setup() {
	webapp_pkg_setup
	has_php
	require_php_with_use session
	for db in ${DB_IUSE} ; do
		use ${db} && require_php_with_use ${db}
	done
	# - Requires register globals off
	# - gd iconv pdf multibyte-char are optional, as are the db backends
	# - max_execution_time = 300+
	# - memory_limit = 32M+
	# - post_max_size = 32M+
	# - file_uploads = on
	# - upload_max_filesize = 32M+
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
