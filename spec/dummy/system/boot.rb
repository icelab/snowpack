require_relative "./dummy/container"

Dummy::Container.require 'apps/web/system/boot'

Dummy::Container.finalize!
