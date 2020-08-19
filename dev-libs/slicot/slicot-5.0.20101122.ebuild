# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEED_OPENMP="1"
inherit fortran-2

DESCRIPTION="Subroutine Library In Control Theory"
HOMEPAGE="http://www.slicot.org"
MY_P="${PN}_5.0+20101122"
SRC_URI="http://deb.debian.org/debian/pool/main/s/${PN}/${MY_P}.orig.tar.gz
	http://deb.debian.org/debian/pool/main/s/${PN}/${MY_P}-4.debian.tar.xz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="dev-util/debhelper
	virtual/lapack
	virtual/blas"
DEPEND="${BDEPEND}"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-5.0-rules.patch" )

S="${WORKDIR}/${PN}-5.0+20101122"

src_unpack() {
#	default
	cd "${WORKDIR}"
	unpack "${MY_P}.orig.tar.gz"
	cd "${S}"
	unpack "${MY_P}-4.debian.tar.xz"
}

src_compile() {
	emake -f debian/rules build
}

src_install() {
	dolib.so libslicot.so.0.0 libslicot.so.0 libslicot.so
	dodoc readme

	if  use doc ; then
		docinto html
		dodoc libindex.html
		docinto html/doc
		dodoc doc/*
		docinto examples/fortran90
		dodoc examples/*
		docinto examples/fortran77
		dodoc examples77/*
	fi
}
