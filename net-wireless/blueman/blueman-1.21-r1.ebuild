# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/blueman/blueman-1.10.ebuild,v 1.2 2009/11/07 23:08:09 volkmar Exp $

EAPI="2"

inherit multilib python

DESCRIPTION="GTK+ Bluetooth Manager, designed to be simple and intuitive for everyday bluetooth tasks."
HOMEPAGE="http://blueman-project.org/"
SRC_URI="http://download.tuxfamily.org/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gnome hal network networkmanager nls policykit pulseaudio"

CDEPEND="dev-libs/glib:2
	>=x11-libs/gtk+-2.12:2
	x11-libs/startup-notification
	>=dev-lang/python-2.5
	dev-python/pygobject
	net-wireless/bluez"
DEPEND="${CDEPEND}
	nls? ( dev-util/intltool sys-devel/gettext )
	dev-util/pkgconfig
	>=dev-python/pyrex-0.9.8"
RDEPEND="${CDEPEND}
	>=app-mobilephone/obex-data-server-0.4.4
	policykit? ( || ( gnome-extra/polkit-gnome gnome-extra/policykit-gnome ) )
	x11-misc/notification-daemon
	sys-apps/dbus
	dev-python/pygtk
	dev-python/notify-python
	dev-python/dbus-python
	gnome? ( dev-python/gconf-python )
	network? (
		networkmanager? ( >=net-misc/networkmanager-0.7.2 )
		!networkmanager? ( sys-apps/hal net-dns/dnsmasq =net-misc/dhcp-3* ) )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.15 )"

src_prepare() {
	# disable pyc compiling
	rm py-compile
	ln -s $(type -P true) py-compile
}

src_configure() {
	if use networkmanager ; then
		myconf="--disable-hal"
	else
		myconf="--enable-hal"
	fi
	econf \
		--with-no-runtime-deps-check \
		--with-dhcp-config=/etc/dhcp/dhcpd.conf \
		$(use_enable nls) \
		$(use_enable policykit polkit) \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README

	if ! use gnome ; then
		python_version
		rm "${D}/usr/$(get_libdir)/python${PYVER}/site-packages/blueman/plugins/config/Gconf.py"
	fi

	if ! use pulseaudio ; then
		python_version
		rm
		"${D}/usr/$(get_libdir)/python${PYVER}/site-packages/blueman/plugins/applet/PulseAudio.py"
	fi

	python_need_rebuild
}

pkg_postinst() {
	python_version
	python_mod_optimize /usr/$(get_libdir)/python${PYVER}/site-packages/blueman
}

pkg_postrm() {
	python_mod_cleanup
}
