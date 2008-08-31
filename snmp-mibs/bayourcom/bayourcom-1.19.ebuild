# Copyright 2008-2008 Quova, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Bayour.com MIB (Bacula/Bind9)"
HOMEPAGE="http://www.bayour.com/bind9-snmp/"
SRC_URI="http://www.bayour.com/bind9-snmp/bind9-snmp_1.7.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/bind94.patch
}

src_install() {
	insinto /usr/share/snmp/mibs
	doins BAYOUR-COM-MIB.txt
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
	if [ "$need_snmp_conf" == "yes" ]
	then
		elog "You need to add the following to your ${ROOT}etc/snmp/snmp.conf"
		elog "for this package to work:"
		elog "mibs +BAYOUR-COM-MIB:UCD-SNMP-MIB"
		echo
	fi
}

# TODO: pkg_config to automatically configure snmp.conf
