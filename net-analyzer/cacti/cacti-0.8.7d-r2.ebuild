# Copyright 1999-2008 Gentoo Foundation ; 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id: bc4c71762197f349daa6dc41180894ebfaf3b0ac $

EAPI=1

inherit eutils webapp depend.php

# Support for _p* in version
MY_P=${P/_p*/}
MY_PV=${PV/_p*/}

# This is the Plugin Architecture version
PIA_V=2.4

# Are there any official patches?
HAS_PATCHES=1

CACTI_BASE_URI="http://www.cacti.net/downloads"
CACTI_PLUG_URI="http://mirror.cactiusers.org/downloads"

DESCRIPTION="a complete frontend to rrdtool"
HOMEPAGE="http://www.cacti.net/"
SRC_URI="${CACTI_BASE_URI}/${MY_P}.tar.gz
	pluginarch? ( ${CACTI_PLUG_URI}/plugins/${PN}-plugin-${MY_PV}-PA-v${PIA_V}.zip )"

# patches
if [ "${HAS_PATCHES}" == "1" ] ; then
	UPSTREAM_PATCHES="ping_timeout
					graph_search
					snmp_string_issue_with_rrdtool_creation"
					# page_length_graph_view (before snmp_string...)
	for i in ${UPSTREAM_PATCHES} ; do
		SRC_URI="${SRC_URI} ${CACTI_BASE_URI}/patches/${PV/_p*}/${i}.patch"
	done
fi

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
RESTRICT=""
IUSE="ldap +pluginarch +snmp"

DEPEND=""

need_php_cli
need_httpd_cgi
need_php_httpd

RDEPEND="dev-php/adodb
	net-analyzer/rrdtool
	snmp? ( net-analyzer/net-snmp )
	ldap? ( net-nds/openldap )
	virtual/mysql
	virtual/cron"

# Most code shamelessly stolen from dobin and newbin
docrond() {
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

newcrond() {
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
	exec docrond "${T}/${2}"
}

src_unpack() {
	# The first thing we do is unpack our sources
	unpack ${MY_P}.tar.gz
	# Add any official patches from upstream
	if [ "${HAS_PATCHES}" == "1" ] ; then
		[ ! ${MY_P} == ${P} ] && mv ${MY_P} ${P}
		# patches
		for i in ${UPSTREAM_PATCHES} ; do
			EPATCH_OPTS="-p1 -d ${S} -N" epatch "${DISTDIR}"/${i}.patch
		done ;
	fi

	# Add the Plugin Architecture
	if use pluginarch; then
		unpack cacti-plugin-${MY_PV}-PA-v${PIA_V}.zip
		cd "${S}"
		sed -i -e '370 d' "${WORKDIR}"/cacti-plugin-${MY_PV}-PA-v${PIA_V}.diff
		EPATCH_OPTS="-p1 -N -d ${S} -F4" \
			epatch "${WORKDIR}"/cacti-plugin-${MY_PV}-PA-v${PIA_V}.diff
		cp -f "${WORKDIR}"/pa.sql "${S}"
	fi

	# Use sed-fu to use the system adodb, rather than the bundled one
	sed -i -e \
		's:$config\["library_path"\] . "/adodb/adodb.inc.php":"adodb/adodb.inc.php":' \
		"${S}"/include/global.php
}

pkg_setup() {
	### TODO:
	### - check for USE=sharedext for PHP and act accordingly
	### - check for SSL/SASL and act accordingly (including LDAP!)

	local __extra_php_flags= __default_php_flags="cli mysql xml session pcre sockets"
	webapp_pkg_setup
	has_php

	# Check if SNMP support is requested
	if use snmp; then
		__extra_php_flags="snmp"
		einfo "Enabling built-in SNMP support (recommended)"
	else
		ewarn "Disabling built-in SNMP support (not recommended)"
	fi

	# Check if LDAP authentication is requested
	if use ldap; then
		__extra_php_flags="$__extra_php_flags ldap"
		einfo "Enabling built-in LDAP authentication support"
	else
		ewarn "Disabling built-in LDAP authentication support"
		einfo "You can still use LDAP authentication via Web Basic"
		einfo "authentication on your web server."
	fi

	# Now, check if our PHP has everything that it needs
	require_php_with_use $_default_php_flags $__extra_php_flags
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
	newcrond "${FILESDIR}"/cacti-poller.crond cacti-poller
	cp -r . "${D}"${MY_HTDOCSDIR}

	webapp_serverowned ${MY_HTDOCSDIR}/rra
	webapp_serverowned ${MY_HTDOCSDIR}/log/cacti.log
	webapp_configfile ${MY_HTDOCSDIR}/include/config.php
	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}
