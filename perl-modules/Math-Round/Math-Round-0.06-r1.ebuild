
inherit perl-module

DESCRIPTION="extension for rounding numbers"
HOMEPAGE="http://search.cpan.org/search?query=Math-Round&mode=dist"
SRC_URI="mirror://cpan/authors/id/G/GR/GROMMEL/${P}.tar.gz"
SRC_TEST="do"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

