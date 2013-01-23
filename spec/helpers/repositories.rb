require 'ronin/repository'

module Helpers
  module Repositories
    DIR = File.expand_path(File.join(File.dirname(__FILE__),'repos'))

    def repository(name)
      Repository.first(name: name)
    end
  end
end
