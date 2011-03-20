# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils flag-o-matic autotools

HASH="aa40c940b180"
DESCRIPTION="Modules for MCabber, jabber console client"
HOMEPAGE="http://hg.lilotux.net/index.cgi/mcabber-modules"
SRC_URI="http://hg.lilotux.net/index.cgi/${PN}/archive/${HASH}.tar.gz"
S="${PN}-${HASH}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="crypt clock comment extsayng ignore_auth info_msgcount killpresence lastmsg"

DEPEND=">=net-im/mcabber-0.10.0[crypt=]
	extsayng? ( app-misc/screen )"
RDEPEND="${DEPEND}"

src_configure() {
	use crypt && ( use clock || use extsay || use ignore_auth ||
		use info_msgcount || use killpresence || use lastmsg ) &&
		append-flags -D_FILE_OFFSET_BITS=64
	cp -r ${S}/* .
	./autogen.sh || die "autoconf failed"
	local myconf=""
	for i in ${IUSE}; do
		if use ${i}; then
			myconf="${myconf} --enable-module-${i}"
		fi
	done
	econf ${myconf} || die "configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}
