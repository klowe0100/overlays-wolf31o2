# Copyright 1999-2008 Gentoo Foundation; 2008 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PV=${PV}-k9
TARBALL="vpnclient-linux-x86_64-${MY_PV}.tar.gz"

DESCRIPTION="Cisco VPN Client (3DES)"
HOMEPAGE="http://cco.cisco.com/en/US/products/sw/secursw/ps2308/index.html"
SRC_URI="http://tuxx-home.at/vpn/Linux/${TARBALL}
	http://longren.org/files/${TARBALL}
	ftp://ftp.tu-graz.ac.at/vc-graz/vpn/${TARBALL}"

LICENSE="cisco-vpn-client"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

RDEPEND="~net-misc/cisco-vpnclient-modules-${PV}"

S=${WORKDIR}/vpnclient

VPNDIR="/opt/cisco-vpnclient"
CFGDIR="/etc/${VPNDIR}"
OLDCFG="/etc/CiscoSystemsVPNClient"

QA_TEXTRELS="${VPNDIR:1}/lib/libvpnapi.so"
QA_EXECSTACK="${VPNDIR:1}/lib/libvpnapi.so
	${VPNDIR:1}/bin/vpnclient
	${VPNDIR:1}/bin/cvpnd
	${VPNDIR:1}/bin/cisco_cert_mgr
	${VPNDIR:1}/bin/ipseclog"

src_install() {
	local binaries="vpnclient ipseclog cisco_cert_mgr"

	# Binaries
	into ${VPNDIR}
	exeopts -m0111
	dobin ${binaries}
	exeopts -m4111
	dobin cvpnd
	# Libraries
	dolib libvpnapi.so
	# Includes
	insinto include
	doins vpnapi.h

	# Configuration files/profiles/etc
	into /
	insinto ${CFGDIR}
	doins vpnclient.ini
	insinto ${CFGDIR}/Profiles
	doins *.pcf
	dodir ${CFGDIR}/Certificates

	# Create some symlinks
	dodir /usr/bin
	for filename in ${binaries}
	do
		dosym ${VPNDIR}/bin/${filename} /usr/bin/${filename}
	done

	# Make sure we keep these, even if they're empty.
	keepdir ${CFGDIR}/Certificates
	keepdir ${CFGDIR}/Profiles
}
