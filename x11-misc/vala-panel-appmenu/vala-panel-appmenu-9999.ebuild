# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxpanel/lxpanel-0.7.0-r1.ebuild,v 1.1 2014/09/10 01:54:45 nullishzero Exp $

EAPI="5"

inherit cmake-utils vala eutils readme.gentoo versionator gnome2-utils git-r3

MAJOR_VER="$(get_version_component_range 1-2)"

DESCRIPTION="Global Menu plugin for xfce4 and vala-panel"
HOMEPAGE="http://github.com/rilian-la-te/vala-panel-appmenu"
EGIT_REPO_URI="https://github.com/rilian-la-te/vala-panel-appmenu.git"
VALA_MIN_API_VERSION=0.24
LICENSE="LGPL-3"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~x86 ~x86-interix ~amd64-linux ~arm-linux ~x86-linux"
SLOT="0"
IUSE="+vala-panel xfce +wnck"
REQUIRED_USE="|| ( xfce vala-panel )"

RDEPEND=">=x11-libs/gtk+-3.12.0:3
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=x11-libs/bamf-0.5.0
	wnck? ( >=x11-libs/libwnck-3.4.0 )
	xfce? ( >=xfce-base/xfce4-panel-4.11.2 )
	vala-panel? ( x11-misc/vala-panel )"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-lang/vala
	virtual/pkgconfig
	sys-devel/gettext"

#src_prepare() {
	#bug #522404
#	epatch "${FILESDIR}"/${PN}-0.7.0-right-click-fix.patch
#	epatch "${FILESDIR}"/${PN}-0.5.9-sandbox.patch
	#bug #415595
#}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable xfce)
		$(cmake-utils_use_enable vala-panel VALAPANEL)
		$(cmake-utils_use_enable wnck)
		-DGSETTINGS_COMPILE=OFF
	)
	cmake-utils_src_configure
}

src_install () {
	cmake-utils_src_install
	dodoc README.md
}

pkg_postinst() {
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_schemas_update
}