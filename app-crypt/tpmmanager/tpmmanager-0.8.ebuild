# Copyright 1999-2009 Gentoo Foundation ; 2009-2009 Chris Gianelloni
# Distributed under the terms of the GNU General Public License v2
# $Id$


#inherit autotools

HOMEPAGE="http://projects.sirrix.com/trac/tpmmanager"
SRC_URI="mirror://sourceforge/tpmmanager/${P}.tar.gz
	doc? ( mirror://sourceforge/tpmmanager/${P}.pdf )"

LICENSE="GPL-2"



SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="doc"

COMMON_DEPEND=">=app-crypt/trousers-0.3.0"
RDEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl )"
# TODO: add optional opencryptoki support
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )"

#%build
#libtoolize --force --copy && aclocal && autoconf
#automake -aic --gnu || : automake ate my hamster
#pushd ssl
#autoreconf -i || : let it fail too
#popd
#%configure --enable-shared --disable-static
#make %{?_smp_mflags}

#%install
#rm -rf $RPM_BUILD_ROOT
#make install DESTDIR=$RPM_BUILD_ROOT
#make -C ssl install DESTDIR=$RPM_BUILD_ROOT

#mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/rc.d/init.d
#install -p -m 755 $RPM_SOURCE_DIR/dc_server.init \
#        $RPM_BUILD_ROOT%{_sysconfdir}/rc.d/init.d/dc_server
#install -p -m 755 $RPM_SOURCE_DIR/dc_client.init \
#        $RPM_BUILD_ROOT%{_sysconfdir}/rc.d/init.d/dc_client

#mkdir -p $RPM_BUILD_ROOT%{_sbindir}

# Unpackaged files
#rm -f $RPM_BUILD_ROOT%{_bindir}/{nal_test,piper} \
#      $RPM_BUILD_ROOT%{_libdir}/lib*.la

#%post
#/sbin/chkconfig --add dc_server
#/sbin/chkconfig --add dc_client
#/sbin/ldconfig
# Add the "distcache" user
#/usr/sbin/useradd -c "Distcache" -u 94 \
#        -s /sbin/nologin -r -d / distcache 2> /dev/null || :

#%preun
#if [ $1 = 0 ]; then
#    /sbin/service dc_server stop > /dev/null 2>&1
#    /sbin/service dc_client stop > /dev/null 2>&1
#    /sbin/chkconfig --del dc_server
#    /sbin/chkconfig --del dc_client
#fi

#%postun -p /sbin/ldconfig

#%clean
#rm -rf $RPM_BUILD_ROOT

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -e "s/-Werror //" -i configure.in
	eautoreconf
}

src_compile() {
	econf $(use_enable nls)
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
