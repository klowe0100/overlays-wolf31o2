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

inherit eutils mysql-dbfuncs # webapp

EXPORT_FUNCTIONS pkg_setup src_install pkg_postinst

# Variables to specify in an ebuild which uses this eclass:
# TODO: Add this section

CACTI_HOME=${CACTI_HOME:-/var/www/localhost/htdocs/cacti}
PLUG_NAME=${PN/cacti-plugins-/}
PLUG_HOME=${CACTI_HOME}/plugins/${PLUG_NAME}
MYSQL_DBNAME=${MYSQL_DBNAME:-cacti}

DESCRIPTION="Cacti plugin: ${PLUG_NAME}"

SLOT="0"
LICENSE="freedist"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT=""

# We require Cacti with USE=plugins
DEPEND=">=net-analyzer/cacti-0.8.7b-r3"

S=${WORKDIR}/${PLUG_NAME}

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
	insinto ${PLUG_HOME}
	doins *.php *.sql
	for source_dir in html images include lib ; do
		if [ -d ${source_dir} ] ; then
			doins -r ${source_dir} || die "Failed installing ${source_dir}!"
		fi
	done
}

cacti-plugins_pkg_postinst() {
	mysql-dbfuncs_load_sql
}
