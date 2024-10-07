# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit "git-r3"

DESCRIPTION="run GUI applications in containers"
HOMEPAGE="https://github.com/mviereck/x11docker"
EGIT_REPO_URI="https://github.com/mviereck/x11docker.git"
LICENSE="MIT"
SLOT=0

IUSE="catatonit docker gpu podman nerdctl"

RDEPEND="app-shells/bash
	|| ( dev-lang/python app-misc/jq )
	|| ( x11-base/xorg-server[xcsecurity,xephyr] net-misc/nx x11-wm/xpra )
	x11-apps/setxkbmap
	x11-apps/xauth
	x11-misc/xclip
	x11-apps/xdpyinfo
	x11-apps/xhost
	x11-apps/xinit
	x11-apps/xrandr
	catatonit? ( app-containers/catatonit )
	docker? ( app-containers/docker )
	gpu? ( x11-misc/xdotool
		x11-wm/xpra )
	podman? ( app-containers/podman )
	nerdctl? ( app-containers/nerdctl )
"

src_install()
{
    sed -i 's:Packagedversion="no":Packagedversion="yes":' x11docker || die "sed failed"
    dobin "${PN}"
    dodoc CHANGELOG.md README.md TODO.md paper.bib paper.md "${PN}".png
    newman "${PN}".man "${PN}".1
}
