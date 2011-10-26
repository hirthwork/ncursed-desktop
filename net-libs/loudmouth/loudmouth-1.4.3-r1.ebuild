# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/loudmouth/loudmouth-1.4.3-r1.ebuild,v 1.11 2010/09/09 13:36:28 ranger Exp $

inherit autotools gnome2

DESCRIPTION="Lightweight C Jabber library"
HOMEPAGE="http://www.loudmouth-project.org/"
SRC_URI="http://ftp.imendio.com/pub/imendio/${PN}/src/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~ppc-macos"

IUSE="asyncns doc ssl debug test fix-utf8"

RDEPEND=">=dev-libs/glib-2.4
	ssl? ( >=net-libs/gnutls-1.4.0 )
	asyncns? ( net-libs/libasyncns )"
# FIXME:
#   openssl dropped because of bug #216705

DEPEND="${RDEPEND}
	test? ( dev-libs/check )
	dev-util/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )
	>=dev-util/gtk-doc-am-1"

DOCS="AUTHORS ChangeLog NEWS README"

pkg_setup() {
	G2CONF="${G2CONF} $(use_enable debug)"

	if use ssl; then
		G2CONF="${G2CONF} --with-ssl=gnutls"
	else
		G2CONF="${G2CONF} --with-ssl=no"
	fi

	if use asyncns; then
		G2CONF="${G2CONF} --with-asyncns=system"
	else
		G2CONF="${G2CONF}  --without-asyncns"
	fi
}

src_unpack() {
	gnome2_src_unpack

	# Use system libasyncns, bug #236844
	epatch "${FILESDIR}/${P}-asyncns-system.patch"

	# Fix detection of gnutls-2.8, bug #272027
	epatch "${FILESDIR}/${P}-gnutls28.patch"

	# Fix digest auth with SRV (or similar)
	# Upstream: http://loudmouth.lighthouseapp.com/projects/17276-libloudmouth/tickets/44-md5-digest-uri-not-set-correctly-when-using-srv
	epatch "${FILESDIR}/${P}-fix-sasl-md5-digest-uri.patch"

	# Drop stanzas when failing to convert them to LmMessages
	# From debian..
	epatch "${FILESDIR}/${P}-drop-stanzas-on-fail.patch"

	# Don't check for sync dns problems when using asyncns [#33]
	# From debian..
	epatch "${FILESDIR}/${P}-async-fix.patch"

	if use fix-utf8; then
		epatch "${FILESDIR}/${P}-fix-utf8.patch"
	fi

	eautoreconf
}
