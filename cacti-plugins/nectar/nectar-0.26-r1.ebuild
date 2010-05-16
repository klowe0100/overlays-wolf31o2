# Copyright 2008-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

CACTI_PLUG_SUPPORTED="yes"

inherit eutils cacti-plugins

SRC_URI="http://docs.cacti.net/_media/plugin:${PN}-v${PV}.tgz -> ${P}.tar.gz
	http://forums.cacti.net/download.php?id=19995 -> ${P}-functions-fix.patch"
S=${WORKDIR}/${PN}

src_prepare() {
	default
	epatch "${DISTDIR}"/${P}-functions-fix.patch
}

### TODO:
# - Requires PHP w/ gd
# - Requires patching settings plugin
# - Requires patching cacti
