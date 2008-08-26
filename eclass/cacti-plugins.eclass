# Copyright 2008 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: Chris Gianelloni <wolf31o2@wolf31o2.org>
# Purpose: Provide a framework for installing Cacti plugins via the unofficial
# Cacti Plugin Architecture patch.

PLUG_BASE="http://mirror.cactiusers.org/downloads/plugins"

# We don't actually need webapp-config for this.
WEBAPP_OPTIONAL="yes"

inherit eutils # webapp

EXPORT_FUNCTIONS pkg_setup src_install pkg_postinst

# Variables to specify in an ebuild which uses this eclass:
# TODO: Add this section

# PLUG_NAME
PLUG_NAME=${PN/cacti-plugins-/}

DESCRIPTION="Cacti plugin: ${PLUG_NAME}"

SLOT="0"
LICENSE="freedist"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT=""

# We require Cacti with USE=plugins
DEPEND=">=net-analyzer/cacti-0.8.7b-r3"

S=${WORKDIR}/${PLUG_NAME}

CACTI_HOME="/var/www/localhost/htdocs/cacti"
CACTI_SQLADMIN="root"

cacti-plugins_setup_mysql() {
	if [ -n "${MYSQL_PASS}" ] ; then
		MYSQL_AUTH="-p${MYSQL_PASS}"
	else
		MYSQL_AUTH=""
	fi
	if [ -n "${SQL_SCRIPTS}" ] ; then
		einfo "Installing MySQL code for ${PLUG_NAME}"
		for sql in ${SQL_SCRIPTS} ; do
			einfo "Installing ${sql}"
			mysql -u${CACTI_SQLADMIN} ${MYSQL_AUTH} cacti < \
				${CACTI_HOME}/plugins/${PLUG_NAME}/$sql
		done
	fi
}

cacti-plugins_add_plugin_to_conf() {
	# Here, we need to grab the current plugin list and add ours to it.
	:
}

cacti-plugins_pkg_setup() {
	if ! built_with_use net-analyzer/cacti plugins; then
		die "Need net-anaylzer/cacti with USE=plugins"
	fi
}

cacti-plugins_src_install() {
	insinto ${CACTI_HOME}/plugins/${PLUG_NAME}
	doins *.php *.sql
}

cacti-plugins_pkg_postinst() {
	cacti-plugins_setup_mysql
}
