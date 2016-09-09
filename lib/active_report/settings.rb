require 'dry-configurable'

class ActiveReport::Settings
  extend Dry::Configurable

  setting :force_encoding, true
  setting :options, { encoding: 'UTF-8' }

end
