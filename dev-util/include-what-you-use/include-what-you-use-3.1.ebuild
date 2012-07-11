# Copyright 2012 Dmitry Potapov
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit subversion

DESCRIPTION="A tool for use with clang to analyze #includes in C and C++ source files"
HOMEPAGE="http://code.google.com/p/include-what-you-use/"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-devel/llvm-${PV}
	>=sys-devel/clang-${PV}"

src_unpack() {
	ESVN_REPO_URI="http://include-what-you-use.googlecode.com/svn/trunk@357"
	ESVN_PROJECT="include-what-you-use"
	subversion_src_unpack
}

src_prepare() {
	epatch ${FILESDIR}/AddCommentHandler.patch
}

src_compile() {
	g++ ${CFLAGS} -o include-what-you-use *.cc -D_GNU_SOURCE -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS -fno-rtti -D_GNU_SOURCE -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS -fno-rtti -lpthread -ldl -lm -L/usr/lib/llvm -lclangAST -lclangBasic -lLLVM-${PV} -lclangFrontend -lclangSema -lclangLex -lclangDriver -lclangAnalysis -lclangAST -lclangStaticAnalyzerCore -lclangBasic -lclangSerialization -lclangParse -lclangEdit -lclangSema -lpthread -ldl -lm -L/usr/lib/llvm || die "compile failed failed"
}

src_install() {
	exeinto /usr/bin
	doexe include-what-you-use || die "doexe failed"
}
