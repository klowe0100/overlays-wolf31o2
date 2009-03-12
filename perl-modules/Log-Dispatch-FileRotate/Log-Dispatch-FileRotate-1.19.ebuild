# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# This ebuild generated by g-cpan 0.15.0

inherit perl-module

DESCRIPTION="No description available"
HOMEPAGE="http://search.cpan.org/search?query=Log-Dispatch-FileRotate&mode=dist"
SRC_URI="mirror://cpan/authors/id/M/MA/MARKPF/${P}.tar.gz"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"

DEPEND="dev-perl/Params-Validate
	perl-modules/Date-Manip
	dev-perl/log-dispatch
	dev-perl/Log-Log4perl
	dev-lang/perl"