# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib python nsplugins

MY_PN="PackageKit"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Manage packages in a secure way using a cross-distro and cross-architecture API"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="http://www.packagekit.org/releases/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="connman +consolekit cron gtk networkmanager nls nsplugin pm-utils
+policykit qt4 static-libs test udev"

CDEPEND="
	connman? ( net-misc/connman )
	gtk? ( dev-libs/dbus-glib
		media-libs/fontconfig
		>=x11-libs/gtk+-2.14.0:2
		x11-libs/pango )
	networkmanager? ( >=net-misc/networkmanager-0.6.4 )
	nsplugin? ( dev-libs/dbus-glib
		dev-libs/glib:2
		dev-libs/nspr
		x11-libs/cairo
		>=x11-libs/gtk+-2.14.0:2
		x11-libs/pango )
	policykit? ( >=sys-auth/polkit-0.92 )
	qt4? ( >=x11-libs/qt-core-4.4.0
		>=x11-libs/qt-dbus-4.4.0
		>=x11-libs/qt-sql-4.4.0 )
	udev? ( >=sys-fs/udev-145[extras] )
	dev-db/sqlite:3
	>=dev-libs/dbus-glib-0.74
	>=dev-libs/glib-2.16.1:2
	>=sys-apps/dbus-1.3.0"
RDEPEND="${CDEPEND}
	consolekit? ( sys-auth/consolekit )
	pm-utils? ( sys-power/pm-utils )
	>=app-portage/layman-1.2.3
	>=sys-apps/portage-2.2_rc39"
DEPEND="${CDEPEND}
	nsplugin? ( >=net-libs/xulrunner-1.9.1 )
	test? ( qt4? ( dev-util/cppunit >=x11-libs/qt-gui-4.4.0 ) )
	dev-libs/libxslt
	>=dev-util/intltool-0.35.0
	dev-util/pkgconfig
	sys-devel/gettext"

S="${WORKDIR}/${MY_P}"
RESTRICT="test" # tests are failing atm

# NOTES:
# polkit is in gnome overlay, otherwise, should use policykit
# do not use a specific user, useless and not more secure according to upstream
# doc is in the tarball and always installed
# ruck is broken (RDEPEND dev-python/urlgrabber), upstream bug 23248
# mono doesn't install anything (RDEPEND dev-dotnet/gtk-sharp-gapi:2
#	(R)DEPEND dev-dotnet/glib-sharp:2 dev-lang/mono), upstream bug 23247
# using >=dbus-1.3.0 instead of >=dbus-1.1.1 because of a bug fixed in 1.3.0
# glib2 is experimental atm. Think about a USE flag when it will be usable.

# TODO:
# gettext is probably needed only if +nls but too long to fix
# +doc to install doc/website
# check if test? qt? ( really needs qt-gui)

# UPSTREAM:
# documentation/website with --enable-doc-install
# failing tests

src_prepare() {
	# fix sandbox issue with gapi2-* tools
	# TODO: commented because mono is broken but:
	# TODO: should be in pkg_setup ? could be done better ?
	#if use mono; then
	#	addwrite "/root/.wapi"
	#fi

	# prevent pyc/pyo generation
	rm py-compile || die "rm py-compile failed"
	ln -s $(type -P true) py-compile
}

src_configure() {
	local myconf=""

	if use policykit; then
		myconf="${myconf} --with-security-framework=polkit"
	else
		myconf="${myconf} --with-security-framework=dummy"
	fi

	# localstatedir: for gentoo it's /var/lib but for $PN it's /var
	# dep-tracking,option-check,libtool-lock,strict,local: obvious reasons
	# gtk-doc: doc already built
	# command,debuginfo,gstreamer,service-packs: not supported by backend
	# ruck,managed: failing (see UPSTREAM in ebuild header)
	# glib2: experimental 
	econf \
		${myconf} \
		--localstatedir=/var \
		--disable-dependency-tracking \
		--enable-option-checking \
		--enable-libtool-lock \
		--disable-strict \
		--disable-local \
		--disable-gtk-doc \
		--disable-command-not-found \
		--disable-debuginfo-install \
		--disable-gstreamer-plugin \
		--disable-service-packs \
		--disable-ruck \
		--disable-managed \
		--disable-glib2 \
		--enable-man-pages \
		--disable-dummy \
		--enable-portage \
		--with-default-backend=portage \
		$(use_enable connman) \
		$(use_enable cron) \
		$(use_enable gtk gtk-module) \
		$(use_enable networkmanager) \
		$(use_enable nls) \
		$(use_enable nsplugin browser-plugin) \
		$(use_enable pm-utils) \
		$(use_enable qt4 qt) \
		$(use_enable static-libs static) \
		$(use_enable test tests) \
		$(use_enable udev device-rebind)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog MAINTAINERS NEWS README TODO || die "dodoc failed"

	if use nsplugin; then
		src_mv_plugins /usr/$(get_libdir)/mozilla/plugins
	fi

	if ! use static-libs; then
		find "${D}" -name *.la | xargs rm || die "removing .la files failed"
	fi
}

pkg_postinst() {
	python_mod_optimize $(python_get_sitedir)/${PN}

	if ! use policykit; then
		ewarn "You are not using policykit, the daemon can't be considered as secure."
		ewarn "All users will be able to do anything through ${MY_PN}."
		ewarn "Please, consider rebuilding ${MY_PN} with policykit USE flag."
		ewarn "THIS IS A SECURITY ISSUE."
		ewarn ""
		ebeep
		epause 5
	fi

	if ! use consolekit; then
		ewarn "You have disabled consolekit support."
		ewarn "Even if you can run ${MY_PN} without a running ConsoleKit daemon,"
		ewarn "it is not recommanded nor supported upstream."
		ewarn ""
	fi
}

pkg_prerm() {
	einfo "Removing downloaded files with ${MY_PN}..."
	[[ -d "${ROOT}"/var/cache/${MY_PN}/downloads/ ]] && \
		rm -rf /var/cache/PackageKit/downloads/*
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/python*/site-packages/${PN}
}

