# Copyright 1999-2008 Gentoo Foundation ; 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit autotools eutils multilib

DESCRIPTION="PKCS#11 provider for IBM cryptographic hardware"
HOMEPAGE="http://sourceforge.net/projects/opencryptoki"
SRC_URI="mirror://sourceforge/opencryptoki/${P}.tar.gz"
#		 mirror://gentoo/opencryptoki-tpm_stdll-sw_fallback-June012006.patch.bz2"
LICENSE="CPL-0.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+tpmtok"

RDEPEND="tpmtok? ( >=app-crypt/trousers-0.2.9 )"
DEPEND="dev-libs/openssl"

pkg_setup() {
	enewgroup pkcs11
}

src_prepare() {
	sed -i '/groupadd/d' usr/lib/pkcs11/api/Makefile.am
	sed -i 's|$(DESTDIR)||' usr/include/pkcs11/Makefile.am

	# enable fallback operation mode for imported keys
	# patch written by Kent Yoder
#	epatch "${WORKDIR}/opencryptoki-tpm_stdll-sw_fallback-June012006.patch" || die
}

src_configure() {
	eautoreconf
	econf $(use_enable tpmtok) || die "econf failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"

	newinitd "${FILESDIR}/pkcsslotd.init" pkcsslotd

	# no need for this
	rm -rf "${D}/etc/ld.so.conf.d"

	# tpmtoken_* binaries expect to find the libs in /usr/lib/
	dosym opencryptoki/stdll/libpkcs11_sw.so.0.0.0 "/usr/$(get_libdir)/libpkcs11_sw.so"
	dosym opencryptoki/stdll/libpkcs11_tpm.so.0.0.0 "/usr/$(get_libdir)/libpkcs11_tpm.so"

	dodoc doc/openCryptoki-HOWTO.pdf
}
