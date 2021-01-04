# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils multilib flag-o-matic git-r3

DESCRIPTION="The most advanced non-linear video editor and compositor"
HOMEPAGE="http://www.cinelerra.org/"
#EGIT_REPO_URI="git://git.cinelerra-cv.org/CinelerraCV.git"
EGIT_REPO_URI="git://git.cinelerra-gg.org/goodguy/cinelerra.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa commercial -festival -git_ffmpeg cpu_flags_x86_mmx opengl -oss -pulseaudio vaapi vdpau"

RDEPEND="festival? ( app-accessibility/festival )
	pulseaudio? ( media-sound/pulseaudio )
	dev-libs/libxml2:=
	dev-perl/Parse-ExuberantCTags:=
	media-fonts/ttf-bitstream-vera:=
	media-fonts/font-adobe-75dpi:=
	media-fonts/font-adobe-100dpi:=
	media-fonts/dejavu:=
	media-gfx/inkscape:=
	media-libs/flac:=
	media-libs/fontconfig
	>=media-libs/freetype-2
	media-libs/giflib:=
	media-libs/ilmbase:=
	media-libs/jbigkit:=
	media-libs/ladspa-sdk:=
	media-libs/libdv:=
	media-libs/libdvdread:=
	media-libs/libdvdnav:=
	media-libs/libiec61883:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/libsndfile:0=
	media-libs/libtheora:=
	media-libs/libvorbis:=
	media-libs/openexr:=
	media-libs/openjpeg:=
	media-libs/sdl-gfx:=
	media-libs/tiff:=
	media-libs/x264:=
	media-libs/x265:=
	media-sound/twolame:=
	media-video/mjpegtools:=
	sci-libs/fftw:=
	sys-apps/util-linux:=
	sys-devel/gettext:=
	sys-fs/e2fsprogs:=
	sys-fs/udftools:=
	sys-libs/libavc1394:=
	sys-libs/ncurses:=
	x11-libs/libX11:=
	x11-libs/libXext:=
	x11-libs/libXft:=
	x11-libs/libXinerama:=
	x11-libs/libXv:=
	x11-libs/libXvMC:=
	x11-libs/libXxf86vm:=
	virtual/libusb:=
	alsa? ( media-libs/alsa-lib:= )
	opengl? (
		virtual/glu
		virtual/opengl
		)
	vaapi? ( x11-libs/libva:= )
	vdpau? ( x11-libs/libvdpau:= )"
DEPEND="${RDEPEND}
	app-arch/bzip2
	app-arch/xz-utils
	virtual/pkgconfig
	dev-lang/yasm
	cpu_flags_x86_mmx? ( dev-lang/nasm )
	sys-apps/texinfo
	sys-libs/zlib
	dev-util/cmake"

S="${WORKDIR}/${P}/${PN}-5.1"

src_prepare() {
	cp "${FILESDIR}/mjpegtools-2.1.0.patch3" "${S}/thirdparty/src"
	eautoreconf
}

src_configure() {
# Good Guy tell me it is best to use the thirdparty build instead of system libraries
# 1) it is know to work 2) it add fix and functions
	econf \
		--with-exec-name=cinelerra \
		$(use_with oss) \
		$(use_with alsa) \
		$(use_with commercial) \
		--without-esound \
		$(use_with opengl gl) \
		$(use_with vaapi) \
		$(use_with vdpau) \
		$(use_with git_ffmpeg git-ffmpeg)
}

src_install() {
	make DESTDIR="${D}" install || die
	prune_libtool_files --all
}
