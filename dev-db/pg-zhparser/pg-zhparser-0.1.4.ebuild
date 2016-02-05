EAPI="5"

DESCRIPTION="PostgreSQL extension for full-text search of Chinese"

HOMEPAGE="http://blog.amutu.com/zhparser/"
LICENSE="postgresql"
SLOT="0"
KEYWORDS="~amd64"

MY_PN=zhparser
MY_P="${MY_PN}-${PV}"
SRC_URI="https://github.com/amutu/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_P}"

IUSE=""

DEPEND="dev-libs/scws"

src_compile() {
	export SCWS_HOME="/usr" # This defaults to empty, but the Makefile has things like this: `-I$(SCWS_HOME)/include/scws`
	default
}
