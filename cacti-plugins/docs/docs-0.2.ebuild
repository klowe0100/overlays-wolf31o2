# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils cacti-plugins

SRC_URI="http://docs.cacti.net/_media/plugin:${PN}_v${PV}.tar.gz -> docs_v0.2.tar.gz"
S=${WORKDIR}/${PN}_v${PV}

LICENSE="GPL-2"
