EAPI=5

inherit bzr

DESCRIPTION=""
HOMEPAGE="http://blog.dustinkirkland.com/2011/02/introducing-run-one-and-run-this-one.html"
EBZR_REPO_URI="lp:run-one"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

src_install() {
  dobin run-one
  # These should be symlinks to run-one:
  dobin keep-one-running run-one-constantly run-one-until-failure run-one-until-success run-this-one
  doman run-one.1
  dodoc debian/changelog
}
