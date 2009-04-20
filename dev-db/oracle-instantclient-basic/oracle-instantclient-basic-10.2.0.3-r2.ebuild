# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/oracle-instantclient-basic/oracle-instantclient-basic-10.2.0.3-r1.ebuild,v 1.3 2008/06/18 22:34:51 wolf31o2 Exp $

inherit eutils

MY_P_x86="${PN/oracle-/}-linux32-${PV}-20061115"
MY_PSDK_x86="${MY_P_x86/basic/sdk}"

MY_P_amd64="${PN/oracle-/}-linux-x86-64-${PV}-20070103"
MY_PSDK_amd64="${MY_P_amd64/basic/sdk}"

S=${WORKDIR}
DESCRIPTION="Oracle 10g basic Linux client and SDK"
HOMEPAGE="http://www.oracle.com/technology/tech/oci/instantclient/index.html"
SRC_URI="amd64? ( ${MY_P_amd64}.zip ${MY_PSDK_amd64}.zip )
		 x86? ( ${MY_P_x86}.zip ${MY_PSDK_x86}.zip )"

LICENSE="OTN"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="|| ( =sys-libs/libstdc++-v3-3.3* =sys-devel/gcc-3.3* )"

__my_arch() {
	MY_P=MY_P_${ARCH}
	export MY_P=${!MY_P}
	MY_PSDK=MY_PSDK_${ARCH}
	export MY_PSDK=${!MY_PSDK}
}

__has_instantclient() {
	local __package=$1
	if has_version / dev-db/oracle-instantclient-$__package ; then
		return 0
	else
		return 1
	fi
}

pkg_setup() {
	__my_arch
}

pkg_nofetch() {
	__my_arch
	eerror "Please go to:"
	eerror "  ${HOMEPAGE}"
	eerror "select your platform and download the"
	eerror "Basic client package with SDK, which are:"
	eerror "  ${MY_P}.zip"
	eerror "  ${MY_PSDK}.zip"
	eerror "Then after downloading put them in:"
	eerror "  ${DISTDIR}"
}

src_unpack() {
	unzip "${DISTDIR}"/${MY_P}.zip || die "unsuccesful unzip ${MY_P}.zip"
	unzip "${DISTDIR}"/${MY_PSDK}.zip || die "unsuccesful unzip ${MY_PSDK}.zip"
}

src_install() {
	# Patch the SDK makefile
	epatch "${FILESDIR}"/${P}-makefile.patch

	# SDK makefile
	dodir /usr/$(get_libdir)/oracle/${PV}/client/rdbms/demo
	cd "${S}"/instantclient_10_2/sdk/demo
	mv demo.mk demo_xe.mk
	insinto /usr/$(get_libdir)/oracle/${PV}/client/rdbms/demo
	doins demo_xe.mk

	# library
	dodir /usr/$(get_libdir)/oracle/${PV}/client/lib
	cd "${S}"/instantclient_10_2
	insinto /usr/$(get_libdir)/oracle/${PV}/client/lib
	doins *.jar *.so *.so.10.1

	# fixes symlinks
	dosym /usr/$(get_libdir)/oracle/${PV}/client/lib/libocci.so.10.1 /usr/$(get_libdir)/oracle/${PV}/client/lib/libocci.so
	dosym /usr/$(get_libdir)/oracle/${PV}/client/lib/libclntsh.so.10.1 /usr/$(get_libdir)/oracle/${PV}/client/lib/libclntsh.so
	dosym /usr/$(get_libdir)/oracle/${PV}/client/include /usr/$(get_libdir)/oracle/${PV}/client/rdbms/public

	# includes
	dodir /usr/$(get_libdir)/oracle/${PV}/client/include
	insinto /usr/$(get_libdir)/oracle/${PV}/client/include
	cd "${S}"/instantclient_10_2/sdk/include
	doins *.h
	# link to original location
	dodir /usr/include/oracle/${PV}/
	ln -s "${D}"/usr/$(get_libdir)/oracle/${PV}/client/include "${D}"/usr/include/oracle/${PV}/client

	# share info
	cd "${S}"/instantclient_10_2/sdk/demo
	dodoc *

	# Add OCI libs to library path
	sed \
		-e "s/%%LIBDIR%%/$(get_libdir)/" \
		-e "s/%%PV%%/${PV}/" \
		"${FILESDIR}"/50${PN} > "${T}"/50${PN}
	doenvd "${T}"/50${PN}

	# create path for tnsnames.ora
	dodir /etc/oracle
}

pkg_postinst() {
	elog "The Basic client and SDK for Oracle 10g has been installed."
	if ! __has_instantclient jdbc && ! __has_instantclient sqlplus ; then
		elog "For additional functionality, you may also wish to install:"
		elog "dev-db/oracle-instantclient-jdbc (supplemental JDBC functions)"
		elog "dev-db/oracle-instantclient-sqlplus (SQL*Plus application/shell)"
	fi
	echo
	elog "Examples are located at:"
	elog "/usr/share/doc/${PF}/"
	echo
	elog "oracle-instantclient-* packages aren't installed in different"
	elog "SLOTs any longer. You may want to uninstall older versions."
	echo
	elog "TNS_ADMIN has been set to "${ROOT}"etc/oracle by default, put your"
	elog "tnsnames.ora there or configure TNS_ADMIN to point to"
	elog "your user specific configuration."
}
