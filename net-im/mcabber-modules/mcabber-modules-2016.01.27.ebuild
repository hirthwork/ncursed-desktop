# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils flag-o-matic autotools

HASH="18621bbdd2b2"
DESCRIPTION="Modules for MCabber, jabber console client"
HOMEPAGE="http://hg.lilotux.net/index.cgi/mcabber-modules"
SRC_URI="http://hg.lilotux.net/${PN}/archive/${HASH}.tar.gz"
S="${PN}-${HASH}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="crypt clock comment extsayng ignore_auth info_msgcount killpresence lastmsg"

DEPEND=">=net-im/mcabber-0.10.0[crypt=]
	extsayng? ( app-misc/screen )"
RDEPEND="${DEPEND}"

src_prepare() {
	use crypt && append-flags -D_FILE_OFFSET_BITS=64
	cp -r ${S}/* .
	./autogen.sh || die "autoconf failed"
	use extsayng && epatch "${FILESDIR}"/extsay.patch
}

src_configure() {
	local myconf=""
	for i in ${IUSE}; do
		if [ ${i} != "crypt" ] && use ${i}; then
			myconf="${myconf} --enable-module-${i}"
		fi
	done
	econf ${myconf} || die "configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	exeinto /usr/lib/mcabber
	use extsayng && doexe extsay-ng/extsay.sh "${D}"/usr/lib/mcabber/ || die
}

pkg_postinst() {
	if use extsayng; then
		elog "You will need to enable FIFO and set extsay_script_path"
		elog "to /usr/lib/mcabber/extsay.sh to use extsay module"
	fi
}
