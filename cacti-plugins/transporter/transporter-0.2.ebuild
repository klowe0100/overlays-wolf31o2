# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils cacti-plugins

SRC_URI="http://forums.cacti.net/download.php?id=14175 -> ${P}.tar.gz"
S=${WORKDIR}/${PN}
