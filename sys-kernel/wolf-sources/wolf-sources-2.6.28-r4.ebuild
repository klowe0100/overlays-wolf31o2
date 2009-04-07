# Copyright 1999-2009 Gentoo Foundation; 2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="7"

inherit kernel-2
detect_version
detect_arch

# This is the same as in tuxonice-sources-2.6.28-r3
TUXONICE_VERSION="20090214-v1"
TUXONICE_TARGET="2.6.28"
TUXONICE_SRC="current-tuxonice-for-${TUXONICE_TARGET}.patch-${TUXONICE_VERSION}"
TUXONICE_URI="http://www.tuxonice.net/downloads/all/${TUXONICE_SRC}.bz2"

# AHCI patch for ICH7-M (D620)
AHCI_PATCH="ahci_quirk_cleanup.diff"
AHCI_URI="http://www.codon.org.uk/~mjg59/tmp/${AHCI_PATCH}"

DESCRIPTION="TuxOnIce + Gentoo patchset + personal patched sources"
HOMEPAGE="http://dev.gentoo.org/~dsd/genpatches/ http://www.tuxonice.net"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI} ${TUXONICE_URI} ${AHCI_URI}"

UNIPATCH_LIST="${DISTDIR}/${TUXONICE_SRC}.bz2 ${DISTDIR}/${AHCI_PATCH}"
UNIPATCH_STRICTORDER="yes"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${RDEPEND}
		>=sys-apps/tuxonice-userui-0.7.3
		>=sys-power/hibernate-script-1.99"

K_EXTRAELOG="If there are issues with this kernel, please direct any
queries to the tuxonice-users mailing list:
http://lists.tuxonice.net/mailman/listinfo/tuxonice-users/"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}
