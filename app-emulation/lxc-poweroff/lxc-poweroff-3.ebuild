# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=6

DESCRIPTION="Init script to shut down all lxc VMs on poweroff, similar to ganeti-kvm-poweroff"
HOMEPAGE="https://github.com/propertyguru/gentoo-overlay/tree/master/app-emulation/lxc-poweroff"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm arm64" # Same architectures as app-emulation/lxc

# The init script uses the command parallel from moreutils
RDEPEND="
	app-emulation/lxc
"

src_unpack() {
	mkdir "${S}" # The source directory '/tmp/portage/app-emulation/lxc-poweroff-1/work/lxc-poweroff-1' doesn't exist
}

src_install() {
	newinitd "${FILESDIR}/${PN}-init" "${PN}"
}
