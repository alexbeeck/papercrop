require 'papercrop'
require 'papercrop/schema'

module Papercrop
  require 'rails'

  class Railtie < Rails::Railtie
    initializer 'papercrop.insert_into_active_record' do |app|
      ActiveSupport.on_load :active_record do
        Papercrop::Railtie.insert
      end
    end
  end

  class Railtie
    def self.insert
      if defined?(ActiveRecord)
        ActiveRecord::Base.send(:include, Papercrop::Schema)
      end
    end
  end
end
