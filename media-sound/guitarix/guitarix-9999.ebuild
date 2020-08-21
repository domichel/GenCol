# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit python-any-r1 waf-utils

DESCRIPTION="A simple Linux Guitar Amplifier for jack with one input and two outputs"
HOMEPAGE="http://guitarix.sourceforge.net/"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
#	EVCS_OFFLINE=1
	EGIT_REPO_URI="https://git.code.sf.net/p/guitarix/git"
	EGIT_SUBMODULES=()
	KEYWORDS=""
	S="${S}/trunk"
else
	SRC_URI="mirror://sourceforge/guitarix/guitarix/${PN}2-${PV}.tar.xz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/guitarix-${PV}"
fi
LICENSE="GPL-2"
SLOT="0"

# Enabling LADSPA is discouraged by the developer
# See https://linuxmusicians.com/viewtopic.php?p=88153#p88153
# For dkbuilder see https://linuxmusicians.com/viewtopic.php?f=44&p=102564
IUSE="+standalone -ladspa +lv2 avahi bluetooth nls dkbuilder"
# When enabling LADSPA, standalone is required because the LADSPA build
# dependencies aren't correctly defined
REQUIRED_USE="|| ( lv2 standalone )"
#	ladspa? ( standalone )"

RDEPEND="media-libs/libsndfile
	x11-libs/gtk+:2
	virtual/jack
	dev-cpp/gtkmm:2.4
	dev-libs/boost
	dev-cpp/eigen:3
	sci-libs/fftw:3.0
	>=media-libs/zita-convolver-3
	media-libs/zita-resampler
	standalone? (
		dev-lang/sassc
		media-libs/lilv
		media-libs/liblrdf
		media-fonts/roboto
	)
	ladspa? ( media-libs/ladspa-sdk )
	lv2? ( media-libs/lv2 )
	avahi? ( net-dns/avahi )
	bluetooth? ( net-wireless/bluez )
	dkbuilder? (
		sci-electronics/geda
		<=dev-lang/faust-0.9.90
		dev-cpp/eigen
		dev-libs/slicot
		sci-libs/cminpack
		sci-libs/sundials
		sci-mathematics/maxima
		dev-python/virtualenv
		dev-python/virtualenvwrapper
	)"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	nls? ( dev-util/intltool )"

DOCS=( changelog README )
PATCHES=( "${FILESDIR}/${PN}.nostrip.patch" )

src_configure() {
#		--ldflags="${LDFLAGS}"
	local mywafconfargs=(
		--cxxflags-debug=""
		--cxxflags-release="-DNDEBUG"
		--enable-lfs
		--lib-dev
		--no-desktop-update
		--no-faust
		--no-ldconfig
		--shared-lib
		$(usex standalone "" "--no-standalone")
		$(usex ladspa "--ladspa --new-ladspa" "")
		$(usex lv2 "" "--no-lv2")
		$(usex avahi "" "--no-avahi")
		$(usex bluetooth "" "--no-bluez")
		$(usex nls "--enable-nls" "--disable-nls")
	)
	waf-utils_src_configure ${mywafconfargs[@]}
}

src_install() {
	waf-utils_src_install
	if use dkbuilder; then
		cd src/headers
		insinto /usr/share/guitarix/src/headers
		doins -r *
		cd "${S}"/tools
		insopts -m0777
		insinto /usr/bin
		doins "${FILESDIR}/dkbuilder"
		# we want to preserve the original file permssions and made them world writable
		mkdir -p "${ED}/usr/share/guitarix/tools"
		cp -r "${S}"/tools/* "${ED}/usr/share/guitarix/tools"
		chmod -R g+w,o+w "${ED}/usr/share/guitarix/tools"

		elog "The dkbuilder is installed world writable into ${ED}/usr/share/guitarix/tools"-
		elog "This doesn't follow hentoo policy, please, don't report it to gentoo,"
		elog "they habe nothing to do with that and this is needed for the dkbuilder to work for the users."
		elog "If you don't like it, just don't use that ebuild to install the dkbuilder."
		elog ""
		elog "You need to setup your environment to use dkbuilder."
		elog "For that follow the advice in:"
		elog "less /usr/share/guitarix/tools/ampsim/DK/README"
		elog "It is more advice and support on https://linuxmusicians.com/viewtopic.php?f=44&t=19586"
		elog "The exact URL on linux musicians can change, so search for dkbuilder"
		elog "The subject name is 'dkbuilder: from circuit to LV2 plugin'"
		elog ""
		elog "That ebuild install a helper sript to help you with the virtual environment setup."
		elog "To read how ro use it, run 'dkbuilder' as user."
	fi
}
