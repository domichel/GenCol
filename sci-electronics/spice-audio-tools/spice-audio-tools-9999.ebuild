# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6,7,8} )
inherit git-r3 python-single-r1 python-utils-r1

DESCRIPTION="2 programs for using wav files with ngspice"
HOMEPAGE="https://github.com/Ttl/${PN}"
# zip snapshot straight from github, renamed and uploaded to proaudio distfiles
EGIT_REPO_URI="https://github.com/Ttl/${PN}.git"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

RESTRICT="mirror"
DOCS="README examples"

src_install() {
	python_doscript spicetowav.py wavtospice.py
	dosym "${EPREFIX}"/usr/lib/python-exec/"${EPYTHON}"/spicetowav.py "${EPREFIX}"/usr/bin/spicetowav
	dosym "${EPREFIX}"/usr/lib/python-exec/"${EPYTHON}"/wavtospice.py "${EPREFIX}"/usr/bin/wavtospice
	einstalldocs
}
