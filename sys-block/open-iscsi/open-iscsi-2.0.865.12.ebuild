# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/open-iscsi/open-iscsi-1.0.514.ebuild,v 1.2 2006/05/23 01:55:46 robbat2 Exp $

inherit versionator linux-mod eutils flag-o-matic

DESCRIPTION="Open-iSCSI project is a high performance, transport independent, multi-platform implementation of RFC3720."
HOMEPAGE="http://www.open-iscsi.org/"
MY_PV="$(replace_version_separator 2 '-')"
MY_SVN_R=865
MY_P="${PN}-${MY_PV}"
#http://www.open-iscsi.org/bits/open-iscsi-2.0-865.12.tar.gz
SRC_URI="http://www.open-iscsi.org/bits/${MY_P}.tar.gz"
#SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"
DEPEND="virtual/libc
		virtual/linux-sources"
RDEPEND="${DEPEND}
		virtual/modutils
		sys-apps/util-linux"

S="${WORKDIR}/${MY_P}"

MODULE_NAMES_ARG="kernel/drivers/scsi:${S}/kernel"
MODULE_NAMES="iscsi_tcp(${MODULE_NAMES_ARG}) scsi_transport_iscsi(${MODULE_NAMES_ARG}) libiscsi(${MODULE_NAMES_ARG})"
BUILD_TARGETS="all"
CONFIG_CHECK="CRYPTO_CRC32C"
ERROR_CFG="open-iscsi needs CRC32C support in your kernel."

src_unpack() {
	unpack ${A}
	#export EPATCH_OPTS="-d${S}/kernel -p0"
	export EPATCH_OPTS="-d${S}"
	if [ $KV_PATCH -lt 15 ]; then
		die "Sorry, your kernel must be 2.6.16-rc5 or newer!"
	elif [ $KV_PATCH -eq 16 ]; then
		einfo "2.6.16 or newer found."
		einfo "Please file a bug if this does not compile."
	fi

	# clean up some junk
	find ${S} -name '*~' -exec rm \{} \; >/dev/null 2>/dev/null

	# O_EXCL locking on idbm files
	#epatch ${FILESDIR}/r438-idbm-file-locking.diff

	#EPATCH_OPTS="-p0 -d${S}" \
	#epatch ${FILESDIR}/open-iscsi-488-udev.patch

	# Converts the close on error to a log message
	#epatch ${FILESDIR}/${PN}-485-out.state.patch
}


src_compile() {
	use debug && append-flags -DDEBUG_TCP -DDEBUG_SCSI

	einfo "Building kernel modules"
	export KSRC="${KERNEL_DIR}"
	linux-mod_src_compile || die "failed to build modules"
	einfo "Building userspace"
	cd ${S}/usr && \
		CFLAGS="" emake OPTFLAGS="${CFLAGS}" \
		|| die "emake failed"
}

src_install() {
	einfo "Installing kernel modules"
	export KSRC="${KERNEL_DIR}"
	#S=${S}/kernel 
	linux-mod_src_install

	einfo "Installing userspace"
	dosbin usr/iscsid usr/iscsiadm usr/iscsistart

	einfo "Installing docs"
	doman doc/*[1-8]
	dodoc README THANKS
	docinto test
	dodoc test/*

	einfo "Installing configuration"
	insinto /etc
	doins etc/iscsid.conf
	doins ${FILESDIR}/initiatorname.iscsi
	newinitd ${FILESDIR}/iscsid-init.d iscsid

	# This is for later
	# dosbin usr/iscsi_id
	#insinto /etc/udev/rules.d/
	#doins doc/iscsi-55.rules

	# security
	keepdir /var/db/iscsi
	fperms 700 /var/db/iscsi
	fperms 600 /etc/iscsid.conf
}

pkg_postinst() {
	linux-mod_pkg_postinst
	[ -d ${ROOT}/var/db/iscsi ] && chmod 700 ${ROOT}/var/db/iscsi
	[ -f ${ROOT}/etc/iscsid.conf ] && chmod 600 ${ROOT}/etc/iscsid.conf
}
