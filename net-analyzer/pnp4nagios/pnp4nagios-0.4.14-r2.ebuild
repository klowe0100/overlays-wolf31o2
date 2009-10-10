# Copyright 1999-2009 Gentoo Foundation ; 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit confutils multilib

MY_P=pnp-${PV}

DESCRIPTION="A performance data analyzer for nagios"
HOMEPAGE="http://www.pnp4nagios.org"

SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND=">=dev-lang/php-4.3
	>=net-analyzer/rrdtool-1.2
	net-analyzer/nagios-core"
RDEPEND="${DEPEND}
	virtual/perl-Getopt-Long
	virtual/perl-Time-HiRes"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	confutils_require_built_with_all dev-lang/php gd pcre xml zlib
}

src_compile() {
	econf \
		--sysconfdir=/etc/pnp \
		--datarootdir=/usr/share/pnp \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--with-perfdata-dir=/var/nagios/perfdata \
		--with-perfdata-spool-dir=/var/spool/pnp  || die "econf failed"
	emake all || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" fullinstall || die "emake install failed"
}

pkg_postinst() {
	elog "To include the pnp webinterface into your Nagios setup you could use"
	elog "an Alias in you Apache configuration as follows:"

	elog "\tAlias /nagios/pnp       /usr/share/pnp/"
	elog "\t<Directory "/usr/share/pnp">"
	elog "\t\tAllowOverride AuthConfig"
	elog "\t\tOrder allow,deny"
	elog "\t\tAllow from all"
	elog "\t</Directory>"
}
