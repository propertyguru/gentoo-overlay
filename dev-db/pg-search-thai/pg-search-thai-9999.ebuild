
EAPI="5"

inherit git-r3

DESCRIPTION="TODO"

HOMEPAGE="https://github.com/zdk/pg-search-thai"
LICENSE="TODO"
SLOT="0"
KEYWORDS="~amd64"

EGIT_REPO_URI="https://github.com/zdk/pg-search-thai.git"

IUSE="" # TODO: dictionary parser

# https://github.com/zdk/pg-search-thai#installation
DEPEND="dev-libs/libthai
	dev-libs/libdatrie
	virtual/libiconv
	dev-db/postgresql[server]"

src_compile() {
	# Unfortunately it seems there is no easy way to separate install and compile, the make file installs everything in the compile phase, so don't do anything here
	true
}

src_install() {
	TSEARCH_DATA_DIR="${D}/`pg_config --sharedir`/tsearch_data"
	mkdir -p "$TSEARCH_DATA_DIR"
	emake DESTDIR="${D}" TSEARCH_DATA_DIR="$TSEARCH_DATA_DIR"
	# TODO: symlink in /usr/share/postgresql-9.4/tsearch_data
	#  ln -s th_TH.dict th_th.dict
	#  th_TH.affix th_th.affix
}

# TODO: support multiple postgres versions
# TODO: there is a test.sh, try to use that under src_test()
# repmgr and textsearch_ja ebuilds might be a good example
