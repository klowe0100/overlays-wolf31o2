# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagstamon/nagstamon-0.8.2.ebuild,v 1.1 2009/08/26 16:27:54 dertobi123 Exp $

EAPI="2"

inherit eutils python distutils

MY_P=${P/-/_}

DESCRIPTION="Nagios status monitor for the desktop"
HOMEPAGE="http://nagstamon.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome"

DEPEND=""
RDEPEND=">=dev-lang/python-2.4
	dev-python/pygtk
	dev-python/lxml
	gnome? (
		|| (
			dev-python/egg-python
			<=dev-python/gnome-python-extras-2.19.1-r2 ) )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	touch "${S}"/Nagstamon/__init__.py
	default
}

#src_install() {
#	cd "${S}/Nagstamon/"
#	exeinto $(python_get_sitedir)/${PN}
#	doexe nagstamon
#	doexe nagstamonActions.py
#	doexe nagstamonConfig.py
#	doexe nagstamonGUI.py
#	doexe nagstamonObjects.py
#	dosym $(python_get_sitedir)/${PN}/${PN} /usr/bin/${PN}

#	dodir /usr/share/${PN}/resources
#	insinto /usr/share/${PN}/resources
#	doins resources/*

#	insinto /usr/share/applications
#	doins "${FILESDIR}"/${PN}.desktop
#}
