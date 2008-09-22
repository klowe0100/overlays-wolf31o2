# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/net-snmp/net-snmp-5.4.1.1.ebuild,v 1.9 2008/06/23 18:59:58 ranger Exp $

EAPI=1

inherit fixheadtails flag-o-matic perl-module python autotools

JVM_BASE="http://java.sun.com/javase/6/docs/jre/api/management"
AP2_BASE="mirror://sourceforge/mod-apache-snmp"

DESCRIPTION="Software for generating and retrieving SNMP data"
HOMEPAGE="http://net-snmp.sourceforge.net/"
AP2_URI="mod_ap2_snmp_1.04.tar.gz"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	apache2? (
		amd64? ( ${AP2_BASE}/${AP2_URI} )
		x86? ( ${AP2_BASE}/${AP2_URI} )
	)
	java? ( ${JVM_BASE}/JVM-MANAGEMENT-MIB.mib )"

LICENSE="as-is BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
# Kernel USE-expand, add Solaris and FreeBSD here when adding support
KERNEL_IUSE="kernel_linux"
IUSE="${KERNEL_IUSE} apache2 +bzip2 +diskio doc elf +extensible ipv6 java kerberos lm_sensors mfd-rewrites minimal perl python rpm selinux +sendmail +smux ssl tcpd X +zlib"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6d )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
	rpm? (
		app-arch/rpm
		dev-libs/popt
		app-arch/bzip2
		>=sys-libs/zlib-1.1.4
	)
	elf? ( dev-libs/elfutils )
	kerberos? ( app-crypt/mit-krb5 )
	bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	kernel_linux? (
		lm_sensors? (
			sys-apps/lm_sensors
		)
	)
	python? ( dev-python/setuptools )"
# NOTE: The current net-snmp implementation only works with MIT's libraries

RDEPEND="${DEPEND}
	perl? (
		X? ( dev-perl/perl-tk )
		!minimal? ( dev-perl/TermReadKey )
	)
	selinux? ( sec-policy/selinux-snmpd )"

# Dependency on autoconf due to bug #225893
DEPEND="${DEPEND}
	>=sys-devel/autoconf-2.61-r2
	>=sys-apps/sed-4
	doc? ( app-doc/doxygen )"

# Dependency on virtual/jre due to bug #233546
RDEPEND="${RDEPEND}
	java? ( virtual/jre snmp-mibs/jvm-management )"

# Dependency on www-apache/mod_ap2_snmp due to bug #234036
RDEPEND="${RDEPEND}
	amd64? (
		apache2? ( www-apache/mod_ap2_snmp ) )
	x86? (
		apache2? ( www-apache/mod_ap2_snmp ) )"

pkg_setup() {
	use perl && perlinfo
	use !ssl && ewarn "AES and encryption support disabled. USE=ssl to enable."
}

src_unpack() {
	unpack ${P}.tar.gz
	if use amd64 || use x86 ; then
		use apache2 && unpack ${AP2_URI}
	fi
	cd "${S}"

	# Copy mod_ap2_snmp files into place
	if use amd64 || use x86 ; then
		if use apache2 ; then
			mkdir -p agent/mibgroup/apache2
			cp ../mod_ap2_snmp_1.04/net-snmp-module/* agent/mibgroup/apache2
			cp ../mod_ap2_snmp_1.04/extra/ap2_snmp.h agent/mibgroup
			echo "config_add_mib(APACHE2-MIB)" >> agent/mibgroup/ap2_snmp.h
			cp ../mod_ap2_snmp_1.04/mib/APACHE2-MIB.TXT mibs/APACHE2-MIB.txt
			cp ../mod_ap2_snmp_1.04/docs/configuration.txt \
				doc/ap2_snmp-config.txt
		fi
	fi

	# fix access violation in make check
	sed -i -e 's/\(snmpd.*\)-Lf/\1-l/' testing/eval_tools.sh || \
		die "sed eval_tools.sh failed"
	# fix path in fixproc
	sed -i -e 's|\(database_file =.*\)/local\(.*\)$|\1\2|' local/fixproc || \
		die "sed fixproc failed"

	if use python ; then
		python_version
		PYTHON_MODNAME="netsnmp"
		PYTHON_DIR=/usr/$(get_libdir)/python${PYVER}/site-packages
		sed -i -e "s:\(install --basedir=\$\$dir\):\1 --root='${D}':" Makefile.in || die "sed python failed"
	fi

	# snmpd crashes when snmpd.conf contains more than one "exec shelltest" line
	epatch "${FILESDIR}"/${PN}-5.4-exec-crash.patch
	# agent: suppress annoying "registration != duplicate" warning for root oids
	epatch "${FILESDIR}"/${PN}-5.4.1-suppresssuppress-annoying.patch
	# Crash when more then one interface have the same IP, bug 203127
	epatch "${FILESDIR}"/${PN}-5.4.1-ipAddressTable-crash-with-double-free.patch
	# snmpconf generates config files with proper selinux context
	use selinux && epatch "${FILESDIR}"/${PN}-5.1.2-snmpconf-selinux.patch
	epatch "${FILESDIR}"/${PN}-5.4.1-clientaddr-fix.patch #180266
	epatch "${FILESDIR}"/${PN}-5.4.1-CVE-2008-2292.patch #222265
	epatch "${FILESDIR}"/${PN}-5.4.1-process-count-race.patch #213415
	epatch "${FILESDIR}"/${PN}-5.4.1-incorrect-hrFSStorageIndex.patch #211660
	epatch "${FILESDIR}"/${PN}-5.4.1-perl-asneeded.patch #224251

	# Fix version number to report 5.4.1.1:
	sed -i -e 's:NetSnmpVersionInfo = "5.4.1":NetSnmpVersionInfo = "5.4.1.1":' \
		snmplib/snmp_version.c

	eautoreconf

	ht_fix_all
}

src_compile() {
	local mibs myconf

	strip-flags

	### MIB module creation section
	# ucd-snmp/dlmod and host are both built by default with the full agent
	mibs=""
	# We don't need Rmon for embedded hosts
	use !minimal && mibs="${mibs} Rmon"
	# Additional hardware support
	use diskio && mibs="${mibs} ucd-snmp/diskio"
	use lm_sensors && mibs="${mibs} ucd-snmp/lmSensors"
	# This should really be default, since it's the RFC MTA MIB
	use sendmail && mibs="${mibs} mibII/mta_sendmail"
	# The TUNNEL-MIB only supports Linux and Solaris, but I cannot test Solaris.
	use kernel_linux && mibs="${mibs} tunnel"
	# These two extend functionality of the agent's capabilities
	use smux && mibs="${mibs} smux"
	use extensible && mibs="${mibs} ucd-snmp/extensible"
	# This adds Apache stats collecting
	if use amd64 || use x86 ; then
		use apache2 && mibs="${mibs} ap2_snmp"
	fi

	### Configure creation section
	# These are the common settings
	# TODO:
	# Add dmalloc/efence support
	# Add PKCS#11 support
	# Add support for specifying transports
	# Add support for specifying security modules
	myconf="${myconf} \
		$(use_with elf) \
		$(use_with ssl openssl) \
		$(use_with tcpd libwrap) \
		$(use_enable ipv6) \
		$(use_enable mfd-rewrites) \
		$(use_enable perl embedded-perl) \
		$(use_enable !ssl internal-md5)"
	if use !minimal ; then
		$(use_with perl perl-modules) \
		$(use_with python python-modules)
	fi
	if use kerberos ; then
		myconf="${myconf} \
			--with-krb5"
		# KSM requires LDFLAGS -lkrb5 -lk5crypto -lcom_err, but this isn't
		# working yet and I haven't had time to investigate as it's considered
		# an experimental feature still.
#		append-flags -I/usr/include -lkrb5 -lk5crypto -lcom_err
#		sec_modules="ksm usm"
#	else
#		sec_modules="usm"
	fi
	if use minimal ; then
		myconf="${myconf} \
		--disable-applications \
		--disable-scripts
		--enable-mini-agent"
	fi
	if use rpm ; then
		myconf="${myconf} \
			--with-rpm \
			--with-bzip2 \
			--with-zlib"
	else
		myconf="${myconf} \
			$(use_with bzip2) \
			$(use_with zlib)"
	fi
	# These are answers to the questions asked by configure
	answers="--with-sys-location=Uknown \
		--with-sys-contact=root@Unknown \
		--with-default-snmp-version=3 \
		--with-logfile=/var/log/net-snmpd.log \
		--with-persistent-directory=/var/lib/net-snmp"

#		--with-security-modules="${sec_modules}" \
	econf \
		${answers} \
		--with-install-prefix="${D}" \
		--with-mib-modules="${mibs}" \
		--enable-ucd-snmp-compatibility \
		--enable-shared \
		--enable-as-needed \
		${myconf} \
		|| die "econf failed"

	emake -j1 || die "emake failed"

	if use doc ; then
		einfo "Building HTML Documentation"
		make docsdox || die "failed to build docs"
	fi
}

src_test() {
	cd testing
	if ! make test ; then
		echo
		einfo "Don't be alarmed if a few tests FAIL."
		einfo "This could happen for several reasons:"
		einfo "    - You don't already have a working configuration."
		einfo "    - Your ethernet interface isn't properly configured."
		echo
	fi
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"

	if use perl ; then
		fixlocalpod
		use X || rm -f "${D}/usr/bin/tkmib"
	else
		rm -f "${D}/usr/bin/mib2c" "${D}/usr/bin/tkmib" "${D}/usr/bin/snmpcheck"
	fi

	dodoc AGENT.txt ChangeLog FAQ INSTALL NEWS PORTING README* TODO
	[ -e doc/ap2_snmp-config.txt ] && dodoc doc/ap2_snmp-config.txt
	newdoc EXAMPLE.conf.def EXAMPLE.conf

	use doc && dohtml docs/html/*

	keepdir /etc/snmp /var/lib/net-snmp /var/agentx

	newinitd "${FILESDIR}"/snmpd.rc7 snmpd
	newconfd "${FILESDIR}"/snmpd.conf snmpd

	newinitd "${FILESDIR}"/snmptrapd.rc7 snmptrapd
	newconfd "${FILESDIR}"/snmptrapd.conf snmptrapd

	# Remove everything not required for an agent, keeping only the snmpd,
	# snmptrapd, MIBs, libs, and includes.
	if use minimal; then
		elog "USE=minimal is set. Cleaning up excess cruft for an embedded/minimal/server-only install."
		rm -rf "${D}"/usr/bin/{encode_keychange,snmp{get,getnext,set,usm,walk,bulkwalk,table,trap,bulkget,translate,status,delta,test,df,vacm,netstat,inform,snmpcheck}}
		rm -rf "${D}"/usr/share/snmp/snmpconf-data "${D}"/usr/share/snmp/*.conf
		rm -rf "${D}"/usr/bin/{fixproc,traptoemail} "${D}"/usr/bin/snmpc{heck,onf}
		find "${D}" -name '*.pl' -exec rm -f '{}' \;
		use ipv6 || rm -rf "${D}"/usr/share/snmp/mibs/IPV6*
	fi

	# bug 113788, install example config
	insinto /etc/snmp
	newins "${S}"/EXAMPLE.conf snmpd.conf.example
}

pkg_postrm() {
	use perl && updatepod
	use python && python_mod_cleanup
}

pkg_postinst() {
	use perl && updatepod
	elog "An example configuration file has been installed in"
	elog "/etc/snmp/snmpd.conf.example."
}
