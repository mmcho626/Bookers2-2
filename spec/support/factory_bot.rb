# frozen_string_literal: true

require 'factory_bot'

# Setup factory bot
FactoryBot.definition_file_paths << Rails.root.join('spec', 'factories')
FactoryBot.reload

RSpec.configure do |config|
  config.include(FactoryBot::Syntax::Methods)
end
