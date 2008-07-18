# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# 	[x] Base Install Required (+400MB)
#	[x] Videos (+225MB)
#	--------------------
#	Total 625MB

inherit eutils games

IUSE="langpatch nocd videos"
DESCRIPTION="Civilization Call to Power"
HOMEPAGE="http://www.lokigames.com/products/civctp/"
KEYWORDS="x86"
DEPEND="virtual/libc
	sys-apps/gawk
	games-util/loki_patch"
	
# Since I do not have a PPC machine to test with, I will leave the PPC stuff in
# here so someone else can stabilize loki_setupdb and loki_patch for PPC and
# then KEYWORD this appropriately.
CTP_LANGUAGES="english french german italian spanish"
CTP_NO_LANG=${CTP_LANG:-y}
CTP_LANG=${CTP_LANG:-english}

SRC_URI="x86? (
		mirror://lokigames/${PN}/${P}-english-unified-x86.run
		linguas_fr? ( mirror://lokigames/${PN}/${P}-french-unified-x86.run )
		linguas_de? ( mirror://lokigames/${PN}/${P}-german-unified-x86.run )
		linguas_it? ( mirror://lokigames/${PN}/${P}-italian-unified-x86.run )
		linguas_es? ( mirror://lokigames/${PN}/${P}-spanish-unified-x86.run )
	)
	ppc? (
		mirror://lokigames/${PN}/${P}-english-unified-ppc.run
		linguas_fr? ( mirror://lokigames/${PN}/${P}-french-unified-ppc.run )
		linguas_de? ( mirror://lokigames/${PN}/${P}-german-unified-ppc.run )
		linguas_it? ( mirror://lokigames/${PN}/${P}-italian-unified-ppc.run )
		linguas_es? ( mirror://lokigames/${PN}/${P}-spanish-unified-ppc.run )
	)
	langpatch? (
		mirror://lokigames/${PN}/${P}-${CTP_LANG}.run
	)"

LICENSE="LOKI-EULA"
SLOT="0"
RESTRICT="nostrip nomirror"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}
Ddir=${D}/${dir}

check_ctp2_cd_version() {
	local CUR_LANG
	local LANG_CNT
	local MY_LANGS
	local USED_LANG

	cdrom_get_cds CivCTP-data.tar.gz
	
	MY_LANGS=${CTP_LANGUAGES// /|}
	USED_LANG=""
	test -f ${CDROM_ROOT}/.ctpcd || die "No .ctpcd file found.";
	CTP_VER=$(cat ${CDROM_ROOT}/.ctpcd)
	test -f ${CDROM_ROOT}/setup/tarball.list || die "No setup/tarball.list found."
	CTP_CD_LANG=$(awk -F/ "/\/ctp_data\/(${MY_LANGS})\/$/ { print \$3; }" ${CDROM_ROOT}/setup/tarball.list 2>/dev/null|head -n 1)
	
	if test -z "${CTP_CD_LANG}"; then
		die "Could not determine language of CtP-CD.";
	else
		einfo "Found CtP-CD version ${CTP_VER} in ${CTP_CD_LANG}."
	fi
	LANG_CNT=0
	for CUR_LANG in ${CTP_LANG_USE}; do
		if useq ${CUR_LANG}; then
			LANG_CNT=$((LANG_CNT+1))
			USED_LANG=${CUR_LANG}
		fi
	done
	if [ $LANG_CNT -eq 0 ]; then
		eerror ""
		eerror "You did not specify the language of your CivCTP cd."
		eerror ""
		eerror "I determined you have the ${CTP_CD_LANG} version of CivCTP."
		eerror "Please add civctp-${CTP_CD_LANG} to your USE-flags."
		eerror ""
		die "Language of CivCTP-CD not specified in USE-flags."
	elif [ $LANG_CNT -gt 1 ]; then
		eerror ""
		eerror "You specified more than one language for your CivCTP cd."
		eerror "Obviously, this cannot be true. I determined you have the"
		eerror "${CTP_CD_LANG} version of CivCTP."
		eerror "Please remove any other civctp-* flag from your USE-flags"
		eerror ""
		die "More than one language specified for CivCTP-CD"
	fi
	USED_LANG=${USED_LANG//civctp-/}
	if [ "${CTP_CD_LANG}" != "${USED_LANG}" ]; then
		eerror ""
		eerror "You specified you have the ${USED_LANG} version of CivCTP."
		eerror "However, i recognized the ${CTP_CD_LANG} version."
		eerror "Please replace civctp-${USED_LANG} by ${CTP_CD_LANG}"
		eerror "in your USE-flags."
		eerror ""
		die "Expected ${CTP_CD_LANG}, but got ${USED_LANG}."
	fi
}

pkg_setup() {
	check_license || die "License check failed"
	use nocd && ewarn "The full installation takes about 625 MB of space!"

	# The following is ugly, but we need to know the CTP version
	# _before_ we can download the updates
	check_ctp2_cd_version

	if useq langpatch; then
		if [ "${CTP_NO_LANG}" = "y" ]; then
			ewarn ""
			ewarn "You did not set the CTP_LANG variable to contain the language"
			ewarn "your CivCTP should be patched to."
			ewarn "Thus, i assume you want the ${CTP_LANG} version of CivCTP."
			ewarn ""
		fi
	fi

	games_pkg_setup
}

src_unpack() {
	local my_a

	# We patch in order of A=in order of SRC_URI
	for my_a in ${A} ; do
		mkdir -p ${S}/${my_a}.dir
		cd ${S}/${my_a}.dir
		unpack_makeself ${my_a}
	done
}

src_install() {
	local my_a
	
	einfo "Copying files... this may take a while..."
	dodir ${dir}
	exeinto ${dir}
	cd ${CDROM_ROOT} || die "Could not change directory to ${CDROM_ROOT}"
	/bin/sh ${CDROM_ROOT}/setup/unpack_data install ${Ddir} > /dev/null 2>&1 || die "unpack_data failed"
	if useq nocd; then
		/bin/sh ${CDROM_ROOT}/setup/unpack_videos install ${Ddir} > /dev/null 2>&1 || die "unpack_videos failed"
	elif useq videos; then
		/bin/sh ${CDROM_ROOT}/setup/unpack_videos install ${Ddir} > /dev/null 2>&1 || die "unpack_videos failed"
	fi
	cd ${S}

	for my_a in ${A}; do
		einfo "Applying patch from ${my_a}..."
		cd ${S}/${my_a}.dir || die "patch dir ${my_a}.dir does not exist in workdir."
		loki_patch --verify patch.dat || die "Verifying patch failed"
		loki_patch patch.dat ${Ddir}/CivCTP > /dev/null 2>&1 || die "Patching CivCTP to ${PV} failed."
	done

	games_make_wrapper civctp ./civctp ${dir}/CivCTP

	insinto /usr/share/pixmaps
	cp -p ${Ddir}/CivCTP/icon.xpm ${S}/civctp.xpm
	doins ${S}/civctp.xpm

	# now, since these files are coming off a cd, the times/sizes/md5sums wont
	# be different ... that means portage will try to unmerge some files (!)
	# we run touch on ${D} so as to make sure portage doesnt do any such thing
	find ${Ddir} -exec touch '{}' \;

	prepgamesdirs
	make_desktop_entry civctp "Civilization Call to Power" "civctp.xpm"
}

pkg_postinst() {
	einfo "To play the game run:"
	einfo " civctp"

	games_pkg_postinst
}
