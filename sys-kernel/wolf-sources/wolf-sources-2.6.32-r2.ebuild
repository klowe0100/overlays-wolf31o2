# Copyright 1999-2009 Gentoo Foundation ; 2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="2"
inherit kernel-2
detect_version
detect_arch

KEYWORDS="~amd64 ~x86"
IUSE="+perl"
HOMEPAGE="http://dev.gentoo.org/~dsd/genpatches"

DESCRIPTION="Full sources including the Gentoo patchset and patches from wolf31o2 for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"

RDEPEND="${RDEPEND}
	perl? ( dev-lang/perl )"

pkg_setup() {
	if ! use perl ; then
		ewarn "perl is required for the new 'make localmodconfig' target."
	else
		elog "Starting with 2.6.32, there is a new 'make localmodconfig' target"
		elog "which builds a kernel using the current .config and all currently"
		elog "loaded modules, as modules.  The 'make localyesconfig' does the"
		elog "same, except it compiles the modules into the kernel image."
	fi
	kernel-2_pkg_setup
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

src_prepare() {
	# Fix incorrect lsmod location for localmodconfig and localyesconfig targets
	sed -i \
		-e 's:/sbin/lsmod:/bin/lsmod:' \
		scripts/kconfig/streamline_config.pl || die "sed"
}
