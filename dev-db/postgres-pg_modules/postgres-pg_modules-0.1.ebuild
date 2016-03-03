EAPI="5"

DESCRIPTION="Postgres modules developed by PropertyGuru"

HOMEPAGE="http://github.com/propertyguru/backend"
LICENSE="commercial"
SLOT="0"
KEYWORDS="amd64 x86"
SRC_URI="https://github.com/propertyguru/backend/archive/${PN}-${PV}.tar.gz"

RESTRICT="fetch"

DEPEND="dev-libs/icu
	dev-db/postgresql[server]"

pkg_nofetch() {
    einfo "Please download the source code from:"
    einfo "${SRC_URI}"
    einfo "and place '${PN}-${PV}.tar.gz' in ${DISTDIR}"
}

src_unpack() {
	default

	# We just want to use github release system to do our work.
	# Github creates a folder named "backend-<releasetag>" at the
	# root of the archive which we need to rename so that
	# emerge/ebuild can function correctly from this point on.
	mv "${WORKDIR}/backend-${PN}-${PV}/" "${WORKDIR}/${PN}-${PV}"
}

src_compile() {
	emake -C native/postgres
}

src_install() {
	emake DESTDIR="${D}" -C native/postgres install
}
