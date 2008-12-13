# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cisco-vpnclient-3des/cisco-vpnclient-3des-4.8.00.0490.ebuild,v 1.9 2007/08/28 20:58:08 wolf31o2 Exp $

inherit eutils linux-mod

MY_PV=${PV}-k9
TARBALL="vpnclient-linux-x86_64-${MY_PV}.tar.gz"

DESCRIPTION="Cisco VPN Client modules"
HOMEPAGE="http://cco.cisco.com/en/US/products/sw/secursw/ps2308/index.html"
SRC_URI="http://tuxx-home.at/vpn/Linux/${TARBALL}
	http://longren.org/files/${TARBALL}
	ftp://ftp.tu-graz.ac.at/vc-graz/vpn/${TARBALL}"

LICENSE="cisco-vpn-client"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

S=${WORKDIR}/vpnclient

MODULE_NAMES="cisco_ipsec(CiscoVPN)"
BUILD_TARGETS="clean default"

src_unpack () {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PV}-amd64.patch
}

pkg_postinst() {
	linux-mod_pkg_postinst
	elog "You will need to load the cisco_ipsec module before using the Cisco"
	elog "VPN Client (vpnclient) application."
}
