# Copyright 2008-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: nagios-plugins.eclass
# @MAINTAINER: wolf31o2@wolf31o2.org
# @BLURB: framework for installing Nagios plugins by using functions
# @DESCRIPTION:
# This eclass sets up Nagios plugins

DESCRIPTION="based on nagios-plugins.eclass"

inherit multilib

NAGIOS_PLUGDIR="${NAGIOS_PLUGDIR:-/usr/$(get_libdir)/nagios/plugins}"

case ${EAPI:-0} in
	0|1)
		EXPORT_FUNCTIONS src_compile src_install
		;;
	*)
		EXPORT_FUNCTIONS src_configure src_compile src_install
		;;
esac

nagios-plugins_src_configure() {
	econf \
		--prefix=/usr \
		--libexecdir=${NAGIOS_PLUGDIR} \
		--sysconfdir=/etc/nagios || die "econf failed"
}

nagios-plugins_src_compile() {
	case ${EAPI:-0} in
		0|1) nagios-plugins_src_configure ;;
	esac
	emake || die "emake failed"
}

nagios-plugins_src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
