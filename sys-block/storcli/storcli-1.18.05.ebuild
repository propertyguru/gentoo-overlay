# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="SAS MegaRAID StorCLI"
HOMEPAGE="http://www.avagotech.com/support/download-search"
SRC_URI="http://docs.avagotech.com/docs-and-downloads/raid-controllers/raid-controllers-common-files/1.18.05_StorCLI.zip"

LICENSE="LSI"
SLOT="6.8"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

RESTRICT="mirror"

QA_PRESTRIPPED="opt/lsi/${PN}/storcli"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	mv storcli_all_os/Ubuntu/storcli_*.deb "${WORKDIR}" || die "Failed to move storclli_*.deb"
	rm -rf storcli_all*
	unpack ./storcli_*.deb
	rm -f storcli_*.deb
	unpack ./data.tar.gz
	rm -f control.tar.gz data.tar.gz debian-binary
}

src_install() {
	exeinto /opt/lsi/${PN}

	if use x86; then
		doexe opt/MegaRAID/storcli/storcli
	elif use amd64; then
		newexe opt/MegaRAID/storcli/storcli64 storcli
	fi

	dosym /opt/lsi/${PN}/storcli /usr/sbin/storcli

	newdoc *CLI.txt ReleaseNotes
}
