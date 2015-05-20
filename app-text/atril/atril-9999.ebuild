# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

ELTCONF="--portage"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools gnome2-utils versionator git-r3

#MATE_BRANCH="$(get_version_component_range 1-2)"

#SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
EGIT_REPO_URI="https://github.com/mate-desktop/atril.git"
DESCRIPTION="Atril document viewer for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="mate caja dbus debug djvu dvi epub gtk3 +introspection gnome-keyring +ps t1lib tiff xps"

RDEPEND=">=app-text/poppler-0.14:0=[cairo]
	app-text/rarian:0
	dev-libs/atk:0
	>=dev-libs/glib-2.32:2
	>=dev-libs/libxml2-2.5:2
	mate? ( >=mate-base/mate-desktop-1.9:0[gtk3?] )
	sys-libs/zlib:0
	gtk3? ( >=x11-libs/gtk+-3.0:3[introspection?] 
			epub? ( net-libs/webkit-gtk:4 ) )
	!gtk3? ( >=x11-libs/gtk+-2.21.5:2[introspection?]
			epub? ( net-libs/webkit-gtk:2 )
			x11-libs/gdk-pixbuf:2 )
	x11-libs/libICE:0
	>=x11-libs/libSM-1:0
	x11-libs/libX11:0
	>=x11-libs/cairo-1.9.10:0
	x11-libs/pango:0
	>=x11-themes/mate-icon-theme-1.6:0
	caja? ( || (
		>=mate-base/caja-1.8:0[introspection?]
		>=mate-base/mate-file-manager-1.6:0[introspection?]
	 ) )
	djvu? ( >=app-text/djvu-3.5.17:0 )
	dvi? (
		virtual/tex-base:0
		t1lib? ( >=media-libs/t1lib-5:5 )
	)
	gnome-keyring? ( >=app-crypt/libsecret-0.5:0 )
	introspection? ( >=dev-libs/gobject-introspection-0.6:0 )
	ps? ( >=app-text/libspectre-0.2:0 )
	tiff? ( >=media-libs/tiff-3.6:0 )
	xps? ( >=app-text/libgxps-0.0.1:0 )
	!!app-text/mate-document-viewer"

DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	app-text/yelp-tools:0
	>=app-text/scrollkeeper-dtd-1:1.0
	>=dev-util/intltool-0.35:*
	virtual/pkgconfig:*
	sys-devel/gettext:*"

# Tests use dogtail which is not available on Gentoo.
RESTRICT="test"

src_prepare() {
	# Patch for mate-desktop optional
	patch -p1 ${PN}-mate-optional.patch
	# Fix .desktop categories, upstream bug #666346.
	sed -e "s:GTK\;Graphics\;VectorGraphics\;Viewer\;:GTK\;Office\;Viewer\;Graphics\;VectorGraphics;:g" -i data/atril.desktop.in.in || die

	# Always autoreconf due to lib path conflict.
	eautoreconf

	gnome2_environment_reset
	gnome2_src_prepare
}

src_configure() {
	# Passing --disable-help would drop offline help, that would be inconsistent
	# with helps of the most of GNOME apps that doesn't require network for that.
	local myconf

	use gtk3 && myconf="${myconf} --with-gtk=3.0"
	use !gtk3 && myconf="${myconf} --with-gtk=2.0"

	if [[ ${PV} = 9999 ]]; then
		myconf="${myconf} --enable-gtk-doc"
	fi

	gnome2_src_configure \
		--disable-tests \
		--enable-comics \
		--enable-pdf \
		--enable-pixbuf \
		--enable-thumbnailer \
		--with-smclient=xsmp \
		--with-platform=mate \
		${myconf} \
		$(use_enable dbus) \
		$(use_enable djvu) \
		$(use_enable dvi) \
		$(use_enable epub) \
		$(use_with gnome-keyring keyring) \
		$(use_with mate matedesktop)
		$(use_enable introspection) \
		$(use_enable caja) \
		$(use_enable ps) \
		$(use_enable t1lib) \
		$(use_enable tiff) \
		$(use_enable xps)
}

DOCS="AUTHORS NEWS README TODO"
