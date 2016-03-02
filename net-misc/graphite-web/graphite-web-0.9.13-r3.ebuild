# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 python-utils-r1 prefix git-2 user

DESCRIPTION="Enterprise scalable realtime graphing"
HOMEPAGE="http://graphite.readthedocs.org/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/graphite-project/${PN}.git"
# FIXME: Very hacky, but they didn't merge to their tagged branch for a long time.
# The differences are huge
EGIT_COMMIT="189ff9c37e9b81087b1e4ad795b3761a02e70ead"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ldap memcached +sqlite +gunicorn"

DEPEND=""
RDEPEND="dev-lang/python[sqlite?]
	>=dev-python/django-1.6[sqlite?,${PYTHON_USEDEP}]
	>=dev-python/twisted-core-10.0[${PYTHON_USEDEP}]
	>=dev-python/django-tagging-0.3.1[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/txAMQP[${PYTHON_USEDEP}]
	net-misc/carbon[${PYTHON_USEDEP}]
	dev-python/whisper[${PYTHON_USEDEP}]
	media-libs/fontconfig
	gunicorn? (
		www-servers/gunicorn[${PYTHON_USEDEP}]
		dev-python/gevent[${PYTHON_USEDEP}]
	)
	memcached? ( dev-python/python-memcached[${PYTHON_USEDEP}] )
	ldap? ( dev-python/python-ldap[${PYTHON_USEDEP}] )"

PATCHES=(
	# Do not install the configuration and data files. We install them
	# somewhere sensible by hand.
	# Use FHS paths
	"${FILESDIR}"/${P}-fhs-paths.patch
	"${FILESDIR}"/${P}-manifest.patch
	"${FILESDIR}"/${P}-gen-secret.patch
)

EXAMPLES=(
	conf/dashboard.conf.example
)

src_prepare() {
	distutils-r1_src_prepare
	eprefixify \
		webapp/graphite/local_settings.py.example
}

python_install() {
	distutils-r1_python_install \
		--install-data="${EPREFIX}"/usr/share/${PN}

	# make manage.py available from an easier location/name
	dodir /usr/bin
	mv webapp/manage.py \
		"${ED}"/usr/bin/${PN}-manage || die
	chmod 0755 "${ED}"/usr/bin/${PN}-manage || die
	python_fix_shebang "${ED}"/usr/bin/${PN}-manage

	insinto /etc/${PN}
	if use gunicorn ; then
		newins "${FILESDIR}"/gunicorn.conf gunicorn.conf
	fi
	
	newins webapp/graphite/local_settings.py.example local_settings.py
	if use gunicorn ; then
		newinitd "${FILESDIR}"/graphite-web.gunicorn.init graphite-web
	fi
	pushd "${D}"/$(python_get_sitedir)/graphite > /dev/null || die
	ln -s ../../../../../etc/${PN}/local_settings.py local_settings.py
	popd > /dev/null || die
}

pkg_config() {
	"${ROOT}"/usr/bin/${PN}-manage syncdb --noinput
	local idx=$(grep 'INDEX_FILE =' "${EROOT}"/etc/graphite-web/local_settings.py 2>/dev/null)
	if [[ -n ${idx} ]] ; then
		idx=${idx##*=}
		idx=$(echo ${idx})
		eval "idx=${idx}"
		touch "${ROOT}"/"${idx}"/index
	fi
}

pkg_postinst() {
	einfo "Don't forget to edit local_settings.py in ${EPREFIX}/etc/${PN}"
	einfo "See http://graphite.readthedocs.org/en/latest/config-local-settings.html"
	einfo "Run emerge --config =${PN}-${PVR} if this is a fresh install."
	enewgroup carbon
	enewuser carbon -1 -1 -1 carbon
}
