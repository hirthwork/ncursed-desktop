# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/supertab/supertab-1.6.ebuild,v 1.6 2012/02/01 20:48:58 ranger Exp $

EAPI="4"
inherit vim-plugin eutils

DESCRIPTION="vim plugin: clang-based C++ completion"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3302"
SRC_URI="https://github.com/Rip-Rip/clang_complete/zipball/486acce73a9b2868f43f44b10b8c5e8ad6e0a0fa -> ${P}.zip"

LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-devel/clang-3.0"

S="${WORKDIR}/Rip-Rip-clang_complete-486acce"

src_prepare() {
	epatch ${FILESDIR}/cache.patch
}

src_compile() {
	einfo "No build required"
}

