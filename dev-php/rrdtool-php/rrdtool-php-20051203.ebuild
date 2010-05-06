# Copyright 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

PHP_EXT_NAME="rrdtool"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

MY_PN=${PN/-php/}

inherit php-ext-source-r1 eutils

DESCRIPTION="PHP extension providing bindings for rrdtool"
HOMEPAGE="http://oss.oetiker.ch/rrdtool/"
SRC_URI="http://oss.oetiker.ch/rrdtool/pub/contrib/php_${MY_PN}.tar.gz
	http://oss.oetiker.ch/rrdtool/pub/contrib/php_${MY_PN}.txt"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="net-analyzer/rrdtool"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

need_php_by_category

src_unpack() {
	unpack php_${MY_PN}.tar.gz
	cd "${S}"
	epatch "${FILESDIR}"/cleanup-minfo.patch
	php-ext-source-r1_phpize
}

src_install() {
	php-ext-source-r1_src_install

	dodir "${PHP_EXT_SHARED_DIR}"
	insinto "${PHP_EXT_SHARED_DIR}"

	dodoc-php "${DISTDIR}"/php_${MY_PN}.txt
}
