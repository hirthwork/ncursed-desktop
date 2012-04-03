# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/supertab/supertab-1.6.ebuild,v 1.6 2012/02/01 20:48:58 ranger Exp $

EAPI="4"
inherit vim-plugin

DESCRIPTION="vim plugin: java completion"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=1785"
SRC_URI="http://www.vim.org/scripts/download_script.php?src_id=14914 -> ${P}.zip"

LICENSE="vim"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_unpack() {
	mkdir "${S}"
	cd "${S}"
	unpack "${A}"
}
