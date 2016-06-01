class ActiveReport::Configuration

  attr_accessor :force_encoding, :options

  def initialize
    @force_encoding = true
    @options = { encoding: "UTF-8" }
  end

end
