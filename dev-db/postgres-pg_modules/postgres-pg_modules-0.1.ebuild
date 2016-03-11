EAPI="5"

DESCRIPTION="Postgres modules developed by PropertyGuru"

HOMEPAGE="http://github.com/propertyguru/backend"
LICENSE="commercial"
SLOT="0"
KEYWORDS="amd64 x86"
SRC_URI="https://github.com/propertyguru/backend/archive/${P}.tar.gz"

RESTRICT="fetch"

DEPEND="dev-libs/icu
	dev-db/postgresql[server]"

RDEPEND=${DEPEND}

pkg_nofetch() {
    einfo "Please download the source code from:"
    einfo "${SRC_URI}"
    einfo "and place '${P}.tar.gz' in ${DISTDIR}"
}

S="${WORKDIR}/backend-${P}/native/postgres"
