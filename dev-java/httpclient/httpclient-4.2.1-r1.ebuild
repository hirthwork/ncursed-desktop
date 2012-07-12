# Copyright 2012 Dmitry Potapov
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="HttpComponents Client library"
HOMEPAGE="http://hc.apache.org/"
SRC_URI="http://www.sai.msu.su/apache/httpcomponents/httpclient/source/httpcomponents-client-${PV}-src.tar.gz"

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
	cd httpcomponents-client-${PV} || die "failed to change dir"
	echo "<settings><localRepository>${WORKDIR}/maventemprepo</localRepository></settings>">${WORKDIR}/maventempconfig.xml || die "failed to create temporary config"
	mvn -s ${WORKDIR}/maventempconfig.xml package || die "build failed"
}

src_install() {
	cd httpcomponents-client-${PV} || die "failed to change dir"
	insinto /usr/share/httpclient/lib
	newins httpclient/target/httpclient-${PV}.jar httpclient.jar || die "failed to install httpclient"
	doins httpmime/target/httpmime-${PV}.jar httpmime.jar || die "failed to install httpmime"
}

