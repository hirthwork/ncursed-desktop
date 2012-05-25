# Copyright 2012 Dmitry Potapov
# Distributed under the terms of the GNU General Public License v2

EAPI=2

DESCRIPTION="A tool for use with clang to analyze #includes in C and C++ source files"
HOMEPAGE="http://code.google.com/p/include-what-you-use/"
SRC_URI="http://${PN}.googlecode.com/files/${P}-1.tar.gz"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-devel/llvm-${PV}
	>=sys-devel/clang-${PV}"

src_compile() {
	cd include-what-you-use || die "cd include-what-you-use failed"
	g++ ${CFLAGS} -o include-what-you-use *.cc -D_GNU_SOURCE -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS -fno-rtti -lclangFrontend -lclangSerialization -lclangDriver -lclangParse -lclangSema -lclangAnalysis -lclangAST -lclangLex -lclangBasic -lLLVMSupport -lLLVMMC -lpthread -ldl -lm -L/usr/lib/llvm || die "compile failed failed"
}

src_install() {
	cd include-what-you-use || die "cd include-what-you-use failed"
	exeinto /usr/bin
	doexe include-what-you-use || die "doexe failed"
}
