# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxpanel/lxpanel-0.7.0-r1.ebuild,v 1.1 2014/09/10 01:54:45 nullishzero Exp $

EAPI="5"

inherit cmake-utils vala eutils readme.gentoo versionator gnome2-utils git-r3

MAJOR_VER="$(get_version_component_range 1-2)"

DESCRIPTION="Lightweight desktop panel"
HOMEPAGE="http://github.com/rilian-la-te/vala-panel"
EGIT_REPO_URI="https://github.com/rilian-la-te/vala-panel.git"
VALA_MIN_API_VERSION=0.24
LICENSE="LGPL-3"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~x86 ~x86-interix ~amd64-linux ~arm-linux ~x86-linux"
SLOT="0"
IUSE="+wnck +X"
GNOME2_ECLASS_GLIB_SCHEMAS="org.valapanel.gschema.xml"

RDEPEND=">=x11-libs/gtk+-3.12.0:3
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=dev-libs/libpeas-1.2.0
	X? ( x11-libs/libX11 )
	wnck? ( >=x11-libs/libwnck-3.4.0:3 )"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-lang/vala
	virtual/pkgconfig
	sys-devel/gettext"

DOC_CONTENTS="If you have problems with broken icons shown in the main panel,
you will have to configure panel settings via its menu.
This will not be an issue with first time installations."

#src_prepare() {
	#bug #522404
#	epatch "${FILESDIR}"/${PN}-0.7.0-right-click-fix.patch
#	epatch "${FILESDIR}"/${PN}-0.5.9-sandbox.patch
	#bug #415595
#}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable wnck)
		$(cmake-utils_use_enable X X11)
		-DGSETTINGS_COMPILE=OFF
		-DCMAKE_INSTALL_SYSCONFDIR=/etc
	)
	cmake-utils_src_configure
	# the gtk+ dep already pulls in libX11, so we might as well hardcode with-x
}

src_install () {
	cmake-utils_src_install
	dodoc README.md
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	gnome2_schemas_update
}
pkg_postrm() {
	readme.gentoo_print_elog
	gnome2_schemas_update
}