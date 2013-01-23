require 'ronin/script'

class ScriptClass

  include Ronin::Script

  property :id, Serial

  parameter :x, default: 1

  attr_reader :y

  def initialize(options={})
    super(options)

    @y = 2
  end

end
