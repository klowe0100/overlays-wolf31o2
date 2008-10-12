# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/opencryptoki/opencryptoki-2.2.4.1.ebuild,v 1.4 2007/11/11 06:28:29 mr_bones_ Exp $

EAPI=1

inherit autotools eutils multilib

DESCRIPTION="PKCS#11 provider for IBM cryptographic hardware"
HOMEPAGE="http://sourceforge.net/projects/opencryptoki"
SRC_URI="mirror://sourceforge/opencryptoki/${P}.tar.bz2"
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

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i '/groupadd/d' usr/lib/pkcs11/api/Makefile.am
	sed -i 's|$(DESTDIR)||' usr/include/pkcs11/Makefile.am

	# enable fallback operation mode for imported keys
	# patch written by Kent Yoder
#	epatch "${WORKDIR}/opencryptoki-tpm_stdll-sw_fallback-June012006.patch" || die
	eautoreconf
}

src_compile() {
	econf $(use_enable tpmtok) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"

	newinitd "${FILESDIR}/pkcsslotd.init" pkcsslotd

	# no need for this
	rm -rf "${D}/etc/ld.so.conf.d"

	# tpmtoken_* binaries expect to find the libs in /usr/lib/
#	dosym opencryptoki/stdll/libpkcs11_sw.so.0.0.0 "/usr/$(get_libdir)/libpkcs11_sw.so"
#	dosym opencryptoki/stdll/libpkcs11_tpm.so.0.0.0 "/usr/$(get_libdir)/libpkcs11_tpm.so"

	dodoc doc/openCryptoki-HOWTO.pdf
}
