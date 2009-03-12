# Copyright 2008 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils cacti-plugins

SRC_URI="${PLUG_BASE}/${PLUG_NAME}-${PV}.tar.gz"

LICENSE="GPL-2"

MYSQL_SCRIPTS="${PLUG_HOME}/discover.sql"
