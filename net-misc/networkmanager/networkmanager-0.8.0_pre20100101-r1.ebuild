# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/networkmanager/networkmanager-0.8.0_pre20091105.ebuild,v 1.2 2009/11/05 15:52:12 dagger Exp $

EAPI="2"

inherit eutils autotools

# NetworkManager likes itself with capital letters
MY_PN=${PN/networkmanager/NetworkManager}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Network configuration and management in an easy way. Desktop environment independent."
HOMEPAGE="http://www.gnome.org/projects/NetworkManager/"
SRC_URI="http://dev.gentoo.org/~dagger/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
KEYWORDS=""
IUSE="+applet avahi bluetooth connection-sharing +dhclient dhcpcd doc +gnutls nls nss resolvconf"

RDEPEND=">=sys-apps/dbus-1.2
	>=dev-libs/dbus-glib-0.75
	>=net-wireless/wireless-tools-28_pre9
	>=sys-fs/udev-145[extras]
	>=dev-libs/glib-2.16
	>=sys-auth/polkit-0.92
	>=dev-libs/libnl-1.1
	>=net-misc/modemmanager-0.2
	>=net-wireless/wpa_supplicant-0.5.10[dbus]
	bluetooth? ( >=net-wireless/bluez-4.42 )
	|| ( sys-libs/e2fsprogs-libs <sys-fs/e2fsprogs-1.41.0 )
	applet? ( gnome-extra/nm-applet )
	avahi? ( net-dns/avahi[autoipd] )
	gnutls? (
		nss? ( >=dev-libs/nss-3.11 )
		!nss? ( dev-libs/libgcrypt
			net-libs/gnutls ) )
	dhclient? (
		dhcpcd? ( >=net-misc/dhcpcd-4.0.0_rc3 )
		!dhcpcd? ( >=net-misc/dhcp-3.0.0 ) )
	resolvconf? ( net-dns/openresolv )
	connection-sharing? (
		net-dns/dnsmasq
		net-firewall/iptables )"
#	>=net-wireless/gnome-bluetooth-2.28 )
#	!dhclient? ( >=net-misc/dhcpcd-4.0.0_rc3 )
#	!gnutls? ( >=dev-libs/nss-3.11 )

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-util/intltool
	net-dialup/ppp
	doc? ( >=dev-util/gtk-doc-1.8 )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# upstream's autogen.sh runs:
	# gtkdocize && autoreconf --install --symlink && intltoolize --force &&
	# autoreconf && ./configure --enable-maintainer-mode $@

	# gtkdocize doesn't *have* to be installed for this package to work, but I
	# am being lazy and am forcing it on, since it's available on my laptop.
	# TODO: make this conditional
	# What this does (essentially):
	# cp -f /usr/share/gtk-doc/data/gtk-doc.make gtk-doc.make
	# cp -f /usr/share/aclocal/gtk-doc.m4 m4/gtk-doc.m4
	gtkdocize --copy

	# eautoreconf doesn't run intltool
	# Should this be using --automake, too?
	intltoolize --force --copy || die "intltoolize failed"
	eautoreconf

	default_src_prepare
}

src_configure() {
	ECONF="--disable-more-warnings
		--localstatedir=/var
		--with-distro=gentoo
		--with-dbus-sys-dir=/etc/dbus-1/system.d
		--disable-dependency-tracking
		--disable-maintainer-mode
		$(use_enable doc gtk-doc)
		$(use_with doc docs)
		$(use_enable nls)
		$(use_with resolvconf)
		$(use_with connection-sharing iptables)"

	# default is dhclient
	if use dhclient ; then
		if use dhcpcd ; then
			ECONF="${ECONF} --with-dhcp-client=dhcpcd"
		else
			ECONF="${ECONF} --with-dhcp-client=dhclient"
		fi
	else
		ECONF="${ECONF} --with-dhcp-client=dhclient"
	fi

	# default is NSS (if none or both are specified), GnuTLS otherwise
	if use gnutls ; then
		if use nss ; then
			ECONF="${ECONF} --with-crypto=nss"
		else
			ECONF="${ECONF} --with-crypto=gnutls"
		fi
	else
		ECONF="${ECONF} --with-crypto=nss"
	fi

	econf ${ECONF}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# Need to keep the /var/run/NetworkManager directory
	keepdir /var/run/NetworkManager

	# Need to keep the /etc/NetworkManager/dispatched.d for dispatcher scripts
	keepdir /etc/NetworkManager/dispatcher.d

	dodoc AUTHORS ChangeLog NEWS README TODO || die "dodoc failed"

	# Add keyfile plugin support
	keepdir /etc/NetworkManager/system-connections
	insinto /etc/NetworkManager
	newins "${FILESDIR}/nm-system-settings.conf" nm-system-settings.conf \
		|| die "newins failed"
#	insinto /etc/udev/rules.d
#	newins callouts/77-nm-probe-modem-capabilities.rules 77-nm-probe-modem-capabilities.rules
#	rm -rf "${D}"/lib/udev/rules.d
}

pkg_postinst() {
	elog "You will need to restart DBUS if this is your first time"
	elog "installing NetworkManager."
	elog ""
	elog "To save system-wide settings as a user, that user needs to have the"
	elog "right policykit privileges. You can add them by running:"
	elog 'polkit-auth --grant org.freedesktop.network-manager-settings.system.modify --user "USERNAME"'
}
