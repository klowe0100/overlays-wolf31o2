# Copyright 1999-2009 Gentoo Foundation ; 2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# This ebuild generated by g-cpan 0.15.0 
# Converted to EAPI=2 by Chris Gianelloni

EAPI="2"

inherit perl-module

DESCRIPTION="CGI.pm-compatible wrapper for mod_perl"
HOMEPAGE="http://search.cpan.org/search?query=CGI-Apache2-Wrapper&mode=dist"
SRC_URI="mirror://cpan/authors/id/R/RK/RKOBES/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 x86"
RESTRICT="primaryuri"
IUSE=""

DEPEND="!perl-gcpan/CGI-Apache2-Wrapper
	www-apache/mod_perl
	www-apache/libapreq2"

RDEPEND="${DEPEND}"
