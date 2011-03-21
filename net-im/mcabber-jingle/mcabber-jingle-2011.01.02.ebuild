# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils flag-o-matic autotools

FOLDER="alkino-mcabber-jingle-41425f7"
DESCRIPTION="Jingle module for MCabber, jabber console client"
HOMEPAGE="http://gsoc-mcabber.blogspot.com/"
SRC_URI="https://download.github.com/${FOLDER}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="crypt"
S="${WORKDIR}/${FOLDER}"

RDEPEND=">=net-im/mcabber-0.10.0[crypt=]
	>=net-libs/loudmouth-1.0"
DEPEND="${DEPEND}
	dev-util/cmake"

src_configure() {
	use crypt && append-flags -D_FILE_OFFSET_BITS=64
	cmake -DCMAKE_INSTALL_PREFIX="/usr" ${S} || die "CMake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}
