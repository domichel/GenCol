# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit autotools git-r3 eutils flag-o-matic

DESCRIPTION="An extremely powerful ICCCM-compliant multiple virtual desktop window manager"
HOMEPAGE="http://www.fvwm.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/fvwmorg/fvwm3.git"
EGIT_BRANCH="master"

LICENSE="GPL-2 FVWM"
SLOT="0"
KEYWORDS=""
IUSE="bidi debug doc netpbm nls perl png readline rplay stroke svg tk truetype vanilla lock"

COMMON_DEPEND="
	sys-libs/zlib
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXrender
	dev-lang/python:3
	bidi? ( dev-libs/fribidi )
	png? ( media-libs/libpng )
	readline? (
		sys-libs/ncurses
		sys-libs/readline
	)
	stroke? ( dev-libs/libstroke )
	svg? ( gnome-base/librsvg )
	truetype? (
		media-libs/fontconfig
		x11-libs/libXft
	)"

RDEPEND="${COMMON_DEPEND}
	dev-lang/perl
	perl? ( tk? (
			dev-lang/tk
			dev-perl/Tk
			>=dev-perl/X11-Protocol-0.56
		)
	)
	rplay? ( media-sound/rplay )
	lock? ( x11-misc/xlockmore )
	userland_GNU? ( sys-apps/debianutils )
	!x86-fbsd? ( netpbm? ( media-libs/netpbm ) )"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	doc? ( dev-libs/libxslt )
	x11-proto/xextproto
	x11-proto/xproto"

src_unpack() {
	einfo "The branch ${EGIT_BRANCH} will be installed."
	einfo "For valid git branches, see https://github.com/fvwmorg/fvwm3/branches"
	git-r3_src_unpack
}

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	local myconf="--prefix=/usr/local --with-imagepath=/usr/include/X11/bitmaps:/usr/include/X11/pixmaps:/usr/share/icons/fvwm --enable-package-subdirs"

	# Non-upstream email where bugs should be sent; used in fvwm-bug.
#	export FVWM_BUGADDR="desktop-wm@nogentoo.org"

	# Recommended by upstream.
	append-flags -fno-strict-aliasing

	# Signed chars are required.
	use ppc && append-flags -fsigned-char

	myconf="${myconf}"

	use readline && myconf="${myconf} --without-termcap-library"

echo	./configure ${myconf} \
		$(use_enable bidi) \
		$(use_enable debug debug-msgs) \
		$(use_enable debug command-log) \
		--enable-mandoc \
		$(use_enable doc htmldoc) \
		$(use_enable nls) \
		$(use_enable nls iconv) \
		$(use_enable perl perllib) \
		$(use_enable png) \
		$(use_with readline readline-library) \
		$(use_with rplay rplay-library) \
		$(use_with stroke stroke-library) \
		$(use_enable svg rsvg) \
		$(use_enable truetype xft) \
		--docdir="/usr/share/doc/${P}"

	./configure ${myconf} \
		$(use_enable bidi) \
		$(use_enable debug debug-msgs) \
		$(use_enable debug command-log) \
		--enable-mandoc \
		$(use_enable doc htmldoc) \
		$(use_enable nls) \
		$(use_enable nls iconv) \
		$(use_enable perl perllib) \
		$(use_enable png) \
		$(use_with readline readline-library) \
		$(use_with rplay rplay-library) \
		$(use_with stroke stroke-library) \
		$(use_enable svg rsvg) \
		$(use_enable truetype xft) \
		--docdir="/usr/share/doc/${P}"
}

src_install() {
#	make DESTDIR="${D}" prefix="/usr/local" docdir="/usr/local/share/doc/${P}" htmldir="/usr/local/share/doc/${P}/html" install || die
echo	make DESTDIR="${ED}" prefix="/usr/local" exec_prefix="/usr/local" libdir="/usr/local/lib" datarootdir="/usr/local/share" install
	make DESTDIR="${D}" prefix="/usr/local" exec_prefix="/usr/local" libdir="/usr/local/lib" datarootdir="/usr/local/share" install || die

	dodir /etc/X11/Sessions
	echo "/usr/local/bin/fvwm3" > "${D}/etc/X11/Sessions/${PN}" || die
	fperms a+x /etc/X11/Sessions/${PN} || die

	dodoc NEWS

	make_session_desktop fvwm3 /usr/local/bin/fvwm3
}
