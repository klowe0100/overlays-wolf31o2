# Copyright 1999-2009 Gentoo Foundation ; 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit multilib

DESCRIPTION="Nagios NSCA  - Nagios Service Check Acceptor"
HOMEPAGE="http://www.nagios.org/"
SRC_URI="mirror://sourceforge/nagios/nsca-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+crypt"

DEPEND=">=net-analyzer/nagios-plugins-1.4.14-r1
	crypt? ( >=dev-libs/libmcrypt-2.5.1-r4 )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/nsca-${PV}

src_configure() {
	econf \
		--localstatedir=/var/nagios \
		--sysconfdir=/etc/nagios/nsca \
		--with-nsca-user=nagios \
		--with-nsca-grp=nagios \
		$(use_with crypt mcrypt) \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		|| die "econf failed"
}

src_compile() {
	emake all || die "emake failed"
}

src_install() {
	dodoc LEGAL Changelog README SECURITY sample-config/nsca.cfg \
		sample-config/send_nsca.cfg
	insinto /etc/nagios/nsca
	doins "${S}"/sample-config/nsca.cfg
	doins "${S}"/sample-config/send_nsca.cfg

	exeinto /usr/bin
	doexe src/nsca
	fowners nagios:nagios /usr/bin/nsca

	exeinto /usr/$(get_libdir)/nagios/plugins
	doexe src/send_nsca
	fowners nagios:nagios /usr/$(get_libdir)/nagios/plugins/send_nsca
	newinitd "${FILESDIR}"/nsca-nagios3.rc nsca
}
pkg_postinst() {
	einfo
	einfo "If you are using the nsca daemon, remember to edit"
	einfo "the config file ${ROOT}etc/nagios/nsca/nsca.cfg"
	einfo
}
