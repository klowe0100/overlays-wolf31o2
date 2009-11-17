# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils nagios-plugins

DESCRIPTION="A nagios plugin for checking Dell PowerConnect switches"
HOMEPAGE="http://exchange.nagios.org/directory/Plugins/Hardware/Network-Gear/Dell/Check-Dell-Powerconnect-switches/details"

SRC_URI="http://exchange.nagios.org/components/com_mtree/attachment.php?link_id=477&cf_id=24 -> ${P}.pl"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""
IUSE=""

DEPEND=">=net-analyzer/nagios-plugins-1.4.13-r1"
RDEPEND="net-analyzer/net-snmp[perl]
	${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
