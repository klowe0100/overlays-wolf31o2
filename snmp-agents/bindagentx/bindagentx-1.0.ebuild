# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="Script for BIND 9.5+ SNMP statistics via AgentX protocol"
HOMEPAGE="http://svn.durchmesser.ch/trac/bindagentx/"
SRC_URI="http://svn.durchmesser.ch/trac/bindagentx/changeset/27/tags/${P}?old_path=%2F&format=zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+mib"

DEPEND=""
RDEPEND="dev-lang/perl
	virtual/perl-Sys-Syslog
	net-analyzer/net-snmp[perl]
	>=net-dns/bind-9.5
	mib? ( ~snmp-mibs/durchmesser-bind-${PV} )"

S=${WORKDIR}/tags/${P}

src_prepare() {
	# Typo fixes
	sed -i \
		-e 's/startet/started/' \
		-e 's/Shuting/Shutting/' \
		bindagentx.pl
}

src_install() {
	# This is the daemon script
	dosbin bindagentx.pl
	# Install Cacti code
	docinto cacti/resource
	dodoc -r cacti/snmp_queries
	docinto cacti/templates
	newdoc cacti/bind_cachedb.xml cacti_data_query_bind_cachedb.xml
	newdoc cacti/bind_incoming_requests.xml \
		cacti_graph_template_bind_incoming_requests.xml
	newdoc cacti/bind_request_protocol.xml \
		cacti_graph_template_bind_request_protocol.xml
	newdoc cacti/bind_zone_query.xml \
		cacti_data_query_bind_zone_query.xml
}

pkg_postinst() {
	if [ -e "${ROOT}"/etc/snmp/snmp.conf ]
	then
		grep \
		'^mibs.*DURCHMESSER-BIND-MIB' \
		"${ROOT}"/etc/snmp/snmp.conf >/dev/null 2>&1 || need_snmp_conf="yes"
	else
		need_snmp_conf="yes"
	fi
	if [ -e "${ROOT}"/etc/snmp/snmpd.conf ]
	then
		### TODO: check for AgentX availability
		need_snmpd_conf="yes"
	fi
	if [ -e "${ROOT}"/etc/bind/named.conf ]
	then
		grep \
		'statistics-file.*/var/bind/named.stats.*' \
		"${ROOT}"/etc/bind/named.conf >/dev/null 2>&1 || need_stats_file="yes"
		grep \
		'zone-statistics.*yes.*' \
		"${ROOT}"/etc/bind/named.conf >/dev/null 2>&1 || need_zone_stats="yes"
	else
		need_stats_file="yes"
		need_zone_stats="yes"
	fi
	if [ "$need_snmpd_conf" == "yes" ]
	then
		elog "You need to enable AgentX support."
		echo
	fi
	if [ "$need_snmp_conf" == "yes" ]
	then
		elog "You need to add the following to your ${ROOT}etc/snmp/snmp.conf"
		elog "for this package to work:"
		elog "mibs +DURCHMESSER-MIB:DURCHESSER-BIND-MIB"
		echo
	fi
	if [ "$need_stats_file" == "yes" ]
	then
		elog "You need to add the following to your ${ROOT}etc/bind/named.conf"
		elog "for this package to work:"
		elog 'statistics-file "/var/bind/named.stats";'
		echo
	fi
	if [ "$need_zone_stats" == "yes" ]
	then
		elog "If you would like to collect per-zone statistics, you will also"
		elog "need to configure BIND to log zone statistics with:"
		elog "zone-statistics yes;"
		elog "in your global options, view options, or zone options, depending"
		elog "on where you want to collect zone statistics."
		echo
	fi
}

# TODO: pkg_config to automatically configure snmp.conf/snmpd.conf
