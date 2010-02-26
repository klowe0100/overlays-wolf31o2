# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/arno-iptables-firewall/arno-iptables-firewall-1.9.0_beta3.ebuild,v 1.1 2008/07/10 20:09:50 wolf31o2 Exp $

EAPI=1
MY_PV=${PV/_beta/-beta}

DESCRIPTION="Arno's iptables firewall script"
HOMEPAGE="http://rocky.molphys.leidenuniv.nl/"
SRC_URI="http://rocky.eld.leidenuniv.nl/${PN}/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+plugins"

# @system packages are listed on purpose, full dependency trees are a good thing
RDEPEND=">=net-firewall/iptables-1.2.5
	sys-apps/sed
	sys-apps/gawk
	sys-apps/coreutils
	sys-apps/net-tools
	sys-apps/module-init-tools
	sys-process/procps
	app-arch/gzip"
# However, we will assume that our PM can unpack a tarball... ;]
DEPEND=""

S=${WORKDIR}/${PN}_${MY_PV}

src_install() {
	insinto /etc/arno-iptables-firewall
	doins etc/arno-iptables-firewall/*

	sed -e 's:local/::' \
		contrib/Gentoo/firewall.conf > \
		"${T}"/arno-iptables-firewall.confd
	newconfd "${T}"/arno-iptables-firewall.confd arno-iptables-firewall
	newinitd contrib/Gentoo/rc.firewall arno-iptables-firewall
	dobin contrib/adsl-failover
	rm -rf contrib

	dobin bin/arno-fwfilter
	dosbin bin/arno-iptables-firewall

	insinto /usr/share/arno-iptables-firewall
	doins share/arno-iptables-firewall/environment

	dodoc CHANGELOG README

	doman share/man/arno-fwfilter.1 share/man/arno-iptables-firewall.8

	if use plugins
	then
		insinto /etc/arno-iptables-firewall/plugins
		doins etc/arno-iptables-firewall/plugins/*

		insinto /usr/share/arno-iptables-firewall/plugins
		doins share/arno-iptables-firewall/plugins/*.plugin
		doins share/arno-iptables-firewall/plugins/traffic-accounting-helper
		doins share/arno-iptables-firewall/plugins/traffic-accounting-log-rotate
		doins share/arno-iptables-firewall/plugins/traffic-accounting-show
		doins share/arno-iptables-firewall/plugins/dyndns-host-open-helper

		docinto plugins
		dodoc share/arno-iptables-firewall/plugins/*.CHANGELOG
	fi
}

pkg_postinst () {
	elog "You will need to configure /etc/${PN}/firewall.conf before using this"
	elog "package.  To start the script, run:"
	elog "  /etc/init.d/${PN} start"
	echo
	elog "If you want to start this script at boot, run:"
	elog "  rc-update add ${PN} default"
	echo
	ewarn "When you stop this script, all firewall rules are flushed!"
	echo
}
