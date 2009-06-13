# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils cacti-plugins

SRC_URI="http://wotsit.thingy.com/haj/cacti/${P}.zip"
HOMEPAGE="http://wotsit.thingy.com/haj/cacti/superlinks-plugin.html"
LICENSE="GPL-2"

### XXX: Requires PHP w/ GD built with PNG and Freetype

PLUGIN_NEEDS_CONFIG="yes"

src_install() {
	local _cachedir=${CACTI_PLUG_HOME}/content
	dodir "${_cachedir}" || die "dodir"
	keepdir "${_cachedir}" || die "keepdir"
	fowners apache:apache "${_cachedir}" || die "fowners"
	fperms 775 "${_cachedir}" || die "fperms"
	cacti-plugins_src_install
}
