# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jarjar/jarjar-0.9.ebuild,v 1.18 2012/04/15 18:19:05 vapier Exp $

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Tool for repackaging third-party jars."
SRC_URI="http://${PN}.googlecode.com/files/${PN}-src-${PV}.zip"
HOMEPAGE="http://code.google.com/p/jarjar"
LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE=""
COMMON_DEP="
	=dev-java/asm-4*
	=dev-java/gnu-regexp-1*
	>=dev-java/ant-core-1.7.0
	dev-java/java-getopt"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/ant-junit )
	app-arch/unzip
	${COMMON_DEP}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/0.9-system-jars.patch"

	cd "${S}/lib"
	rm "*.jar"
	java-pkg_jar-from asm-4
	java-pkg_jar-from gnu-regexp-1
	java-pkg_jar-from ant-core ant.jar
	java-pkg_jar-from java-getopt-1
}

ANT_TASKS="none"
EANT_BUILD_TARGET="jar-nojarjar"

src_test() {
	# regenerates this
	cp -i dist/${P}.jar "${T}" || die
	cd lib || die
	java-pkg_jar-from junit
	cd ..
	ANT_TASKS="ant-junit" eant test
	cp "${T}/${P}.jar" dist || die
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar
	java-pkg_register-ant-task
	use doc && java-pkg_dojavadoc dist/javadoc
	use source && java-pkg_dosrc src/main/*
}
