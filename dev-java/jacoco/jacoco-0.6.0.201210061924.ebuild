# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jarjar/jarjar-0.9.ebuild,v 1.18 2012/04/15 18:19:05 vapier Exp $

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="JaCoCo Java Code Coverage Library"
SRC_URI="https://github.com/downloads/${PN}/${PN}/${P}.zip"
HOMEPAGE="http://www.eclemma.org/jacoco/"
LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
COMMON_DEPS=">=dev-java/asm-4.0"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPS}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPS}"

src_unpack() {
	unpack ${A}
	java-pkg_jar-from asm-4
}

ANT_TASKS="none"

src_compile() { :; }

src_install() {
	java-pkg_newjar lib/jacocoant.jar jacocoant.jar
	java-pkg_register-ant-task
}
