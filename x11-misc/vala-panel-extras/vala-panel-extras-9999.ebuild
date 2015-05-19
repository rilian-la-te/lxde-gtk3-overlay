# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxpanel/lxpanel-0.7.0-r1.ebuild,v 1.1 2014/09/10 01:54:45 nullishzero Exp $

EAPI="5"

inherit cmake-utils vala eutils readme.gentoo versionator gnome2-utils git-r3

MAJOR_VER="$(get_version_component_range 1-2)"

DESCRIPTION="Small StatusNotifier binaries"
HOMEPAGE="http://github.com/rilian-la-te/vala-panel-extras"
EGIT_REPO_URI="https://github.com/rilian-la-te/vala-panel-extras.git"
VALA_MIN_API_VERSION=0.24
LICENSE="LGPL-3"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~x86 ~x86-interix ~amd64-linux ~arm-linux ~x86-linux"
SLOT="0"
IUSE="+alsa +xkb +weather +upower +gtop"
GNOME2_ECLASS_GLIB_SCHEMAS="org.valapanel.volume.gschema.xml"

RDEPEND=">=x11-libs/gtk+-3.12.0:3
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	alsa? ( media-libs/alsa-lib )
	weather? ( >=dev-libs/libgweather-3.14.0 )
	upower? ( >=sys-power/upower-0.99.0 )
	xkb? ( x11-libs/libxkbcommon[X]
	       x11-libs/libxcb
	       x11-libs/libX11 )
	gtop? ( gnome-base/libgtop )"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-lang/vala
	virtual/pkgconfig
	sys-devel/gettext"

DOC_CONTENTS="You must install StatusNotifierWatcher to use this package."

#src_prepare() {
	#bug #522404
#	epatch "${FILESDIR}"/${PN}-0.7.0-right-click-fix.patch
#	epatch "${FILESDIR}"/${PN}-0.5.9-sandbox.patch
	#bug #415595
#}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable alsa)
		$(cmake-utils_use_enable weather)
		$(cmake-utils_use_enable upower BATTERY)
		$(cmake-utils_use_enable xkb)
		$(cmake-utils_use_enable gtop LIBGTOP)
		-DGSETTINGS_COMPILE=OFF
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