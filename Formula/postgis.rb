class Postgis < Formula
  desc "Adds support for geographic objects to PostgreSQL"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-3.0.2.tar.gz"
  sha256 "a3a1641dfd73c83924088a185bdb8b35567b3d1dc8d0887f9e4b492e228ab2ca"

  bottle do
    cellar :any
    sha256 "583a389714f5dcaab3c7c999d6b606cfb5850e4fc8b45ea8c78ba07b55dc18d4" => :catalina
    sha256 "434ee9eb677124e3ee778125153fd0ec48317d023a7f07bd045d6c14fce5a9ba" => :mojave
    sha256 "2499a78f8fbcd4684e1629009ad7f7027f2b690af1681e38063837aa981e500f" => :high_sierra
  end

  head do
    url "https://git.osgeo.org/gitea/postgis/postgis.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gpp" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal" # for GeoJSON and raster handling
  depends_on "geos"
  depends_on "json-c" # for GeoJSON and raster handling
  depends_on "pcre"
  depends_on "postgresql"
  depends_on "proj"
  depends_on "protobuf-c" # for MVT (map vector tiles) support
  depends_on "sfcgal" # for advanced 2D/3D functions

  def install
    ENV.deparallelize

    args = [
      "--with-projdir=#{Formula["proj"].opt_prefix}",
      "--with-jsondir=#{Formula["json-c"].opt_prefix}",
      "--with-pgconfig=#{Formula["postgresql"].opt_bin}/pg_config",
      "--with-protobufdir=#{Formula["protobuf-c"].opt_bin}",
      # Unfortunately, NLS support causes all kinds of headaches because
      # PostGIS gets all of its compiler flags from the PGXS makefiles. This
      # makes it nigh impossible to tell the buildsystem where our keg-only
      # gettext installations are.
      "--disable-nls",
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"

    mkdir "stage"
    system "make", "install", "DESTDIR=#{buildpath}/stage"

    bin.install Dir["stage/**/bin/*"]
    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]
    (doc/"postgresql/extension").install Dir["stage/**/share/doc/postgresql/extension/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
    pkgshare.install Dir["stage/**/contrib/postgis-*/*"]
    (share/"postgis_topology").install Dir["stage/**/contrib/postgis_topology-*/*"]

    # Extension scripts
    bin.install %w[
      utils/create_undef.pl
      utils/postgis_proc_upgrade.pl
      utils/postgis_restore.pl
      utils/profile_intersects.pl
      utils/test_estimation.pl
      utils/test_geography_estimation.pl
      utils/test_geography_joinestimation.pl
      utils/test_joinestimation.pl
    ]

    man1.install Dir["doc/**/*.1"]
  end

  test do
    require "base64"
    (testpath/"brew.shp").write ::Base64.decode64 <<~EOS
      AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAoOgDAAALAAAAAAAAAAAAAAAA
      AAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAEAAAASCwAAAAAAAAAAAPA/AAAAAAAA8D8AAAAAAAAA
      AAAAAAAAAAAAAAAAAgAAABILAAAAAAAAAAAACEAAAAAAAADwPwAAAAAAAAAA
      AAAAAAAAAAAAAAADAAAAEgsAAAAAAAAAAAAQQAAAAAAAAAhAAAAAAAAAAAAA
      AAAAAAAAAAAAAAQAAAASCwAAAAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAAAAA
      AAAAAAAAAAAABQAAABILAAAAAAAAAAAAAAAAAAAAAAAUQAAAAAAAACJAAAAA
      AAAAAEA=
    EOS
    (testpath/"brew.dbf").write ::Base64.decode64 <<~EOS
      A3IJGgUAAABhAFsAAAAAAAAAAAAAAAAAAAAAAAAAAABGSVJTVF9GTEQAAEMA
      AAAAMgAAAAAAAAAAAAAAAAAAAFNFQ09ORF9GTEQAQwAAAAAoAAAAAAAAAAAA
      AAAAAAAADSBGaXJzdCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgIFBvaW50ICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgU2Vjb25kICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICBQb2ludCAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgIFRoaXJkICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICAgUG9pbnQgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICBGb3VydGggICAgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICAgIFBvaW50ICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgQXBwZW5kZWQgICAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAgICAgICBQb2ludCAgICAgICAgICAgICAgICAgICAgICAg
      ICAgICAgICAgICAg
    EOS
    (testpath/"brew.shx").write ::Base64.decode64 <<~EOS
      AAAnCgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAARugDAAALAAAAAAAAAAAAAAAA
      AAAAAADwPwAAAAAAABBAAAAAAAAAFEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAADIAAAASAAAASAAAABIAAABeAAAAEgAAAHQAAAASAAAA
      igAAABI=
    EOS
    result = shell_output("#{bin}/shp2pgsql #{testpath}/brew.shp")
    assert_match(/Point/, result)
    assert_match(/AddGeometryColumn/, result)
  end
end
