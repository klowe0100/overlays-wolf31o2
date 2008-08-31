# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="MIB for LSI-based SCSI RAID controllers"
HOMEPAGE="http://linux.dell.com/storage.shtml"
SRC_URI="ftp://ftp.us.dell.com/ide/perc-cerc-apps-6.03-A06.tar.gz"

LICENSE="Dell"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/etc/percsnmp

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"
	unpack ./percsnmp-4.09-1.tar.gz
	unpack ./percsnmp/percsnmp.tgz
}

src_install() {
	insinto /usr/share/snmp/mibs
	sed \
		-e 's/not_available/notavailable/' \
		-e 's/fastest_possible/fastestpossible/' \
		"${S}"/perc.mib > "${T}"/RAID-Adapter-MIB.txt || die "sed"
	doins "${T}"/RAID-Adapter-MIB.txt
}

pkg_postinst() {
	if [ -e "${ROOT}"/etc/snmp/snmp.conf ]
	then
		grep \
		'^mibs.*RAID-Adapter-MIB' \
		"${ROOT}"/etc/snmp/snmp.conf >/dev/null 2>&1 || need_snmp_conf="yes"
	else
		need_snmp_conf="yes"
	fi
	if [ "$need_snmp_conf" == "yes" ]
	then
		elog "You need to add the following to your ${ROOT}etc/snmp/snmp.conf"
		elog "for this package to work:"
		elog "mibs +RAID-Adapter-MIB"
		echo
	fi
}

# TODO: pkg_config to automatically configure snmp.conf
