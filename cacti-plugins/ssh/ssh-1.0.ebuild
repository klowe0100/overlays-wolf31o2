# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils cacti-plugins

SRC_URI="http://forums.cacti.net/download.php?id=11871 -> ${P}.tar.gz"
# http://docs.cacti.net/_media/plugin:${PN}-latest.tgz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}
