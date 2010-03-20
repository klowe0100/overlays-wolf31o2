# Copyright 2008-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils cacti-plugins

SRC_URI="http://gilles.boulon.free.fr/manage/${P}.zip"
HOMEPAGE="http://gilles.boulon.free.fr/manage/"
LICENSE="GPL-2"

RDEPEND="${RDEPEND} cacti-plugins/settings"

src_prepare() {
	default
	mv "patch architecture" patch_architecture
}
