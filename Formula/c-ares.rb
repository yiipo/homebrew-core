class CAres < Formula
  desc "Asynchronous DNS library"
  homepage "https://c-ares.haxx.se/"
  url "https://c-ares.haxx.se/download/c-ares-1.15.0.tar.gz"
  sha256 "6cdb97871f2930530c97deb7cf5c8fa4be5a0b02c7cea6e7c7667672a39d6852"

  bottle do
    cellar :any
    sha256 "81aa80ae8e49b0a8d44f8753b94424e6f044144361e13a9f7fe138ea09ef16f7" => :mojave
    sha256 "90ff616a7b816ce090d1319e541ad45d7b515c2787007d10b7eace9601fb2396" => :high_sierra
    sha256 "82c529566254c10dd71d09ae23281cf4a2c75d16200cc4df6d406ddecde5ba16" => :sierra
    sha256 "3c9943c455dbb8a0f641f78fd93dec6a27937494021b8f94f1bfe381ded46ca3" => :el_capitan
  end

  head do
    url "https://github.com/bagder/c-ares.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./buildconf" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-debug"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <ares.h>

      int main()
      {
        ares_library_init(ARES_LIB_INIT_ALL);
        ares_library_cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcares", "-o", "test"
    system "./test"
  end
end
