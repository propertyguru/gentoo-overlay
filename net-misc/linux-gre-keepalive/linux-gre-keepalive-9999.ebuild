EAPI=6

EGIT_REPO_URI="https://github.com/PaulTimmins/${PN}.git"

inherit git-r3

DESCRIPTION="Userspace daemon in perl to handle Cisco GRE keepalives"
HOMEPAGE="https://github.com/PaulTimmins/linux-gre-keepalive"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-perl/Proc-Daemon
dev-perl/Net-Pcap
virtual/perl-Socket"
DEPEND=""

src_install() {
  dobin gre-keepalive.pl
  dodoc README.md
}
