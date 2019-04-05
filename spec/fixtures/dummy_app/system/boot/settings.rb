Dummy::Application.boot :settings, from: :system do
  before :init do
    require "dry/types"
  end

  settings do
    key :database_url, Dry::Types["strict.string"]
  end
end
