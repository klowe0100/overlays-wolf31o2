# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/afacli/afacli-4.1.ebuild,v 1.1 2008/05/24 10:41:57 wschlich Exp $

inherit rpm

MY_PV=${PV}-0
DESCRIPTION="Adaptec/Dell AACRAID-based RAID controller SNMP MIB."
HOMEPAGE="http://linux.dell.com/storage.html"
SRC_URI="ftp://ftp.dell.com/scsi-raid/afa-apps-snmp.2807420-A04.tar.gz"

LICENSE="Dell"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="mirror"

RDEPEND=""
DEPEND=""

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	rpm_unpack "${S}"/afasnmp-${MY_PV}.i386.rpm || die "failed to unpack RPM"
}

src_install() {
	insinto /usr/share/snmp/mibs
	newins usr/share/snmp/mibs/afa-MIB.txt AdaptecArrayController-MIB.txt
}
