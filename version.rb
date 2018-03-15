module Nanotwitter
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 4
    MINOR = 0
    TINY = 0
    PRE = "pre-alpha"

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join('.')
  end
end
