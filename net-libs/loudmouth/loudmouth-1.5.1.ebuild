# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GNOME_TARBALL_SUFFIX="bz2"
GNOME2_LA_PUNT="yes"
# Not using gnome macro, but behavior is similar, #434736
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="Lightweight C Jabber library"
HOMEPAGE="https://github.com/engineyard/loudmouth"
SRC_URI="https://mcabber.com/files/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="asyncns ssl static-libs test"

# Automagic libidn dependency
RDEPEND="
	>=dev-libs/glib-2.4:2
	net-dns/libidn
	ssl? ( >=net-libs/gnutls-1.4.0 )
	asyncns? ( net-libs/libasyncns )
"
# FIXME:
#   openssl dropped because of bug #216705

DEPEND="${RDEPEND}
	test? ( dev-libs/check )
	virtual/pkgconfig
	>=dev-util/gtk-doc-am-1
"

src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	local myconf

	if use ssl; then
		myconf="${myconf} --with-ssl=gnutls"
	else
		myconf="${myconf} --with-ssl=no"
	fi

	if use asyncns; then
		myconf="${myconf} --with-asyncns"
	else
		myconf="${myconf} --without-asyncns"
	fi
	gnome2_src_configure \
		$(use_enable static-libs static) \
		${myconf}
}

