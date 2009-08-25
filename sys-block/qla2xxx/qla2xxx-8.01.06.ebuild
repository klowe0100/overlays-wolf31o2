# Copyright 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit linux-info

DESCRIPTION="drivers for QLogic HBAs"
HOMEPAGE="http://driverdownloads.qlogic.com/QLogicDriverDownloads_UI/default.aspx"
SRC_URI="qla2xxx-v${PV}-dist.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/qlogic/${P}

src_unpack() {
	unpack ${A}
	cd ${WORKDIR}/qlogic
	unpack ./${PN}-src-v${PV}.tar.gz
}

src_prepare() {
	# KV_FULL == full version
	# KERNEL_DIR == path to sources
	sed -i "s:\`uname -r\`:${KV_FULL}:" extras/build.sh || die "sed uname"
	sed -i "s:pci_module_init:pci_register_driver:" *.c || die "sed *.c"
}

src_compile() {
	extras/build.sh || die "Build failed." || die "failed compile"
}
