# Copyright 1999-2008 Gentoo Foundation ; 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=1

inherit eutils webapp depend.php

# Support for _p* in version.
MY_P=${P/_p*/}
# This is the Plugin Architecture version
PAV=2.4
HAS_PATCHES=1

DESCRIPTION="a complete frontend to rrdtool"
HOMEPAGE="http://www.cacti.net/"
SRC_URI="http://www.cacti.net/downloads/${MY_P}.tar.gz
	pluginarch? ( http://mirror.cactiusers.org/downloads/plugins/${PN}-plugin-${PV}-PA-v${PAV}.zip )"
#	pluginarch? ( http://cactiusers.org/downloads/cacti-plugin-arch.tar.gz )

# patches
if [ "${HAS_PATCHES}" == "1" ] ; then
	UPSTREAM_PATCHES="ping_timeout
					graph_search
					page_length_graph_view
					snmp_string_issue_with_rrdtool_creation"
	for i in $UPSTREAM_PATCHES ; do
		SRC_URI="${SRC_URI} http://www.cacti.net/downloads/patches/${PV/_p*}/${i}.patch"
	done
fi

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
RESTRICT=""
IUSE="+pluginarch +snmp"

DEPEND=""

need_php_cli
need_httpd_cgi
need_php_httpd

RDEPEND="snmp? ( net-analyzer/net-snmp )
	net-analyzer/rrdtool
	dev-php/adodb
	virtual/mysql
	virtual/cron"

# Most code shamelessly stolen from dobin and newbin
docron() {
	source "${PORTAGE_BIN_PATH:-/usr/lib/portage/bin}"/isolated-functions.sh

	if [[ $# -lt 1 ]] ; then
		vecho "$0: at least one argument needed" 1>&2
		exit 1
	fi

	if [[ ! -d ${D}${DESTTREE}/etc/cron.d ]] ; then
		install -d "${D}${DESTTREE}/etc/cron.d" || exit 2
	fi

	ret=0

	for x in "$@" ; do
		if [[ -e ${x} ]] ; then
			install -m0644 -o ${PORTAGE_INST_UID:-0} -g ${PORTAGE_INST_GID:-0}
			"${x}" "${D}${DESTTREE}/etc/cron.d"
		else
			echo "!!! ${0##*/}: $x does not exist" 1>&2
			false
		fi
		((ret+=$?))
	done

	return ${ret}
}

newcron() {
	if [[ -z ${T} ]] || [[ -z ${2} ]] ; then
		echo "$0: Need two arguments, old file and new file" 1>&2
		exit 1
	fi

	if [ ! -e "$1" ] ; then
		echo "!!! ${0##*/}: $1 does not exist" 1>&2
		exit 1
	fi

	rm -rf "${T}/${2}" && \
	cp -f "${1}" "${T}/${2}" && \
	exec docron "${T}/${2}"
}

src_unpack() {
	unpack ${MY_P}.tar.gz
	if use pluginarch; then
	#	unpack cacti-plugin-arch.tar.gz
		unpack cacti-plugin-${PV}-PA-v${PAV}.zip
		cd "${S}"
		sed -i -e '370 d' "${WORKDIR}"/cacti-plugin-${PV}-PA-v${PAV}.diff
		EPATCH_OPTS="-p1 -N -F3"
		epatch "${WORKDIR}"/cacti-plugin-${PV}-PA-v${PAV}.diff
		cp -f "${WORKDIR}"/pa.sql "${S}"
	fi
	if [ "${HAS_PATCHES}" == "1" ] ; then
		[ ! ${MY_P} == ${P} ] && mv ${MY_P} ${P}
		# patches
		EPATCH_OPTS="-p1 -N"
		for i in ${UPSTREAM_PATCHES} ; do
			epatch "${DISTDIR}"/${i}.patch
		done ;
	fi

	sed -i -e \
		's:$config\["library_path"\] . "/adodb/adodb.inc.php":"adodb/adodb.inc.php":' \
		"${S}"/include/global.php
}

pkg_setup() {
	webapp_pkg_setup
	has_php
	require_php_with_use cli mysql xml session pcre sockets
}

src_install() {
	webapp_src_preinst

	rm LICENSE README
	dodoc docs/{CHANGELOG,CONTRIB,INSTALL,README,REQUIREMENTS,UPGRADE,text/manual.txt}
	dohtml -r docs/html
	rm -rf docs
	rm -rf lib/adodb

	edos2unix `find -type f -name '*.php'`

	dodir ${MY_HTDOCSDIR}
	newcron "${FILESDIR}"/cacti-poller.crond cacti-poller
	cp -r . "${D}"${MY_HTDOCSDIR}

	webapp_serverowned ${MY_HTDOCSDIR}/rra
	webapp_serverowned ${MY_HTDOCSDIR}/log/cacti.log
	webapp_configfile ${MY_HTDOCSDIR}/include/config.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
