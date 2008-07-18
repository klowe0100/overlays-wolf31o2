# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/maya/maya-6.5.ebuild,v 1.4 2005/10/13 17:31:24 dang Exp $

inherit rpm eutils versionator

DESCRIPTION="Commercial modeling and animation package"
HOMEPAGE="http://www.alias.com/eng/products-services/maya/index.shtml"
# Patches to download go into SRC_URI
SRC_URI=""

SLOT="$(get_version_component_range 1-2)"
LICENSE="maya-5.0 mayadoc-5.0"
KEYWORDS="~amd64 ~x86"
# Still having trouble getting the docs working right.
IUSE="bundled-libs doc"
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"

RDEPEND="|| ( app-shells/tcsh app-shells/csh )
	x86? ( virtual/fam
		!bundled-libs? ( =x11-libs/qt-3*
			=virtual/libstdc++-3.3*
			>=x11-libs/openmotif-2.2 ) )
	amd64? ( >=app-emulation/emul-linux-x86-baselibs-2.1.4
		app-emulation/emul-linux-x86-xlibs
		!bundled-libs? ( app-emulation/emul-linux-x86-qtlibs ) )
	 doc? ( !bundled-libs? ( >=virtual/jre-1.4.2 ) )
	 virtual/opengl"

S="${WORKDIR}"

AWDIR="/usr/aw"
MAYADIR="${AWDIR}/maya${SLOT}"

pkg_nofetch() {
	einfo "Please place the required files in ${DISTDIR}:"
#	einfo
#	einfo "Downloads from Alias's support server:"
#	einfo "http://aliaswavefront.topdownloads.com/pub/bws/bws_107/myr_maya501_gold_linux_update.tgz"
#	einfo "http://aliaswavefront.topdownloads.com/pub/bws/bws_79/myr_TechDocs.zip"
}

src_unpack() {
	# We have two disks for Maya.  CD1 is for x86, where CD2 is for AMD64.
	if use amd64
	then
		AWCOMMON_RPM="AWCommon-10.80-7.x86_64.rpm"
		AWCOMMON_SERVER_RPM="AWCommon-server-10.80-7.x86_64.rpm"
		MAYA_RPM="Maya8_0_64-8.0-179.x86_64.rpm"
		MAYA_DOCS_RPM="Maya8_0-docs_en_US-8.0-103.x86_64.rpm"
		CDROM_NAME_1="Maya 8.0 Installation CD (x86_64)"
	elif use x86
	then
		AWCOMMON_RPM="AWCommon-10.80-12.i686.rpm"
		AWCOMMON_SERVER_RPM="AWCommon-server-10.80-12.i686.rpm"
		MAYA_RPM="Maya8_0-8.0-163.i686.rpm"
		MAYA_DOCS_RPM="Maya8_0-docs_en_US-8.0-104.i686.rpm"
		CDROM_NAME_1="Maya 8.0 Installation CD"
	fi

	cdrom_get_cds ${AWCOMMON_RPM}

	cd "${S}"
	einfo "Unpacking RPM packages from ${CDROM_ROOT}..."
	rpm_unpack ${CDROM_ROOT}/${AWCOMMON_RPM} || die
	rpm_unpack ${CDROM_ROOT}/${AWCOMMON_SERVER_RPM} || die
	rpm_unpack ${CDROM_ROOT}/${MAYA_RPM} || die

	if use doc ; then
		rpm_unpack ${CDROM_ROOT}/${MAYA_DOCS_RPM} || die
	fi

	# Use app-admin/flexlm
	rm -rf ${S}/usr/aw/COM/{bin/lmutil,etc/lmgrd} || die

	cp -a ${CDROM_ROOT}/README.html ${S} || die

	# Remove unneeded libs (provided by RDEPEND).
	if ! use bundled-libs; then
		rm -f ${S}/insroot/${MAYADIR}/lib/libgcc_s.so* || die
		rm -f ${S}/insroot/${MAYADIR}/lib/libGLU.so* || die
		rm -f ${S}/insroot/${MAYADIR}/lib/libstdc++.so* || die
		rm -f ${S}/insroot/${MAYADIR}/lib/libXm.so* || die

		# We keep this one because of possible C++ ABI changes...
		rm -f ${S}/insroot/${MAYADIR}/lib/libqt-mt.so* || die
	fi
}

src_install() {
	dohtml README.html
	insinto "${AWDIR}"

	doins -r usr/aw/* || die

	### Start rpm -qp --scripts AWCommon-10.80-12.i686.rpm
	keepdir /var/flexlm
	# We use our own Motif runtime unless USE=bundled-libs
	#if use bundled-libs; then
		dosym libXm.so.3 ${AWDIR}/COM/lib/libXm.so
		dosym libXm.so.3 ${AWDIR}/COM/lib/libXm.so.2
	#fi

	# SLOT the COM directory to avoid conflicts
	mv ${D}${AWDIR}/COM ${D}${AWDIR}/COM-${SLOT}
	dosym COM-${SLOT} ${AWDIR}/COM
	dosym COM ${AWDIR}/COM2
	# End rpm -qp --scripts AWCommon-10.80-12.i686.rpm

	# What follows is modified from rpm -qp --scripts Maya8_0-8.0-163.i686.rpm
	fperms 777 /var/flexlm
	dosym maya8.0 ${AWDIR}/maya

	# The RPM puts these in /usr/local/bin
	dosym Maya8.0 ${MAYADIR}/bin/maya

	dodir /usr/bin
	for mayaexec in Render fcheck imgcvt maya; do
		dosym ../../${AWDIR:1}/maya/bin/${mayaexec} /usr/bin/${mayaexec}
	done

	# links for pcw
	dosym libawcsprt.so.1 ${MAYADIR}/lib/libawcsprt.so
	dosym libpcw_opa.so.1 ${MAYADIR}/lib/libpcw_opa.so
	dosym libpcwfindkey.so.1 ${MAYADIR}/lib/libpcwfindkey.so
	dosym libpcwxml.so.1 ${MAYADIR}/lib/libpcwxml.so

	# We use our own gcc runtime unless USE=bundled-libs
	if use bundled-libs; then
		dosym libgcc_s.so.1 ${MAYADIR}/lib/libgcc_s.so
		dosym libstdc++.so.6.0.6 ${MAYADIR}/lib/libstdc++.so.6
		dosym libstdc++.so.6.0.6 ${MAYADIR}/lib/libstdc++.so
		dosym libGLU.so.1.3 ${MAYADIR}/lib/libGLU.so.1
	fi

	# update the mental ray configuration files in place
	dosed "/\[PREFIX\]/s//\/opt/" ${MAYADIR}/mentalray/maya.rayrc
	dosed "/\[PREFIX\]/s//\/opt/" ${MAYADIR}/bin/unsupported/mayarender_with_mr
	dosed "/\[PREFIX\]/s//\/opt/" ${MAYADIR}/bin/unsuppoered/mayaexport_with_mr
	fperms 755 ${MAYADIR}/bin/unsupported/mayarender_with_mr
	fperms 755 ${MAYADIR}/bin/unsupported/mayaexport_with_mr
	chmod -R +x ${D}/${AWDIR}
	### End rpm -qp --scripts Maya8_0-8.0-163.i686.rpm

	doenvd ${FILESDIR}/50maya

	# Fix permissions
	find ${D} -type d -exec chmod 755 {} \;

	dosed 's:tail -1: tail -n 1:g' ${AWDIR}/maya${SLOT}/bin/Maya${SLOT}

	# For compatibility purposes.  Also, COM/bin/installKey uses
	# /usr/aw/COM/lib as runtime lib path to find libXm.so.2
#	dosym ../opt/aw /usr/aw
}

pkg_postinst() {
	# What follows is modified from rpm -qp --scripts Maya8_0-8.0-163.i686.rpm
	cp ${ROOT}/etc/services ${T}/services.maya_save
	awk '/mi-ray3_2maya5_0/ { found++; print ; next } {print} END {if (0==found)
	print "mi-ray3_2maya5_0 7054/tcp" }' /tmp/services.maya_save > ${ROOT}/etc/services

	# update the magic file 
	if [[ -e ${ROOT}/usr/share/magic ]]; then
		mv ${ROOT}/usr/share/magic ${T}/magic.rpmsave
		awk '/Alias.Wavefront Maya files. begin/ {p=1} /Alias.Wavefront Maya files. end/ {p=2} {if (p==2) { p=0} else if (p==0) print }' ${T}/magic.rpmsave > ${ROOT}/usr/share/magic
		cat ${ROOT}${MAYADIR}/.tmpdata/awmagic >> ${ROOT}/usr/share/magic;
		# get file to rebuild the cache 
		file -C > /dev/null 2>&1
		rm -Rf ${ROOT}${MAYADIR}/.tmpdata/awmagic 2>&1 > /dev/null
	fi
	# End rpm -qp --scripts Maya8_0-8.0-163.i686.rpm

	einfo "There may be a more recent license for this workstation available on the"
	einfo "Autodesk web site. Please visit the following URL to check for"
	einfo "updated licenses:"
	einfo "http://www.autodesk.com/maya-webkey"
	echo
	einfo "To install your key, either place aw.dat in /var/flexlm or run the following"
	einfo "command from an X session:"
	einfo "${AWDIR}/COM/bin/installKey -input ${MAYADIR}/license_data/maya_prekey_data"
	echo
	einfo "One init scripts has been installed:"
	einfo "maya-docs is for the document server (help system)."
	echo
	einfo "If you want to use the flexlm license server, emerge '>=app-admin/flexlm-9.5'"
	echo
	einfo "The Maya SDK headers are located in ${MAYADIR}/include, and libs"
	einfo "are in ${MAYADIR}/lib."
	echo
	# http://www.highend2d.com/boards/showthreaded.php?Cat=&Board=linuxforum&Number=174726&page=&view=&sb=&o=
	ewarn "You should disable klipper, xfce4-clipman, and any other clipboard"
	ewarn "utilities as they have been shown to cause maya to crash."
	ewarn "Feedback on whether or not this is still true on Maya 8.0 would be"
	ewarn "appreciated at http://bugs.gentoo.org"

	if use doc && [[ ! -x /usr/bin/mozilla ]] ; then
		echo
		ewarn "The Maya document system has been installed, but we have detected"
		ewarn "that you don't have Mozilla installed on your system.  Maya"
		ewarn "launches mozilla to start the help program, so it is advised that"
		ewarn "you either install mozilla or place a stub executable at /usr/bin/mozilla"
		ewarn "which will launch another browser on your system."
	fi
	echo
}
