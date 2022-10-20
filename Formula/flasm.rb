class Flasm < Formula
  desc "Flash command-line assembler and disassembler"
  homepage "https://www.nowrap.de/flasm.html"
  url "https://github.com/JrMasterModelBuilder/homebrew-flasm/releases/download/sources/flasm16src.1.64.zip"
  version "1.64"
  sha256 "bb37695bccc8c03616b877779c6d659005f5ad0f2d6d0ab3937c38b2c0c6fa58"

  uses_from_macos "gperf" => :build

  def install
    inreplace "Makefile", "keywords.gperf >", "--size-type=size_t keywords.gperf >" if OS.mac?
    inreplace "unflasm.c", "swfVersion", "_swfVersion"
    inreplace "flasm.c",
      "(iniFile = fopen(inipath, \"r\")) == NULL",
      "(iniFile = fopen(inipath, \"r\")) == NULL && (iniFile = fopen(\"#{etc}/flasm.ini\", \"r\")) == NULL"
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "flasm"
    etc.install "flasm.ini"
  end

  test do
    (testpath/"test").write <<~EOS
      constants 'a', 'b'
      push 'a', 'b'
      getVariable
      push 'b'
      getVariable
      multiply
      setVariable
    EOS

    system "#{bin}/flasm", "-b", "test"
  end
end
