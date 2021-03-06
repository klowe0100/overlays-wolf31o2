# Copyright 1999-2009 Gentoo Foundation ; 2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# This ebuild generated by g-cpan 0.15.0 
# Converted to EAPI=2 by Chris Gianelloni

EAPI="2"

inherit perl-module

DESCRIPTION="easy access to SQLite databases using objects"
HOMEPAGE="http://search.cpan.org/search?query=DBIx-SQLite-Simple&mode=dist"
SRC_URI="mirror://cpan/authors/id/G/GO/GOMOR/${P}.tar.gz"
SRC_TEST="do"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"
RESTRICT="primaryuri"

DEPEND="!perl-gcpan/DBIx-SQLite-Simple
	perl-modules/Class-Gomor
	dev-perl/DBD-SQLite
	dev-lang/perl"

RDEPEND="${DEPEND}"
