# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..13} )
inherit autotools xdg-utils git-r3 python-single-r1

DESCRIPTION="GPL Electronic Design Automation (gEDA):gaf fork"
HOMEPAGE="https://github.com/lepton-eda/lepton-eda"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug doc nls stroke contrib"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Use gtk2 which need gtk-extra as gtksheet needed by the gtk3 version is not in portage.
CDEPEND="contrib? ( ${PYTHON_DEPS}
	!!sci-electronics/geda )
	dev-libs/glib:2
	x11-libs/gtk+:2
	>=x11-libs/gtk+extra-3.0.0
	x11-libs/pango
	>=x11-libs/cairo-1.2.0
	x11-libs/gdk-pixbuf
	>=dev-scheme/guile-2.2.0
	nls? ( virtual/libintl )
	stroke? ( >=dev-libs/libstroke-0.5.1 )"

DEPEND="${CDEPEND}
	sys-apps/groff
	dev-util/desktop-file-utils
	x11-misc/shared-mime-info
	virtual/pkgconfig
	sys-apps/texinfo
	nls? ( >=sys-devel/gettext-0.16 )
	doc? ( app-doc/doxygen
		|| ( media-gfx/imagemagick media-gfx/inkscape )
		media-gfx/graphviz )"

RDEPEND="${CDEPEND}
	sci-electronics/electronics-menu"

DOCS="AUTHORS NEWS.md README.md"

PATCHES=( "${FILESDIR}"/Makefile_contrib_manpages.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		$(use_with stroke libstroke) \
		$(use_enable nls) \
		$(use_enable contrib) \
		$(use_enable doc doxygen) \
		$(use_enable debug assert) \
		--disable-rpath \
		--disable-update-xdg-database
}

src_compile() {
	emake
	use doc && emake doxygen
	use contrib && python_fix_shebang utils/scripts
}

src_test() {
	emake -j1 check
}

src_install() {
	use doc && HTML_DOCS="utils/docs/html"
	emake DESTDIR="${D}" install
	einstalldocs
	if use contrib ; then
		dobin contrib/gmk_sym/convert_sym
		doman contrib/gmk_sym/convert_sym.1
		dobin contrib/gmk_sym/gmk_sym
		doman contrib/gmk_sym/gmk_sym.1
		newdoc contrib/gmk_sym/README README.gmk_sym
		dobin contrib/olib/olib
		doman contrib/olib/olib.1
		dodoc contrib/olib/README.olib
		dobin contrib/sarlacc_schem/sarlacc_schem
		doman contrib/sarlacc_schem/sarlacc_schem.1
		dobin contrib/scripts/bom_xref.sh
		dobin contrib/scripts/bompp.sh
		dobin contrib/scripts/gnet_hier_verilog.sh
		doman contrib/scripts/gnet_hier_verilog.1
		dobin contrib/scripts/mk_char_tab.pl
		dobin contrib/scripts/pads_backannotate
		doman contrib/scripts/pads_backannotate.1
		dobin contrib/scripts/sarlacc_sym
		doman contrib/scripts/sarlacc_sym.1
		dobin contrib/scripts/sch2eaglepos.sh
		dobin contrib/scripts/sw2asc
		doman contrib/scripts/sw2asc.1
		dobin contrib/smash_megafile/smash_megafile
		doman contrib/smash_megafile/smash_megafile.1
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
