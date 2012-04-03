# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/supertab/supertab-1.6.ebuild,v 1.6 2012/02/01 20:48:58 ranger Exp $

EAPI="4"
inherit vim-plugin

DESCRIPTION="vim plugin: cscope integration"
HOMEPAGE="http://cscope.sourceforge.net/cscope_vim_tutorial.html"
SRC_URI="http://cscope.sourceforge.net/cscope_maps.vim"

LICENSE=""
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	mkdir "${S}"
	mkdir "${S}/plugin"
	cp "/usr/portage/distfiles/${A}" "${S}/plugin" || die "install failed"
}

