EAPI="5"

DESCRIPTION="Postgres modules developed by PropertyGuru"

HOMEPAGE="http://github.com/propertyguru/backend"
LICENSE="commercial"
SLOT="0"
KEYWORDS="amd64 x86"
SRC_URI="http://bogus-server.localhost/lol/${PN}-${PV}.tar.gz"

DEPEND="dev-libs/icu
	dev-db/postgresql[server]"

pkg_nofetch() {
    einfo "Please download"
    einfo "  - ${P}.tar.gz"
    einfo "and place them in ${DISTDIR}"
}

src_compile() {
	emake -C native/postgres
}

src_install() {
	emake DESTDIR="${D}" -C native/postgres install
}
