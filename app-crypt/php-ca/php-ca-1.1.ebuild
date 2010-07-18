# Copyright 1999-2009 Gentoo Foundation ; 2010-2010 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit depend.php eutils webapp

DESCRIPTION="Simple PHP Certificate Authority (CA)"
HOMEPAGE="http://sourceforge.net/projects/php-ca"
SRC_URI="mirror://sourceforge/php-ca/${P}.tar.gz"

LICENSE="OSL-1.1"
KEYWORDS=""
IUSE="spkac"

# Notes:
# - Use SetEnv to set OPENSSL_CONF to WEBROOT + openssl/openssl.conf
# - openssl and config need to be owned by web user
# - needs *a* web server w/ PHP support
# - needs PHP w/ SSL support
# - optional openssl dependency for Netscape SPKAC client certs







##### OLD EBUILD BELOW

RDEPEND="dev-vcs/subversion
	enscript? ( app-text/enscript )"

need_httpd_cgi
need_php_httpd

pkg_setup() {
	webapp_pkg_setup
	has_php
	require_php_with_use ssl
}

src_install() {
	webapp_src_preinst

	dodoc README
	rm -f INSTALL LICENSE

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned "${MY_HTDOCSDIR}"/config
	webapp_serverowned "${MY_HTDOCSDIR}"/openssl

	webapp_src_install
}
