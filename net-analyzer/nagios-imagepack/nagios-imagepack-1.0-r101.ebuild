# Copyright 1999-2009 Gentoo Foundation ; 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="Nagios imagepacks - Icons and pictures for Nagios"
HOMEPAGE="http://www.nagios.org"
IMAGE_URI="mirror://sourceforge/nagios/"
NAGEXCH_URI="http://exchange.nagios.org/components/com_mtree"
SRC_URI="
	${IMAGE_URI}/imagepak-andrade.tar.gz
	${IMAGE_URI}/imagepak-base.tar.gz
	${IMAGE_URI}/imagepak-bernhard.tar.gz
	${IMAGE_URI}/imagepak-didier.tar.gz
	${IMAGE_URI}/imagepak-remus.tar.gz
	${IMAGE_URI}/imagepak-satrapa.tar.gz
	${IMAGE_URI}/imagepak-werschler.tar.gz
	${NAGEXCH_URI}/attachment.php?link_id=845&cf_id=24 -> imagepak-ubuntu.tar.gz
	${NAGEXCH_URI}/attachment.php?link_id=844&cf_id=24 -> imagepak-squid.tar.gz
	${NAGEXCH_URI}/attachment.php?link_id=843&cf_id=24 -> imagepak-snort.tar.gz
	${NAGEXCH_URI}/attachment.php?link_id=832&cf_id=24 -> imagepak-fedora.tar.gz
	http://dev.gentoo.org/~eldad/distfiles/imagepak-gentoo.tar.bz2
"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE=""

src_unpack() {
	mkdir "${S}" && cd "${S}"
	unpack ${A}
}

src_install () {
	# nagios-core installs nagios.gd2
	rm base/nagios.gd2

	insinto /usr/share/nagios/htdocs/images/logos
	doins base/* didier/* imagepak-andrade/* imagepak-bernhard/* remus/* satrapa/* werschler/* gentoo/*
}
