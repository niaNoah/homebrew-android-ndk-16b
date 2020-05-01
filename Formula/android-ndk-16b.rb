class AndroidNdk16b < Formula
  version '16b'
  desc ""
  homepage 'https://developer.android.com/ndk/index.html'
  url "https://dl.google.com/android/repository/android-ndk-r#{version}-darwin-x86_64.zip"
  sha256 "9654a692ed97713e35154bfcacb0028fdc368128d636326f9644ed83eec5d88b"

  conflicts_with cask: 'android-ndk'

  # shim script (https://github.com/caskroom/homebrew-cask/issues/18809)
  shimscript = "#{staged_path}/ndk_exec.sh"
  preflight do
    FileUtils.ln_sf("#{staged_path}/android-ndk-r#{version}", "#{HOMEBREW_PREFIX}/share/android-ndk-r#{version}")

    IO.write shimscript, <<~EOS
      #!/bin/bash
      readonly executable="#{staged_path}/android-ndk-r#{version}/$(basename ${0})"
      test -f "${executable}" && exec "${executable}" "${@}"
    EOS
  end

  [
    'ndk-build',
    'ndk-depends',
    'ndk-gdb',
    'ndk-stack',
    'ndk-which',
  ].each { |link_name| binary shimscript, target: link_name }

  uninstall_postflight do
    FileUtils.rm("#{HOMEBREW_PREFIX}/share/android-ndk-r#{version}")
  end

  caveats <<~EOS
    You may want to add to your profile:
       'export ANDROID_NDK_HOME="#{HOMEBREW_PREFIX}/share/android-ndk-r#{version}"'
  EOS

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
  end
end