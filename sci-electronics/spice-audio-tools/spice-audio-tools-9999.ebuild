# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9,10,11,12} )
inherit git-r3 python-single-r1 python-utils-r1

DESCRIPTION="2 programs for using wav files with ngspice"
HOMEPAGE="https://github.com/Ttl/${PN}"
EGIT_REPO_URI="https://github.com/Ttl/${PN}.git"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	sci-electronics/ngspice"

RESTRICT="mirror"
DOCS="README examples"

src_install() {
	python_doscript spiceaudiotools/spicetowav.py spiceaudiotools/wavtospice.py
	dosym "${EPREFIX}"/usr/lib/python-exec/"${EPYTHON}"/spicetowav.py "${EPREFIX}"/usr/bin/spicetowav
	dosym "${EPREFIX}"/usr/lib/python-exec/"${EPYTHON}"/wavtospice.py "${EPREFIX}"/usr/bin/wavtospice
	einstalldocs
}
