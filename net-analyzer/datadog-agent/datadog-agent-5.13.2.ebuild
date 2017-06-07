# Distributed under the terms of the GNU General Public License v2
# https://raw.githubusercontent.com/DataDog/dd-agent/master/packaging/datadog-agent/source/setup_agent.sh
# TODO: we are not installing the jmx parts, that seems quite some work and we don't use JMX anyway

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 # We don't use distutils-r1 because although the tar.gz has a `setup.py` file but it's only useful for win32 and darwin

DESCRIPTION="The Datadog Agent faithfully collects events and metrics and brings them to app.datadoghq.com"
HOMEPAGE="https://github.com/DataDog/dd-agent/"
SRC_URI="
	https://github.com/DataDog/dd-agent/tarball/${PV} -> DataDog-dd-agent-${PV}.tar.gz
	https://api.github.com/repos/DataDog/integrations-core/tarball/${PV} -> DataDog-integrations-core-${PV}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="btrfs disk mysql network pgbouncer ssh_check"

GIT_HASH_AGENT="d37ee3a" # This is inside the .tar.gz file
S="${WORKDIR}/DataDog-dd-agent-${GIT_HASH_AGENT}"

GIT_HASH_INTEGRATIONS="d8872fa" # This is inside the .tar.gz file
S_INTEGRATIONS="${WORKDIR}/DataDog-integrations-core-${GIT_HASH_INTEGRATIONS}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}" # https://wiki.gentoo.org/wiki/Project:Python/python-single-r1#REQUIRED_USE

# https://github.com/DataDog/dd-agent/blob/master/requirements.txt
# The datadog agent requirements.txt says `python-etcd==0.4.2` but we are using 0.4.5 here because that's the first one which includes the dependency virtual/python-dnspython, without that datadog doesn't work
# The use optional dependencies are from `grep '^[^#]'. */requirements.txt` in the integrations directory
RDEPEND="
	app-admin/sysstat
	dev-python/boto[${PYTHON_USEDEP}]
	>=dev-python/docker-py-1.10.6[${PYTHON_USEDEP}]
	dev-python/kazoo[${PYTHON_USEDEP}]
	dev-python/ntplib[${PYTHON_USEDEP}]
	dev-python/python-consul[${PYTHON_USEDEP}]
	>=dev-python/python-etcd-0.4.5[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	dev-python/uptime[${PYTHON_USEDEP}]
	btrfs? ( dev-python/psutil[${PYTHON_USEDEP}] )
	disk? ( dev-python/psutil[${PYTHON_USEDEP}] )
	mysql? ( dev-python/pymysql[${PYTHON_USEDEP}] )
	network? ( dev-python/psutil[${PYTHON_USEDEP}] )
	pgbouncer? ( dev-python/psycopg:2[${PYTHON_USEDEP}] )
	ssh_check? ( dev-python/paramiko[${PYTHON_USEDEP}] )
"

DOCS="CHANGELOG.md CONTRIBUTING.md README.md datadog.conf.example"

DD_HOME=/opt/datadog-agent

src_install_datadog_integrations() {
	# This is really ugly, but this is what the `setup_agent.sh` script does :/
	local INTEGRATIONS=$(ls "$S_INTEGRATIONS"/)
	for INT in $INTEGRATIONS; do
		INT_DIR="${ED}/$DD_HOME/integrations/$INT"
		mv -v "$S_INTEGRATIONS/$INT" "$INT_DIR"
		if [ -f "$INT_DIR/check.py" ]; then
			cp -v "$INT_DIR/check.py" "${ED}/$DD_HOME/agent/checks.d/$INT.py"
		fi
		if [ -f "$INT_DIR/conf.yaml.example" ]; then
			cp -v "$INT_DIR/conf.yaml.example" "${ED}/$DD_HOME/agent/conf.d/$INT.yaml.example"
		fi
		if [ -f "$INT_DIR/auto_conf.yaml" ]; then
			cp -v "$INT_DIR/auto_conf.yaml" "${ED}/$DD_HOME/agent/conf.d/auto_conf/$INT.yaml"
		fi
		if [ -f "$INT_DIR/conf.yaml.default" ]; then
			cp -v "$INT_DIR/conf.yaml.default" "${ED}/$DD_HOME/agent/conf.d/$INT.yaml.default"
		fi
	done
}

src_install() {
	default

	find "${S}" -name '*.py' -type f -print0 | xargs -0 sed -i '1 s%#!/opt/datadog-agent/embedded/bin/python%#!/usr/bin/env python%' || die

	python_moduleinto "$DD_HOME/agent"
	python_domodule checks dogstream utils
	python_domodule aggregator.py config.py daemon.py emitter.py graphite.py jmxfetch.py modules.py transaction.py util.py

	exeinto "$DD_HOME/agent"
	doexe agent.py ddagent.py dogstatsd.py

	insinto "$DD_HOME/agent"
	doins datadog-cert.pem

	dodir "$DD_HOME"/{integrations,agent/checks.d,agent/conf.d/auto_conf}

	src_install_datadog_integrations

	python_fix_shebang "${ED}"
	python_optimize "${ED}"

	dodir /var/log/datadog

	dodir /etc/dd-agent/ #/etc/dd-agent/checks.d /etc/dd-agent/conf.d

	doinitd "${FILESDIR}/init.d"/{datadog-agent,datadog-ddagent,datadog-dogstatsd}
}
