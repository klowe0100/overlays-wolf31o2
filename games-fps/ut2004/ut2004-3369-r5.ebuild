# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

MY_P="${PN}-lnxpatch${PV}-2.tar.bz2"

DESCRIPTION="Editor's Choice Edition plus Mega Pack for the critically-acclaimed first-person shooter"
HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI="mirror://3dgamers/unrealtourn2k4/${MY_P}
	http://speculum.twistedgamer.com/pub/0day.icculus.org/${PN}/${MY_P}
	http://treefort.icculus.org/${PN}/${MY_P}
	http://sonic-lux.net/data/mirror/ut2004/${MY_P}"

LICENSE="ut2003"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="mirror strip"

RDEPEND=">=games-fps/ut2004-data-3186-r2
	>=games-fps/ut2004-bonuspack-ece-1-r1
	>=games-fps/ut2004-bonuspack-mega-1-r1
	opengl? ( virtual/opengl )
	=virtual/libstdc++-3.3
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp"

S=${WORKDIR}/UT2004-Patch
dir=${GAMES_PREFIX_OPT}/${PN}

QA_EXECSTACK="${dir:1}/System/ut2004-bin
	${dir:1}/System/ucc-bin"

GAMES_CHECK_LICENSE="yes"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Newbie check
	if [[ ! -e "${FILESDIR}/${PN}.xml" ]] ; then
		die "Missing: ${FILESDIR}/${PN}.xml"
	fi

	if use x86 ; then
		rm -f System/{ucc,ut2004}-bin-linux-amd64
	else
		mv -f System/ucc-bin-linux-amd64 System/ucc-bin || die
		mv -f System/ut2004-bin-linux-amd64 System/ut2004-bin || die
	fi
}

src_install() {
	# These files are owned by ut2004-bonuspack-mega
	rm -f System/{Manifest.in{i,t},Packages.md5}

	# Installing patch files
	local d
	for d in Animations Help Speech System Textures Web ; do
		insinto "${dir}"
		doins -r "${d}" || die "doins ${p} from patch"
	done

	rm -f "${D}/${dir}/System"/{ucc,ut2004}-bin
	exeinto "${dir}/System"
	doexe System/{ucc,ut2004}-bin || die "doexe failed"

	# Creating .manifest files
	sed -e "s:GAMES_PREFIX_OPT:${GAMES_PREFIX_OPT}:" "${FILESDIR}"/${PN}.xml > \
		"${T}"/${PN}.xml || die "sed ${PN}.xml failed"
	insinto "${dir}"/.manifest
	doins "${T}"/${PN}.xml

	# Creating .loki/installed links
	mkdir -p "${D}"/root/.loki/installed
	dosym "${dir}"/.manifest/${PN}.xml /root/.loki/installed/${PN}.xml

	# Replaces the /opt/ut2004/ut2004 script, which is not provided on
	# the Anthology DVD.
	# games-mods.eclass requires the /opt/ut2004/ut2004 script, for mods.
	games_make_wrapper ut2004 ./ut2004 "${dir}"

	echo -e "#!/bin/sh\ncd System\nif [[ \"\${LD_LIBRARY_PATH+set}\" = \"set\" ]] ; then\n\texport LD_LIBRARY_PATH=\"..:.\"\nelse\n\texport LD_LIBRARY_PATH=\"\${LD_LIBRARY_PATH}:..:.\"\nfi\nexec ./ut2004-bin \"\$@\"" \
		> ut2004 || die
	exeinto "${dir}"
	doexe ut2004 || die

	make_desktop_entry ut2004 "Unreal Tournament 2004" ut2004.xpm

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst

	# Here is where we check for the existence of a CD key...
	# If we don't find one, we ask the user for it.
	if [[ -f "${dir}/System/cdkey" ]] ; then
		einfo "A CD key file is already present in ${dir}/System"
	else
		ewarn "You MUST run this before playing the game:"
		ewarn "emerge --config =${CATEGORY}/${PF}"
		ewarn "That way you can [re]enter your CD key."
	fi
	echo
	elog "Starting with 3369, the game supports render-to-texture. To enable"
	elog "it, you will need the Nvidia drivers of at least version 7676 and"
	elog "you should edit the following:"
	elog
	elog 'Set "UseRenderTargets=True" in the "[OpenGLDrv.OpenGLRenderDevice]"'
	elog 'section of your UT2004.ini/Default.ini and set "bPlayerShadows=True"'
	elog 'and "bBlobShadow=False" in the "[UnrealGame.UnrealPawn]" section of'
	elog 'your User.ini/DefUser.ini'
	if use x86 ; then
		elog
		elog "The 32-bit version of UT2004 uses Pixomatic, which means it"
		elog "really does need an executable stack. It is safe to ignore any"
		elog "warnings from Portage about this. See:"
		elog "http://bugs.gentoo.org/show_bug.cgi?id=114733"
		elog "for more information."
	fi
	elog
	elog "To play the game, run:"
	elog " ut2004"
	echo
}

pkg_postrm() {
	ewarn "This package leaves a CD key file that you"
	ewarn "need to remove, to completely get rid of this game's files:"
	ewarn "${dir}/System/cdkey"
}

pkg_config() {
	local cdkey1 cdkey2

	ewarn "Your CD key is NOT checked for validity here."
	ewarn "Make sure you type it in correctly."
	eerror "If you CTRL+C out of this, the game will not run!"
	echo
	einfo "CD key format is: XXXXX-XXXXX-XXXXX-XXXXX"
	while true ; do
		einfo "Please enter your CD key:"
		read cdkey1
		if [[ "${cdkey1}" == "" ]] ; then
			echo "You entered a blank CD key. Try again."
			continue
		fi
		einfo "Please re-enter your CD key:"
		read cdkey2
		if [[ "${cdkey2}" == "" ]] ; then
			echo "You entered a blank CD key. Try again."
			continue
		fi

		if [[ "${cdkey1}" == "${cdkey2}" ]] ; then
			echo "${cdkey1}" | tr a-z A-Z > "${dir}"/System/cdkey
			einfo "Thanks, created ${dir}/System/cdkey"
			break
		else
			eerror "Your CD key entries do not match. Try again."
		fi
	done
}
