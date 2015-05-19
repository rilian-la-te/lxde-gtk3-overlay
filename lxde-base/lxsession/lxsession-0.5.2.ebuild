# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxsession/lxsession-0.4.9.2-r3.ebuild,v 1.3 2014/05/31 22:20:19 ssuominen Exp $

EAPI=5

VALA_MIN_API_VERSION="0.14"
VALA_MAX_API_VERSION="0.22"

inherit vala autotools eutils

DESCRIPTION="LXDE session manager (lite version)"
HOMEPAGE="http://lxde.sf.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~x86 ~arm-linux ~x86-linux"
SLOT="0"
# upower USE flag is enabled by default in the desktop profile
IUSE="nls upower gtk3 +polkit-agent +clipboard"

COMMON_DEPEND="dev-libs/glib:2
	dev-libs/dbus-glib
	lxde-base/lxde-common
	sys-auth/polkit
	gtk3? ( x11-libs/gtk+:3
	dev-libs/libgee:0.8 )
	!gtk3? ( x11-libs/gtk+:2
	dev-libs/libgee:0 )
	x11-libs/libX11
	sys-apps/dbus"
RDEPEND="${COMMON_DEPEND}
	!lxde-base/lxsession-edit
	sys-apps/lsb-release
	upower? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"

DOCS="AUTHORS ChangeLog README"

src_prepare() {
	# bug #488082
	#epatch "${FILESDIR}"/${P}-makefile.patch

	# bug #497100
	#epatch "${FILESDIR}"/${P}-configure.patch

	# bug #496880
	#epatch "${FILESDIR}"/${P}-fix-logind-dbus-calls.patch
	if use gtk3; then
		rm "${WORKDIR}"/"${P}"/lxsession-default-apps/*.c
	fi
	eautoreconf
}

src_configure() {
	# dbus is used for restart/shutdown (CK, logind?), and suspend/hibernate (UPower)
	econf \
		$(use_enable nls)\
		$(use_enable gtk3)\
		$(use_enable clipboard buildin-clipboard)\
		$(use_enable polkit-agent buildin-polkit)
}

src_compile() {
	if [ -f Makefile ] || [ -f GNUmakefile ] || [ -f makefile ]; then
		emake -j1 || die "emake failed"
	fi
}
