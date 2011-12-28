# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/mutt/mutt-1.5.21-r7.ebuild,v 1.2 2011/12/04 21:05:40 grobian Exp $

EAPI="3"

inherit eutils flag-o-matic autotools

PATCHSET_REV="-r7"

DESCRIPTION="A small but very powerful text-based mail client"
HOMEPAGE="http://www.mutt.org/"
SRC_URI="ftp://ftp.mutt.org/mutt/devel/${P}.tar.gz
	mirror://gentoo/${P}-gentoo-patches${PATCHSET_REV}.tar.bz2
	http://dev.gentoo.org/~grobian/distfiles/${P}-gentoo-patches${PATCHSET_REV}.tar.bz2"
IUSE="berkdb crypt debug doc gdbm gnutls gpg idn imap mbox nls nntp pop qdbm sasl selinux sidebar smime smtp ssl tokyocabinet"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
RDEPEND=">=sys-libs/ncurses-5.2
	tokyocabinet?  ( dev-db/tokyocabinet )
	!tokyocabinet? (
		qdbm?  ( dev-db/qdbm )
		!qdbm? (
			gdbm?  ( sys-libs/gdbm )
			!gdbm? ( berkdb? ( >=sys-libs/db-4 ) )
		)
	)
	imap?    (
		gnutls?  ( >=net-libs/gnutls-1.0.17 )
		!gnutls? ( ssl? ( >=dev-libs/openssl-0.9.6 ) )
		sasl?    ( >=dev-libs/cyrus-sasl-2 )
	)
	pop?     (
		gnutls?  ( >=net-libs/gnutls-1.0.17 )
		!gnutls? ( ssl? ( >=dev-libs/openssl-0.9.6 ) )
		sasl?    ( >=dev-libs/cyrus-sasl-2 )
	)
	smtp?     (
		gnutls?  ( >=net-libs/gnutls-1.0.17 )
		!gnutls? ( ssl? ( >=dev-libs/openssl-0.9.6 ) )
		sasl?    ( >=dev-libs/cyrus-sasl-2 )
	)
	idn?     ( net-dns/libidn )
	gpg?     ( >=app-crypt/gpgme-0.9.0 )
	smime?   ( >=dev-libs/openssl-0.9.6 )
	selinux? ( sec-policy/selinux-mutt )
	app-misc/mime-types"
DEPEND="${RDEPEND}
	net-mail/mailbase
	doc? (
		dev-libs/libxml2
		dev-libs/libxslt
		app-text/docbook-xsl-stylesheets
		|| ( www-client/lynx www-client/w3m www-client/elinks )
	)"

PATCHDIR="${WORKDIR}"/${P}-gentoo-patches${PATCHSET_REV}

src_prepare() {
	# Post-release hot-fixes grabbed from HG, this is what all following
	# patches are based on in my Mercurial patchqueue (mq).
	# If you ever take over or need to modify patches here, just check
	# out the gentoo branch(es) of Gentoo's Mutt Mercurial clone, and
	# the patchqueue as it'll save you a lot of work.
	# http://prefix.gentooexperimental.org:8000/mutt/
	# http://prefix.gentooexperimental.org:8000/mutt-patches/
	for rev in $(eval echo {0..${PR#r}}) ; do
		local revpatch="${PATCHDIR}"/mutt-gentoo-${PV}-r${rev}.patch
		[[ -e ${revpatch} ]] && \
			epatch "${revpatch}"
	done

	# this patch is non-generic and only works because we use a sysconfdir
	# different from the one used by the mailbase ebuild
	use prefix && epatch "${PATCHDIR}"/prefix-mailcap.patch

	# must have fixes to compile or behave correctly, upstream
	# ignores, disagrees or simply doesn't respond/apply
	epatch "${PATCHDIR}"/bdb-prefix.patch # fix bdb detection
	epatch "${PATCHDIR}"/interix-btowc.patch
	epatch "${PATCHDIR}"/solaris-ncurses-chars.patch
	epatch "${PATCHDIR}"/gpgme-1.2.0.patch
	# same category, but functional bits
	epatch "${PATCHDIR}"/dont-reveal-bbc.patch

	# the big feature patches that upstream doesn't want to include, but
	# nearly every distro has due to their usefulness
	for p in "${PATCHDIR}"/[0-9][0-9]-*.patch ; do
		epatch "${p}"
	done

	# we conditionalise this one, simply because it has considerable
	# impact on the code
	if use sidebar ; then
		epatch "${PATCHDIR}"/sidebar.patch
		epatch "${PATCHDIR}"/sidebar-utf8.patch
		epatch "${PATCHDIR}"/sidebar-dotpathsep.patch
	fi

	use sasl && epatch "${FILESDIR}"/auth.patch

	# patch version string for bug reports
	sed -i -e 's/"Mutt %s (%s)"/"Mutt %s (%s, Gentoo '"${PVR}"')"/' \
		muttlib.c || die "failed patching in Gentoo version"

	# many patches touch the buildsystem, we always need this
	AT_M4DIR="m4" eautoreconf

	# the configure script contains some "cleverness" whether or not to setgid
	# the dotlock program, resulting in bugs like #278332
	sed -i -e 's/@DOTLOCK_GROUP@//' \
		Makefile.in || die "sed failed"

	# don't just build documentation (lengthy process, with big dependencies)
	if use !doc ; then
		sed -i -e '/SUBDIRS =/s/doc//' Makefile.in || die
	fi
}

src_configure() {
	local myconf="
		$(use_enable crypt pgp) \
		$(use_enable debug) \
		$(use_enable gpg gpgme) \
		$(use_enable imap) \
		$(use_enable nls) \
		$(use_enable nntp) \
		$(use_enable pop) \
		$(use_enable smime) \
		$(use_enable smtp) \
		$(use_with idn) \
		$(use_with !nntp mixmaster) \
		--enable-compressed \
		--enable-external-dotlock \
		--enable-nfs-fix \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--with-curses \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PN}-${PVR} \
		--with-regex \
		--with-exec-shell=${EPREFIX}/bin/sh"

	case $CHOST in
		*-solaris*)
			# Solaris has no flock in the standard headers
			myconf="${myconf} --enable-fcntl --disable-flock"
		;;
		*)
			myconf="${myconf} --disable-fcntl --enable-flock"
		;;
	esac

	# mutt prioritizes gdbm over bdb, so we will too.
	# hcache feature requires at least one database is in USE.
	if use tokyocabinet; then
		myconf="${myconf} --enable-hcache \
			--with-tokyocabinet --without-qdbm --without-gdbm --without-bdb"
	elif use qdbm; then
		myconf="${myconf} --enable-hcache \
			--without-tokyocabinet --with-qdbm --without-gdbm --without-bdb"
	elif use gdbm ; then
		myconf="${myconf} --enable-hcache \
			--without-tokyocabinet --without-qdbm --with-gdbm --without-bdb"
	elif use berkdb; then
		myconf="${myconf} --enable-hcache \
			--without-tokyocabinet --without-qdbm --without-gdbm --with-bdb"
	else
		myconf="${myconf} --disable-hcache \
			--without-tokyocabinet --without-qdbm --without-gdbm --without-bdb"
	fi

	# there's no need for gnutls, ssl or sasl without socket support
	if use pop || use imap || use smtp ; then
		if use gnutls; then
			myconf="${myconf} --with-gnutls"
		elif use ssl; then
			myconf="${myconf} --with-ssl"
		fi
		# not sure if this should be mutually exclusive with the other two
		myconf="${myconf} $(use_with sasl)"
	else
		myconf="${myconf} --without-gnutls --without-ssl --without-sasl"
	fi

	if use mbox; then
		myconf="${myconf} --with-mailpath=${EPREFIX}/var/spool/mail"
	else
		myconf="${myconf} --with-homespool=Maildir"
	fi

	econf ${myconf} || die "configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	if use mbox; then
		insinto /etc/mutt
		newins "${FILESDIR}"/Muttrc.mbox Muttrc
	else
		insinto /etc/mutt
		doins "${FILESDIR}"/Muttrc
	fi

	# A newer file is provided by app-misc/mime-types. So we link it.
	rm "${ED}"/etc/${PN}/mime.types
	dosym /etc/mime.types /etc/${PN}/mime.types

	# A man-page is always handy
	if use !doc; then
		make -C doc DESTDIR="${D}" muttrc.man || die
		cp doc/mutt.man mutt.1
		cp doc/muttbug.man flea.1
		cp doc/muttrc.man muttrc.5
		doman mutt.1 flea.1 muttrc.5
	else
		# nuke manpages that should be provided by an MTA, bug #177605
		rm "${ED}"/usr/share/man/man5/{mbox,mmdf}.5 \
			|| ewarn "failed to remove files, please file a bug"
	fi

	if use !prefix ; then
		fowners root:mail /usr/bin/mutt_dotlock
		fperms g+s /usr/bin/mutt_dotlock
	fi

	dodoc BEWARE COPYRIGHT ChangeLog NEWS OPS* PATCHES README* TODO VERSION
}

pkg_postinst() {
	echo
	elog "If you are new to mutt you may want to take a look at"
	elog "the Gentoo QuickStart Guide to Mutt E-Mail:"
	elog "   http://www.gentoo.org/doc/en/guide-to-mutt.xml"
	echo
}
