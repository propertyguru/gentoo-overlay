EAPI="6"

PYTHON_COMPAT=( python2_7 ) # compatible only with python 2.7, for example it uses the old style print statements
inherit git-r3 distutils-r1

DESCRIPTION="Continuous archiving of PostgreSQL WAL files and base backups"
HOMEPAGE="https://github.com/wal-e/wal-e"
EGIT_REPO_URI="https://github.com/wal-e/wal-e.git"

LICENSE="BSD-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="keystone swift test"

RESTRICT="test" # Tests cannot be ran currently because the azure>=0.7.0 package is not in gentoo

RDEPEND="app-arch/lzop
	>=dev-db/postgresql-8.4
	sys-apps/pv
	>=dev-python/gevent-1.0.2
	>=dev-python/boto-2.24.0
	swift? (  >=dev-python/python-swiftclient-1.8.0 )
	keystone? ( >=dev-python/python-keystoneclient-0.4.2 )
	"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}] )
	"

python_test() {
	esetup.py test
}
