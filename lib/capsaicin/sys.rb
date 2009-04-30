module Capsaicin
  module LocalSys

    def windows?
      @windows ||= !! (RUBY_PLATFORM =~ /cygwin|mingw|win32|mswin|windows/)
    end

  end

  Capistrano.plugin :local_sys, LocalSys
end
