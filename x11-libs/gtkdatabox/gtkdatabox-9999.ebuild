# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils git-r3

DESCRIPTION="Gtk+ Widgets for live display of big amounts of fluctuating data xoscope version"
HOMEPAGE="https://sourceforge.net/projects/xoscope/"
EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/git"
EGIT_BRANCH="GTK2" # The GTK3 in HEAD is not done yet.

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="examples glade static-libs test"

RDEPEND="x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/pango
	glade? ( gnome-base/libglade )"
DEPEND=${RDEPEND}

src_prepare() {
	default

	eautoreconf

	# Remove -D.*DISABLE_DEPRECATED cflags
	find . -iname 'Makefile.am' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die
	# Do Makefile.in after Makefile.am to avoid automake maintainer-mode
	find . -iname 'Makefile.in' -exec \
		sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' -i {} + || die
	sed -e '/SUBDIRS/{s: examples::;}' -i Makefile.am -i Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable glade libglade) \
		--disable-glade \
		$(use_enable static-libs static) \
		$(use_enable test gtktest) \
		--disable-dependency-tracking \
		--enable-libtool-lock
}

src_install() {
	default

	prune_libtool_files

	dodoc AUTHORS ChangeLog README TODO
	if use examples; then
		docinto examples
		dodoc "${S}"/examples/*
	fi
}
