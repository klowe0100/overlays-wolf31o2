# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils cacti-plugins

SRC_URI="http://docs.cacti.net/_media/plugin:${PN}-latest.tgz -> ${PN}_v${PV}.tar.gz"

LICENSE="GPL-2"

src_configure() {
	sed -i -e 's/HEAP/MEMORY/g' flowview.sql setup.php || die "sed"
}
