# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Scripts to build Ganeti VMs with debootstrap"
HOMEPAGE="http://code.google.com/p/ganeti/"
SRC_URI="http://downloads.ganeti.org/instance-debootstrap/ganeti-instance-debootstrap-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-arch/dpkg
	app-arch/dump
	app-emulation/ganeti
	dev-util/debootstrap
	>=sys-apps/coreutils-6.10-r1
	sys-apps/util-linux
	sys-fs/e2fsprogs
	sys-fs/multipath-tools"

src_prepare() {
	epatch "${FILESDIR}/x-instance-debootstrap-sfdisk.patch"
	epatch "${FILESDIR}/x-create-add-xfs.patch"
}

src_configure() {
	econf --docdir=/usr/share/doc/${P} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	insinto /etc/ganeti/instance-debootstrap/hooks
	doins examples/hooks/*

	# Virgo fixes:
	# Remove grub hook, it's useless still:
	rm "${D}"/etc/ganeti/instance-debootstrap/hooks/grub || die
	# The interfaces script works well on the other hand:
	chmod +x "${D}"/etc/ganeti/instance-debootstrap/hooks/interfaces || die
	# Replace variants.list with a link to /etc/ganeti, like on ubuntu:
	ln -sf ../../../../../etc/ganeti/instance-debootstrap/variants.list "${D}"/usr/share/ganeti/os/debootstrap/variants.list || die
	# Replace CACHE_DIR="/var/lib/cache/ganeti-instance-debootstrap" with CACHE_DIR="/var/cache/ganeti-instance-debootstrap" because there is no /var/lib/cache directory on ubuntu:
	sed -i 's#^CACHE_DIR.*$#CACHE_DIR="/var/cache/ganeti-instance-debootstrap"#' "${D}"/usr/share/ganeti/os/debootstrap/common.sh || die
}
