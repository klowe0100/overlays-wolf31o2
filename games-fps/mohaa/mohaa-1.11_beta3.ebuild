# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games

DESCRIPTION="Medal of Honor : Allied Assault"
HOMEPAGE="http://icculus.org/betas/mohaa/"
SRC_URI="http://icculus.org/~ravage/mohaa/donotlinktomyfiles/${PN}-lnx-1.11-beta3.run"

BIN_FILE="mohaa-lnxclient-beta3.tar.bz2"

LICENSE=""
SLOT="0"
KEYWORDS="~x86"
RESTRICT="strip"
IUSE="cdinstall"

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}
	app-arch/unshield"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/${PN}

src_unpack() {
	unpack_makeself ${A} || die "unpack_makeself failed"
	mkdir patch
	tar xvjpf ${BIN_FILE} -C patch 1> /dev/null || die
	use cdinstall && cdrom_get_cds data2.cab data3.cab
	if use cdinstall ; then
		einfo "Copying files from first CD ..."
		cp "${CDROM_ROOT}/data1.cab" ./ || die
		cp "${CDROM_ROOT}/data1.hdr" ./ || die
        	cp "${CDROM_ROOT}/data2.cab" ./ || die
		eend 0
		cdrom_load_next_cd
                einfo "Linking files from second CD ..."
                ln -s "${CDROM_ROOT}/data3.cab" ./ || die
		ln -s "${CDROM_ROOT}/main/Pak2.pk3" ./ || die
                eend 0 
		einfo "Unpacking files from CDs ..."
		unshield x data1.cab 1> /dev/null || die
		eend 0
		rm data1.cab data1.hdr data2.cab data3.cab
	fi
}

src_install() {
	newicon mohaa.xpm ${PN}.xpm
	games_make_wrapper ${PN} ./${PN}_lnx "${dir}" "${dir}"
	make_desktop_entry ${PN} "Medal of Honor - Allied Assault" ${PN}.xpm
	einfo "Installing files ..."
	insinto "${dir}"
	cd patch 
	doins cgame.so fgame.so libSDL-1.2.so.0 openal.so README || die "doinsfailed"
	exeinto "${dir}"
	doexe mohaa_lnx
	cd ..
        insinto ${dir}/main
        doins *.pk3 || die
	if use cdinstall ; then	
		doins Data_Files_Minimal/* || die
		insinto ${dir}/main/sound/music
		doins Music_Files/* || die
		insinto ${dir}/main/sound/amb_stereo
		doins Sound_AmbStereo_Files/* || die
       		insinto ${dir}/main/sound/amb
        	doins Sound_Amb_Files/* || die
		insinto ${dir}/main/sound/dialogue
		doins -r Sound_Dialogue_Files/* || die
		insinto ${dir}/main/sound/mechanics
		doins Sound_Mechanics_Files/* || die
		insinto ${dir}/main/sound/vehicle
        	doins Sound_Vehicle_Files/* || die
		insinto ${dir}/main/sound/weapons
        	doins -r Sound_Weapons_Files/* || die
		insinto ${dir}/main/video
        	doins Video_Files/* || die
	fi
	eend 0
	prepgamesdirs
}

pkg_postinst() {
	if ! use cdinstall ; then
		einfo "You need the data files from Medal of Honor in ${GAMES_PREFIX_OPT}/${PN}/main."
	fi
	games_pkg_postinst
}
