# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluez/bluez-4.39-r2.ebuild,v 1.7 2009/11/30 06:33:54 josejx Exp $

EAPI="2"

inherit autotools multilib eutils

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="http://www.bluez.org"
SRC_URI="mirror://kernel/linux/bluetooth/${P}.tar.gz"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa caps +consolekit cups debug doc gstreamer old-daemons pcmcia test-programs udev usb"

CDEPEND="caps? ( >=sys-libs/libcap-ng-0.6.2 )
	alsa? (
		media-libs/alsa-lib[alsa_pcm_plugins_extplug,alsa_pcm_plugins_ioplug] )
	gstreamer? (
		>=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-base-0.10 )
	usb? ( dev-libs/libusb )
	cups? ( net-print/cups )
	sys-fs/udev
	dev-libs/glib
	sys-apps/dbus
	media-libs/libsndfile
	>=dev-libs/libnl-1.1
	!net-wireless/bluez-libs
	!net-wireless/bluez-utils"
DEPEND="${CDEPEND}
	sys-devel/bison
	sys-devel/flex
	>=dev-util/pkgconfig-0.20"

RDEPEND="${CDEPEND}
	consolekit? ( sys-auth/pambase[consolekit] )
	test-programs? (
		dev-python/dbus-python
		dev-python/pygobject )"

src_prepare() {
	if ! use consolekit; then
		# No consolekit for at_console etc, so we grant plugdev the rights
		epatch "${FILESDIR}/bluez-plugdev.patch"
	fi

	if use cups; then
		epatch "${FILESDIR}/4.50-cups-location.patch"
	fi

	# needed for both patches
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable caps capng) \
		--enable-network \
		--enable-serial \
		--enable-input \
		--enable-audio \
		--enable-service \
		$(use_enable gstreamer) \
		$(use_enable alsa) \
		$(use_enable usb) \
		$(use_enable pcmcia) \
		--enable-netlink \
		--enable-tools \
		--enable-bccmd \
		--enable-hid2hci \
		--enable-dfutool \
		$(use_enable old-daemons hidd) \
		$(use_enable old-daemons pand) \
		$(use_enable old-daemons dund) \
		$(use_enable cups) \
		$(use_enable test-programs test) \
		--enable-configfiles \
		$(use_enable udev udevrules) \
		$(use_enable debug) \
		--localstatedir=/var
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README || die

	# Remove .la files
	find "${D}" -type f -name '*.la' -delete || die "failed to remove .la files"

	if use test-programs ; then
		cd "${S}/test"
		dobin simple-agent simple-service monitor-bluetooth
		newbin list-devices list-bluetooth-devices
		for b in apitest hsmicro hsplay test-* ; do
			newbin "${b}" "bluez-${b}"
		done
		insinto /usr/share/doc/${PF}/test-services
		doins service-*
		cd "${S}"
	fi

	newinitd "${FILESDIR}/bluetooth-init.d" bluetooth || die
	newconfd "${FILESDIR}/bluetooth-conf.d" bluetooth || die

	if use old-daemons; then
		newconfd "${FILESDIR}/conf.d-hidd" hidd || die
		newinitd "${FILESDIR}/init.d-hidd" hidd || die
	fi

	insinto /etc/udev/rules.d/
	exeinto /$(get_libdir)/udev/
	newins "${FILESDIR}/${PN}-4.18-udev.rules" 70-bluetooth-gentoo.rules || die
	newexe "${FILESDIR}/${PN}-4.18-udev.script" bluetooth.sh || die
	insinto /etc/bluetooth
	if use pcmcia ; then
		doexe "${S}/scripts/bluetooth_serial" || die
		doins serial/serial.conf
	fi

	doins \
		input/input.conf \
		audio/audio.conf \
		network/network.conf
}

pkg_postinst() {
	udevadm control --reload-rules && \
		udevadm trigger --subsystem-match=bluetooth

	echo
	elog "To use dial up networking you must install net-dialup/ppp."
	echo
	elog "Since 3.0 bluez has changed the passkey handling to use a dbus based"
	elog "API so please remember to update your /etc/bluetooth/hcid.conf."
	elog "For a password agent, there are for example net-wireless/bluez-gnome"
	elog "and net-wireless/gnome-bluetooth:2 for GNOME. For KDE, see bug 246381"
	echo
	elog "Since 3.10.1 we don't install the old style daemons any more but rely"
	elog "on the new service architechture:"
	elog "	http://wiki.bluez.org/wiki/Services"
	echo
	elog "3.15 adds support for the audio service. See"
	elog "http://wiki.bluez.org/wiki/HOWTO/AudioDevices for configuration help."
	echo
	elog "Use the old-daemons use flag to get the old daemons like hidd"
	elog "installed. Please note that the init script doesn't stop the old"
	elog "daemons after you update it so it's recommended to run:"
	elog "  /etc/init.d/bluetooth stop"
	elog "before updating your configuration files or you can manually kill"
	elog "the extra daemons you previously enabled in /etc/conf.d/bluetooth."
	echo
	elog "If you want to use rfcomm as a normal user, you need to add the user"
	elog "to the uucp group."
	echo
	if use old-daemons; then
		elog "The hidd init script was installed because you have the old-daemons"
		elog "use flag on. It is not started by default via udev so please add it"
		elog "to the required runleves using rc-update <runlevel> add hidd. If"
		elog "you need init scripts for the other daemons, please file requests"
		elog "to https://bugs.gentoo.org."
	else
		elog "The bluetooth service should be started automatically by udev"
		elog "when the required hardware is inserted next time."
	fi
	echo
	ewarn "On first install you need to run /etc/init.d/dbus reload or hcid"
	ewarn "will fail to start."
}
