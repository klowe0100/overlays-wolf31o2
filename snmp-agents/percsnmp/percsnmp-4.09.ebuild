# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="SNMP Agent for LSI-based Dell PERC SCSI/RAID cards"
HOMEPAGE="http://linux.dell.com/storage.shtml"
SRC_URI="ftp://ftp.us.dell.com/ide/perc-cerc-apps-6.03-A06.tar.gz"

LICENSE="Dell"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

DEPEND=""
RDEPEND="net-analyzer/net-snmp
	!minimal? ( snmp-mibs/raid-adapter )"

S=${WORKDIR}/etc/percsnmp

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	unpack ./percsnmp-4.09-1.tar.gz
	unpack ./percsnmp/percsnmp.tgz
}

src_install() {
	insinto /etc/percsnmp
	keepdir /etc/percsnmp
	dosbin percagent percmain
	doins percsnmpd.conf percsnmptrap.conf
	dodoc readme.txt
	newinitd "${FILESDIR}"/percsnmpd.rc percsnmpd
}

pkg_postinst() {
	elog "You need to add the following to your /etc/snmp/snmpd.conf for this"
	elog "package to work:"
	echo
	elog "pass .1.3.6.1.4.1.3582 /usr/sbin/percmain"
}

# TODO: pkg_config to automatically configure snmpd.conf
