Dummy::Container.namespace "persistence" do |persistence|
  persistence.finalize :rom do
    init do
      require "rom"
      persistence.register "config", ROM::Configuration.new(:sql, Dummy::Container.settings[:database_url])
    end

    start do
      persistence.register "rom", ROM.container(container["persistence.config"])
    end
  end
end
