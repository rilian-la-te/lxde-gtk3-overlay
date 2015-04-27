# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/pcmanfm/pcmanfm-9999.ebuild,v 1.19 2013/05/04 08:57:20 hwoarang Exp $

EAPI=5

EGIT_REPO_URI="git://git.lxde.org/lxde/${PN}.git http://git.lxde.org/git/lxde/${PN}.git"

inherit autotools git-r3 fdo-mime

DESCRIPTION="Fast lightweight tabbed filemanager"
HOMEPAGE="http://pcmanfm.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="gtk3 debug"
KEYWORDS=""

COMMON_DEPEND=">=dev-libs/glib-2.18:2
	gtk3? ( >=x11-libs/gtk+-3.0:3 )
	!gtk3? ( >=x11-libs/gtk+-2.16:2 )
	>=lxde-base/menu-cache-0.3.2
	>=x11-libs/libfm-9999:=[gtk3=]"
RDEPEND="${COMMON_DEPEND}
	virtual/eject
	virtual/freedesktop-icon-theme"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext"

RESTRICT="test"

src_prepare() {
	intltoolize --force --copy --automake || die
	# drop -O0 -g. Bug #382265 and #382265
	sed -i -e "s:-O0::" -e "/-DG_ENABLE_DEBUG/s: -g::" "${S}"/configure.ac || die
	#Remove -Werror for automake-1.12. Bug #421101
	sed -i "s:-Werror::" configure.ac || die
	eautoreconf
}

src_configure() {
if use gtk3; then
		GTK_API="--with-gtk=3.0"
else
		GTK_API="--with-gtk=2.0"
fi
	econf \
		--sysconfdir="${EPREFIX}/etc" \
		"${GTK_API}" \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	elog 'PCmanFM can optionally support the menu://applications/ location.'
	elog 'You should install lxde-base/lxmenu-data for that	functionality.'
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
