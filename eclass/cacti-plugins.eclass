# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

#
# Original Author: Chris Gianelloni <wolf31o2@wolf31o2.org>
# Purpose: Provide a framework for installing Cacti plugins via the Cacti
# Plugin Architecture patch.

# We don't actually need webapp-config for this.
WEBAPP_OPTIONAL="yes"

inherit eutils mysql-dbfuncs webapp

case "${EAPI:-0}" in
	0|1)
		EXPORT_FUNCTIONS pkg_setup src_install pkg_postinst
		DEPEND=">=net-analyzer/cacti-0.8.7b-r4"
		;;
	*)
		EXPORT_FUNCTIONS src_install pkg_postinst
		DEPEND=">=net-analyzer/cacti-0.8.7d-r2[pluginarch]"
		;;
esac

# Variables to specify in an ebuild which uses this eclass:
# TODO: Add this section's docs
export CACTI_HOME=${CACTI_HOME:-/var/www/localhost/htdocs/cacti}
export CACTI_SQL_DBNAME=${CACTI_SQL_DBNAME:-cacti}

export CACTI_PLUG_BASE="http://mirror.cactiusers.org/downloads/plugins"
export CACTI_PLUG_NAME=${PN}
export CACTI_PLUG_HOME=${CACTI_HOME}/plugins/${CACTI_PLUG_NAME}

export MYSQL_DBNAME=${CACTI_SQL_DBNAME}

DESCRIPTION="Cacti plugin: ${CACTI_PLUG_NAME}"
HOMEPAGE="http://cactiusers.org/downloads"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="primaryuri"

RDEPEND="${DEPEND}"

cacti-plugins_cleanup_adodb_includes() {
	einfo "Switching to system adodb"
	sed -i -e \
		's:$config\["library_path"\] . "/adodb/adodb.inc.php":"adodb/adodb.inc.php":' \
		"$@" || die "Failed sed for adodb"
}
cacti-plugins_pkg_setup() {
	if has_version \<net-analyzer/cacti-0.8.7d-r2 ; then
		if built_with_use --missing ok \>=net-analyzer/cacti-0.8.7d-r2 plugins pluginarch; then
			einfo "Found Cacti Plugin Architecture"
		else
			die "Need net-anaylzer/cacti with USE=pluginarch"
		fi
	fi
}

cacti-plugins_src_install() {
	local __phpfiles=`find -type f -name '*.php'`
	insinto ${CACTI_PLUG_HOME}

	edos2unix ${__phpfiles}
	cacti-plugins_cleanup_adodb_includes ${__phpfiles}
	doins -r * || die "Failed installing"
}

cacti-plugins_pkg_postinst() {
	### TODO: make this *way* smarter
	[ -n "${DO_MYSQL_INSTALL}" ] && [ -n "${MYSQL_SCRIPTS}" ] && mysql-dbfuncs_load_sql
}

