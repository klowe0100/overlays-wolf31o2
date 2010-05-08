# Copyright 1999-2010 Gentoo Foundation ; 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="1"
PHP_EXT_NAME="memcached"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README.markdown memcached-api.php memcached.ini ChangeLog CREDITS"

inherit php-ext-pecl-r1 php-ext-base-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="PHP extension for interfacing with memcached via libmemcached library"
LICENSE="PHP-3"
SLOT="0"
IUSE="+session"

DEPEND="dev-libs/libmemcached sys-libs/zlib"
RDEPEND="${DEPEND}"

need_php_by_category

pkg_setup() {
	use session && require_php_with_use session
}

src_compile() {
	my_conf="--enable-memcached
		--with-zlib-dir=/usr
		$(use_enable session memcached-session)"
	#--enable-memcached-igbinary
	php-ext-pecl-r1_src_compile
}

src_install() {
	php-ext-pecl-r1_src_install

	# php-ext-base-r1_addtoinifiles "memcached...." "..."
	php-ext-base-r1_addtoinifiles "memcached.sess_locking" "on"
	php-ext-base-r1_addtoinifiles "memcached.sess_lock_wait" "15000"
	php-ext-base-r1_addtoinifiles "memcached.sess_prefix" "memc.sess.key."
	php-ext-base-r1_addtoinifiles "memcached.compression_type" "fastlz"
	php-ext-base-r1_addtoinifiles "memcached.compression_factor" "1.3"
	php-ext-base-r1_addtoinifiles "memcached.compression_threshold" "2000"
	php-ext-base-r1_addtoinifiles "memcached.serializer" "igbinary"
}
