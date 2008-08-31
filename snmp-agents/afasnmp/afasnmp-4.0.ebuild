# Copyright 2008 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit rpm

MY_PV=${PV}-0
DESCRIPTION="Dell AACRAID-based PERC RAID controller SNMP agent."
HOMEPAGE="http://linux.dell.com/storage.html"
SRC_URI="ftp://ftp.dell.com/scsi-raid/afa-apps-snmp.2807420-A04.tar.gz"

LICENSE="Dell"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

RESTRICT="strip mirror test"

RDEPEND="!minimal? (
	snmp-mibs/adaptecarraycontroller )
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-compat )
	x86? (
		sys-libs/lib-compat
		sys-libs/ncurses )"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	rpm_unpack "${S}"/afasnmp-${MY_PV}.i386.rpm || die "failed to unpack RPM"
}

src_install() {
	dosbin usr/sbin/afasnmpd
	newinitd "${FILESDIR}"/afasnmpd.rc afasnmpd
}
