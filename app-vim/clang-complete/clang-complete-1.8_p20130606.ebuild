# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/supertab/supertab-1.6.ebuild,v 1.6 2012/02/01 20:48:58 ranger Exp $

EAPI="4"
inherit vim-plugin eutils

DESCRIPTION="vim plugin: clang-based C++ completion"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3302"
SRC_URI="https://github.com/Rip-Rip/clang_complete/zipball/b4880dcb45e10c658bfa1f5a4702173997ba8896 -> ${P}.zip"

LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-devel/clang-3.0"

S="${WORKDIR}/Rip-Rip-clang_complete-b4880dc"

src_prepare() {
	epatch ${FILESDIR}/cache-new.patch
}

src_compile() {
	einfo "No build required"
}

