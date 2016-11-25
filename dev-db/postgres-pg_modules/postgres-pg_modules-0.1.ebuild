EAPI="6"

inherit git-3

DESCRIPTION="Postgres modules developed by PropertyGuru"

HOMEPAGE="https://github.com/propertyguru/guruland/tree/master/backend/backend/native"
LICENSE="commercial"
SLOT="0"
KEYWORDS="amd64 x86"
SRC_URI=""
EGIT_REPO_URI="git://github.com/propertyguru/guruland"

DEPEND="dev-libs/icu
	dev-db/postgresql[server]"

S="${WORKDIR}/backend/backend/native/postgres"
