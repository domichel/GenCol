# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 git-r3

DESCRIPTION="A Python wrapper for the liblo OSC library"
HOMEPAGE="http://github.com/gesellkammer/pyliblo3"
EGIT_REPO_URI="https://github.com/gesellkammer/${PN}.git"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=media-libs/liblo-0.27
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"
#	<dev-python/cython-3[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${P}_pointer-type.patch"
	"${FILESDIR}/${P}_gitignore.patch"
)

distutils_enable_tests unittest
