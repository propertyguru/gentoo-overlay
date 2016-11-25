EAPI="6"

inherit git-r3

DESCRIPTION="Postgres modules developed by PropertyGuru"

HOMEPAGE="https://github.com/propertyguru/guruland/tree/master/backend/backend/native"
LICENSE="commercial"
SLOT="0"
KEYWORDS="amd64 x86"
# You need to put deploy key/ssh private key
# owned by portage:portage to /var/tmp/portage/.ssh directory
EGIT_REPO_URI="ssh://git@github.com/propertyguru/guruland"

DEPEND="dev-libs/icu
        dev-db/postgresql[server]"

S="${WORKDIR}/${P}/backend/backend/native/postgres"
