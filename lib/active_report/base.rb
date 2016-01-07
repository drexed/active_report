class ActiveReport::Base

  private

  def encode_to_utf8(line)
    line.map do |l|
      unless l.nil?
        l.gsub!(/"/, ''.freeze)
        l.encode!('UTF-8'.freeze, 'binary'.freeze, invalid: :replace, undef: :replace, replace: ''.freeze)
      end
    end
  end

end