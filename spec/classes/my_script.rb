require 'ronin/script'

class MyScript

  include Ronin::Script

  property :id, Serial

  property :content, String, required: true

  parameter :x, default: 1

  attr_accessor :var

  def initialize(options={})
    super(options)

    @var = 2
  end

end
