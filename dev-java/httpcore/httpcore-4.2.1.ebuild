# Copyright 2012 Dmitry Potapov
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="HttpComponents Core library"
HOMEPAGE="http://hc.apache.org/"
SRC_URI="http://www.sai.msu.su/apache/httpcomponents/httpcore/source/httpcomponents-core-${PV}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=virtual/jdk-1.5"

DEPEND="${RDEPEND}
	|| (
		>=dev-java/maven-2.2.1
		>=dev-java/maven-bin-2.2.1
	)"

src_compile() {
	cd httpcomponents-core-${PV} || die "failed to change dir"
	echo "<settings><localRepository>${WORKDIR}/maventemprepo</localRepository></settings>">${WORKDIR}/maventempconfig.xml || die "failed to create temporary config"
	mvn -s ${WORKDIR}/maventempconfig.xml package || die "build failed"
}

src_install() {
	cd httpcomponents-core-${PV} || die "failed to change dir"
	insinto /usr/share/httpcore/lib
	doins httpcore/target/httpcore-${PV}.jar || die "failed to install httpcore"
	doins httpcore-nio/target/httpcore-nio-${PV}.jar || die "failed to install httpcore-nio"
}

