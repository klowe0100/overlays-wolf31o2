# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib games games-ut2k4mod

DESCRIPTION="Unreal Tournament 2004 - this is the data portion of UT2004"
HOMEPAGE="http://www.unrealtournament2004.com/"
SRC_URI=""

LICENSE="ut2003"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="dynamic icon"
RESTRICT="strip"

# Must assume for Midway DVDs that openal, libsdl & unshield are needed.
# Needs >=app-arch/unshield-0.5-r1 due to bug #149235.
# Needs imagemagick to extract the icon from some Midway DVDs.
RDEPEND="media-libs/openal
	media-libs/libsdl"
DEPEND="${RDEPEND}
	games-util/uz2unpack
	>=app-arch/unshield-0.5-r1
	icon? ( media-gfx/imagemagick )"
# Ideally, will be downloading ut2004 while installing ut2004-data
PDEPEND="games-fps/ut2004"

S=${WORKDIR}
dir=${GAMES_PREFIX_OPT}/ut2004
Ddir=${D}/${dir}

QA_TEXTRELS="${dir:1}/System/libSDL-1.2.so.0"

GAMES_LICENSE_CHECK="yes"

grabdirs() {
	local d srcdir

	for d in {Music,Sounds,Speech,StaticMeshes,Textures} ; do
		srcdir=${CDROM_ROOT}/$1${d}
		# Is flexible to handle CD_ROOT vs CD_ROOT_1 mixups
		[[ -d "${srcdir}" ]] || srcdir=${CDROM_ROOT}/${d}
		if [[ -d "${srcdir}" ]] ; then
			insinto "${dir}"
			doins -r "${srcdir}" || die "doins ${srcdir} failed"
		fi
	done
}

pkg_setup() {
	games_pkg_setup

	ewarn "This is a huge package. If you do not have at least 7GB of free"
	ewarn "disk space in ${PORTAGE_TMPDIR} and also in ${GAMES_PREFIX_OPT}"
	ewarn "then you should abort this installation now and free up some space."
}

src_unpack() {
	check_dvd

	if [[ "${USE_DVD}" -eq 1 ]] ; then
		if [[ "${USE_MIDWAY_DVD}" -eq 1 ]] ; then
			# Is 1 DVD, either UT2004-only or Anthology
			if [[ "${USE_GERMAN_MIDWAY_DVD}" -eq 1 ]] ; then
				cdrom_get_cds autorund/unreal.ico
			else
				cdrom_get_cds AutoRunData/Unreal.ico
			fi
		else
			DISK1="CD1/"
			DISK2="CD2/"
			DISK3="CD3/"
			DISK4="CD4/"
			DISK5="CD5/"
			DISK6="CD6/"
			if [[ "${USE_ECE_DVD}" -eq 1 ]] ; then
				# Editor's Choice Edition DVD
				cdrom_get_cds "${DISK1}"System/UT2004.ini \
					"${DISK2}"Textures/2K4Fonts.utx.uz2 \
					"${DISK3}"Textures/ONSDeadVehicles-TX.utx.uz2 \
					"${DISK4}"Textures/XGameShaders2004.utx.uz2 \
					"${DISK5}"Speech/ons.xml \
					"${DISK6}"Sounds/TauntPack.det_uax.uz2
			else
				# Original DVD
				cdrom_get_cds "${DISK1}"System/UT2004.ini \
					"${DISK2}"Textures/2K4Fonts.utx.uz2 \
					"${DISK3}"Textures/ONSDeadVehicles-TX.utx.uz2 \
					"${DISK4}"StaticMeshes/AlienTech.usx.uz2 \
					"${DISK5}"Speech/ons.xml \
					"${DISK6}"Sounds/TauntPack.det_uax.uz2
			fi
		fi
	else
		# 6 CDs
		cdrom_get_cds System/UT2004.ini \
			Textures/2K4Fonts.utx.uz2 \
			Textures/ONSDeadVehicles-TX.utx.uz2 \
			StaticMeshes/AlienTech.usx.uz2 \
			Speech/ons.xml \
			Sounds/TauntPack.det_uax.uz2
	fi

	if [[ "${USE_MIDWAY_DVD}" -ne 1 ]] ; then
		unpack_makeself "${CDROM_ROOT}"/linux-installer.sh \
			|| die "unpacking linux installer"
		use x86 && unpack ./linux-x86.tar
		use amd64 && unpack ./linux-amd64.tar
	fi
}

src_install() {
	local cabfile diskno srcdir varname j

	if [[ "${USE_MIDWAY_DVD}" -eq 1 ]] ; then
		einfo "Copying files from UT2004 Midway DVD."

		if [[ -e "${CDROM_ROOT}"/Manual/Manual.pdf ]] ; then
			insinto "${dir}"/Manual
			doins "${CDROM_ROOT}"/Manual/Manual.pdf \
				|| die "copying Manual.pdf"
		elif [[ -e "${CDROM_ROOT}"/Manual.pdf ]] ; then
			insinto "${dir}"/Manual
			doins "${CDROM_ROOT}"/Manual.pdf \
				|| die "copying Manual.pdf"
		fi

		# Symlinks for unshield. data1&2.cab are both in Disk1.
		# unshield needs data1.hdr
		if [[ "${USE_GERMAN_MIDWAY_DVD}" -eq 1 ]] ; then
			ln -sfn "${CDROM_ROOT}/disk1/data1.hdr" .
			ln -sfn "${CDROM_ROOT}/disk1/data1.cab" .
			ln -sfn "${CDROM_ROOT}/disk1/data2.cab" .
			ln -sfn "${CDROM_ROOT}/disk2/data3.cab" .
			ln -sfn "${CDROM_ROOT}/disk3/data4.cab" .
			ln -sfn "${CDROM_ROOT}/disk4/data5.cab" .
			ln -sfn "${CDROM_ROOT}/disk5/data6.cab" .
			ln -sfn "${CDROM_ROOT}/disk6/data7.cab" .
			ln -sfn "${CDROM_ROOT}/disk7/data8.cab" .
		else
			ln -sfn "${CDROM_ROOT}/Disk1/data1.hdr" .
			ln -sfn "${CDROM_ROOT}/Disk1/data1.cab" .
			ln -sfn "${CDROM_ROOT}/Disk1/data2.cab" .
			ln -sfn "${CDROM_ROOT}/Disk2/data3.cab" .
			ln -sfn "${CDROM_ROOT}/Disk3/data4.cab" .
			ln -sfn "${CDROM_ROOT}/Disk4/data5.cab" .
			ln -sfn "${CDROM_ROOT}/Disk5/data6.cab" .
			# The Midway Anthology DVD contains up to data9.cab
			if [[ -e "${CDROM_ROOT}/Disk8/data9.cab" ]] ; then
				ln -sfn "${CDROM_ROOT}/Disk6/data7.cab" .
				ln -sfn "${CDROM_ROOT}/Disk7/data8.cab" .
				ln -sfn "${CDROM_ROOT}/Disk8/data9.cab" .
			fi
		fi

		# The big extraction
		einfo "Extracting from CAB files - this will take several minutes."
		unshield x data1.cab || die "unshield data1.cab failed"

		# Useful debugging information
		ls -R > extract-filelist.txt

		if [[ -d 4_UT2004_Animations ]] ; then
			# Delete the other games on the Anthology DVD
			rm -rf {1,2,3}_Unreal* 4_UT2004_EXE Launcher_English OCXFiles
			# Rename directories to be same as Midway UT2004-only DVD,
			# i.e. rename "4_UT2004_Animations" to "Animations".
			for j in 4_UT2004_* ; do
				mv -f "${j}" "${j:9}" || die "mv ${j} failed"
			done
		fi

		# The "logging" subdirectory is created by unshield.
		rm -rf logging
		rm -f *.{cab,hdr}

		for j in Animations Benchmark ForceFeedback Help KarmaData \
			Manual Maps Music Sounds Speech StaticMeshes \
			System Textures Web ; do
			einfo "Collating ${j}"

			# UT2004-only DVD has "All_*" dirs, and Anthology DVD has "*_All"
			if [[ -d "All_${j}" ]] ; then
				if [[ -d "${j}" ]] ; then
					cp -rf "All_${j}"/* "${j}" || die "cp All_${j}"
				else
					mv -f "All_${j}" "${j}" || die "mv All_${j}"
				fi
			fi
			if [[ -d "${j}_All" ]] ; then
				if [[ -d "${j}" ]] ; then
					cp -rf "${j}_All"/* "${j}" || die "cp ${j}_All"
				else
					mv -f "${j}_All" "${j}" || die "mv ${j}_All"
				fi
			fi

			if [[ -d "English_${j}" ]] ; then
				if [[ -d "${j}" ]] ; then
					cp -rf "English_${j}"/* "${j}" || die "cp English_${j}"
				else
					mv -f "English_${j}" "${j}" || die "mv English_${j}"
				fi
			fi
			if [[ -d "${j}_English" ]] ; then
				if [[ -d "${j}" ]] ; then
					cp -rf "${j}_English"/* "${j}" || die "cp ${j}_English"
				else
					mv -f "${j}_English" "${j}" || die "mv ${j}_English"
				fi
			fi

			# Ensure that the directory exists
			mkdir -p "${j}" || die
		done

		# Rearrange directories
		if [[ -d English_Sounds_Speech_System_Help ]] ; then
			# http://utforums.epicgames.com/showthread.php?t=558146
			for j in Sounds Speech System Help ; do
				cp -rf English_Sounds_Speech_System_Help/"${j}"/* "${j}" \
					|| die "cp English_Sounds_Speech_System_Help/${j}"
			done
		fi

		if [[ ! -d Benchmark/Stuff ]] ; then
			mkdir -p Benchmark/Stuff || die
			cp -f BenchmarkStuff/timedemo.txt Benchmark/Stuff || die
		fi

		if [[ ! -d System/editorres ]] ; then
			mkdir -p System/editorres || die
			cp -rf Systemeditorres/* System/editorres || die
		fi

		if [[ ! -d Web/images ]] ; then
			mkdir -p Web/{images,ServerAdmin,Src} || die
			cp -rf Webimages/* Web/images || die
			cp -rf WebServerAdmin/* Web/ServerAdmin || die
			cp -rf WebSrc/* Web/Src || die
		fi

		# Straggling file. Seems safe to ignore.
		#[[ -e US_License.int ]] && mv -f US_License.int System

		# Remove unnecessary directories
		rm -rf Benchmark{CSVs,Logs,Results,Stuff}
		rm -rf Systemeditorres Web{images,ServerAdmin,Src}
		rm -rf \<* \[* _* All_* English_* *_All *_English

		# These files are created later, for all installations
		find . -type f -name 'DO_NOT_DELETE.ME' -delete

		# Sanity checks
		[[ -d Animations ]] || die "Animations directory does not exist."
		[[ -d Music ]] || die "Music directory does not exist."

		if [[ ! -e ut2004.xpm ]] && use icon ; then
			# Create ut2004.xpm desktop icon if possible
			if [[ -e Help/Unreal.ico ]] ; then
				einfo "Creating icon from Help/Unreal.ico"
				# Uses imagemagick to convert the icon
				convert Help/Unreal.ico ut2004.xpm \
					|| die "convert Unreal.ico failed"
				mv -f ut2004-6.xpm ut2004.xpm || die
				# Remove the other graphics files that were extracted
				rm -f ut2004-?.xpm
			elif [[ -e "${CDROM_ROOT}"/AutoRunData/Unreal.ico ]] ; then
				einfo "Creating icon from /AutoRunData/Unreal.ico on DVD"
				# Uses imagemagick to convert the icon
				convert "${CDROM_ROOT}"/AutoRunData/Unreal.ico ut2004.xpm \
					|| die "convert Unreal.ico failed"
				mv -f ut2004-6.xpm ut2004.xpm || die
				# Remove the other graphics files that were extracted
				rm -f ut2004-?.xpm
			elif [[ -e Help/Unreal.bmp ]] ; then
				einfo "Creating icon from Help/Unreal.bmp"
				# Uses imagemagick to convert the icon
				convert -transparent 'rgb(255,0,255)' Help/Unreal.bmp \
					ut2004.xpm || die "convert Unreal.bmp failed"
				# Remove pink border from icon. A shadow remains.
				mogrify -transparent 'rgb(252,2,252)' ut2004.xpm || die
				mogrify -transparent 'rgb(217,14,217)' ut2004.xpm || die
				mogrify -transparent 'rgb(228,10,228)' ut2004.xpm || die
				mogrify -transparent 'rgb(237,11,236)' ut2004.xpm || die
				mogrify -transparent 'rgb(246,6,246)' ut2004.xpm || die
				mogrify -transparent 'rgb(207,21,206)' ut2004.xpm || die
				mogrify -transparent 'rgb(243,10,243)' ut2004.xpm || die
				mogrify -transparent 'rgb(211,35,210)' ut2004.xpm || die
				mogrify -transparent 'rgb(170,69,168)' ut2004.xpm || die
				mogrify -transparent 'rgb(227,23,227)' ut2004.xpm || die
				mogrify -transparent 'rgb(215,20,215)' ut2004.xpm || die
				mogrify -transparent 'rgb(216,32,215)' ut2004.xpm || die
				mogrify -transparent 'rgb(152,82,149)' ut2004.xpm || die
				mogrify -transparent 'rgb(220,29,219)' ut2004.xpm || die
				mogrify -transparent 'rgb(186,56,185)' ut2004.xpm || die
				mogrify -transparent 'rgb(231,19,231)' ut2004.xpm || die
				mogrify -transparent 'rgb(165,74,163)' ut2004.xpm || die
				mogrify -transparent 'rgb(142,93,140)' ut2004.xpm || die
				mogrify -transparent 'rgb(203,43,201)' ut2004.xpm || die
				mogrify -transparent 'rgb(150,86,147)' ut2004.xpm || die
				mogrify -transparent 'rgb(205,41,204)' ut2004.xpm || die
				mogrify -transparent 'rgb(133,99,131)' ut2004.xpm || die
				mogrify -transparent 'rgb(128,104,125)' ut2004.xpm || die
				mogrify -transparent 'rgb(176,65,174)' ut2004.xpm || die
				mogrify -transparent 'rgb(152,85,150)' ut2004.xpm || die
				mogrify -transparent 'rgb(138,96,135)' ut2004.xpm || die
				mogrify -transparent 'rgb(160,78,158)' ut2004.xpm || die
			fi
		fi

		# The big install
		einfo "Installing UT2004 directories..."
		insinto "${dir}"
		doins -r * || die "doins -r * failed"

		if [[ -e ut2004.xpm ]] ; then
			# Install icon
			doicon ut2004.xpm || die "doicon failed"
		fi
	else
		# Disk 1
		einfo "Copying files from Disk 1..."
		insinto "${dir}"
		doins -r "${CDROM_ROOT}/${DISK1}"{Animations,ForceFeedback,Help,KarmaData,Maps,Sounds,Web} \
			|| die "copying directories"
		insinto "${dir}"/System
		doins -r "${CDROM_ROOT}/${DISK1}"System/{editorres,*.{bat,bmp,dat,det,est,frt,ini,int,itt,kot,md5,smt,tmt,u,ucl,upl,url}} \
			|| die "copying System files"
		insinto "${dir}"/Manual
		doins "${CDROM_ROOT}/${DISK1}"Manual/Manual.pdf \
			|| die "copying Manual.pdf"
		insinto "${dir}"/Benchmark/Stuff
		doins -r "${CDROM_ROOT}/${DISK1}"Benchmark/Stuff/* \
			|| die "copying Benchmark files"
		cdrom_load_next_cd

		for diskno in {2..5} ; do
			einfo "Copying files from Disk ${diskno}..."
			varname="DISK${diskno}"
			srcdir=${!varname}
			grabdirs "${srcdir}"
			cdrom_load_next_cd
		done

		# Disk 6
		einfo "Copying files from Disk 6..."
		grabdirs "${DISK6}"

		# Install extra help files
		insinto "${dir}"/Help
		doins Unreal.bmp

		# Install EULA
		insinto "${dir}"
		doins UT2004_EULA.txt

		# Installing documentation/icon
		doins README.linux ut2004.xpm || die "copying readme/icon"
		dodoc README.linux || die "dodoc README.linux"
		doicon ut2004.xpm || die "doicon failed"

		# Install System.inis
		insinto "${dir}"/System
		doins ini-{det,est,frt,int,itt,kot,smt,tmt}.tar

		# Don't need a messy FindPath() script. This is replaced by
		# games_make_wrapper in the ut2004 ebuild.
		#exeinto "${dir}"
		#doexe bin/ut2004 || die "copying ut2004"

		exeinto "${dir}"/System
		doexe System/{libSDL-1.2.so.0,openal.so} \
			|| die "copying libraries"

		# Uncompressing files
		einfo "Uncompressing files... this *will* take a while..."
		for j in Animations Maps Sounds StaticMeshes Textures ; do
			fperms -R u+w "${dir}/${j}" || die "fperms ${j} failed"
			games_ut_unpack "${Ddir}/${j}"
		done
	fi

	# Empty directories. "DO_NOT_DELETE.ME" is the original filename, so
	# is preferred to keepdir.
	for j in CSVs Logs Results ; do
		mkdir -p "${Ddir}/Benchmark/${j}"
		touch "${Ddir}/Benchmark/${j}/DO_NOT_DELETE.ME" || die "touch failed"
	done

	# Removing unneccessary files
	rm -f "${Ddir}"/*.{bat,exe,EXE,int}
	rm -f "${Ddir}"/Help/{InstallerLogo.bmp,SAPI-EULA.txt,{Unreal,UnrealEd}.ico}
	rm -f "${Ddir}"/Manual/*.exe
	rm -rf "${Ddir}"/Speech/Redist
	rm -f "${Ddir}"/System/*.{bat,dll,exe,tar}
	rm -f "${Ddir}"/System/{{License,Manifest}.smt,{ucc,StdOut}.log}
	rm -f "${Ddir}"/System/{User,UT2004}.ini

	# Removing file collisions with ut2004-3369-r4
	rm -f "${Ddir}"/Animations/ONSNewTank-A.ukx
	rm -f "${Ddir}"/Help/UT2004Logo.bmp
	rm -f "${Ddir}"/System/{ALAudio.kot,AS-{Convoy,FallenCity,Glacier}.kot,AS-{Convoy,FallenCity,Glacier,Junkyard,Mothership,RobotFactory}.int,bonuspack.{det,est,frt},BonusPack.{int,itt,u},BR-Serenity.int}
	rm -f "${Ddir}"/System/CTF-{AbsoluteZero,BridgeOfFate,DE-ElecFields,DoubleDammage,January,LostFaith}.int
	rm -f "${Ddir}"/System/DM-{1on1-Albatross,1on1-Desolation,1on1-Mixer,Corrugation,IronDeity,JunkYard}.int
	rm -f "${Ddir}"/System/{DOM-Atlantis.int,OnslaughtBP.{kot,u,ucl},OnslaughtFull.int}
	rm -f "${Ddir}"/System/{Build.ini,CacheRecords.ucl,Core.{est,frt,kot,int,itt,u},CTF-January.kot,D3DDrv.kot,DM-1on1-Squader.kot}
	rm -f "${Ddir}"/System/{Editor,Engine,Gameplay,GamePlay,UnrealGame,UT2k4Assault,XInterface,XPickups,xVoting,XVoting,XWeapons,XWebAdmin}.{det,est,frt,int,itt,u}
	rm -f "${Ddir}"/System/{Fire.u,IpDrv.u,License.int,ONS-ArcticStronghold.kot}
	rm -f "${Ddir}"/System/{OnslaughtFull,onslaughtfull,UT2k4AssaultFull}.{det,est,frt,itt,u}
	rm -f "${Ddir}"/System/{GUI2K4,Onslaught,skaarjpack,SkaarjPack,XGame}.{det,est,frt,int,itt,kot,u}
	rm -f "${Ddir}"/System/{Setup,Window}.{det,est,frt,int,itt,kot}
	rm -f "${Ddir}"/System/XPlayers.{det,est,frt,int,itt}
	rm -f "${Ddir}"/System/{UnrealEd.u,UTClassic.u,UTV2004c.u,UTV2004s.u,UWeb.u,Vehicles.kot,Vehicles.u,Xweapons.itt,UT2K4AssaultFull.int,UTV2004.kot,UTV2004s.kot}
	rm -f "${Ddir}"/System/{XAdmin.kot,XAdmin.u,XMaps.det,XMaps.est}
	rm -f "${Ddir}"/Textures/jwfasterfiles.utx
	rm -f "${Ddir}"/Web/ServerAdmin/{admins_home.htm,current_bots.htm,ut2003.css,current_bots_species_group.inc}
	rm -f "${Ddir}"/Web/ServerAdmin/ClassicUT/current_bots.htm
	rm -f "${Ddir}"/Web/ServerAdmin/UnrealAdminPage/{adminsframe.htm,admins_home.htm,admins_menu.htm,current_bots.htm,currentframe.htm,current_menu.htm}
	rm -f "${Ddir}"/Web/ServerAdmin/UnrealAdminPage/{defaultsframe.htm,defaults_menu.htm,footer.inc,mainmenu.htm,mainmenu_itemd.inc,rootframe.htm,UnrealAdminPage.css}
	rm -f "${Ddir}"/Web/ServerAdmin/UT2K3Stats/{admins_home.htm,current_bots.htm,ut2003stats.css}

	# Removing file collisions with ut2004-bonuspack-ece
	rm -f "${Ddir}"/Animations/{MechaSkaarjAnims,MetalGuardAnim,NecrisAnim,ONSBPAnimations}.ukx
	rm -f "${Ddir}"/Help/BonusPackReadme.txt
	rm -f "${Ddir}"/Maps/ONS-{Adara,IslandHop,Tricky,Urban}.ut2
	rm -f "${Ddir}"/Sounds/{CicadaSnds,DistantBooms,ONSBPSounds}.uax
	rm -f "${Ddir}"/StaticMeshes/{BenMesh02,BenTropicalSM01,HourAdara,ONS-BPJW1,PC_UrbanStatic}.usx
	rm -f "${Ddir}"/System/{ONS-Adara.int,ONS-IslandHop.int,ONS-Tricky.int,ONS-Urban.int,OnslaughtBP.int,xaplayersl3.upl}
	rm -f "${Ddir}"/Textures/{AW-2k4XP,BenTex02,BenTropical01,BonusParticles,CicadaTex,Construction_S}.utx
	rm -f "${Ddir}"/Textures/{HourAdaraTexor,ONSBPTextures,ONSBP_DestroyedVehicles,PC_UrbanTex,UT2004ECEPlayerSkins}.utx

	# Removing file collisions with ut2004-bonuspack-mega
	rm -f "${Ddir}"/Help/MegapackReadme.txt
	rm -f "${Ddir}"/Maps/{AS-BP2-Acatana,AS-BP2-Jumpship,AS-BP2-Outback,AS-BP2-SubRosa,AS-BP2-Thrust}.ut2
	rm -f "${Ddir}"/Maps/{CTF-BP2-Concentrate,CTF-BP2-Pistola,DM-BP2-Calandras,DM-BP2-GoopGod}.ut2
	rm -f "${Ddir}"/Music/APubWithNoBeer.ogg
	rm -f "${Ddir}"/Sounds/A_Announcer_BP2.uax
	rm -f "${Ddir}"/StaticMeshes/{JumpShipObjects,Ty_RocketSMeshes}.usx
	rm -f "${Ddir}"/System/{AssaultBP.u,Manifest.in{i,t},Packages.md5}
	rm -f "${Ddir}"/Textures/{JumpShipTextures,T_Epic2k4BP2,Ty_RocketTextures}.utx

	# Now, since these files are coming off a CD, the times/sizes/md5sums won't
	# be different ... that means portage will try to unmerge some files (!)
	# We run touch on ${D} so as to make sure portage doesn't do any such thing
	find "${Ddir}" -exec touch '{}' \;

	prepgamesdirs

	if [[ "${USE_MIDWAY_DVD}" -eq 1 ]] || use dynamic ; then
		# Done after prepgamesdirs because do not want to change perms.
		# Can improve performance, and remove pause when exiting game,
		# although upstream wants us to use the binary libs.
		# The binary libs are not even supplied with Midway DVDs anyway.
		[[ -e "${D}/${dir}"/System/libSDL-1.2.so.0 ]] \
			&& rm -f "${D}/${dir}"/System/libSDL-1.2.so.0
		dosym /usr/"$(get_libdir)"/libSDL-1.2.so.0 \
			"${dir}"/System/libSDL-1.2.so.0 \
			|| die "dosym libSDL-1.2.so.0 failed"

		[[ -e "${D}/${dir}"/System/openal.so ]] \
			&& rm -f "${D}/${dir}"/System/openal.so
		dosym /usr/"$(get_libdir)"/libopenal.so "${dir}"/System/openal.so \
			|| die "dosym openal.so failed"
	fi
}

pkg_postinst() {
	games_pkg_postinst

	echo
	elog "This is only the data portion of the game. To play UT2004,"
	elog "you still need to emerge ut2004."
	echo
}
