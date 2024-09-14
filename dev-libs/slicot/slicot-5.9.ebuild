# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_NEED_OPENMP="1"
inherit fortran-2

DESCRIPTION="Subroutine Library In Control Theory"
HOMEPAGE="http://www.slicot.org"
MY_P="${PN}_${PV}"
SRC_URI="http://deb.debian.org/debian/pool/main/s/${PN}/${MY_P}.orig.tar.gz"
#	http://deb.debian.org/debian/pool/main/s/${PN}/${MY_P}-1.debian.tar.xz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

BDEPEND="dev-util/debhelper
	virtual/lapack
	virtual/blas"
DEPEND="${BDEPEND}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/SLICOT-SLICOT-Reference-a037f7e"

src_compile() {
	SO=0
	emake -f makefile_Unix lib FORTRAN="${FC}" OPTS="${CFLAGS} $(fortran_int64_abi_fflags) -fPIC" ARCH=$(tc-getAR) \
		SLICOTLIB="../libslicot.a"
	${FC} ${LDFLAGS} -shared -Wl,-soname=libslicot.so."${SO}" -o libslicot.so."${SO}" -Wl,--whole-archive libslicot.a \
		-Wl,--no-whole-archive -lblas -llapack || die "Build lib failed"
	ln -snf libslicot.so.0 libslicot.so || die "Symlink lib failed"
}

src_install() {
	dolib.so libslicot.so.0 libslicot.so
	dodoc README.md

	if  use doc ; then
		docinto html
		dodoc libindex.html
		docinto html/doc
		dodoc doc/*
	fi
	if  use doc ; then
		docinto examples/fortran90
		dodoc examples/*
	fi
}
