# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

DESCRIPTION="Ignore MUC user plugin for mcabber"
HOMEPAGE="https://github.com/hirthwork/${PN}"
SRC_URI="https://github.com/hirthwork/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
HASH="7a72057"
S="${WORKDIR}/hirthwork-${PN}-${HASH}"

DEPEND=">=net-im/mcabber-0.10.0[modules]"
RDEPEND="${DEPEND}"

src_install() {
	make DESTDIR="${D}/usr/lib/mcabber" CFLAGS="${CFLAGS}" install || die "install failed"
}

