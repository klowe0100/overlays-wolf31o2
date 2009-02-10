# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/vmware-workstation-tools/vmware-workstation-tools-5.5.1.ebuild,v 1.2 2006/06/12 20:44:35 wolf31o2 Exp $

inherit eutils vmware

DESCRIPTION="Guest-os tools for VMware ESX"
HOMEPAGE="http://www.vmware.com/"
SRC_URI=""

LICENSE="vmware"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"
RESTRICT=""

RDEPEND="sys-apps/pciutils"

S=${WORKDIR}/vmware-tools-distrib

RUN_UPDATE="no"

dir=/opt/vmware/esx/tools
Ddir=${D}/${dir}

ANY_ANY=
TARBALL="VMwareTools-3.5.0-143128.tar.gz"
MY_P=${TARBALL/.tar.gz/}

src_install() {
	vmware_src_install

	dodir ${dir}/sbin ${dir}/bin
	keepdir ${dir}/sbin ${dir}/bin

	# if we have X, install the default config
	if use X ; then
		insinto /etc/X11
		doins ${FILESDIR}/xorg.conf
	fi
}
