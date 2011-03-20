# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils flag-o-matic autotools

HASH="bbf9dc965f77"
DESCRIPTION="PEP module for MCabber, jabber console client"
HOMEPAGE="http://hg.lilotux.net/index.cgi/mod-mcabber-pep"
SRC_URI="http://hg.lilotux.net/index.cgi/${PN}/archive/${HASH}.tar.gz"
S="${PN}-${HASH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="crypt"

RDEPEND="=net-im/mcabber-0.10.1[crypt=]
	>=net-libs/loudmouth-1.0"
DEPEND="${DEPEND}
	dev-util/cmake"

src_configure() {
	use crypt && append-flags -D_FILE_OFFSET_BITS=64
	(cd ${S} && epatch "${FILESDIR}"/pep_branch.patch && cd ->/dev/null) ||
		die "Branch patch failed"
	cmake -DCMAKE_INSTALL_PREFIX="/usr" ${S} || die "CMake failed"
}

src_install() {
	CMAKE_INSTALL_PREFIX=/usr make DESTDIR="${D}" install || die "install failed"
}
