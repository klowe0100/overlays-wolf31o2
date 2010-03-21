# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/gfs2/gfs2-2.03.09.ebuild,v 1.5 2009/02/10 22:58:09 xmerlin Exp $

inherit eutils versionator

DESCRIPTION="File System Cache daemon"
HOMEPAGE="http://people.redhat.com/~dhowells/fscache/"
SRC_URI="http://people.redhat.com/dhowells/fscache/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
# Needs dnotify proc and xattrs in kernel
# stats in /proc/fs/cachefiles
# dir_index should be on fs
# /etc/cachefilesd.conf is configuration file
# /sbin/cachefilesd [-d]* [-s] [-n] [-f <configfile>]
# -d = debug
# -s = stderr instead of syslog
# -n = don't daemonize
# cache default is in /var/fscache

src_install() {
	emake DESTDIR="${D}" install
#	dosbin cachefilesd
#	insinto /etc
#	doins cachefilesd.conf || die "conf"
	mkdir -p ${D}/var/fscache
	keepdir "${D}"/var/fscache
	dodoc README howto.txt move-cache.txt
}

