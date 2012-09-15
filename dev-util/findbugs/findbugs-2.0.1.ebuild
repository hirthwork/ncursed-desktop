# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/findbugs/findbugs-1.3.9.ebuild,v 1.1 2011/04/11 01:26:55 nerdboy Exp $

EAPI=3

WANT_ANT_TASKS="ant-nodeps ant-junit"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2

DESCRIPTION="Find Bugs in Java Programs"
HOMEPAGE="http://findbugs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-source.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/ant-core
	dev-java/commons-lang:2.1
	dev-java/apple-java-extensions-bin:0
	>=dev-java/asm-3.1:3
	dev-java/dom4j
	dev-java/bcel[findbugs]
	dev-java/jsr305
	dev-java/jformatstring
	=dev-java/jaxen-1.1*
	=dev-java/jdepend-2.9*
	doc? (
		=dev-java/saxon-6.5*
		app-text/docbook-xsl-stylesheets
	)
	dev-java/ant-junit
	=dev-java/junit-4*
"
RDEPEND=">=virtual/jre-1.5
	dev-java/icu4j:0
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${CDEPEND}"

src_compile() {
	ant || die "build failed"
}

src_install() {
	java-pkg_dojar "${S}"/lib/*.jar
	# no plugins installed yet (see README.plugins)
	dodir /usr/share/${PN}/plugin
	newdoc "${S}"/plugin/README README.plugin
	# "${S}"/plugin/*.jar
	# dosym /usr/share/${PN}/lib/coreplugin.jar  /usr/share/${PN}/plugin/
	dobin "${FILESDIR}"/findbugs

	use doc && java-pkg_dojavadoc "${S}"/apiJavaDoc
	use source && java-pkg_dosrc "${S}"/src
}

pkg_postinst() {
	elog
	elog "Scanning large class files can take large amounts of memory, so"
	elog "if you experiance out of memory errors, edit /usr/bin/findbugs"
	elog "and increase the VM memory allocation (or buy more RAM ;)"
	elog
}
