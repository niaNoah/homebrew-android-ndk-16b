class AndroidNdk16b < Formula
  desc "NDK"
  homepage 'https://developer.android.com/ndk/index.html'
  url "https://dl.google.com/android/repository/android-ndk-r16b-darwin-x86_64.zip"
  sha256 "9654a692ed97713e35154bfcacb0028fdc368128d636326f9644ed83eec5d88b"


  def install
    bin.mkpath
    prefix.install Dir['*']

    # Create a dummy script to launch the ndk apps
    ndk_exec = prefix+'ndk-exec.sh'
    ndk_exec.write <<-EOS.undent
      #!/bin/sh
      BASENAME=`basename $0`
      EXEC="#{prefix}/$BASENAME"
      test -f "$EXEC" && exec "$EXEC" "$@"
    EOS
    ndk_exec.chmod 0755
    %w[ndk-build ndk-depends ndk-gdb ndk-stack ndk-which].each { |app| bin.install_symlink ndk_exec => app }
  end
end