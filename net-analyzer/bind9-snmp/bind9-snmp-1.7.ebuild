# Copyright 2008-2008 Quova, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module eutils

DESCRIPTION="Scripts for BIND SNMP statistics"
HOMEPAGE="http://www.bayour.com/bind9-snmp/"
SRC_URI="http://www.bayour.com/bind9-snmp/${PN}_${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl
	net-analyzer/net-snmp
	net-dns/bind"

src_unpack() {
	unpack ${A}
	cd "${S}"
#	epatch "${FILESDIR}"/${P}-bind94.patch
	epatch "${FILESDIR}"/${P}-config.patch
}

src_install() {
	perlinfo
	insinto /usr/share/snmp/mibs
	doins BAYOUR-COM-MIB.txt
	dosbin bind9-snmp-stats.pl
	insinto /etc/snmp
	doins "${FILESDIR}"/bind9-snmp.conf
	insinto "${SITE_LIB}"
	doins BayourCOM_SNMP.pm
	dodoc README.txt UPGRADE.txt snmp{,d}.conf.stub
	docinto cacti
	dodoc bind9-stats_*.xml cacti_*
}

pkg_postinst() {
	if [ -e "${ROOT}"/etc/snmp/snmp.conf ]
	then
		grep \
		'^mibs.*BAYOUR-COM-MIB' \
		"${ROOT}"/etc/snmp/snmp.conf >/dev/null 2>&1 || need_snmp_conf="yes"
	else
		need_snmp_conf="yes"
	fi
	if [ -e "${ROOT}"/etc/snmp/snmpd.conf ]
	then
		grep \
		'^pass_persist.*.1.3.6.1.4.1.8767.2.1.*/usr/sbin/bind9-snmp-stats.pl' \
		"${ROOT}"/etc/snmp/snmpd.conf >/dev/null 2>&1 || need_snmpd_conf="yes"
	else
		need_snmpd_conf="yes"
	fi
	if [ -e "${ROOT}"/etc/bind/named.conf ]
	then
		grep \
		'statistics-file.*/var/tmp/dns-stats.log.*' \
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
		elog "You need to add the following to your ${ROOT}etc/snmp/snmpd.conf"
		elog "for this package to work:"
		elog "pass_persist .1.3.6.1.4.1.8767.2.1 /usr/sbin/bind9-snmp-stats.pl"
		echo
	fi
	if [ "$need_snmp_conf" == "yes" ]
	then
		elog "You need to add the following to your ${ROOT}etc/snmp/snmp.conf"
		elog "for this package to work:"
		elog "mibs +BAYOUR-COM-MIB:UCD-SNMP-MIB"
		echo
	fi
	if [ "$need_stats_file" == "yes" ]
	then
		elog "You need to add the following to your ${ROOT}etc/bind/named.conf"
		elog "for this package to work:"
		elog 'statistics-file "/var/tmp/dns-stats.log";'
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
