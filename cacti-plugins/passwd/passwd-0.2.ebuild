# Copyright 2008-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils cacti-plugins

SRC_URI="http://gilles.boulon.free.fr/passwd/passwd-0.1-modified-${PV}.zip"
HOMEPAGE="http://gilles.boulon.free.fr/passwd/"
LICENSE="GPL-2"

RDEPEND="${RDEPEND} cacti-plugins/settings"
