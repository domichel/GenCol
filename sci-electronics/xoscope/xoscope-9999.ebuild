# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils git-r3

DESCRIPTION="Soundcard Oscilloscope for X"
HOMEPAGE="http://xoscope.sourceforge.net"
EGIT_REPO_URI="git://git.code.sf.net/p/${PN}/code"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/gtkdatabox
	media-libs/alsa-lib
	virtual/man"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-man_no_-Tutf8.patch
	"${FILESDIR}"/${PN}-trace_colors.patch )

src_prepare() {
	default
	eautoreconf
}
