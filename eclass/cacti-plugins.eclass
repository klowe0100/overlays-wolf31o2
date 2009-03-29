# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: Chris Gianelloni <wolf31o2@wolf31o2.org>
# Purpose: Provide a framework for installing Cacti plugins via the unofficial
# Cacti Plugin Architecture patch.

CACTI_PLUG_BASE="http://mirror.cactiusers.org/downloads/plugins"

# We don't actually need webapp-config for this.
WEBAPP_OPTIONAL="yes"

inherit eutils mysql-dbfuncs # webapp

EXPORT_FUNCTIONS pkg_setup src_install pkg_postinst

# Variables to specify in an ebuild which uses this eclass:
# TODO: Add this section

CACTI_HOME=${CACTI_HOME:-/var/www/localhost/htdocs/cacti}
CACTI_PLUG_NAME=${PN}
CACTI_PLUG_HOME=${CACTI_HOME}/plugins/${CACTI_PLUG_NAME}
CACTI_SQL_DBNAME=${CACTI_SQL_DBNAME:-cacti}

DESCRIPTION="Cacti plugin: ${CACTI_PLUG_NAME}"
HOMEPAGE="http://cactiusers.org/downloads"

SLOT="0"
LICENSE="freedist"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT=""

# We require Cacti with USE=plugins
DEPEND=">=net-analyzer/cacti-0.8.7b-r3"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${CACTI_PLUG_NAME}

cacti-plugins_pkg_setup() {
	if ! built_with_use net-analyzer/cacti plugins; then
		die "Need net-anaylzer/cacti with USE=plugins"
	fi
}

cacti-plugins_src_install() {
	insinto ${CACTI_PLUG_HOME}
	edos2unix `find -type f -name '*.php'`
	doins -r * || die "Failed installing"
}

cacti-plugins_pkg_postinst() {
	mysql-dbfuncs_load_sql
}
