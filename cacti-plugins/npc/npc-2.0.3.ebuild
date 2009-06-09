# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils cacti-plugins

SRC_URI="http://www.constructaegis.com/downloads/${P}.tar.gz"
S=${WORKDIR}/${PN}
# Requires JSON and PDO for PHP
# Requires Nagios and NDOUtils

