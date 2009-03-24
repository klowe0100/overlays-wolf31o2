# Copyright 1999-2008 Gentoo Foundation ; 2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils vmware

ANY_ANY="vmware-any-any-update117d"

DESCRIPTION="Guest-os tools for VMware ESX"
HOMEPAGE="http://www.vmware.com/"
SRC_URI="http://vmkernelnewbies.googlegroups.com/web/${ANY_ANY}.tar.gz"

LICENSE="vmware"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"
PROPERTIES="interactive"
RESTRICT=""

RDEPEND="sys-apps/pciutils"

S=${WORKDIR}/vmware-tools-distrib

RUN_UPDATE="no"

dir=/opt/vmware/esx/tools
Ddir=${D}/${dir}

TARBALL="VMwareTools-3.5.0-143128.tar.gz"
MY_P=${TARBALL/.tar.gz/}

pkg_setup() {
	groupadd ${VMWARE_GROUP}
	vmware_pkg_setup
}

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
