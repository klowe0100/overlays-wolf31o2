# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

CACTI_PLUG_SUPPORTED="yes"

inherit eutils cacti-plugins

SRC_URI="http://docs.cacti.net/_media/plugin:${PN}_v${PV}.tar.gz -> ${P}-r1.tar.gz"
S=${WORKDIR}/${PN}_v${PV}
KEYWORDS="amd64 x86"
