# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"

EGIT_OVERRIDE_REPO_ENYOJS_BOOTPLATE="https://github.com/enyojs/bootplate.git"
EGIT_OVERRIDE_BRANCH_ENYOJS="master"

inherit python-any-r1 waf-utils xdg git-r3

DESCRIPTION="Virtual Guitar Amplifier for Linux"
HOMEPAGE="https://guitarix.org/"
EGIT_REPO_URI="https://github.com/brummer10/${PN}.git"
KEYWORDS=""
S="${WORKDIR}/${P}/trunk"

LICENSE="GPL-2"
SLOT="0"

# Enabling LADSPA is discouraged by the developer
# See https://linuxmusicians.com/viewtopic.php?p=88153#p88153
# For dkbuilder see https://linuxmusicians.com/viewtopic.php?f=44&p=102564
IUSE="bluetooth debug +lv2 nls nsm +standalone -ladspa zeroconf dkbuilder"
# When enabling LADSPA, standalone is required because the LADSPA build
# dependencies aren't correctly defined
REQUIRED_USE="|| ( lv2 standalone )"
#	ladspa? ( standalone )"

DEPEND="
	dev-cpp/eigen:3
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-libs/glib:2
	media-libs/libsndfile
	>=media-libs/zita-convolver-4
	>=media-libs/zita-resampler-1
	net-misc/curl
	sci-libs/fftw:3.0=
	x11-libs/gtk+:3
	lv2? ( media-libs/lv2 )
	standalone? (
		dev-libs/boost:=
		media-libs/liblrdf
		media-libs/lilv
		virtual/jack
		bluetooth? ( net-wireless/bluez )
		nsm? ( media-libs/liblo )
		zeroconf? ( net-dns/avahi )
	)
	ladspa? ( media-libs/ladspa-sdk )
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
	)
"
RDEPEND="
	${RDEPEND}
	standalone? ( media-fonts/roboto )
"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	standalone? (
		dev-lang/sassc
		nls? (
			dev-util/intltool
			sys-devel/gettext
		)
	)
"

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
		$(use_enable nls)
		$(usex bluetooth "" "--no-bluez")
		$(usex debug "--debug" "")
		$(usex lv2 "--lv2dir=${EPREFIX}/usr/$(get_libdir)/lv2" "--no-lv2 --no-lv2-gui")
		$(usex nsm "" "--no-nsm")
		$(usex standalone "" "--no-standalone")
		$(usex ladspa "--ladspa" "")
		$(usex zeroconf "" "--no-avahi")
	)
	waf-utils_src_configure "${mywafconfargs[@]}"
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
