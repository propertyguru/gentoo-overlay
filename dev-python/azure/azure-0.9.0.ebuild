# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Windows Azure client APIs"
HOMEPAGE="https://github.com/Azure/azure-sdk-for-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-python/python-dateutil[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"